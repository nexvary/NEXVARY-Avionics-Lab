#pragma once
#include "core/AlertManager.hpp"
#include "core/EventLog.hpp"
#include "core/SensorBus.hpp"
#include "core/SystemHealth.hpp"
#include "core/TelemetryRecorder.hpp"
#include "sim/FaultInjector.hpp"
#include "sim/ScenarioEngine.hpp"
#include "sim/SimulationClock.hpp"
#include <chrono>
#include <vector>

namespace nexvary::avionics {

struct LabSnapshot {
    std::uint64_t tick{0};
    std::chrono::milliseconds simTime{0};
    ScenarioKind scenario{ScenarioKind::Nominal};
    std::map<std::string, SensorSample> sensors;
    std::vector<HealthIssue> issues;
    std::vector<Alert> alerts;
};

class AvionicsLab {
public:
    explicit AvionicsLab(ScenarioKind scenario = ScenarioKind::Nominal);
    LabSnapshot step(std::chrono::milliseconds delta = std::chrono::milliseconds{100});
    void reset();
    void setScenario(ScenarioKind scenario);
    [[nodiscard]] LabSnapshot snapshot() const;
    [[nodiscard]] const TelemetryRecorder& recorder() const noexcept;
    [[nodiscard]] const EventLog& eventLog() const noexcept;

private:
    SensorBus bus_;
    EventLog log_;
    SystemHealth health_;
    AlertManager alerts_;
    TelemetryRecorder recorder_;
    FaultInjector faults_;
    SimulationClock clock_;
    ScenarioEngine scenario_;
    std::size_t lastActiveAlerts_{0};
};

} // namespace nexvary::avionics
