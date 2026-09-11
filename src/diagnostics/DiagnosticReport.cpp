#include "diagnostics/DiagnosticReport.hpp"
#include <nlohmann/json.hpp>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <stdexcept>
#include <utility>

namespace nexvary::avionics {
namespace {
using json = nlohmann::json;

DiagnosticSeverity severityFromString(const std::string& value) {
    if (value == "FAULT") return DiagnosticSeverity::Fault;
    if (value == "WARNING") return DiagnosticSeverity::Warning;
    return DiagnosticSeverity::Advisory;
}

json evidenceJson(const DiagnosticEvidence& evidence) {
    return json{{"source", evidence.source}, {"key", evidence.key}, {"observation", evidence.observation}, {"expected", evidence.expected}, {"sequence", evidence.sequence}, {"weight", evidence.weight}};
}

json findingJson(const DiagnosticFinding& finding) {
    json evidence = json::array();
    for (const auto& item : finding.evidence) evidence.push_back(evidenceJson(item));
    return json{{"code", finding.code}, {"system", finding.system}, {"category", finding.category}, {"severity", diagnosticSeverityName(finding.severity)}, {"title", finding.title}, {"probable_cause", finding.probableCause}, {"isolation", finding.isolation}, {"recovery", finding.recovery}, {"confidence", finding.confidence}, {"priority", finding.priority}, {"occurrences", finding.occurrences}, {"recovery_verified", finding.recoveryVerified}, {"evidence", evidence}};
}

void writeText(const std::string& path, const std::string& text) {
    std::ofstream output(path, std::ios::binary | std::ios::trunc);
    if (!output) throw std::runtime_error("unable to open diagnostic report for writing: " + path);
    output << text;
    if (!output) throw std::runtime_error("failed to write diagnostic report: " + path);
}
}

std::string DiagnosticReport::toJson(const DiagnosticSummary& summary) {
    json findings = json::array();
    for (const auto& finding : summary.findings) findings.push_back(findingJson(finding));
    json root{
        {"schema", summary.schema},
        {"scope", summary.scope},
        {"scenario", summary.scenario},
        {"generated_tick", summary.generatedTick},
        {"frame_count", summary.frameCount},
        {"event_count", summary.eventCount},
        {"sensor_count", summary.sensorCount},
        {"health_score", summary.healthScore},
        {"fingerprint", summary.fingerprint},
        {"counts", {{"advisory", summary.advisoryCount}, {"warning", summary.warningCount}, {"fault", summary.faultCount}}},
        {"recommendations", summary.recommendations},
        {"findings", findings}
    };
    return root.dump(2);
}

DiagnosticSummary DiagnosticReport::fromJson(std::string_view jsonText) {
    const auto root = json::parse(jsonText.begin(), jsonText.end());
    DiagnosticSummary summary;
    summary.schema = root.value("schema", "nexvary-avionics-diagnostic/v1");
    summary.scope = root.value("scope", "training-simulation");
    summary.scenario = root.value("scenario", "unknown");
    summary.generatedTick = root.value("generated_tick", std::uint64_t{0});
    summary.frameCount = root.value("frame_count", std::size_t{0});
    summary.eventCount = root.value("event_count", std::size_t{0});
    summary.sensorCount = root.value("sensor_count", std::size_t{0});
    summary.healthScore = root.value("health_score", 100.0);
    summary.fingerprint = root.value("fingerprint", std::string{});
    if (root.contains("recommendations")) summary.recommendations = root.at("recommendations").get<std::vector<std::string>>();
    if (root.contains("findings")) {
        for (const auto& item : root.at("findings")) {
            DiagnosticFinding finding;
            finding.code = item.value("code", "");
            finding.system = item.value("system", "");
            finding.category = item.value("category", "");
            finding.severity = severityFromString(item.value("severity", "ADVISORY"));
            finding.title = item.value("title", "");
            finding.probableCause = item.value("probable_cause", "");
            finding.isolation = item.value("isolation", "");
            finding.recovery = item.value("recovery", "");
            finding.confidence = item.value("confidence", 0.0);
            finding.priority = item.value("priority", 0);
            finding.occurrences = item.value("occurrences", std::size_t{1});
            finding.recoveryVerified = item.value("recovery_verified", false);
            if (item.contains("evidence")) {
                for (const auto& evidenceItem : item.at("evidence")) {
                    finding.evidence.push_back({
                        evidenceItem.value("source", ""),
                        evidenceItem.value("key", ""),
                        evidenceItem.value("observation", ""),
                        evidenceItem.value("expected", ""),
                        evidenceItem.value("sequence", std::uint64_t{0}),
                        evidenceItem.value("weight", 1.0)});
                }
            }
            summary.findings.push_back(std::move(finding));
        }
    }
    for (const auto& finding : summary.findings) {
        if (finding.severity == DiagnosticSeverity::Fault) ++summary.faultCount;
        else if (finding.severity == DiagnosticSeverity::Warning) ++summary.warningCount;
        else ++summary.advisoryCount;
    }
    return summary;
}

std::string DiagnosticReport::toMarkdown(const DiagnosticSummary& summary) {
    std::ostringstream out;
    out << "# NEXVARY Avionics Diagnostic Report\n\n";
    out << "> TRAINING / SIMULATION ONLY — synthetic evidence, not OEM or airworthiness data.\n\n";
    out << "- Schema: `" << summary.schema << "`\n";
    out << "- Scenario: **" << summary.scenario << "**\n";
    out << "- Tick: **" << summary.generatedTick << "**\n";
    out << "- Frames: **" << summary.frameCount << "**\n";
    out << "- Events: **" << summary.eventCount << "**\n";
    out << "- Diagnostic health score: **" << std::fixed << std::setprecision(1) << summary.healthScore << "/100**\n";
    out << "- Fingerprint: `" << summary.fingerprint << "`\n";
    out << "- Findings: **" << summary.findings.size() << "** (" << summary.faultCount << " fault / " << summary.warningCount << " warning / " << summary.advisoryCount << " advisory)\n\n";
    out << "## Findings\n\n";
    if (summary.findings.empty()) out << "No active diagnostic findings in the analyzed synthetic state.\n\n";
    for (const auto& finding : summary.findings) {
        out << "### " << finding.code << " — " << finding.title << "\n\n";
        out << "- System: **" << finding.system << " / " << finding.category << "**\n";
        out << "- Severity: **" << diagnosticSeverityName(finding.severity) << "**\n";
        out << "- Confidence: **" << std::setprecision(0) << finding.confidence * 100.0 << "%**\n";
        out << "- Priority: **" << finding.priority << "**\n";
        out << "- Probable cause: " << finding.probableCause << "\n";
        out << "- Isolation: " << finding.isolation << "\n";
        out << "- Recovery: " << finding.recovery << "\n";
        out << "- Evidence:\n";
        for (const auto& evidence : finding.evidence) {
            out << "  - `" << evidence.source << "/" << evidence.key << "`: " << evidence.observation << " (expected: " << evidence.expected << ", seq " << evidence.sequence << ")\n";
        }
        out << "\n";
    }
    out << "## Training Recommendations\n\n";
    for (const auto& recommendation : summary.recommendations) out << "- " << recommendation << "\n";
    return out.str();
}

void DiagnosticReport::writeJson(const std::string& path, const DiagnosticSummary& summary) { writeText(path, toJson(summary)); }
void DiagnosticReport::writeMarkdown(const std::string& path, const DiagnosticSummary& summary) { writeText(path, toMarkdown(summary)); }

} // namespace nexvary::avionics
