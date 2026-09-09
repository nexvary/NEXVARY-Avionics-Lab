#include "app/AvionicsLab.hpp"
#include "sim/NativeSyntheticProvider.hpp"
#include "sim/TrainingFaultCatalog.hpp"
#include <string>
namespace nexvary::avionics {
AvionicsLab::AvionicsLab(ScenarioKind scenario):provider_(std::make_unique<NativeSyntheticProvider>(scenario)){log_.push(Severity::Info,"lab","training simulation initialized");}
LabSnapshot AvionicsLab::step(std::chrono::milliseconds delta){clock_.advance(delta);provider_->step(clock_,bus_,scenarioFaults_);trainingFaults_.apply(bus_);const auto issues=health_.evaluate(bus_);alerts_.update(issues,clock_.tick());recorder_.record(clock_.tick(),clock_.elapsed(),bus_);const auto active=alerts_.activeCount();if(active!=lastActiveAlerts_){log_.push(active>lastActiveAlerts_?Severity::Warning:Severity::Info,"health",active>lastActiveAlerts_?"active alert count increased":"active alert count decreased");lastActiveAlerts_=active;}return snapshot();}
void AvionicsLab::reset(){bus_.clear();recorder_.clear();alerts_=AlertManager{};scenarioFaults_.clear();trainingFaults_.clear();clock_.reset();provider_->reset();lastActiveAlerts_=0;log_.push(Severity::Info,"lab","simulation reset");}
void AvionicsLab::setScenario(ScenarioKind scenario){provider_->setScenario(scenario);log_.push(Severity::Info,"scenario",std::string("scenario selected: ")+ScenarioEngine::toString(scenario));}
bool AvionicsLab::applyTrainingFault(std::string_view presetId){const auto preset=TrainingFaultCatalog::find(presetId);if(!preset){log_.push(Severity::Warning,"fault_lab","rejected unknown training fault preset");return false;}trainingFaults_.set(preset->fault);log_.push(Severity::Info,"fault_lab",std::string("training fault applied: ")+preset->id);return true;}
void AvionicsLab::clearTrainingFaults(){if(trainingFaults_.active().empty())return;trainingFaults_.clear();log_.push(Severity::Info,"fault_lab","all training faults cleared");}
std::vector<FaultSpec> AvionicsLab::activeTrainingFaults() const{return trainingFaults_.active();}
LabSnapshot AvionicsLab::snapshot() const{const auto issues=health_.evaluate(bus_);return {clock_.tick(),clock_.elapsed(),provider_->scenario(),bus_.snapshot(),issues,alerts_.active()};}
const TelemetryRecorder& AvionicsLab::recorder() const noexcept{return recorder_;}const EventLog& AvionicsLab::eventLog() const noexcept{return log_;}std::string_view AvionicsLab::providerId() const noexcept{return provider_->id();}
} // namespace nexvary::avionics
