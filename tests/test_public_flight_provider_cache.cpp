#include "air_ops/PublicFlightFeed.hpp"
#include "air_ops/PublicFlightProviderCache.hpp"

#include <chrono>
#include <filesystem>
#include <string>

using namespace nexvary::avionics;

#define CHECK_OR_RETURN(expr) do { if (!(expr)) return __LINE__; } while (false)

int main() {
    const auto feed = PublicFlightFeed::fromJson(R"({
        "source":"TEST ADS-B",
        "generatedAt":"test",
        "tracks":[
            {"icao24":"abc123","callsign":"CIV101","country":"Egypt","latitude":30.02,"longitude":31.21,"altitudeMeters":8500.0,"velocityMetersPerSecond":210.0,"headingDegrees":95.0,"telemetrySource":"TEST ADS-B"}
        ]
    })");

    const std::string providerPayload = R"({
        "provider": {
            "name":"LICENSED ROUTE CACHE",
            "license":"TEST-LICENSE-CACHE",
            "sourceUrl":"https://licensed.example.test/provider",
            "generatedAtEpoch":1000,
            "defaultTtlSeconds":300
        },
        "records":[
            {"icao24":"ABC123","registration":"TEST-REG","operatorName":"Test Operator","aircraftTypeCode":"A320","flightNumber":"TST101","originAirportIcao":"HECA","destinationAirportIcao":"LGAV","route":"HECA → LGAV"}
        ]
    })";

    PublicFlightProviderCache providerCache;
    CHECK_OR_RETURN(providerCache.refreshFromJson(providerPayload, 1100));
    CHECK_OR_RETURN(providerCache.available());
    CHECK_OR_RETURN(!providerCache.usingFallback());
    CHECK_OR_RETURN(providerCache.recordCount() == 1);
    CHECK_OR_RETURN(providerCache.provider().name == "LICENSED ROUTE CACHE");
    CHECK_OR_RETURN(providerCache.provider().license == "TEST-LICENSE-CACHE");
    CHECK_OR_RETURN(providerCache.payloadBytes() == providerPayload.size());
    CHECK_OR_RETURN(providerCache.lastRefreshEpoch() == 1100);
    CHECK_OR_RETURN(providerCache.statusText().find("ACTIVE") != std::string::npos);

    auto enriched = feed.snapshot();
    CHECK_OR_RETURN(providerCache.apply(enriched, 1100) == 1);
    CHECK_OR_RETURN(enriched.tracks.at(0).registration == "TEST-REG");
    CHECK_OR_RETURN(enriched.tracks.at(0).operatorName == "Test Operator");
    CHECK_OR_RETURN(enriched.tracks.at(0).route == "HECA → LGAV");
    CHECK_OR_RETURN(enriched.tracks.at(0).metadataSource == "LICENSED ROUTE CACHE");
    CHECK_OR_RETURN(enriched.tracks.at(0).metadataLicense == "TEST-LICENSE-CACHE");
    CHECK_OR_RETURN(enriched.tracks.at(0).routeSource == "LICENSED ROUTE CACHE");
    CHECK_OR_RETURN(enriched.tracks.at(0).enrichmentCacheState == "FRESH");

    const auto unique = std::to_string(
        std::chrono::steady_clock::now().time_since_epoch().count());
    const auto cachePath = std::filesystem::temp_directory_path() /
                           ("nexvary-public-flight-provider-cache-" + unique + ".json");
    std::error_code cleanupError;
    std::filesystem::remove(cachePath, cleanupError);

    CHECK_OR_RETURN(providerCache.persistLastGood(cachePath));
    CHECK_OR_RETURN(std::filesystem::exists(cachePath));

    // A broken refresh must not replace the valid provider snapshot.
    CHECK_OR_RETURN(!providerCache.refreshFromJson("{broken", 1200));
    CHECK_OR_RETURN(providerCache.available());
    CHECK_OR_RETURN(providerCache.usingFallback());
    CHECK_OR_RETURN(providerCache.provider().name == "LICENSED ROUTE CACHE");
    CHECK_OR_RETURN(providerCache.statusText().find("FALLBACK") != std::string::npos);
    CHECK_OR_RETURN(!providerCache.lastError().empty());

    auto fallbackSnapshot = feed.snapshot();
    CHECK_OR_RETURN(providerCache.apply(fallbackSnapshot, 1200) == 1);
    CHECK_OR_RETURN(fallbackSnapshot.tracks.at(0).registration == "TEST-REG");
    CHECK_OR_RETURN(fallbackSnapshot.tracks.at(0).metadataSource == "LICENSED ROUTE CACHE");

    // A fresh process can restore the persisted last-known-good provider.
    PublicFlightProviderCache restored;
    CHECK_OR_RETURN(restored.restoreLastGood(cachePath, 1300));
    CHECK_OR_RETURN(restored.available());
    CHECK_OR_RETURN(restored.usingFallback());
    CHECK_OR_RETURN(restored.provider().name == "LICENSED ROUTE CACHE");
    CHECK_OR_RETURN(restored.provider().license == "TEST-LICENSE-CACHE");
    CHECK_OR_RETURN(restored.statusText().find("CACHE FALLBACK") != std::string::npos);

    auto restoredSnapshot = feed.snapshot();
    CHECK_OR_RETURN(restored.apply(restoredSnapshot, 1300) == 1);
    CHECK_OR_RETURN(restoredSnapshot.tracks.at(0).route == "HECA → LGAV");
    CHECK_OR_RETURN(restoredSnapshot.tracks.at(0).enrichmentCacheState == "FRESH");

    // Payload bounds are enforced before a provider can replace the cache.
    PublicFlightProviderCache tinyCache(64);
    CHECK_OR_RETURN(!tinyCache.refreshFromJson(providerPayload, 1400));
    CHECK_OR_RETURN(!tinyCache.available());
    CHECK_OR_RETURN(tinyCache.statusText().find("UNAVAILABLE") != std::string::npos);

    std::filesystem::remove(cachePath, cleanupError);
    return 0;
}
