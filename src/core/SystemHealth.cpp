#include "core/SystemHealth.hpp"

namespace nexvary::avionics {

std::vector<HealthIssue> SystemHealth::evaluate(const SensorBus& bus) const {
    std::vector<HealthIssue> issues;
    const auto sensors = bus.snapshot();

    for (const auto& [name, sample] : sensors) {
        if (!sample.valid) {
            issues.push_back({Severity::Fault, name, "sensor sample marked invalid"});
        }
    }

    if (const auto temp = bus.read("cpu_temp_c")) {
        if (temp->valid && temp->value > 85.0) {
            issues.push_back({Severity::Warning, "compute", "CPU temperature above training threshold"});
        }
    }

    if (const auto voltage = bus.read("bus_voltage_v")) {
        if (voltage->valid && (voltage->value < 22.0 || voltage->value > 30.0)) {
            issues.push_back({Severity::Warning, "power", "simulated bus voltage outside nominal range"});
        }
    }

    return issues;
}

} // namespace nexvary::avionics
