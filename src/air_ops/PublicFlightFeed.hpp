#pragma once

#include <cstddef>
#include <filesystem>
#include <string>
#include <vector>

namespace nexvary::avionics {

struct PublicFlightTrack {
    std::string icao24;
    std::string callsign;
    std::string country;
    double latitude{0.0};
    double longitude{0.0};
    double altitudeMeters{0.0};
    double velocityMetersPerSecond{0.0};
    double headingDegrees{0.0};
    bool onGround{false};
};

struct PublicFlightSnapshot {
    std::string source{"PUBLIC ADS-B"};
    std::string generatedAt;
    std::vector<PublicFlightTrack> tracks;
};

class PublicFlightFeed final {
public:
    PublicFlightFeed() = default;
    explicit PublicFlightFeed(PublicFlightSnapshot snapshot);

    static PublicFlightFeed fromJson(const std::string& jsonText);
    static PublicFlightFeed fromFile(const std::filesystem::path& path);
    static PublicFlightFeed demo();

    const PublicFlightSnapshot& snapshot() const noexcept;
    std::size_t trackCount() const noexcept;
    bool empty() const noexcept;

private:
    static PublicFlightSnapshot parse(const std::string& jsonText);
    PublicFlightSnapshot snapshot_;
};

} // namespace nexvary::avionics
