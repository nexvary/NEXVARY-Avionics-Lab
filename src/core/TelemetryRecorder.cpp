#include "core/TelemetryRecorder.hpp"

namespace nexvary::avionics {

void TelemetryRecorder::record(std::uint64_t sequence, std::chrono::milliseconds simTime, const SensorBus& bus) {
    frames_.push_back({sequence, simTime, bus.snapshot()});
}

void TelemetryRecorder::clear() { frames_.clear(); }
std::size_t TelemetryRecorder::size() const noexcept { return frames_.size(); }
const std::vector<TelemetryFrame>& TelemetryRecorder::frames() const noexcept { return frames_; }

std::optional<TelemetryFrame> TelemetryRecorder::frame(std::size_t index) const {
    if (index >= frames_.size()) return std::nullopt;
    return frames_[index];
}

ReplayCursor::ReplayCursor(const TelemetryRecorder& recorder) : recorder_(recorder) {}
bool ReplayCursor::hasNext() const noexcept { return index_ < recorder_.size(); }

std::optional<TelemetryFrame> ReplayCursor::next() {
    if (!hasNext()) return std::nullopt;
    return recorder_.frame(index_++);
}

void ReplayCursor::reset() noexcept { index_ = 0; }

} // namespace nexvary::avionics
