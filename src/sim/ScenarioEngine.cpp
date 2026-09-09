#include "sim/ScenarioEngine.hpp"
#include <cmath>
#include <stdexcept>

namespace nexvary::avionics {

ScenarioEngine::ScenarioEngine(ScenarioKind kind) : kind_(kind) {}
void ScenarioEngine::setScenario(ScenarioKind kind) { kind_ = kind; }
ScenarioKind ScenarioEngine::scenario() const noexcept { return kind_; }

void ScenarioEngine::step(const SimulationClock& clock, SensorBus& bus, FaultInjector& faults) const {
    const double t = static_cast<double>(clock.elapsed().count()) / 1000.0;
    const double wave = std::sin(t * 0.35);

    bus.publish("cpu_temp_c", {58.0 + wave * 2.5, "C", true});
    bus.publish("bus_voltage_v", {27.2 + std::sin(t * 0.2) * 0.25, "V", true});
    bus.publish("imu_pitch_deg", {std::sin(t * 0.45) * 4.0, "deg", true});
    bus.publish("imu_roll_deg", {std::sin(t * 0.31) * 7.0, "deg", true});
    bus.publish("altitude_m", {2400.0 + std::sin(t * 0.08) * 120.0, "m", true});
    bus.publish("airspeed_kph", {640.0 + std::sin(t * 0.12) * 18.0, "km/h", true});
    bus.publish("hydraulic_pressure_pct", {94.0 + std::sin(t * 0.19) * 2.0, "%", true});
    bus.publish("fuel_level_pct", {78.0 - t * 0.002, "%", true});

    faults.clear();
    switch (kind_) {
        case ScenarioKind::Nominal:
            break;
        case ScenarioKind::PowerTransient:
            if (clock.tick() >= 15 && clock.tick() <= 35) {
                faults.set({"scenario-power", "bus_voltage_v", FaultMode::Override, 20.8, true});
            }
            break;
        case ScenarioKind::SensorDropout:
            if (clock.tick() >= 12 && clock.tick() <= 28) {
                faults.set({"scenario-imu", "imu_pitch_deg", FaultMode::Invalidate, 0.0, true});
            }
            break;
        case ScenarioKind::ThermalRise:
            if (clock.tick() >= 10) {
                const double rise = static_cast<double>(clock.tick() - 9) * 1.4;
                faults.set({"scenario-thermal", "cpu_temp_c", FaultMode::Offset, rise, true});
            }
            break;
    }
    faults.apply(bus);
}

std::vector<std::string> ScenarioEngine::names() {
    return {"nominal", "power-transient", "sensor-dropout", "thermal-rise"};
}

ScenarioKind ScenarioEngine::fromName(const std::string& name) {
    if (name == "nominal") return ScenarioKind::Nominal;
    if (name == "power-transient") return ScenarioKind::PowerTransient;
    if (name == "sensor-dropout") return ScenarioKind::SensorDropout;
    if (name == "thermal-rise") return ScenarioKind::ThermalRise;
    throw std::invalid_argument("unknown scenario: " + name);
}

const char* ScenarioEngine::toString(ScenarioKind kind) {
    switch (kind) {
        case ScenarioKind::Nominal: return "NOMINAL";
        case ScenarioKind::PowerTransient: return "POWER TRANSIENT";
        case ScenarioKind::SensorDropout: return "SENSOR DROPOUT";
        case ScenarioKind::ThermalRise: return "THERMAL RISE";
    }
    return "UNKNOWN";
}

} // namespace nexvary::avionics
