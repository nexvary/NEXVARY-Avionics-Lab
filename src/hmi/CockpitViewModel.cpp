#include "hmi/CockpitViewModel.hpp"
#include <iomanip>
#include <sstream>

namespace nexvary::avionics {
namespace {
std::string formatted(const SensorSample& sample) {
    std::ostringstream out;
    out << std::fixed << std::setprecision(1) << sample.value << ' ' << sample.unit;
    return out.str();
}

void addSensor(CockpitPage& page, const LabSnapshot& snapshot, const std::string& id, const std::string& label) {
    const auto it = snapshot.sensors.find(id);
    if (it == snapshot.sensors.end()) {
        page.tiles.push_back({id, label, "NO DATA", "FAULT"});
        return;
    }
    page.tiles.push_back({id, label, formatted(it->second), it->second.valid ? "NOMINAL" : "FAULT"});
}
}

CockpitPage CockpitViewModel::build(const LabSnapshot& snapshot) const {
    CockpitPage page;
    page.title = "NEXVARY AVIONICS LAB";
    page.subtitle = std::string{"TRAINING / SIMULATION - "} + ScenarioEngine::toString(snapshot.scenario);
    addSensor(page, snapshot, "altitude_m", "ALTITUDE");
    addSensor(page, snapshot, "airspeed_kph", "AIRSPEED");
    addSensor(page, snapshot, "imu_pitch_deg", "PITCH");
    addSensor(page, snapshot, "imu_roll_deg", "ROLL");
    addSensor(page, snapshot, "bus_voltage_v", "POWER BUS");
    addSensor(page, snapshot, "cpu_temp_c", "COMPUTE TEMP");
    addSensor(page, snapshot, "hydraulic_pressure_pct", "HYDRAULIC");
    addSensor(page, snapshot, "fuel_level_pct", "FUEL");

    for (const auto& alert : snapshot.alerts) {
        if (alert.active) page.annunciators.push_back(alert.subsystem + ": " + alert.message);
    }
    if (page.annunciators.empty()) page.annunciators.push_back("SYSTEMS NOMINAL");
    return page;
}

} // namespace nexvary::avionics
