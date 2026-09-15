#include "air_ops/PublicFlightEnrichment.hpp"
#include "air_ops/PublicFlightFeed.hpp"

#include <cassert>
#include <cmath>
#include <string>

using namespace nexvary::avionics;

int main() {
    const std::string feedJson = R"({
        "source":"TEST ADS-B",
        "generatedAt":"test",
        "tracks":[
            {"icao24":"abc123","callsign":"CIV101","country":"Egypt","latitude":30.02,"longitude":31.21,"altitudeMeters":8500.0,"velocityMetersPerSecond":210.0,"headingDegrees":95.0,"telemetrySource":"TEST ADS-B","positionSource":"ADS-B"}
        ]
    })";
    const auto feed = PublicFlightFeed::fromJson(feedJson);
    auto snapshot = feed.snapshot();
    const auto originalLatitude = snapshot.tracks.at(0).latitude;
    const auto originalVelocity = snapshot.tracks.at(0).velocityMetersPerSecond;

    const std::string enrichmentJson = R"({
        "provider": {
            "name":"LICENSED TEST PROVIDER",
            "license":"TEST-LICENSE-1",
            "sourceUrl":"https://licensed.example.test/metadata",
            "generatedAt":"1970-01-01T00:16:40Z",
            "generatedAtEpoch":1000,
            "defaultTtlSeconds":300
        },
        "records":[
            {"icao24":"ABC123","callsign":"CIV101","registration":"TEST-REG","aircraftTypeCode":"A320","aircraftModel":"Test Model","manufacturer":"Test Manufacturer","serialNumber":"MSN-1","operatorName":"Test Operator","operatorIcao":"TST","operatorIata":"T1","registrationCountry":"Test Country","aircraftFamily":"A320 FAMILY","variant":"TEST VARIANT","engineType":"Turbofan","yearBuilt":"2020","flightNumber":"TST101","originAirportIcao":"HECA","originAirportIata":"CAI","destinationAirportIcao":"LGAV","destinationAirportIata":"ATH","route":"HECA → LGAV","scheduledDeparture":"10:00Z","estimatedArrival":"12:00Z"}
        ]
    })";

    const auto cache = PublicFlightEnrichmentCache::fromJson(enrichmentJson);
    assert(cache.size() == 1);
    assert(cache.provider().name == "LICENSED TEST PROVIDER");
    assert(cache.provider().license == "TEST-LICENSE-1");

    const auto applied = cache.apply(snapshot, 1100);
    assert(applied == 1);
    const auto& enriched = snapshot.tracks.at(0);
    assert(enriched.registration == "TEST-REG");
    assert(enriched.aircraftTypeCode == "A320");
    assert(enriched.aircraftModel == "Test Model");
    assert(enriched.operatorName == "Test Operator");
    assert(enriched.operatorIcao == "TST");
    assert(enriched.flightNumber == "TST101");
    assert(enriched.route == "HECA → LGAV");
    assert(enriched.metadataSource == "LICENSED TEST PROVIDER");
    assert(enriched.routeSource == "LICENSED TEST PROVIDER");
    assert(enriched.metadataLicense == "TEST-LICENSE-1");
    assert(enriched.routeLicense == "TEST-LICENSE-1");
    assert(enriched.metadataSourceUrl == "https://licensed.example.test/metadata");
    assert(enriched.enrichmentCacheState == "FRESH");
    assert(enriched.enrichmentCachedAtEpoch == 1000);
    assert(enriched.enrichmentExpiresAtEpoch == 1300);
    assert(std::abs(enriched.latitude - originalLatitude) < 0.000001);
    assert(enriched.velocityMetersPerSecond == originalVelocity);
    assert(enriched.telemetrySource == "TEST ADS-B");

    auto staleSnapshot = feed.snapshot();
    assert(cache.apply(staleSnapshot, 1400) == 1);
    assert(staleSnapshot.tracks.at(0).enrichmentCacheState == "STALE");
    assert(staleSnapshot.tracks.at(0).registration == "TEST-REG");

    const auto callsignCache = PublicFlightEnrichmentCache::fromJson(R"({
        "provider":{"name":"CALLSIGN PROVIDER","license":"TEST-LICENSE-2","defaultTtlSeconds":60},
        "records":[{"callsign":"CIV101","operatorName":"Callsign Operator"}]
    })");
    auto callsignSnapshot = feed.snapshot();
    callsignSnapshot.tracks.at(0).icao24 = "different";
    assert(callsignCache.apply(callsignSnapshot, 2000) == 1);
    assert(callsignSnapshot.tracks.at(0).operatorName == "Callsign Operator");

    PublicFlightHistoryStore history(60);
    auto historySnapshot = feed.snapshot();
    historySnapshot.tracks.at(0).lastContactEpoch.reset();
    history.record(historySnapshot, 1100);
    historySnapshot.tracks.at(0).latitude = 30.12;
    history.record(historySnapshot, 1200);
    historySnapshot.tracks.at(0).latitude = 30.22;
    history.record(historySnapshot, 1500);

    assert(history.pointCount("ABC123") == 3);
    assert(history.totalPointCount() == 3);
    const auto fiveMinutes = history.window("abc123", 5, 1500);
    assert(fiveMinutes.size() == 2);
    assert(std::abs(fiveMinutes.front().latitude - 30.12) < 0.000001);
    const auto sixtyMinutes = history.window("ABC123", 60, 1500);
    assert(sixtyMinutes.size() == 3);

    const auto serialized = history.toJson();
    const auto restored = PublicFlightHistoryStore::fromJson(serialized);
    assert(restored.retentionMinutes() == 60);
    assert(restored.pointCount("abc123") == 3);
    assert(restored.totalPointCount() == 3);
    const auto restoredWindow = restored.window("abc123", 60, 1500);
    assert(restoredWindow.size() == 3);
    assert(restoredWindow.back().telemetrySource == "TEST ADS-B");

    PublicFlightHistoryStore shortHistory(5);
    auto pruneSnapshot = feed.snapshot();
    pruneSnapshot.tracks.at(0).lastContactEpoch.reset();
    shortHistory.record(pruneSnapshot, 1000);
    pruneSnapshot.tracks.at(0).latitude = 31.0;
    shortHistory.record(pruneSnapshot, 1401);
    assert(shortHistory.pointCount("abc123") == 1);

    return 0;
}
