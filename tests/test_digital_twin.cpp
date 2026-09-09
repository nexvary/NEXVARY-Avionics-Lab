#include "app/AvionicsLab.hpp"
#include "twin/DigitalTwin.hpp"
#include <cassert>
#include <string>

using namespace nexvary::avionics;

namespace {
TwinSubsystem find(const DigitalTwinSnapshot& snapshot, const std::string& id) {
    for (const auto& subsystem : snapshot.subsystems) {
        if (subsystem.id == id) return subsystem;
    }
    assert(false && "missing twin subsystem");
    return {};
}
}

int main() {
    AvionicsLab nominal{ScenarioKind::Nominal};
    for (int i = 0; i < 20; ++i) nominal.step();
    auto snapshot = nominal.snapshot();
    auto twin = DigitalTwinModel::build(snapshot.sensors, snapshot.issues);
    assert(twin.subsystems.size() == 5);
    assert(twin.nominalCount == 5);
    assert(twin.degradedCount == 0);
    assert(twin.faultCount == 0);
    assert(find(twin, "flight_sensors").healthPercent == 100.0);

    AvionicsLab power{ScenarioKind::PowerTransient};
    for (int i = 0; i < 20; ++i) power.step();
    snapshot = power.snapshot();
    twin = DigitalTwinModel::build(snapshot.sensors, snapshot.issues);
    assert(find(twin, "power").state == TwinState::Degraded);
    assert(find(twin, "power").issueCount > 0);

    AvionicsLab dropout{ScenarioKind::SensorDropout};
    for (int i = 0; i < 15; ++i) dropout.step();
    snapshot = dropout.snapshot();
    twin = DigitalTwinModel::build(snapshot.sensors, snapshot.issues);
    const auto flightSensors = find(twin, "flight_sensors");
    assert(flightSensors.state == TwinState::Fault);
    assert(flightSensors.validChannels == 3);
    assert(flightSensors.issueCount > 0);

    AvionicsLab thermal{ScenarioKind::ThermalRise};
    for (int i = 0; i < 35; ++i) thermal.step();
    snapshot = thermal.snapshot();
    twin = DigitalTwinModel::build(snapshot.sensors, snapshot.issues);
    assert(find(twin, "compute").state == TwinState::Degraded);

    std::map<std::string, SensorSample> incomplete{{"bus_voltage_v", {27.0, "V", true}}};
    twin = DigitalTwinModel::build(incomplete, {});
    assert(find(twin, "power").state == TwinState::Nominal);
    assert(find(twin, "compute").state == TwinState::Unknown);
    assert(twin.unknownCount == 4);
    return 0;
}
