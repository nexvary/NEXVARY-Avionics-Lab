#include "app/AvionicsLab.hpp"
#include "report/LabReport.hpp"
#include <cassert>
#include <string>

using namespace nexvary::avionics;

int main() {
    AvionicsLab nominal{ScenarioKind::Nominal};
    for (int i = 0; i < 40; ++i) nominal.step();

    const auto report = LabReport::analyze(
        "nominal",
        nominal.recorder(),
        nominal.eventLog(),
        20);
    assert(report.frameCount == 40);
    assert(report.trendWindowFrames == 20);
    assert(report.sensorSampleCount > report.frameCount);
    assert(report.sequenceMonotonic && report.timeMonotonic);
    assert(!report.sensors.empty());

    const auto bus = report.sensors.at("bus_voltage_v");
    assert(bus.samples == 20);
    assert(bus.validSamples == 20);
    assert(bus.invalidSamples == 0);
    assert(bus.missingSamples == 0);
    assert(bus.hasValidSamples);

    const auto json = LabReport::toJson(report);
    const auto markdown = LabReport::toMarkdown(report);
    assert(json.find("nexvary-avionics-verification/v2") != std::string::npos);
    assert(json.find("slope_per_second") != std::string::npos);
    assert(json.find("missing_samples") != std::string::npos);
    assert(markdown.find("Sequence monotonic: PASS") != std::string::npos);
    assert(markdown.find("Slope/s") != std::string::npos);

    AvionicsLab dropout{ScenarioKind::SensorDropout};
    for (int i = 0; i < 50; ++i) dropout.step();
    const auto dropoutReport = LabReport::analyze(
        "sensor-dropout",
        dropout.recorder(),
        dropout.eventLog());
    assert(dropoutReport.invalidSampleCount > 0);
    assert(dropoutReport.sensors.at("imu_pitch_deg").invalidSamples > 0);
    return 0;
}
