#include "core/Watchdog.hpp"

namespace nexvary::avionics {

Watchdog::Watchdog(std::chrono::milliseconds timeout)
    : timeout_(timeout), last_kick_(std::chrono::steady_clock::now()) {}

void Watchdog::kick() {
    last_kick_ = std::chrono::steady_clock::now();
}

bool Watchdog::expired() const {
    return std::chrono::steady_clock::now() - last_kick_ > timeout_;
}

} // namespace nexvary::avionics
