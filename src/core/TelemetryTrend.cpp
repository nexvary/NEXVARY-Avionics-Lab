#include "core/TelemetryTrend.hpp"
#include <algorithm>
#include <chrono>
#include <limits>
#include <map>

namespace nexvary::avionics {
namespace {

struct Accumulator {
    std::size_t observed{0};
    std::size_t valid{0};
    std::size_t invalid{0};
    double minimum{std::numeric_limits<double>::infinity()};
    double maximum{-std::numeric_limits<double>::infinity()};
    double sum{0.0};
    double firstValue{0.0};
    double latestValue{0.0};
    std::chrono::milliseconds firstTime{0};
    std::chrono::milliseconds latestTime{0};
    bool hasFirst{false};
    std::string unit;
};

} // namespace

std::map<std::string, TelemetryTrend> TelemetryTrendAnalyzer::analyze(
    const std::vector<TelemetryFrame>& frames,
    std::size_t windowFrames) {
    std::map<std::string, TelemetryTrend> result;
    if (frames.empty()) return result;

    const std::size_t window = windowFrames == 0 ? frames.size() : std::min(windowFrames, frames.size());
    const std::size_t beginIndex = frames.size() - window;
    std::map<std::string, Accumulator> accumulators;

    for (std::size_t index = beginIndex; index < frames.size(); ++index) {
        const auto& frame = frames[index];
        for (const auto& [name, sample] : frame.sensors) {
            auto& acc = accumulators[name];
            ++acc.observed;
            if (acc.unit.empty()) acc.unit = sample.unit;

            if (!sample.valid) {
                ++acc.invalid;
                continue;
            }

            ++acc.valid;
            acc.minimum = std::min(acc.minimum, sample.value);
            acc.maximum = std::max(acc.maximum, sample.value);
            acc.sum += sample.value;

            if (!acc.hasFirst) {
                acc.hasFirst = true;
                acc.firstValue = sample.value;
                acc.firstTime = frame.simTime;
            }
            acc.latestValue = sample.value;
            acc.latestTime = frame.simTime;
        }
    }

    for (const auto& [name, acc] : accumulators) {
        TelemetryTrend trend;
        trend.samples = acc.observed;
        trend.validSamples = acc.valid;
        trend.invalidSamples = acc.invalid;
        trend.missingSamples = window - acc.observed;
        trend.unit = acc.unit;

        if (acc.valid > 0) {
            trend.hasValidSamples = true;
            trend.minimum = acc.minimum;
            trend.maximum = acc.maximum;
            trend.mean = acc.sum / static_cast<double>(acc.valid);
            trend.latest = acc.latestValue;
            trend.delta = acc.latestValue - acc.firstValue;
            const auto elapsedMs = (acc.latestTime - acc.firstTime).count();
            if (elapsedMs > 0) {
                trend.slopePerSecond = trend.delta / (static_cast<double>(elapsedMs) / 1000.0);
            }
        }

        result.emplace(name, std::move(trend));
    }

    return result;
}

} // namespace nexvary::avionics
