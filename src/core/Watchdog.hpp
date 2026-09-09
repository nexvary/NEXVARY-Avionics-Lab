#pragma once
#include <chrono>

namespace nexvary::avionics {

class Watchdog {
public:
    explicit Watchdog(std::chrono::milliseconds timeout);
    void kick();
    [[nodiscard]] bool expired() const;

private:
    std::chrono::milliseconds timeout_;
    std::chrono::steady_clock::time_point last_kick_;
};

} // namespace nexvary::avionics
