#pragma once

#include "air_ops/PublicFlightFeed.hpp"

#include <cstddef>
#include <filesystem>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace nexvary::avionics {

struct AircraftEnrichmentProviderInfo {
    std::string name;
    std::string license;
    std::string sourceUrl;
    std::string generatedAt;
    long long generatedAtEpoch{0};
    long long defaultTtlSeconds{86400};
};

struct AircraftEnrichmentRecord {
    std::string icao24;
    std::string callsign;
    std::string registration;
    std::string aircraftTypeCode;
    std::string aircraftModel;
    std::string manufacturer;
    std::string serialNumber;
    std::string operatorName;
    std::string marketingOperator;
    std::string operatorIcao;
    std::string operatorIata;
    std::string registrationCountry;
    std::string registrationStatus;
    std::string aircraftFamily;
    std::string variant;
    std::string engineType;
    std::string yearBuilt;
    std::string flightNumber;
    std::string originAirportIcao;
    std::string originAirportIata;
    std::string destinationAirportIcao;
    std::string destinationAirportIata;
    std::string route;
    std::string scheduledDeparture;
    std::string estimatedArrival;
    std::optional<long long> cachedAtEpoch;
    std::optional<long long> expiresAtEpoch;
};

class PublicFlightEnrichmentCache final {
public:
    static PublicFlightEnrichmentCache fromJson(const std::string& jsonText);
    static PublicFlightEnrichmentCache fromFile(const std::filesystem::path& path);

    const AircraftEnrichmentProviderInfo& provider() const noexcept;
    std::size_t size() const noexcept;
    bool empty() const noexcept;

    // Enrichment is read-only with respect to the external provider. It never
    // mutates telemetry coordinates or kinematics. Expired cache entries may be
    // shown as stale, but provenance is always attached to the enriched fields.
    std::size_t apply(PublicFlightSnapshot& snapshot, long long nowEpoch) const;

private:
    static PublicFlightEnrichmentCache parse(const std::string& jsonText);
    void rebuildIndexes();

    AircraftEnrichmentProviderInfo provider_;
    std::vector<AircraftEnrichmentRecord> records_;
    std::unordered_map<std::string, std::size_t> byIcao24_;
    std::unordered_map<std::string, std::size_t> byCallsign_;
};

struct PublicFlightHistoryPoint {
    long long observedEpoch{0};
    double latitude{0.0};
    double longitude{0.0};
    std::optional<double> altitudeMeters;
    std::optional<double> velocityMetersPerSecond;
    std::optional<double> headingDegrees;
    std::string telemetrySource;
};

class PublicFlightHistoryStore final {
public:
    explicit PublicFlightHistoryStore(int retentionMinutes = 60);

    static PublicFlightHistoryStore fromJson(const std::string& jsonText);
    static PublicFlightHistoryStore fromFile(const std::filesystem::path& path);

    void record(const PublicFlightSnapshot& snapshot, long long observedEpoch);
    std::vector<PublicFlightHistoryPoint> window(const std::string& icao24,
                                                  int minutes,
                                                  long long nowEpoch) const;
    std::size_t pointCount(const std::string& icao24) const noexcept;
    std::size_t totalPointCount() const noexcept;
    int retentionMinutes() const noexcept;

    std::string toJson() const;
    void save(const std::filesystem::path& path) const;

private:
    void prune(long long nowEpoch);

    int retentionMinutes_{60};
    std::unordered_map<std::string, std::vector<PublicFlightHistoryPoint>> points_;
};

} // namespace nexvary::avionics
