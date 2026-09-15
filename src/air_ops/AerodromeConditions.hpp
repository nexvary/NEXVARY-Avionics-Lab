#pragma once

#include <cstddef>
#include <filesystem>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace nexvary::avionics {

struct AerodromeConditionProviderInfo {
    std::string name;
    std::string license;
    std::string sourceUrl;
    std::string generatedAt;
    long long generatedAtEpoch{0};
    long long defaultTtlSeconds{3600};
};

struct AerodromeWeatherObservation {
    std::string airportIcao;
    std::string airportIata;
    std::string airportName;
    std::string observedAt;
    std::optional<long long> observedAtEpoch;
    std::string rawMetar;
    std::string flightCategory;
    std::string weatherPhenomena;
    std::string skyCover;
    std::optional<double> windDirectionDegrees;
    std::optional<double> windSpeedKnots;
    std::optional<double> windGustKnots;
    std::optional<double> visibilityStatuteMiles;
    std::optional<double> ceilingFeet;
    std::optional<double> temperatureCelsius;
    std::optional<double> dewpointCelsius;
    std::optional<double> altimeterInHg;
    std::optional<long long> cachedAtEpoch;
    std::optional<long long> expiresAtEpoch;
    std::string cacheState;
};

struct RunwayConditionObservation {
    std::string airportIcao;
    std::string runway;
    std::string state;
    std::string surface;
    std::string brakingAction;
    std::string contamination;
    std::string observedAt;
    std::optional<long long> observedAtEpoch;
    std::optional<int> runwayConditionCode;
    std::optional<double> frictionCoefficient;
    bool closed{false};
    std::optional<long long> cachedAtEpoch;
    std::optional<long long> expiresAtEpoch;
    std::string cacheState;
};

struct AerodromeConditionSnapshot {
    AerodromeConditionProviderInfo provider;
    std::vector<AerodromeWeatherObservation> weather;
    std::vector<RunwayConditionObservation> runways;
};

class AerodromeConditionFeed final {
public:
    AerodromeConditionFeed() = default;
    explicit AerodromeConditionFeed(AerodromeConditionSnapshot snapshot);

    // Normalized provider envelope. Provider name and license/provenance are required.
    static AerodromeConditionFeed fromJson(const std::string& jsonText, long long nowEpoch = 0);
    static AerodromeConditionFeed fromFile(const std::filesystem::path& path, long long nowEpoch = 0);

    // Parser for the public NOAA/NWS Aviation Weather Center METAR JSON array.
    // This adapter is weather-only; it never fabricates runway condition data.
    static AerodromeConditionFeed fromAviationWeatherMetarJson(const std::string& jsonText,
                                                                long long nowEpoch = 0);

    const AerodromeConditionSnapshot& snapshot() const noexcept;
    const AerodromeConditionProviderInfo& provider() const noexcept;
    const AerodromeWeatherObservation* weatherFor(const std::string& airportIcao) const noexcept;
    std::vector<RunwayConditionObservation> runwaysFor(const std::string& airportIcao) const;
    std::size_t weatherCount() const noexcept;
    std::size_t runwayCount() const noexcept;
    bool empty() const noexcept;

private:
    static AerodromeConditionFeed parseNormalized(const std::string& jsonText, long long nowEpoch);
    void normalizeFreshness(long long nowEpoch);
    void rebuildIndexes();

    AerodromeConditionSnapshot snapshot_;
    std::unordered_map<std::string, std::size_t> weatherByIcao_;
    std::unordered_multimap<std::string, std::size_t> runwaysByIcao_;
};

} // namespace nexvary::avionics
