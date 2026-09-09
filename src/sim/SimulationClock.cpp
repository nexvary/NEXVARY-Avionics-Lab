#include "sim/SimulationClock.hpp"
#include <stdexcept>

namespace nexvary::avionics {

void SimulationClock::reset() {
    tick_ = 0;
    elapsed_ = std::chrono::milliseconds{0};
}

void SimulationClock::advance(std::chrono::milliseconds delta) {
    if (delta.count() <= 0) {
        throw std::invalid_argument("simulation delta must be positive");
    }
    ++tick_;
    elapsed_ += delta;
}

std::uint64_t SimulationClock::tick() const noexcept { return tick_; }
std::chrono::milliseconds SimulationClock::elapsed() const noexcept { return elapsed_; }

} // namespace nexvary::avionics
