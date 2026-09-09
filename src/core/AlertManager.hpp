#pragma once
#include "core/SystemHealth.hpp"
#include <cstdint>
#include <map>
#include <string>
#include <vector>

namespace nexvary::avionics {

struct Alert {
    std::string key;
    Severity severity{Severity::Info};
    std::string subsystem;
    std::string message;
    std::uint64_t firstSeenTick{0};
    std::uint64_t lastSeenTick{0};
    bool active{false};
};

class AlertManager {
public:
    void update(const std::vector<HealthIssue>& issues, std::uint64_t tick);
    [[nodiscard]] std::vector<Alert> active() const;
    [[nodiscard]] std::vector<Alert> history() const;
    [[nodiscard]] std::size_t activeCount() const;

private:
    std::map<std::string, Alert> alerts_;
};

} // namespace nexvary::avionics
