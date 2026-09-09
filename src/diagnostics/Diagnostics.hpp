#pragma once
#include <string>
#include <string_view>

namespace nexvary::avionics {

class Diagnostics {
public:
    static void initialize(std::string_view level = "warn", const std::string& logFile = {});
    [[nodiscard]] static bool initialized() noexcept;
    static void debug(std::string_view message);
    static void info(std::string_view message);
    static void warn(std::string_view message);
    static void error(std::string_view message);
    static void flush();
    static void shutdown() noexcept;
};

} // namespace nexvary::avionics
