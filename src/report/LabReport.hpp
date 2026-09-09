#pragma once
#include "core/EventLog.hpp"
#include "core/TelemetryRecorder.hpp"
#include "core/TelemetryTrend.hpp"
#include <cstdint>
#include <map>
#include <string>
#include <string_view>

namespace nexvary::avionics {

using SensorStatistic = TelemetryTrend;

struct LabReportData {
    std::string scenario;
    std::size_t frameCount{0};
    std::size_t eventCount{0};
    std::size_t sensorSampleCount{0};
    std::size_t invalidSampleCount{0};
    std::size_t trendWindowFrames{0};
    bool sequenceMonotonic{true};
    bool timeMonotonic{true};
    std::uint64_t checksum{0};
    std::map<std::string, SensorStatistic> sensors;
};

class LabReport {
public:
    static LabReportData analyze(
        std::string_view scenario,
        const TelemetryRecorder& recorder,
        const EventLog& log,
        std::size_t trendWindowFrames = 0);
    static std::string toJson(const LabReportData& report);
    static std::string toMarkdown(const LabReportData& report);
    static void writeJson(const std::string& path, const LabReportData& report);
    static void writeMarkdown(const std::string& path, const LabReportData& report);
};

} // namespace nexvary::avionics
