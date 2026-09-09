#include "app/AvionicsLab.hpp"

namespace nexvary::avionics {

AvionicsLab::AvionicsLab(ScenarioKind scenario) : scenario_(scenario) {
    log_.push(Severity::Info, "lab", "training simulation initialized");
}

LabSnapshot AvionicsLab::step(std::chrono::milliseconds delta) {
    clock_.advance(delta);
    scenario_.step(clock_, bus_, faults_);
    const auto issues = health_.evaluate(bus_);
    alerts_.update(issues, clock_.tick());
    recorder_.record(clock_.tick(), clock_.elapsed(), bus_);

    const auto active = alerts_.activeCount();
    if (active != lastActiveAlerts_) {
        log_.push(active > lastActiveAlerts_ ? Severity::Warning : Severity::Info,
                  "health", active > lastActiveAlerts_ ? "active alert count increased" : "active alert count decreased");
        lastActiveAlerts_ = active;
    }
    return snapshot();
}

void AvionicsLab::reset() {
    bus_.clear();
    recorder_.clear();
    alerts_ = AlertManager{};
    faults_.clear();
    clock_.reset();
    lastActiveAlerts_ = 0;
    log_.push(Severity::Info, "lab", "simulation reset");
}

void AvionicsLab::setScenario(ScenarioKind scenario) {
    scenario_.setScenario(scenario);
    log_.push(Severity::Info, "scenario", std::string("scenario selected: ") + ScenarioEngine::toString(scenario));
}

LabSnapshot AvionicsLab::snapshot() const {
    const auto issues = health_.evaluate(bus_);
    return {clock_.tick(), clock_.elapsed(), scenario_.scenario(), bus_.snapshot(), issues, alerts_.active()};
}

const TelemetryRecorder& AvionicsLab::recorder() const noexcept { return recorder_; }
const EventLog& AvionicsLab::eventLog() const noexcept { return log_; }

} // namespace nexvary::avionics
