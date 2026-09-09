#include "core/TelemetryArchive.hpp"
#include <iomanip>
#include <limits>
#include <sstream>
#include <stdexcept>

namespace nexvary::avionics {
namespace {
constexpr std::string_view kHeader = "NEXVARY_TELEMETRY_V1";

[[noreturn]] void malformed(const std::string& detail) {
    throw std::invalid_argument("invalid telemetry archive: " + detail);
}
}

std::string TelemetryArchive::encode(const std::vector<TelemetryFrame>& frames) {
    std::ostringstream out;
    out << kHeader << '\n';
    out << std::setprecision(std::numeric_limits<double>::max_digits10);
    for (const auto& frame : frames) {
        out << "FRAME " << frame.sequence << ' ' << frame.simTime.count() << ' ' << frame.sensors.size() << '\n';
        for (const auto& [name, sample] : frame.sensors) {
            out << "SENSOR " << std::quoted(name) << ' ' << sample.value << ' '
                << std::quoted(sample.unit) << ' ' << (sample.valid ? 1 : 0) << '\n';
        }
    }
    out << "END " << frames.size() << '\n';
    return out.str();
}

std::vector<TelemetryFrame> TelemetryArchive::decode(std::string_view archive) {
    std::istringstream input{std::string{archive}};
    std::string line;
    if (!std::getline(input, line) || line != kHeader) malformed("missing or unsupported header");

    std::vector<TelemetryFrame> frames;
    while (std::getline(input, line)) {
        if (line.empty()) continue;
        std::istringstream row{line};
        std::string kind;
        row >> kind;
        if (kind == "END") {
            std::size_t declared = 0;
            if (!(row >> declared) || declared != frames.size()) malformed("frame count mismatch");
            std::string extra;
            if (row >> extra) malformed("trailing footer data");
            while (std::getline(input, line)) {
                if (line.find_first_not_of(" \t\r") != std::string::npos) malformed("data after footer");
            }
            return frames;
        }
        if (kind != "FRAME") malformed("expected FRAME or END");

        TelemetryFrame frame;
        long long simMs = 0;
        std::size_t sensorCount = 0;
        if (!(row >> frame.sequence >> simMs >> sensorCount) || simMs < 0) malformed("bad frame metadata");
        std::string extra;
        if (row >> extra) malformed("trailing frame metadata");
        frame.simTime = std::chrono::milliseconds{simMs};

        for (std::size_t i = 0; i < sensorCount; ++i) {
            if (!std::getline(input, line)) malformed("truncated sensor list");
            std::istringstream sensorRow{line};
            std::string sensorKind;
            std::string name;
            SensorSample sample;
            int valid = 0;
            if (!(sensorRow >> sensorKind) || sensorKind != "SENSOR") malformed("expected SENSOR");
            if (!(sensorRow >> std::quoted(name) >> sample.value >> std::quoted(sample.unit) >> valid)) malformed("bad sensor record");
            if (valid != 0 && valid != 1) malformed("invalid sensor validity flag");
            if (name.empty()) malformed("empty sensor name");
            if (frame.sensors.contains(name)) malformed("duplicate sensor name in frame");
            if (sensorRow >> extra) malformed("trailing sensor data");
            sample.valid = valid == 1;
            frame.sensors.emplace(std::move(name), std::move(sample));
        }
        frames.push_back(std::move(frame));
    }
    malformed("missing END footer");
}

TelemetryArchiveSummary TelemetryArchive::inspect(const std::vector<TelemetryFrame>& frames) {
    TelemetryArchiveSummary summary;
    summary.frameCount = frames.size();
    for (std::size_t i = 0; i < frames.size(); ++i) {
        const auto& frame = frames[i];
        summary.sensorSampleCount += frame.sensors.size();
        for (const auto& [_, sample] : frame.sensors) {
            if (!sample.valid) ++summary.invalidSampleCount;
        }
        if (i > 0) {
            if (frame.sequence <= frames[i - 1].sequence) summary.sequenceMonotonic = false;
            if (frame.simTime < frames[i - 1].simTime) summary.timeMonotonic = false;
        }
    }
    summary.checksum = checksum(encode(frames));
    return summary;
}

std::uint64_t TelemetryArchive::checksum(std::string_view bytes) noexcept {
    std::uint64_t hash = 14695981039346656037ull;
    for (const unsigned char byte : bytes) {
        hash ^= byte;
        hash *= 1099511628211ull;
    }
    return hash;
}

std::string TelemetryArchive::verificationReport(const std::vector<TelemetryFrame>& frames) {
    const auto s = inspect(frames);
    std::ostringstream out;
    out << "# NEXVARY Telemetry Verification Report\n\n"
        << "Synthetic training data only. No live-aircraft interface.\n\n"
        << "| Check | Result |\n|---|---|\n"
        << "| Frames | " << s.frameCount << " |\n"
        << "| Sensor samples | " << s.sensorSampleCount << " |\n"
        << "| Invalid samples | " << s.invalidSampleCount << " |\n"
        << "| Sequence monotonic | " << (s.sequenceMonotonic ? "PASS" : "FAIL") << " |\n"
        << "| Simulation time monotonic | " << (s.timeMonotonic ? "PASS" : "FAIL") << " |\n"
        << "| Archive checksum (FNV-1a 64) | `" << std::hex << std::setw(16) << std::setfill('0') << s.checksum << "` |\n";
    return out.str();
}

} // namespace nexvary::avionics
