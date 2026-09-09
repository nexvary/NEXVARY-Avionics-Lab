#pragma once
#include "sim/SimulationProvider.hpp"

namespace nexvary::avionics {

class NativeSyntheticProvider final : public SimulationProvider {
public:
    explicit NativeSyntheticProvider(ScenarioKind scenario = ScenarioKind::Nominal);
    [[nodiscard]] std::string_view id() const noexcept override;
    void reset() override;
    void setScenario(ScenarioKind scenario) override;
    [[nodiscard]] ScenarioKind scenario() const noexcept override;
    void step(const SimulationClock& clock, SensorBus& bus, FaultInjector& faults) override;
private:
    ScenarioEngine engine_;
};

} // namespace nexvary::avionics
