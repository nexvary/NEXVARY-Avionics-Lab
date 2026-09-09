#pragma once
#include "core/SensorBus.hpp"
#include "sim/FaultInjector.hpp"
#include "sim/ScenarioEngine.hpp"
#include "sim/SimulationClock.hpp"
#include <string_view>

namespace nexvary::avionics {

class SimulationProvider {
public:
    virtual ~SimulationProvider() = default;
    [[nodiscard]] virtual std::string_view id() const noexcept = 0;
    virtual void reset() = 0;
    virtual void setScenario(ScenarioKind scenario) = 0;
    [[nodiscard]] virtual ScenarioKind scenario() const noexcept = 0;
    virtual void step(const SimulationClock& clock, SensorBus& bus, FaultInjector& faults) = 0;
};

} // namespace nexvary::avionics
