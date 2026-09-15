#pragma once

#include <cstddef>
#include <filesystem>
#include <optional>
#include <string>
#include <vector>

namespace nexvary::avionics {

struct PublicFlightTrack {
    std::string icao24;
    std::string callsign;
    std::string country;
    std::string flightNumber;
    std::string aircraftTypeCode;
    std::string registration;
    std::string aircraftModel;
    std::string manufacturer;
    std::string serialNumber;
    std::string operatorName;
    std::string marketingOperator;
    std::string operatorIcao;
    std::string operatorIata;
    std::string originAirportIcao;
    std::string originAirportIata;
    std::string destinationAirportIcao;
    std::string destinationAirportIata;
    std::string route;
    std::string scheduledDeparture;
    std::string estimatedArrival;
    std::string aircraftFamily;
    std::string variant;
    std::string engineType;
    std::string yearBuilt;
    std::string registrationStatus;
    std::string registrationCountry;
    std::string telemetrySource{"PUBLIC ADS-B"};
    std::string metadataSource;
    std::string routeSource;
    std::string metadataLicense;
    std::string metadataSourceUrl;
    std::string routeLicense;
    std::string routeSourceUrl;
    std::string enrichmentCacheState;
    std::string positionSource;
    double latitude{0.0};
    double longitude{0.0};
    std::optional<double> altitudeMeters;
    std::optional<double> geometricAltitudeMeters;
    std::optional<double> velocityMetersPerSecond;
    std::optional<double> trueAirspeedMetersPerSecond;
    std::optional<double> headingDegrees;
    std::optional<double> verticalRateMetersPerSecond;
    std::optional<double> signalQualityPercent;
    std::optional<long long> lastContactEpoch;
    std::optional<long long> dataAgeSeconds;
    std::optional<long long> enrichmentCachedAtEpoch;
    std::optional<long long> enrichmentExpiresAtEpoch;
    std::string squawk;
    int category{0};
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
