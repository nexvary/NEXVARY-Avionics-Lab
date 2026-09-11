#include "app/AvionicsLab.hpp"
#include "diagnostics/DiagnosticEngine.hpp"
#include "diagnostics/DiagnosticReport.hpp"
#include "sim/ScenarioEngine.hpp"
#include <cassert>
#include <string>

using namespace nexvary::avionics;

static DiagnosticSummary scan(AvionicsLab& lab, int ticks) {
    LabSnapshot snapshot;
    for (int i = 0; i < ticks; ++i) snapshot = lab.step();
    return DiagnosticEngine::analyze(
        ScenarioEngine::toString(snapshot.scenario),
        snapshot.tick,
        snapshot.sensors,
        snapshot.issues,
        lab.recorder(),
        lab.eventLog());
}

int main() {
    AvionicsLab nominal{ScenarioKind::Nominal};
    const auto nominalReport = scan(nominal, 20);
    assert(nominalReport.schema == "nexvary-avionics-diagnostic/v1");
    assert(nominalReport.frameCount == 20);
    assert(nominalReport.sensorCount >= 8);
    assert(nominalReport.healthScore >= 90.0);
    assert(!nominalReport.fingerprint.empty());

    const auto nominalJson = DiagnosticReport::toJson(nominalReport);
    const auto parsedNominal = DiagnosticReport::fromJson(nominalJson);
    assert(parsedNominal.schema == nominalReport.schema);
    assert(parsedNominal.frameCount == nominalReport.frameCount);
    assert(parsedNominal.findings.size() == nominalReport.findings.size());
    const auto nominalMarkdown = DiagnosticReport::toMarkdown(nominalReport);
    assert(nominalMarkdown.find("TRAINING / SIMULATION ONLY") != std::string::npos);

    AvionicsLab power{ScenarioKind::PowerTransient};
    const auto powerReport = scan(power, 25);
    assert(DiagnosticEngine::containsCode(powerReport, "NXD-PWR-101"));
    assert(powerReport.healthScore < nominalReport.healthScore);

    AvionicsLab dropout{ScenarioKind::SensorDropout};
    const auto dropoutReport = scan(dropout, 20);
    assert(!dropoutReport.findings.empty());
    assert(DiagnosticEngine::containsCode(dropoutReport, "NXD-FLT-303") ||
           DiagnosticEngine::containsCode(dropoutReport, "NXD-FLT-304") ||
           DiagnosticEngine::containsCode(dropoutReport, "NXD-DAT-606"));

    AvionicsLab thermal{ScenarioKind::ThermalRise};
    const auto thermalReport = scan(thermal, 20);
    assert(DiagnosticEngine::containsCode(thermalReport, "NXD-CMP-201"));
    return 0;
}
