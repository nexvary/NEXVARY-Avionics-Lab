#include "air_ops/AerodromeConditions.hpp"

#include <cassert>
#include <cmath>
#include <stdexcept>
#include <string>

using namespace nexvary::avionics;

int main() {
    const std::string normalized = R"({
        "provider": {
            "name":"LICENSED AERODROME TEST PROVIDER",
            "license":"TEST-AERODROME-LICENSE",
            "sourceUrl":"https://licensed.example.test/aerodromes",
            "generatedAtEpoch":1000,
            "defaultTtlSeconds":300
        },
        "weather":[
            {"airportIcao":"HECA","airportIata":"CAI","airportName":"Cairo Test","observedAt":"1970-01-01T00:16:30Z","observedAtEpoch":990,"rawMetar":"HECA TEST","flightCategory":"VFR","weatherPhenomena":"HZ","skyCover":"SCT","windDirectionDegrees":320,"windSpeedKnots":12,"windGustKnots":18,"visibilityStatuteMiles":6.2,"ceilingFeet":8000,"temperatureCelsius":31,"dewpointCelsius":18,"altimeterInHg":29.92},
            {"airportIcao":"HEAX","rawMetar":"HEAX TEST","flightCategory":"MVFR","windSpeedKnots":9}
        ],
        "runways":[
            {"airportIcao":"HECA","runway":"05R/23L","state":"OPEN","surface":"ASPHALT","brakingAction":"GOOD","runwayConditionCode":6,"frictionCoefficient":0.58,"closed":false},
            {"airportIcao":"HECA","runway":"05C/23C","state":"CLOSED","surface":"ASPHALT","contamination":"MAINTENANCE","closed":true}
        ]
    })";

    const auto feed = AerodromeConditionFeed::fromJson(normalized, 1100);
    assert(feed.weatherCount() == 2);
    assert(feed.runwayCount() == 2);
    assert(!feed.empty());
    assert(feed.provider().name == "LICENSED AERODROME TEST PROVIDER");
    assert(feed.provider().license == "TEST-AERODROME-LICENSE");

    const auto* cairo = feed.weatherFor("heca");
    assert(cairo != nullptr);
    assert(cairo->airportIata == "CAI");
    assert(cairo->flightCategory == "VFR");
    assert(cairo->windSpeedKnots && std::abs(*cairo->windSpeedKnots - 12.0) < 0.0001);
    assert(cairo->cachedAtEpoch == 1000);
    assert(cairo->expiresAtEpoch == 1300);
    assert(cairo->cacheState == "FRESH");

    const auto runways = feed.runwaysFor("HECA");
    assert(runways.size() == 2);
    assert(runways.at(0).runway == "05C/23C");
    assert(runways.at(0).closed);
    assert(runways.at(1).runway == "05R/23L");
    assert(runways.at(1).runwayConditionCode == 6);
    assert(runways.at(1).frictionCoefficient && std::abs(*runways.at(1).frictionCoefficient - 0.58) < 0.0001);

    const auto stale = AerodromeConditionFeed::fromJson(normalized, 1401);
    assert(stale.weatherFor("HECA") != nullptr);
    assert(stale.weatherFor("HECA")->cacheState == "STALE");
    assert(stale.runwaysFor("HECA").at(0).cacheState == "STALE");

    const std::string awc = R"([
        {
            "icaoId":"HECA",
            "reportTime":"2026-09-15T16:00:00Z",
            "obsTime":1789488000,
            "rawOb":"HECA 151600Z 32012G18KT 9999 SCT030 31/18 Q1013",
            "fltCat":"VFR",
            "wxString":"HZ",
            "wdir":320,
            "wspd":12,
            "wgst":18,
            "visib":6.2,
            "temp":31,
            "dewp":18,
            "altim":29.92,
            "clouds":[{"cover":"SCT","base":3000},{"cover":"BKN","base":9000}]
        },
        {
            "icaoId":"HESH",
            "rawOb":"HESH TEST",
            "fltCat":"MVFR",
            "wdir":"VRB",
            "wspd":"7"
        }
    ])";

    const auto publicWeather = AerodromeConditionFeed::fromAviationWeatherMetarJson(awc, 2000);
    assert(publicWeather.weatherCount() == 2);
    assert(publicWeather.runwayCount() == 0);
    assert(publicWeather.provider().name == "NOAA/NWS Aviation Weather Center Data API");
    assert(publicWeather.provider().sourceUrl == "https://aviationweather.gov/api/data/metar");
    assert(publicWeather.provider().license.find("public-domain") != std::string::npos);
    const auto* awcCairo = publicWeather.weatherFor("HECA");
    assert(awcCairo != nullptr);
    assert(awcCairo->rawMetar.find("HECA") == 0);
    assert(awcCairo->skyCover == "SCT/BKN");
    assert(awcCairo->ceilingFeet && std::abs(*awcCairo->ceilingFeet - 9000.0) < 0.0001);
    assert(awcCairo->cacheState == "FRESH");
    const auto* awcSharm = publicWeather.weatherFor("hesh");
    assert(awcSharm != nullptr);
    assert(!awcSharm->windDirectionDegrees);
    assert(awcSharm->windSpeedKnots && std::abs(*awcSharm->windSpeedKnots - 7.0) < 0.0001);

    bool rejectedMissingLicense = false;
    try {
        static_cast<void>(AerodromeConditionFeed::fromJson(R"({"provider":{"name":"BAD"},"weather":[{"airportIcao":"HECA"}]})", 100));
    } catch (const std::invalid_argument&) {
        rejectedMissingLicense = true;
    }
    assert(rejectedMissingLicense);

    bool rejectedEmpty = false;
    try {
        static_cast<void>(AerodromeConditionFeed::fromJson(R"({"provider":{"name":"OK","license":"L"},"weather":[],"runways":[]})", 100));
    } catch (const std::invalid_argument&) {
        rejectedEmpty = true;
    }
    assert(rejectedEmpty);

    return 0;
}
