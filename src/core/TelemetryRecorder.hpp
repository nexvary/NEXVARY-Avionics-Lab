#pragma once
#include "core/SensorBus.hpp"
#include <chrono>
#include <cstdint>
#include <optional>
#include <vector>

namespace nexvary::avionics {

struct TelemetryFrame {
    std::uint64_t sequence{0};
    std::chrono::milliseconds simTime{0};
    std::map<std::string, SensorSample> sensors;
};

class TelemetryRecorder {
public:
    void record(std::uint64_t sequence, std::chrono::milliseconds simTime, const SensorBus& bus);
    void clear();
    [[nodiscard]] std::size_t size() const noexcept;
    [[nodiscard]] const std::vector<TelemetryFrame>& frames() const noexcept;
    [[nodiscard]] std::optional<TelemetryFrame> frame(std::size_t index) const;

private:
    std::vector<TelemetryFrame> frames_;
};

class ReplayCursor {
public:
    explicit ReplayCursor(const TelemetryRecorder& recorder);
    [[nodiscard]] bool hasNext() const noexcept;
    [[nodiscard]] std::optional<TelemetryFrame> next();
    void reset() noexcept;

private:
    const TelemetryRecorder& recorder_;
    std::size_t index_{0};
};

} // namespace nexvary::avionics
