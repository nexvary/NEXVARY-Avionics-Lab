#pragma once
#include <chrono>
#include <cstdint>

namespace nexvary::avionics {

class SimulationClock {
public:
    void reset();
    void advance(std::chrono::milliseconds delta);
    [[nodiscard]] std::uint64_t tick() const noexcept;
    [[nodiscard]] std::chrono::milliseconds elapsed() const noexcept;

private:
    std::uint64_t tick_{0};
    std::chrono::milliseconds elapsed_{0};
};

} // namespace nexvary::avionics
