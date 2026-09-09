#include "diagnostics/Diagnostics.hpp"
#include <spdlog/logger.h>
#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/spdlog.h>
#include <memory>
#include <mutex>
#include <stdexcept>
#include <string>
#include <vector>

namespace nexvary::avionics {
namespace {
std::mutex loggerMutex;
std::shared_ptr<spdlog::logger> logger;

spdlog::level::level_enum parseLevel(std::string_view level) {
    if (level == "trace") return spdlog::level::trace;
    if (level == "debug") return spdlog::level::debug;
    if (level == "info") return spdlog::level::info;
    if (level == "warn") return spdlog::level::warn;
    if (level == "error") return spdlog::level::err;
    if (level == "critical") return spdlog::level::critical;
    if (level == "off") return spdlog::level::off;
    throw std::invalid_argument("unsupported log level: " + std::string(level));
}

template <typename Fn>
void withLogger(Fn&& fn) {
    std::scoped_lock lock{loggerMutex};
    if (logger) fn(*logger);
}
}

void Diagnostics::initialize(std::string_view level, const std::string& logFile) {
    const auto parsedLevel = parseLevel(level);
    std::vector<spdlog::sink_ptr> sinks;

    auto consoleSink = std::make_shared<spdlog::sinks::stderr_color_sink_mt>();
    consoleSink->set_level(parsedLevel);
    sinks.push_back(consoleSink);

    if (!logFile.empty()) {
        auto fileSink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(logFile, false);
        fileSink->set_level(parsedLevel);
        sinks.push_back(fileSink);
    }

    auto next = std::make_shared<spdlog::logger>("nexvary-avionics", sinks.begin(), sinks.end());
    next->set_level(parsedLevel);
    next->set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%l] %v");
    next->flush_on(spdlog::level::warn);

    std::scoped_lock lock{loggerMutex};
    logger = std::move(next);
}

bool Diagnostics::initialized() noexcept {
    std::scoped_lock lock{loggerMutex};
    return static_cast<bool>(logger);
}

void Diagnostics::debug(std::string_view message) {
    withLogger([&](spdlog::logger& value) { value.debug("{}", message); });
}

void Diagnostics::info(std::string_view message) {
    withLogger([&](spdlog::logger& value) { value.info("{}", message); });
}

void Diagnostics::warn(std::string_view message) {
    withLogger([&](spdlog::logger& value) { value.warn("{}", message); });
}

void Diagnostics::error(std::string_view message) {
    withLogger([&](spdlog::logger& value) { value.error("{}", message); });
}

void Diagnostics::flush() {
    withLogger([](spdlog::logger& value) { value.flush(); });
}

void Diagnostics::shutdown() noexcept {
    std::scoped_lock lock{loggerMutex};
    if (logger) logger->flush();
    logger.reset();
}

} // namespace nexvary::avionics
