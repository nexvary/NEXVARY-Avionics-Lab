#include "air_ops/PublicFlightFeed.hpp"

#include <cassert>
#include <cmath>
#include <string>

using namespace nexvary::avionics;

int main() {
    const auto demo = PublicFlightFeed::demo();
    assert(demo.trackCount() == 4);
    assert(demo.snapshot().source == "PUBLIC ADS-B / DEMO");
    assert(!demo.empty());

    const std::string opensky = R"({
        "time": 1726000000,
        "states": [
            ["abc123"," CIV101 ","Egypt",1725999998,1725999999,31.21,30.02,8500.0,false,210.0,95.0,4.5,null,8600.0,"4321",false,0,4],
            ["def456"," CIV202 ","Greece",null,null,29.90,31.15,10200.0,false,228.0,270.0,null,null,10350.0,null,false,0]
        ]
    })";
    const auto liveLike = PublicFlightFeed::fromJson(opensky);
    assert(liveLike.trackCount() == 2);
    assert(liveLike.snapshot().tracks.at(0).icao24 == "abc123");
    assert(liveLike.snapshot().tracks.at(0).callsign == "CIV101");
    assert(std::abs(liveLike.snapshot().tracks.at(0).latitude - 30.02) < 0.001);
    assert(std::abs(liveLike.snapshot().tracks.at(0).longitude - 31.21) < 0.001);
    assert(liveLike.snapshot().tracks.at(0).altitudeMeters.has_value());
    assert(std::abs(*liveLike.snapshot().tracks.at(0).velocityMetersPerSecond - 210.0) < 0.001);
    assert(std::abs(*liveLike.snapshot().tracks.at(0).geometricAltitudeMeters - 8600.0) < 0.001);
    assert(std::abs(*liveLike.snapshot().tracks.at(0).verticalRateMetersPerSecond - 4.5) < 0.001);
    assert(liveLike.snapshot().tracks.at(0).squawk == "4321");
    assert(liveLike.snapshot().tracks.at(0).positionSource == "ADS-B");
    assert(liveLike.snapshot().tracks.at(0).dataAgeSeconds == 1);
    assert(liveLike.snapshot().tracks.at(0).category == 4);

    const std::string normalized = R"({
        "source":"LAB-PUBLIC-FEED",
        "generatedAt":"demo",
        "tracks":[
            {"icao24":"xyz789","callsign":"TEST9","flightNumber":"TST009","country":"Test","latitude":30.5,"longitude":31.5,"altitudeMeters":5000,"geometricAltitudeMeters":5060,"velocityMps":150,"headingDegrees":180,"verticalRateMps":-2.5,"squawk":"7000","aircraftTypeCode":"A320","registration":"TEST-REG","aircraftModel":"Generic test aircraft","manufacturer":"Test Manufacturer","serialNumber":"MSN-1","operatorName":"Test Operator","operatorIcao":"TST","operatorIata":"T9","originAirportIcao":"TEST","destinationAirportIcao":"TEND","route":"TEST → TEND","aircraftFamily":"Test Family","variant":"V1","engineType":"Turbofan","yearBuilt":"2020","registrationStatus":"ACTIVE","telemetrySource":"TEST ADS-B","metadataSource":"TEST OPEN DATA","routeSource":"TEST ROUTE DATA","positionSource":"ADS-B","signalQualityPercent":91,"dataAgeSeconds":3,"onGround":false}
        ]
    })";
    const auto normalizedFeed = PublicFlightFeed::fromJson(normalized);
    assert(normalizedFeed.trackCount() == 1);
    assert(normalizedFeed.snapshot().source == "LAB-PUBLIC-FEED");
    const auto& enriched = normalizedFeed.snapshot().tracks.at(0);
    assert(enriched.headingDegrees == 180.0);
    assert(enriched.flightNumber == "TST009");
    assert(enriched.aircraftTypeCode == "A320");
    assert(enriched.registration == "TEST-REG");
    assert(enriched.operatorName == "Test Operator");
    assert(enriched.route == "TEST → TEND");
    assert(enriched.metadataSource == "TEST OPEN DATA");
    assert(enriched.signalQualityPercent == 91.0);

    const auto missingMetadata = PublicFlightFeed::fromJson(R"({"tracks":[{"icao24":"empty1","latitude":1,"longitude":1}]})");
    assert(missingMetadata.trackCount() == 1);
    assert(missingMetadata.snapshot().tracks.at(0).registration.empty());
    assert(!missingMetadata.snapshot().tracks.at(0).altitudeMeters.has_value());
    return 0;
}
