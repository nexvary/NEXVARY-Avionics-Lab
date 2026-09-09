#include "twin/DigitalTwin.hpp"
#include <algorithm>
#include <array>
#include <string_view>

namespace nexvary::avionics {
namespace {

struct Definition {
    std::string_view id;
    std::vector<std::string_view> sensors;
};

const std::array<Definition, 5> kDefinitions{{
    {"power", {"bus_voltage_v"}},
    {"compute", {"cpu_temp_c"}},
    {"flight_sensors", {"imu_pitch_deg", "imu_roll_deg", "altitude_m", "airspeed_kph"}},
    {"hydraulics", {"hydraulic_pressure_pct"}},
    {"fuel", {"fuel_level_pct"}},
}};

std::string_view groupForSource(std::string_view source) {
    for (const auto& definition : kDefinitions) {
        if (source == definition.id) return definition.id;
        for (const auto sensor : definition.sensors) {
            if (source == sensor) return definition.id;
        }
    }
    return {};
}

int rank(TwinState state) noexcept {
    switch (state) {
        case TwinState::Unknown: return 0;
        case TwinState::Nominal: return 1;
        case TwinState::Degraded: return 2;
        case TwinState::Fault: return 3;
    }
    return 0;
}

void escalate(TwinSubsystem& subsystem, TwinState candidate) {
    if (rank(candidate) > rank(subsystem.state)) subsystem.state = candidate;
}

} // namespace

DigitalTwinSnapshot DigitalTwinModel::build(
    const std::map<std::string, SensorSample>& sensors,
    const std::vector<HealthIssue>& issues) {
    DigitalTwinSnapshot result;
    result.subsystems.reserve(kDefinitions.size());

    for (const auto& definition : kDefinitions) {
        TwinSubsystem subsystem;
        subsystem.id = definition.id;
        subsystem.expectedChannels = definition.sensors.size();

        for (const auto sensorName : definition.sensors) {
            const auto it = sensors.find(std::string(sensorName));
            if (it == sensors.end()) continue;
            ++subsystem.observedChannels;
            if (it->second.valid) {
                ++subsystem.validChannels;
            } else {
                escalate(subsystem, TwinState::Fault);
            }
        }

        if (subsystem.observedChannels == 0) {
            subsystem.state = TwinState::Unknown;
        } else if (subsystem.state != TwinState::Fault) {
            subsystem.state = subsystem.observedChannels < subsystem.expectedChannels
                ? TwinState::Degraded
                : TwinState::Nominal;
        }

        for (const auto& issue : issues) {
            if (groupForSource(issue.subsystem) != definition.id) continue;
            ++subsystem.issueCount;
            if (issue.severity == Severity::Fault) {
                escalate(subsystem, TwinState::Fault);
            } else if (issue.severity == Severity::Warning) {
                escalate(subsystem, TwinState::Degraded);
            }
        }

        const double completeness = subsystem.expectedChannels == 0
            ? 0.0
            : 100.0 * static_cast<double>(subsystem.validChannels)
                / static_cast<double>(subsystem.expectedChannels);
        switch (subsystem.state) {
            case TwinState::Nominal:
                subsystem.healthPercent = completeness;
                ++result.nominalCount;
                break;
            case TwinState::Degraded:
                subsystem.healthPercent = std::min(completeness, 75.0);
                ++result.degradedCount;
                break;
            case TwinState::Fault:
                subsystem.healthPercent = std::min(completeness, 25.0);
                ++result.faultCount;
                break;
            case TwinState::Unknown:
                subsystem.healthPercent = 0.0;
                ++result.unknownCount;
                break;
        }

        result.subsystems.push_back(std::move(subsystem));
    }

    return result;
}

const char* to_string(TwinState state) noexcept {
    switch (state) {
        case TwinState::Unknown: return "UNKNOWN";
        case TwinState::Nominal: return "NOMINAL";
        case TwinState::Degraded: return "DEGRADED";
        case TwinState::Fault: return "FAULT";
    }
    return "UNKNOWN";
}

} // namespace nexvary::avionics
