#pragma once
#include "core/SensorBus.hpp"
#include "sim/FaultInjector.hpp"
#include "sim/SimulationClock.hpp"
#include <string>
#include <vector>

namespace nexvary::avionics {

enum class ScenarioKind { Nominal, PowerTransient, SensorDropout, ThermalRise };

class ScenarioEngine {
public:
    explicit ScenarioEngine(ScenarioKind kind = ScenarioKind::Nominal);
    void setScenario(ScenarioKind kind);
    [[nodiscard]] ScenarioKind scenario() const noexcept;
    void step(const SimulationClock& clock, SensorBus& bus, FaultInjector& faults) const;
    [[nodiscard]] static std::vector<std::string> names();
    [[nodiscard]] static ScenarioKind fromName(const std::string& name);
    [[nodiscard]] static const char* toString(ScenarioKind kind);

private:
    ScenarioKind kind_;
};

} // namespace nexvary::avionics
