#include "app/AvionicsLab.hpp"
#include "diagnostics/DiagnosticCasebook.hpp"
#include "diagnostics/DiagnosticComparator.hpp"
#include "diagnostics/DiagnosticEngine.hpp"
#include "diagnostics/DiagnosticHistory.hpp"
#include "diagnostics/DiagnosticWorkflow.hpp"
#include "sim/ScenarioEngine.hpp"
#include <cassert>
#include <string>
#include <vector>

using namespace nexvary::avionics;

static DiagnosticSummary makeScan(ScenarioKind kind, int ticks) {
    AvionicsLab lab{kind};
    LabSnapshot snapshot;
    for (int i = 0; i < ticks; ++i) snapshot = lab.step();
    return DiagnosticEngine::analyze(ScenarioEngine::toString(snapshot.scenario), snapshot.tick, snapshot.sensors, snapshot.issues, lab.recorder(), lab.eventLog());
}

int main() {
    const auto nominal = makeScan(ScenarioKind::Nominal, 20);
    const auto power = makeScan(ScenarioKind::PowerTransient, 25);
    const auto comparison = DiagnosticComparator::compare(nominal, power);
    assert(comparison.healthDelta < 0.0);
    assert(!comparison.newCodes.empty());

    DiagnosticHistory history;
    history.ingest(power);
    history.ingest(power);
    assert(history.activeCount() == power.findings.size());
    assert(history.recurrentCount() >= 1);

    DiagnosticCaseRecord record;
    record.id = "DX-0001";
    record.title = "Power transient training case";
    record.openedTick = power.generatedTick;
    record.updatedTick = power.generatedTick;
    for (const auto& finding : power.findings) record.findingCodes.push_back(finding.code);
    assert(DiagnosticWorkflow::transition(record, DiagnosticWorkflowState::Isolating, 26, "evidence correlation started"));
    assert(DiagnosticWorkflow::transition(record, DiagnosticWorkflowState::Recovering, 27, "synthetic initiating condition removed"));
    assert(DiagnosticWorkflow::transition(record, DiagnosticWorkflowState::Verifying, 28, "recovery verification started"));
    assert(DiagnosticWorkflow::transition(record, DiagnosticWorkflowState::Closed, 29, "training case verified"));
    assert(!DiagnosticWorkflow::transition(record, DiagnosticWorkflowState::Detected, 30));

    const std::vector<DiagnosticCaseRecord> cases{record};
    const auto json = DiagnosticCasebook::toJson(cases);
    const auto parsed = DiagnosticCasebook::fromJson(json);
    assert(parsed.size() == 1);
    assert(parsed.front().state == DiagnosticWorkflowState::Closed);
    assert(parsed.front().findingCodes == record.findingCodes);
    return 0;
}
