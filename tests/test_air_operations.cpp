#include "air_ops/AirOperationsIntegration.hpp"

#include <cassert>
#include <stdexcept>
#include <string>

using namespace nexvary::avionics;

int main() {
    const auto demo = AirOperationsIntegration::demo();
    const auto& snapshot = demo.snapshot();

    assert(snapshot.schema == AirOperationsIntegration::kSchema);
    assert(snapshot.source == "Aegis-CUAS-Command");
    assert(snapshot.mode == "simulation-replay");
    assert(snapshot.summary.trackCount == 3);
    assert(snapshot.summary.incidentCount == 1);
    assert(snapshot.summary.highOrAboveCount == 1);
    assert(snapshot.summary.observations == 48);
    assert(snapshot.tracks.front().trackId == "AEG-TRK-101");
    assert(snapshot.tracks.front().insideProtectedZone);

    const std::string awareness = R"json({
        "schema":"nexvary.air-operations.exchange/v1",
        "source":"Aegis-CUAS-Command",
        "mode":"awareness-only",
        "tracks":[],
        "incidents":[]
    })json";
    const auto empty = AirOperationsIntegration::fromJson(awareness);
    assert(empty.empty());

    bool rejected = false;
    try {
        AirOperationsIntegration::fromJson(R"json({
            "schema":"nexvary.air-operations.exchange/v1",
            "source":"unsafe-test",
            "mode":"simulation-replay",
            "actuation":{"command":"example"},
            "tracks":[],
            "incidents":[]
        })json");
    } catch (const std::invalid_argument&) {
        rejected = true;
    }
    assert(rejected);

    return 0;
}
