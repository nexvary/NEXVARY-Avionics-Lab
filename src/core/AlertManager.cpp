#include "core/AlertManager.hpp"
#include <set>

namespace nexvary::avionics {

void AlertManager::update(const std::vector<HealthIssue>& issues, std::uint64_t tick) {
    std::set<std::string> seen;
    for (const auto& issue : issues) {
        const std::string key = issue.subsystem + "|" + issue.detail;
        seen.insert(key);
        auto [it, inserted] = alerts_.try_emplace(key);
        auto& alert = it->second;
        if (inserted) {
            alert.key = key;
            alert.firstSeenTick = tick;
        }
        alert.severity = issue.severity;
        alert.subsystem = issue.subsystem;
        alert.message = issue.detail;
        alert.lastSeenTick = tick;
        alert.active = true;
    }
    for (auto& [key, alert] : alerts_) {
        if (!seen.contains(key)) alert.active = false;
    }
}

std::vector<Alert> AlertManager::active() const {
    std::vector<Alert> result;
    for (const auto& [key, alert] : alerts_) {
        (void)key;
        if (alert.active) result.push_back(alert);
    }
    return result;
}

std::vector<Alert> AlertManager::history() const {
    std::vector<Alert> result;
    for (const auto& [key, alert] : alerts_) {
        (void)key;
        result.push_back(alert);
    }
    return result;
}

std::size_t AlertManager::activeCount() const { return active().size(); }

} // namespace nexvary::avionics
