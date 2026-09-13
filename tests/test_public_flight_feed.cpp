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
            ["abc123"," CIV101 ","Egypt",null,null,31.21,30.02,8500.0,false,210.0,95.0,null,null,8600.0,null,false,0],
            ["def456"," CIV202 ","Greece",null,null,29.90,31.15,10200.0,false,228.0,270.0,null,null,10350.0,null,false,0]
        ]
    })";
    const auto liveLike = PublicFlightFeed::fromJson(opensky);
    assert(liveLike.trackCount() == 2);
    assert(liveLike.snapshot().tracks.at(0).icao24 == "abc123");
    assert(liveLike.snapshot().tracks.at(0).callsign == "CIV101");
    assert(std::abs(liveLike.snapshot().tracks.at(0).latitude - 30.02) < 0.001);
    assert(std::abs(liveLike.snapshot().tracks.at(0).longitude - 31.21) < 0.001);
    assert(std::abs(liveLike.snapshot().tracks.at(0).velocityMetersPerSecond - 210.0) < 0.001);

    const std::string normalized = R"({
        "source":"LAB-PUBLIC-FEED",
        "generatedAt":"demo",
        "tracks":[
            {"icao24":"xyz789","callsign":"TEST9","country":"Test","latitude":30.5,"longitude":31.5,"altitudeMeters":5000,"velocityMps":150,"headingDegrees":180,"onGround":false}
        ]
    })";
    const auto normalizedFeed = PublicFlightFeed::fromJson(normalized);
    assert(normalizedFeed.trackCount() == 1);
    assert(normalizedFeed.snapshot().source == "LAB-PUBLIC-FEED");
    assert(normalizedFeed.snapshot().tracks.at(0).headingDegrees == 180.0);
    return 0;
}
