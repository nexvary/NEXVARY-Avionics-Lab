#include "air_ops/AerodromeProviderCache.hpp"

#include <cassert>
#include <filesystem>
#include <fstream>
#include <string>

using namespace nexvary::avionics;

int main() {
    const std::string metarPayload = R"([
        {"icaoId":"HECA","rawOb":"HECA TEST METAR","fltCat":"VFR","wdir":320,"wspd":12,"visib":6.0,"obsTime":1000}
    ])";

    AerodromeProviderCache metar(AerodromeProviderPayloadKind::PublicMetar, 4096);
    assert(metar.refreshFromJson(metarPayload, 1100));
    assert(metar.available());
    assert(!metar.usingFallback());
    assert(metar.feed().weatherCount() == 1);
    assert(metar.feed().runwayCount() == 0);
    assert(metar.provider().name == "NOAA/NWS Aviation Weather Center Data API");
    assert(metar.statusText().find("PUBLIC METAR ACTIVE") != std::string::npos);

    const auto base = std::filesystem::temp_directory_path() / "nexvary-aerodrome-provider-cache-test";
    std::filesystem::create_directories(base);
    const auto metarPath = base / "metar.json";
    const auto licensedPath = base / "licensed.json";
    assert(metar.persistLastGood(metarPath));

    AerodromeProviderCache restoredMetar(AerodromeProviderPayloadKind::PublicMetar, 4096);
    assert(restoredMetar.restoreLastGood(metarPath, 1200));
    assert(restoredMetar.usingFallback());
    assert(restoredMetar.feed().weatherCount() == 1);
    assert(restoredMetar.statusText().find("CACHE FALLBACK") != std::string::npos);
    assert(!restoredMetar.refreshFromJson("{bad-json", 1300));
    assert(restoredMetar.available());
    assert(restoredMetar.usingFallback());
    assert(restoredMetar.feed().weatherCount() == 1);

    const std::string licensedPayload = R"({
        "provider":{"name":"LICENSED RUNWAY TEST","license":"TEST-LICENSE","sourceUrl":"https://licensed.example.test/runways","defaultTtlSeconds":300},
        "weather":[{"airportIcao":"HECA","rawMetar":"LICENSED WEATHER","flightCategory":"VFR"}],
        "runways":[{"airportIcao":"HECA","runway":"05R/23L","state":"OPEN","surface":"ASPHALT","runwayConditionCode":6,"closed":false}]
    })";

    AerodromeProviderCache licensed(AerodromeProviderPayloadKind::LicensedConditions, 4096);
    assert(licensed.refreshFromJson(licensedPayload, 2000));
    assert(licensed.available());
    assert(licensed.feed().weatherCount() == 1);
    assert(licensed.feed().runwayCount() == 1);
    assert(licensed.provider().license == "TEST-LICENSE");
    assert(licensed.persistLastGood(licensedPath));

    AerodromeProviderCache restoredLicensed(AerodromeProviderPayloadKind::LicensedConditions, 4096);
    assert(restoredLicensed.restoreLastGood(licensedPath, 2100));
    assert(restoredLicensed.usingFallback());
    assert(restoredLicensed.feed().runwayCount() == 1);
    restoredLicensed.noteRefreshFailure("network unavailable");
    assert(restoredLicensed.available());
    assert(restoredLicensed.usingFallback());
    assert(restoredLicensed.statusText().find("LAST GOOD") != std::string::npos);
    assert(restoredLicensed.feed().runwaysFor("HECA").at(0).runway == "05R/23L");

    AerodromeProviderCache bounded(AerodromeProviderPayloadKind::LicensedConditions, 32);
    assert(!bounded.refreshFromJson(licensedPayload, 2200));
    assert(!bounded.available());
    assert(bounded.lastError().find("limit") != std::string::npos);

    std::error_code ec;
    std::filesystem::remove_all(base, ec);
    return 0;
}
