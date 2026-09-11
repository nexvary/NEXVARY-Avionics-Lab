#include "diagnostics/DiagnosticEngine.hpp"
#include <algorithm>
#include <cctype>
#include <cmath>
#include <iomanip>
#include <set>
#include <sstream>
#include <string>

namespace nexvary::avionics {
namespace {

std::string lower(std::string value) {
    std::transform(value.begin(), value.end(), value.begin(), [](unsigned char c) {
        return static_cast<char>(std::tolower(c));
    });
    return value;
}

std::string number(double value, int precision = 2) {
    std::ostringstream out;
    out << std::fixed << std::setprecision(precision) << value;
    return out.str();
}

int basePriority(DiagnosticSeverity severity) noexcept {
    switch (severity) {
        case DiagnosticSeverity::Fault: return 90;
        case DiagnosticSeverity::Warning: return 60;
        case DiagnosticSeverity::Advisory: return 30;
    }
    return 30;
}

void addFinding(std::vector<DiagnosticFinding>& findings, DiagnosticFinding finding) {
    finding.confidence = std::clamp(finding.confidence, 0.0, 0.99);
    finding.priority = std::clamp(basePriority(finding.severity) + static_cast<int>(std::round(finding.confidence * 9.0)), 0, 99);
    const auto existing = std::find_if(findings.begin(), findings.end(), [&](const DiagnosticFinding& item) {
        return item.code == finding.code;
    });
    if (existing == findings.end()) {
        findings.push_back(std::move(finding));
        return;
    }
    existing->occurrences += finding.occurrences;
    existing->confidence = std::max(existing->confidence, finding.confidence);
    existing->priority = std::max(existing->priority, finding.priority);
    if (static_cast<int>(finding.severity) > static_cast<int>(existing->severity)) existing->severity = finding.severity;
    for (const auto& evidence : finding.evidence) {
        if (existing->evidence.size() >= 12) break;
        existing->evidence.push_back(evidence);
    }
}

DiagnosticFinding makeFinding(
    std::string code,
    std::string system,
    std::string category,
    DiagnosticSeverity severity,
    std::string title,
    std::string cause,
    std::string isolation,
    std::string recovery,
    double confidence,
    DiagnosticEvidence evidence) {
    DiagnosticFinding result;
    result.code = std::move(code);
    result.system = std::move(system);
    result.category = std::move(category);
    result.severity = severity;
    result.title = std::move(title);
    result.probableCause = std::move(cause);
    result.isolation = std::move(isolation);
    result.recovery = std::move(recovery);
    result.confidence = confidence;
    result.evidence.push_back(std::move(evidence));
    return result;
}

const SensorSample* sensor(const std::map<std::string, SensorSample>& sensors, std::string_view id) {
    const auto it = sensors.find(std::string{id});
    return it == sensors.end() ? nullptr : &it->second;
}

std::string codeForInvalidSensor(std::string_view id) {
    if (id == "bus_voltage_v") return "NXD-PWR-109";
    if (id == "cpu_temp_c") return "NXD-CMP-210";
    if (id == "imu_pitch_deg") return "NXD-FLT-303";
    if (id == "imu_roll_deg") return "NXD-FLT-304";
    if (id == "altitude_m") return "NXD-FLT-305";
    if (id == "airspeed_kph") return "NXD-FLT-306";
    if (id == "hydraulic_pressure_pct") return "NXD-HYD-409";
    if (id == "fuel_level_pct") return "NXD-FUL-502";
    return "NXD-DAT-610";
}

std::string systemForSensor(std::string_view id) {
    if (id == "bus_voltage_v") return "POWER";
    if (id == "cpu_temp_c") return "COMPUTE";
    if (id == "imu_pitch_deg" || id == "imu_roll_deg" || id == "altitude_m" || id == "airspeed_kph") return "FLIGHT SENSORS";
    if (id == "hydraulic_pressure_pct") return "HYDRAULICS";
    if (id == "fuel_level_pct") return "FUEL";
    return "DATA";
}

std::string fingerprint(const DiagnosticSummary& summary) {
    std::vector<std::string> tokens;
    tokens.reserve(summary.findings.size() + 1);
    tokens.push_back(summary.scenario);
    for (const auto& finding : summary.findings) tokens.push_back(finding.code);
    std::sort(tokens.begin(), tokens.end());
    std::uint64_t hash = 1469598103934665603ULL;
    for (const auto& token : tokens) {
        for (const unsigned char c : token) {
            hash ^= static_cast<std::uint64_t>(c);
            hash *= 1099511628211ULL;
        }
        hash ^= 0xffULL;
        hash *= 1099511628211ULL;
    }
    std::ostringstream out;
    out << std::hex << std::setw(16) << std::setfill('0') << hash;
    return out.str();
}

void addSystemRecommendation(std::set<std::string>& recommendations, const DiagnosticFinding& finding) {
    if (finding.system == "POWER") recommendations.insert("Correlate electrical-bus evidence with the scenario timeline before accepting recovery.");
    else if (finding.system == "COMPUTE") recommendations.insert("Review compute temperature, data freshness and event timing as one correlated evidence set.");
    else if (finding.system == "FLIGHT SENSORS") recommendations.insert("Validate synthetic sensor quality and agreement before using derived flight-state evidence.");
    else if (finding.system == "HYDRAULICS") recommendations.insert("Confirm hydraulic evidence continuity and stable recovery across consecutive simulated frames.");
    else if (finding.system == "FUEL") recommendations.insert("Check fuel-channel continuity and trend coherence against the active training profile.");
    else if (finding.system == "DATA" || finding.system == "RECORDER") recommendations.insert("Repair the evidence chain before relying on replay or verification conclusions.");
    else recommendations.insert("Correlate the finding with telemetry, timeline and Digital Twin evidence before closure.");
}

} // namespace

DiagnosticSummary DiagnosticEngine::analyze(
    std::string_view scenario,
    std::uint64_t tick,
    const std::map<std::string, SensorSample>& sensors,
    const std::vector<HealthIssue>& issues,
    const TelemetryRecorder& recorder,
    const EventLog& events) {
    DiagnosticSummary summary;
    summary.scenario = std::string{scenario};
    summary.generatedTick = tick;
    summary.frameCount = recorder.size();
    summary.eventCount = events.size();
    summary.sensorCount = sensors.size();

    for (const auto& [id, sampleValue] : sensors) {
        if (sampleValue.valid) continue;
        const auto code = codeForInvalidSensor(id);
        const auto system = systemForSensor(id);
        addFinding(summary.findings, makeFinding(
            code, system, "DATA QUALITY", DiagnosticSeverity::Fault,
            "Diagnostic evidence channel invalid",
            "Synthetic source dropout, injected training fault, stale provider output, or malformed sample.",
            "Locate the first invalid frame, compare adjacent samples, and correlate the channel with Digital Twin state.",
            "Restore consecutive valid synthetic samples and verify the related subsystem returns to a nominal evidence state.",
            0.98,
            {"telemetry", id, "INVALID", "VALID synthetic sample", tick, 1.0}));
    }

    if (const auto* value = sensor(sensors, "bus_voltage_v"); value && value->valid) {
        if (value->value < 23.0) {
            addFinding(summary.findings, makeFinding(
                "NXD-PWR-101", "POWER", "VOLTAGE", DiagnosticSeverity::Warning,
                "Bus voltage below training envelope",
                "Synthetic power transient, injected low-power condition, or source/load imbalance.",
                "Review bus_voltage_v trend, event timing and power subsystem health together.",
                "Return the synthetic bus above the configured lower training boundary for consecutive frames.",
                0.94,
                {"telemetry", "bus_voltage_v", number(value->value) + " " + value->unit, ">= 23.00 V training boundary", tick, 1.0}));
        } else if (value->value > 29.5) {
            addFinding(summary.findings, makeFinding(
                "NXD-PWR-102", "POWER", "VOLTAGE", DiagnosticSeverity::Fault,
                "Bus voltage above training envelope",
                "Injected voltage offset, synthetic regulator anomaly, or corrupted sample.",
                "Compare the current bus value with the previous frames and the active training scenario.",
                "Return the synthetic bus to the configured nominal band and verify stable quality.",
                0.94,
                {"telemetry", "bus_voltage_v", number(value->value) + " " + value->unit, "<= 29.50 V training boundary", tick, 1.0}));
        }
    }

    if (const auto* value = sensor(sensors, "cpu_temp_c"); value && value->valid && value->value > 80.0) {
        const auto severity = value->value >= 95.0 ? DiagnosticSeverity::Fault : DiagnosticSeverity::Warning;
        addFinding(summary.findings, makeFinding(
            "NXD-CMP-201", "COMPUTE", "THERMAL", severity,
            "Compute thermal excursion",
            "Synthetic thermal-rise scenario, compute-hot training preset, or reduced cooling margin.",
            "Review cpu_temp_c trend, compute Digital Twin state and correlated warnings.",
            "Remove the synthetic heat condition and verify a sustained downward temperature trend.",
            value->value >= 95.0 ? 0.97 : 0.91,
            {"telemetry", "cpu_temp_c", number(value->value) + " " + value->unit, "<= 80.00 C preferred training boundary", tick, 1.0}));
    }

    if (const auto* value = sensor(sensors, "hydraulic_pressure_pct"); value && value->valid && value->value < 70.0) {
        addFinding(summary.findings, makeFinding(
            "NXD-HYD-401", "HYDRAULICS", "PRESSURE", value->value < 45.0 ? DiagnosticSeverity::Fault : DiagnosticSeverity::Warning,
            "Hydraulic pressure degraded",
            "Scenario-driven degradation, injected training condition, or abnormal pressure evidence.",
            "Inspect hydraulic_pressure_pct value, quality, delta and subsystem health.",
            "Restore stable pressure inside the configured training band and verify Digital Twin recovery.",
            0.90,
            {"telemetry", "hydraulic_pressure_pct", number(value->value) + " " + value->unit, ">= 70% preferred training boundary", tick, 1.0}));
    }

    if (const auto* value = sensor(sensors, "fuel_level_pct"); value && value->valid && value->value < 20.0) {
        addFinding(summary.findings, makeFinding(
            "NXD-FUL-501", "FUEL", "QUANTITY", DiagnosticSeverity::Warning,
            "Fuel quantity training margin reduced",
            "Synthetic run progression or an injected quantity offset reduced the configured training reserve.",
            "Compare fuel_level_pct trend with the active scenario and recorded-frame continuity.",
            "Restore a coherent synthetic fuel state or complete the training scenario with the finding acknowledged.",
            0.88,
            {"telemetry", "fuel_level_pct", number(value->value) + " " + value->unit, ">= 20% preferred training margin", tick, 0.9}));
    }

    for (const auto& issue : issues) {
        const auto subsystem = lower(issue.subsystem);
        std::string code{"NXD-ASR-1209"};
        std::string system{"ASSURANCE"};
        if (subsystem.find("power") != std::string::npos) { code = "NXD-PWR-111"; system = "POWER"; }
        else if (subsystem.find("compute") != std::string::npos) { code = "NXD-CMP-208"; system = "COMPUTE"; }
        else if (subsystem.find("flight") != std::string::npos || subsystem.find("sensor") != std::string::npos) { code = "NXD-FLT-309"; system = "FLIGHT SENSORS"; }
        else if (subsystem.find("hyd") != std::string::npos) { code = "NXD-HYD-410"; system = "HYDRAULICS"; }
        else if (subsystem.find("fuel") != std::string::npos) { code = "NXD-FUL-509"; system = "FUEL"; }
        const auto severity = issue.severity == Severity::Fault ? DiagnosticSeverity::Fault : DiagnosticSeverity::Warning;
        addFinding(summary.findings, makeFinding(
            code, system, "HEALTH MODEL", severity,
            "Health-model issue correlated",
            "The deterministic health model reported a non-nominal subsystem condition.",
            "Correlate the health issue with raw telemetry and the unified event timeline before isolation.",
            "Remove the synthetic initiating condition and require the health model to return to nominal.",
            issue.severity == Severity::Fault ? 0.90 : 0.82,
            {"health", issue.subsystem, issue.detail, "NOMINAL subsystem state", tick, 0.9}));
    }

    const auto& frames = recorder.frames();
    if (frames.empty() && tick > 5) {
        addFinding(summary.findings, makeFinding(
            "NXD-REC-801", "RECORDER", "CONTINUITY", DiagnosticSeverity::Fault,
            "Recorder continuity failure",
            "No recorded evidence frames are available for the current diagnostic run.",
            "Verify recorder initialization and compare the current simulation tick with recorder size.",
            "Record a fresh deterministic session before accepting diagnostic or replay conclusions.",
            0.99,
            {"recorder", "frames", "0", "> 0 recorded frames", tick, 1.0}));
    }
    for (std::size_t i = 1; i < frames.size(); ++i) {
        if (frames[i].sequence <= frames[i - 1].sequence) {
            addFinding(summary.findings, makeFinding(
                "NXD-DAT-601", "DATA", "SEQUENCE", DiagnosticSeverity::Fault,
                "Telemetry sequence integrity fault",
                "Recorded frame sequence is not strictly monotonic.",
                "Locate the first non-monotonic frame and compare archive/session provenance.",
                "Regenerate a deterministic session whose frame sequence passes verification.",
                0.99,
                {"recorder", "sequence", std::to_string(frames[i].sequence), "> previous sequence", frames[i].sequence, 1.0}));
            break;
        }
    }
    for (std::size_t i = 1; i < frames.size(); ++i) {
        if (frames[i].simTime <= frames[i - 1].simTime) {
            addFinding(summary.findings, makeFinding(
                "NXD-DAT-602", "DATA", "TIMING", DiagnosticSeverity::Fault,
                "Timestamp discontinuity",
                "Simulation time is not strictly monotonic in the evidence chain.",
                "Inspect the first timing discontinuity and compare it with frame sequence and replay state.",
                "Regenerate the session with deterministic monotonic simulation time.",
                0.99,
                {"recorder", "sim_time_ms", std::to_string(frames[i].simTime.count()), "> previous simulation time", frames[i].sequence, 1.0}));
            break;
        }
    }

    const auto eventRows = events.snapshot();
    std::size_t warningEvents = 0;
    std::size_t faultEvents = 0;
    for (const auto& event : eventRows) {
        if (event.severity == Severity::Fault) ++faultEvents;
        else if (event.severity == Severity::Warning) ++warningEvents;
    }
    if (faultEvents > 0) {
        addFinding(summary.findings, makeFinding(
            "NXD-ASR-1201", "ASSURANCE", "EVENT CORRELATION", DiagnosticSeverity::Warning,
            "Fault-severity events require correlation",
            "The event log contains one or more fault-severity observations that must be reconciled with telemetry evidence.",
            "Open the correlated event window and verify whether each fault event has matching telemetry evidence.",
            "Close the diagnostic case only after the evidence chain explains or clears every active fault event.",
            0.78,
            {"event_log", "fault_events", std::to_string(faultEvents), "0 unexplained fault events", tick, 0.7}));
    }

    const auto scenarioText = lower(std::string{scenario});
    if (scenarioText.find("power") != std::string::npos && !containsCode(summary, "NXD-PWR-101")) {
        addFinding(summary.findings, makeFinding(
            "NXD-PWR-103", "POWER", "SCENARIO CONTEXT", DiagnosticSeverity::Advisory,
            "Power-transient scenario context",
            "The active training scenario is designed to exercise power-system response.",
            "Use bus and event evidence to determine whether the transient currently produces a diagnosable condition.",
            "Return to the nominal scenario and verify the advisory context clears.",
            0.58,
            {"scenario", "name", std::string{scenario}, "nominal when scenario context is removed", tick, 0.5}));
    }
    if (scenarioText.find("thermal") != std::string::npos && !containsCode(summary, "NXD-CMP-201")) {
        addFinding(summary.findings, makeFinding(
            "NXD-CMP-201", "COMPUTE", "THERMAL", DiagnosticSeverity::Advisory,
            "Thermal-rise scenario context",
            "The active synthetic scenario is designed to increase compute thermal stress.",
            "Monitor cpu_temp_c and health evidence until the thermal response is visible or the scenario is removed.",
            "Return to nominal scenario conditions and verify stable temperature evidence.",
            0.55,
            {"scenario", "name", std::string{scenario}, "nominal scenario context", tick, 0.5}));
    }
    if (scenarioText.find("dropout") != std::string::npos && summary.findings.empty()) {
        addFinding(summary.findings, makeFinding(
            "NXD-DAT-606", "DATA", "AVAILABILITY", DiagnosticSeverity::Advisory,
            "Sensor-dropout scenario armed",
            "The active synthetic scenario contains an intermittent sensor-availability condition.",
            "Continue the run and correlate the first invalid sample with event and Digital Twin evidence.",
            "Return to nominal scenario and verify all expected channels remain valid.",
            0.52,
            {"scenario", "name", std::string{scenario}, "all expected channels valid", tick, 0.5}));
    }

    std::sort(summary.findings.begin(), summary.findings.end(), [](const DiagnosticFinding& a, const DiagnosticFinding& b) {
        if (a.priority != b.priority) return a.priority > b.priority;
        if (a.confidence != b.confidence) return a.confidence > b.confidence;
        return a.code < b.code;
    });

    double penalty = 0.0;
    std::set<std::string> recommendations;
    for (const auto& finding : summary.findings) {
        const double base = finding.severity == DiagnosticSeverity::Fault ? 18.0 : (finding.severity == DiagnosticSeverity::Warning ? 8.0 : 3.0);
        penalty += base * std::clamp(finding.confidence, 0.25, 1.0);
        if (finding.severity == DiagnosticSeverity::Fault) ++summary.faultCount;
        else if (finding.severity == DiagnosticSeverity::Warning) ++summary.warningCount;
        else ++summary.advisoryCount;
        addSystemRecommendation(recommendations, finding);
    }
    if (warningEvents > 0 && faultEvents == 0) recommendations.insert("Review warning-severity events alongside the highest-confidence diagnostic finding.");
    if (summary.findings.empty()) recommendations.insert("No active diagnostic finding: preserve the run as nominal reference evidence.");
    summary.healthScore = std::clamp(100.0 - penalty, 0.0, 100.0);
    summary.recommendations.assign(recommendations.begin(), recommendations.end());
    summary.fingerprint = fingerprint(summary);
    return summary;
}

bool DiagnosticEngine::containsCode(const DiagnosticSummary& summary, std::string_view code) noexcept {
    return std::any_of(summary.findings.begin(), summary.findings.end(), [&](const DiagnosticFinding& finding) {
        return finding.code == code;
    });
}

} // namespace nexvary::avionics
