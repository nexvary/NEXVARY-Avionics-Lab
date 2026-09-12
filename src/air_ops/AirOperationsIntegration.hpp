#pragma once

#include <cstddef>
#include <filesystem>
#include <optional>
#include <string>
#include <vector>

namespace nexvary::avionics {

struct AirOperationsTrack {
    std::string trackId;
    std::string classification;
    double latitude{0.0};
    double longitude{0.0};
    double altitudeMeters{0.0};
    std::optional<double> speedMetersPerSecond;
    std::optional<double> headingDegrees;
    double confidence{0.0};
    std::string threatLevel{"None"};
    int threatScore{0};
    bool insideProtectedZone{false};
    std::string zoneName;
    std::vector<std::string> sensors;
};

struct AirOperationsIncident {
    std::string incidentId;
    std::string trackId;
    std::string peakThreatLevel{"None"};
    int peakScore{0};
    std::string summary;
    std::string status;
};

struct AirOperationsSummary {
    std::size_t trackCount{0};
    std::size_t incidentCount{0};
    std::size_t highOrAboveCount{0};
    std::size_t observations{0};
};

struct AirOperationsSnapshot {
    std::string schema;
    std::string source;
    std::string mode;
    std::string generatedAt;
    AirOperationsSummary summary;
    std::vector<AirOperationsTrack> tracks;
    std::vector<AirOperationsIncident> incidents;
};

class AirOperationsIntegration final {
public:
    static constexpr const char* kSchema = "nexvary.air-operations.exchange/v1";

    AirOperationsIntegration() = default;
    explicit AirOperationsIntegration(AirOperationsSnapshot snapshot);

    static AirOperationsIntegration fromJson(const std::string& jsonText);
    static AirOperationsIntegration fromFile(const std::filesystem::path& path);
    static AirOperationsIntegration demo();

    const AirOperationsSnapshot& snapshot() const noexcept;
    bool empty() const noexcept;

private:
    static void validatePayloadSafety(const std::string& jsonText);
    static AirOperationsSnapshot parse(const std::string& jsonText);

    AirOperationsSnapshot snapshot_;
};

} // namespace nexvary::avionics
