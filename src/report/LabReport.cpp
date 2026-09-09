#include "report/LabReport.hpp"
#include "core/TelemetryArchive.hpp"
#include <nlohmann/json.hpp>
#include <algorithm>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <stdexcept>

namespace nexvary::avionics {

LabReportData LabReport::analyze(
    std::string_view scenario,
    const TelemetryRecorder& recorder,
    const EventLog& log,
    std::size_t trendWindowFrames) {
    LabReportData report;
    report.scenario = std::string(scenario);
    report.frameCount = recorder.size();
    report.eventCount = log.size();
    report.trendWindowFrames = trendWindowFrames == 0
        ? recorder.size()
        : std::min(trendWindowFrames, recorder.size());

    const auto summary = TelemetryArchive::inspect(recorder.frames());
    report.sensorSampleCount = summary.sensorSampleCount;
    report.invalidSampleCount = summary.invalidSampleCount;
    report.sequenceMonotonic = summary.sequenceMonotonic;
    report.timeMonotonic = summary.timeMonotonic;
    report.checksum = summary.checksum;
    report.sensors = TelemetryTrendAnalyzer::analyze(recorder.frames(), trendWindowFrames);
    return report;
}

std::string LabReport::toJson(const LabReportData& report) {
    nlohmann::json json{
        {"schema", "nexvary-avionics-verification/v2"},
        {"scope", "synthetic-training"},
        {"scenario", report.scenario},
        {"frame_count", report.frameCount},
        {"event_count", report.eventCount},
        {"sensor_sample_count", report.sensorSampleCount},
        {"invalid_sample_count", report.invalidSampleCount},
        {"trend_window_frames", report.trendWindowFrames},
        {"sequence_monotonic", report.sequenceMonotonic},
        {"time_monotonic", report.timeMonotonic},
        {"checksum", report.checksum}
    };

    json["sensors"] = nlohmann::json::object();
    for (const auto& [name, sensor] : report.sensors) {
        json["sensors"][name] = {
            {"unit", sensor.unit},
            {"samples", sensor.samples},
            {"valid_samples", sensor.validSamples},
            {"invalid_samples", sensor.invalidSamples},
            {"missing_samples", sensor.missingSamples},
            {"has_valid_samples", sensor.hasValidSamples},
            {"minimum", sensor.minimum},
            {"maximum", sensor.maximum},
            {"mean", sensor.mean},
            {"latest", sensor.latest},
            {"delta", sensor.delta},
            {"slope_per_second", sensor.slopePerSecond}
        };
    }
    return json.dump(2);
}

std::string LabReport::toMarkdown(const LabReportData& report) {
    std::ostringstream out;
    out << "# NEXVARY Avionics Verification Report\n\n"
        << "Synthetic training/simulation data only. No live-aircraft control interface.\n\n"
        << "- Scenario: `" << report.scenario << "`\n"
        << "- Frames: " << report.frameCount << "\n"
        << "- Events: " << report.eventCount << "\n"
        << "- Sensor samples: " << report.sensorSampleCount << "\n"
        << "- Invalid samples: " << report.invalidSampleCount << "\n"
        << "- Trend window: " << report.trendWindowFrames << " frame(s)\n"
        << "- Sequence monotonic: " << (report.sequenceMonotonic ? "PASS" : "FAIL") << "\n"
        << "- Time monotonic: " << (report.timeMonotonic ? "PASS" : "FAIL") << "\n"
        << "- Checksum: `" << report.checksum << "`\n\n"
        << "| Sensor | Unit | Samples | Valid | Invalid | Missing | Min | Max | Mean | Latest | Delta | Slope/s |\n"
        << "|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|\n";

    out << std::fixed << std::setprecision(3);
    for (const auto& [name, sensor] : report.sensors) {
        out << '|' << name << '|' << sensor.unit << '|' << sensor.samples << '|'
            << sensor.validSamples << '|' << sensor.invalidSamples << '|' << sensor.missingSamples << '|'
            << sensor.minimum << '|' << sensor.maximum << '|' << sensor.mean << '|'
            << sensor.latest << '|' << sensor.delta << '|' << sensor.slopePerSecond << "|\n";
    }
    return out.str();
}

namespace {
void writeText(const std::string& path, const std::string& value) {
    std::ofstream file(path, std::ios::binary | std::ios::trunc);
    if (!file) throw std::runtime_error("unable to open report output");
    file << value;
    if (!file) throw std::runtime_error("unable to write report output");
}
} // namespace

void LabReport::writeJson(const std::string& path, const LabReportData& report) {
    writeText(path, toJson(report));
}

void LabReport::writeMarkdown(const std::string& path, const LabReportData& report) {
    writeText(path, toMarkdown(report));
}

} // namespace nexvary::avionics
