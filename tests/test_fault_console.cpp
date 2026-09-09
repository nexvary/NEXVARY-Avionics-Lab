#include "app/AvionicsLab.hpp"
#include <cassert>

using namespace nexvary::avionics;

int main() {
    AvionicsLab lab{ScenarioKind::Nominal};
    auto snapshot = lab.step();
    assert(lab.activeTrainingFaults().empty());
    assert(snapshot.sensors.at("imu_pitch_deg").valid);

    assert(lab.applyTrainingFault("imu-dropout"));
    snapshot = lab.step();
    assert(lab.activeTrainingFaults().size() == 1);
    assert(!snapshot.sensors.at("imu_pitch_deg").valid);
    assert(!snapshot.issues.empty());

    lab.clearTrainingFaults();
    snapshot = lab.step();
    assert(lab.activeTrainingFaults().empty());
    assert(snapshot.sensors.at("imu_pitch_deg").valid);

    assert(lab.applyTrainingFault("low-power-bus"));
    snapshot = lab.step();
    assert(snapshot.sensors.at("bus_voltage_v").value == 20.5);
    assert(!snapshot.issues.empty());

    lab.clearTrainingFaults();
    assert(lab.applyTrainingFault("compute-hot"));
    snapshot = lab.step();
    assert(snapshot.sensors.at("cpu_temp_c").value == 91.0);
    assert(!snapshot.issues.empty());

    assert(!lab.applyTrainingFault("not-a-preset"));
    lab.reset();
    snapshot = lab.step();
    assert(lab.activeTrainingFaults().empty());
    assert(snapshot.sensors.at("cpu_temp_c").value < 85.0);
    return 0;
}
