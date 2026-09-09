#include "sim/NativeSyntheticProvider.hpp"
#include <cassert>
using namespace nexvary::avionics;
int main(){SimulationClock clock;SensorBus bus;FaultInjector faults;NativeSyntheticProvider provider;assert(provider.id()=="native-synthetic");clock.advance(std::chrono::milliseconds{100});provider.step(clock,bus,faults);assert(bus.snapshot().size()==8);provider.setScenario(ScenarioKind::SensorDropout);assert(provider.scenario()==ScenarioKind::SensorDropout);for(int i=0;i<15;++i){clock.advance(std::chrono::milliseconds{100});provider.step(clock,bus,faults);}const auto pitch=bus.read("imu_pitch_deg");assert(pitch.has_value());assert(!pitch->valid);return 0;}
