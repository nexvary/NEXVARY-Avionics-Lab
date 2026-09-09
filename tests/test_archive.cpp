#include "app/AvionicsLab.hpp"
#include "core/TelemetryArchive.hpp"
#include <cassert>
#include <stdexcept>
#include <string>

using namespace nexvary::avionics;

int main() {
    AvionicsLab lab{ScenarioKind::Nominal};
    for (int i = 0; i < 16; ++i) lab.step();

    const auto& original = lab.recorder().frames();
    assert(original.size() == 16);

    const auto encoded = TelemetryArchive::encode(original);
    const auto decoded = TelemetryArchive::decode(encoded);
    assert(decoded.size() == original.size());
    assert(TelemetryArchive::encode(decoded) == encoded);

    const auto summary = TelemetryArchive::inspect(decoded);
    assert(summary.frameCount == 16);
    assert(summary.sensorSampleCount > summary.frameCount);
    assert(summary.invalidSampleCount == 0);
    assert(summary.sequenceMonotonic);
    assert(summary.timeMonotonic);
    assert(summary.checksum == TelemetryArchive::checksum(encoded));

    const auto report = TelemetryArchive::verificationReport(decoded);
    assert(report.find("Sequence monotonic | PASS") != std::string::npos);
    assert(report.find("No live-aircraft interface") != std::string::npos);

    bool rejected = false;
    try {
        (void)TelemetryArchive::decode("NOT_A_NEXVARY_ARCHIVE\nEND 0\n");
    } catch (const std::invalid_argument&) {
        rejected = true;
    }
    assert(rejected);

    auto nonMonotonic = decoded;
    nonMonotonic[5].sequence = nonMonotonic[4].sequence;
    assert(!TelemetryArchive::inspect(nonMonotonic).sequenceMonotonic);
    return 0;
}
