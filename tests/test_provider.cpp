#include "sim/NativeSyntheticProvider.hpp"
#include "telemetry/TelemetryDictionary.hpp"
#include <cassert>
using namespace nexvary::avionics;
int main(){
    SimulationClock clock; SensorBus bus; FaultInjector faults; NativeSyntheticProvider provider;
    assert(provider.id()=="native-synthetic");
    clock.advance(std::chrono::milliseconds{100});
    provider.step(clock,bus,faults);
    const auto snapshot=bus.snapshot();
    assert(snapshot.size()==TelemetryDictionary::channels().size());
    assert(snapshot.size()==15);
    assert(snapshot.count("jet_engine_core_pct")==1);
    assert(snapshot.count("turboprop_torque_pct")==1);
    assert(snapshot.count("rotor_rpm_pct")==1);
    assert(snapshot.count("battery_soc_pct")==1);
    assert(snapshot.count("link_quality_pct")==1);
    assert(snapshot.count("nav_quality_pct")==1);
    provider.setScenario(ScenarioKind::SensorDropout);
    assert(provider.scenario()==ScenarioKind::SensorDropout);
    for(int i=0;i<15;++i){clock.advance(std::chrono::milliseconds{100});provider.step(clock,bus,faults);}
    const auto pitch=bus.read("imu_pitch_deg");
    assert(pitch.has_value());
    assert(!pitch->valid);
    return 0;
}
