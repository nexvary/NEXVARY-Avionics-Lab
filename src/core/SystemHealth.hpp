#pragma once
#include "core/EventLog.hpp"
#include "core/SensorBus.hpp"
#include <string>
#include <vector>

namespace nexvary::avionics {

struct HealthIssue {
    Severity severity;
    std::string subsystem;
    std::string detail;
};

class SystemHealth {
public:
    [[nodiscard]] std::vector<HealthIssue> evaluate(const SensorBus& bus) const;
};

} // namespace nexvary::avionics
