#pragma once
#include "core/EventLog.hpp"
#include "core/TelemetryRecorder.hpp"
#include <chrono>
#include <optional>
#include <string>
#include <vector>

namespace nexvary::avionics {

struct TimelineFramePoint {
    std::uint64_t sequence{0};
    std::chrono::milliseconds simTime{0};
};

struct TimelineEventPoint {
    std::chrono::milliseconds wallOffset{0};
    Severity severity{Severity::Info};
    std::string source;
    std::string message;
};

struct UnifiedTimelineSnapshot {
    std::vector<TimelineFramePoint> frames;
    std::vector<TimelineEventPoint> events;
    std::chrono::milliseconds simulationDuration{0};
};

class UnifiedTimeline {
public:
    [[nodiscard]] static UnifiedTimelineSnapshot build(const TelemetryRecorder& recorder, const EventLog& log);
    [[nodiscard]] static std::optional<TimelineFramePoint> nearestFrame(const UnifiedTimelineSnapshot& timeline, std::chrono::milliseconds target);
    [[nodiscard]] static std::vector<TimelineEventPoint> eventsBetween(const UnifiedTimelineSnapshot& timeline, std::chrono::milliseconds begin, std::chrono::milliseconds end);
};

} // namespace nexvary::avionics
