#include "sim/NativeSyntheticProvider.hpp"

namespace nexvary::avionics {
NativeSyntheticProvider::NativeSyntheticProvider(ScenarioKind scenario) : engine_(scenario) {}
std::string_view NativeSyntheticProvider::id() const noexcept { return "native-synthetic"; }
void NativeSyntheticProvider::reset() {}
void NativeSyntheticProvider::setScenario(ScenarioKind scenario) { engine_.setScenario(scenario); }
ScenarioKind NativeSyntheticProvider::scenario() const noexcept { return engine_.scenario(); }
void NativeSyntheticProvider::step(const SimulationClock& clock, SensorBus& bus, FaultInjector& faults) { engine_.step(clock, bus, faults); }
} // namespace nexvary::avionics
