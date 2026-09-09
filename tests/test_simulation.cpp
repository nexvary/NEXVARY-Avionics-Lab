#include "app/AvionicsLab.hpp"
#include "core/TelemetryRecorder.hpp"
#include "sim/FaultInjector.hpp"
#include "sim/ScenarioEngine.hpp"
#include "sim/SimulationClock.hpp"
#include <cassert>
#include <chrono>

using namespace nexvary::avionics;

int main() {
    SimulationClock clock;
    clock.advance(std::chrono::milliseconds{100});
    assert(clock.tick() == 1);
    assert(clock.elapsed().count() == 100);

    SensorBus bus;
    bus.publish("x", {10.0, "u", true});
    FaultInjector faults;
    faults.set({"offset", "x", FaultMode::Offset, 5.0, true});
    faults.apply(bus);
    assert(bus.read("x")->value == 15.0);

    AvionicsLab lab(ScenarioKind::PowerTransient);
    LabSnapshot snap;
    for (int i = 0; i < 20; ++i) snap = lab.step();
    assert(snap.tick == 20);
    assert(lab.recorder().size() == 20);
    assert(!snap.alerts.empty());

    ReplayCursor replay(lab.recorder());
    std::size_t frames = 0;
    while (replay.next()) ++frames;
    assert(frames == 20);

    AvionicsLab normal(ScenarioKind::Nominal);
    for (int i = 0; i < 100; ++i) snap = normal.step();
    assert(snap.issues.empty());
    assert(normal.recorder().size() == 100);
    return 0;
}
