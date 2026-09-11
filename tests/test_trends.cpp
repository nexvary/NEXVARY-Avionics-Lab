#include "app/AvionicsLab.hpp"
#include "core/TelemetryTrend.hpp"
#include "telemetry/TelemetryDictionary.hpp"
#include <cassert>
#include <chrono>
#include <cmath>
#include <vector>

using namespace nexvary::avionics;

int main() {
    AvionicsLab nominal{ScenarioKind::Nominal};
    for (int i = 0; i < 50; ++i) nominal.step(std::chrono::milliseconds{100});

    const auto recent = TelemetryTrendAnalyzer::analyze(nominal.recorder().frames(), 20);
    assert(recent.size() == TelemetryDictionary::channels().size());
    assert(recent.size() == 15);
    assert(recent.count("jet_engine_core_pct") == 1);
    assert(recent.count("rotor_rpm_pct") == 1);
    assert(recent.count("link_quality_pct") == 1);
    const auto bus = recent.at("bus_voltage_v");
    assert(bus.samples == 20);
    assert(bus.validSamples == 20);
    assert(bus.invalidSamples == 0);
    assert(bus.missingSamples == 0);
    assert(bus.hasValidSamples);
    assert(bus.maximum >= bus.minimum);
    assert(bus.mean >= bus.minimum && bus.mean <= bus.maximum);
    assert(std::isfinite(bus.slopePerSecond));

    AvionicsLab dropout{ScenarioKind::SensorDropout};
    for (int i = 0; i < 40; ++i) dropout.step(std::chrono::milliseconds{100});
    const auto dropoutTrends = TelemetryTrendAnalyzer::analyze(dropout.recorder().frames());
    const auto pitch = dropoutTrends.at("imu_pitch_deg");
    assert(pitch.samples == 40);
    assert(pitch.invalidSamples > 0);
    assert(pitch.validSamples + pitch.invalidSamples == pitch.samples);

    TelemetryFrame first;
    first.sequence = 1;
    first.simTime = std::chrono::milliseconds{100};
    first.sensors["demo"] = {10.0, "u", true};
    TelemetryFrame second;
    second.sequence = 2;
    second.simTime = std::chrono::milliseconds{200};
    TelemetryFrame third;
    third.sequence = 3;
    third.simTime = std::chrono::milliseconds{300};
    third.sensors["demo"] = {0.0, "u", false};
    TelemetryFrame fourth;
    fourth.sequence = 4;
    fourth.simTime = std::chrono::milliseconds{1100};
    fourth.sensors["demo"] = {14.0, "u", true};

    const auto synthetic = TelemetryTrendAnalyzer::analyze({first, second, third, fourth});
    const auto demo = synthetic.at("demo");
    assert(demo.samples == 3);
    assert(demo.validSamples == 2);
    assert(demo.invalidSamples == 1);
    assert(demo.missingSamples == 1);
    assert(demo.minimum == 10.0);
    assert(demo.maximum == 14.0);
    assert(demo.mean == 12.0);
    assert(demo.latest == 14.0);
    assert(demo.delta == 4.0);
    assert(std::abs(demo.slopePerSecond - 4.0) < 1e-9);

    assert(TelemetryTrendAnalyzer::analyze({}).empty());
    return 0;
}
