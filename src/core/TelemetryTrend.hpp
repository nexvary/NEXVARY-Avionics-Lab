#pragma once
#include "core/TelemetryRecorder.hpp"
#include <cstddef>
#include <map>
#include <string>
#include <vector>

namespace nexvary::avionics {

struct TelemetryTrend {
    std::size_t samples{0};
    std::size_t validSamples{0};
    std::size_t invalidSamples{0};
    std::size_t missingSamples{0};
    double minimum{0.0};
    double maximum{0.0};
    double mean{0.0};
    double latest{0.0};
    double delta{0.0};
    double slopePerSecond{0.0};
    bool hasValidSamples{false};
    std::string unit;
};

class TelemetryTrendAnalyzer {
public:
    [[nodiscard]] static std::map<std::string, TelemetryTrend> analyze(
        const std::vector<TelemetryFrame>& frames,
        std::size_t windowFrames = 0);
};

} // namespace nexvary::avionics
