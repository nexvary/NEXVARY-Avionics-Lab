#include "air_ops/AirOperationsIntegration.hpp"

#include <fstream>
#include <nlohmann/json.hpp>
#include <sstream>
#include <stdexcept>

namespace nexvary::avionics {
namespace {

using json = nlohmann::json;

bool containsForbiddenKey(const json& value) {
    static const std::vector<std::string> forbidden{
        "actuation", "engagement", "mitigationcommand", "jam", "jamming",
        "spoof", "spoofing", "takeover", "weapon", "firecontrol"
    };

    if (value.is_object()) {
        for (const auto& [key, child] : value.items()) {
            std::string lowered;
            lowered.reserve(key.size());
            for (const char ch : key) {
                lowered.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(ch))));
            }
            for (const auto& token : forbidden) {
                if (lowered.find(token) != std::string::npos) {
                    return true;
                }
            }
            if (containsForbiddenKey(child)) {
                return true;
            }
        }
    } else if (value.is_array()) {
        for (const auto& child : value) {
            if (containsForbiddenKey(child)) {
                return true;
            }
        }
    }
    return false;
}

std::optional<double> optionalNumber(const json& object, const char* key) {
    if (!object.contains(key) || object.at(key).is_null()) {
        return std::nullopt;
    }
    return object.at(key).get<double>();
}

std::vector<std::string> stringArray(const json& object, const char* key) {
    std::vector<std::string> values;
    if (!object.contains(key) || !object.at(key).is_array()) {
        return values;
    }
    for (const auto& item : object.at(key)) {
        values.push_back(item.get<std::string>());
    }
    return values;
}

} // namespace

AirOperationsIntegration::AirOperationsIntegration(AirOperationsSnapshot snapshot)
    : snapshot_(std::move(snapshot)) {}

AirOperationsIntegration AirOperationsIntegration::fromJson(const std::string& jsonText) {
    validatePayloadSafety(jsonText);
    return AirOperationsIntegration(parse(jsonText));
}

AirOperationsIntegration AirOperationsIntegration::fromFile(const std::filesystem::path& path) {
    std::ifstream input(path, std::ios::binary);
    if (!input) {
        throw std::runtime_error("Unable to open air-operations replay file");
    }
    std::ostringstream buffer;
    buffer << input.rdbuf();
    return fromJson(buffer.str());
}

AirOperationsIntegration AirOperationsIntegration::demo() {
    static constexpr const char* sample = R"json({
  "schema":"nexvary.air-operations.exchange/v1",
  "source":"Aegis-CUAS-Command",
  "mode":"simulation-replay",
  "generatedAt":"2026-09-12T15:45:00Z",
  "summary":{"tracks":3,"incidents":1,"highOrAbove":1,"observations":48},
  "tracks":[
    {"trackId":"AEG-TRK-101","classification":"Drone","latitude":30.0444,"longitude":31.2357,"altitudeMeters":145.0,"speedMetersPerSecond":16.2,"headingDegrees":83.0,"confidence":0.96,"threatLevel":"High","threatScore":78,"insideProtectedZone":true,"zoneName":"TRAINING-ZONE-A","sensors":["Simulator","RemoteId"]},
    {"trackId":"AEG-TRK-102","classification":"Aircraft","latitude":30.0710,"longitude":31.1810,"altitudeMeters":2100.0,"speedMetersPerSecond":118.0,"headingDegrees":248.0,"confidence":0.92,"threatLevel":"None","threatScore":8,"insideProtectedZone":false,"zoneName":"","sensors":["Simulator","Radar"]},
    {"trackId":"AEG-TRK-103","classification":"Bird","latitude":30.0320,"longitude":31.2700,"altitudeMeters":82.0,"speedMetersPerSecond":9.1,"headingDegrees":125.0,"confidence":0.74,"threatLevel":"Low","threatScore":22,"insideProtectedZone":false,"zoneName":"","sensors":["Simulator","EoIr"]}
  ],
  "incidents":[
    {"incidentId":"AEG-INC-5001","trackId":"AEG-TRK-101","peakThreatLevel":"High","peakScore":78,"summary":"Synthetic protected-zone entry for operator training","status":"Open"}
  ]
})json";
    return fromJson(sample);
}

const AirOperationsSnapshot& AirOperationsIntegration::snapshot() const noexcept {
    return snapshot_;
}

bool AirOperationsIntegration::empty() const noexcept {
    return snapshot_.tracks.empty() && snapshot_.incidents.empty();
}

void AirOperationsIntegration::validatePayloadSafety(const std::string& jsonText) {
    const auto document = json::parse(jsonText);
    if (containsForbiddenKey(document)) {
        throw std::invalid_argument("Air-operations exchange payload contains an active-control field");
    }
}

AirOperationsSnapshot AirOperationsIntegration::parse(const std::string& jsonText) {
    const auto document = json::parse(jsonText);
    if (!document.is_object()) {
        throw std::invalid_argument("Air-operations payload must be a JSON object");
    }

    AirOperationsSnapshot result;
    result.schema = document.value("schema", "");
    result.source = document.value("source", "");
    result.mode = document.value("mode", "");
    result.generatedAt = document.value("generatedAt", "");

    if (result.schema != kSchema) {
        throw std::invalid_argument("Unsupported air-operations exchange schema");
    }
    if (result.source.empty()) {
        throw std::invalid_argument("Air-operations source is required");
    }
    if (result.mode != "simulation-replay" && result.mode != "awareness-only") {
        throw std::invalid_argument("Only simulation-replay or awareness-only payloads are accepted");
    }

    if (document.contains("tracks")) {
        if (!document.at("tracks").is_array()) {
            throw std::invalid_argument("tracks must be an array");
        }
        for (const auto& row : document.at("tracks")) {
            AirOperationsTrack track;
            track.trackId = row.value("trackId", "");
            track.classification = row.value("classification", "Unknown");
            track.latitude = row.value("latitude", 0.0);
            track.longitude = row.value("longitude", 0.0);
            track.altitudeMeters = row.value("altitudeMeters", 0.0);
            track.speedMetersPerSecond = optionalNumber(row, "speedMetersPerSecond");
            track.headingDegrees = optionalNumber(row, "headingDegrees");
            track.confidence = row.value("confidence", 0.0);
            track.threatLevel = row.value("threatLevel", "None");
            track.threatScore = row.value("threatScore", 0);
            track.insideProtectedZone = row.value("insideProtectedZone", false);
            track.zoneName = row.value("zoneName", "");
            track.sensors = stringArray(row, "sensors");

            if (track.trackId.empty()) {
                throw std::invalid_argument("Each air track requires a trackId");
            }
            if (track.latitude < -90.0 || track.latitude > 90.0 ||
                track.longitude < -180.0 || track.longitude > 180.0) {
                throw std::invalid_argument("Air track coordinates are outside valid ranges");
            }
            if (track.confidence < 0.0 || track.confidence > 1.0) {
                throw std::invalid_argument("Air track confidence must be between 0 and 1");
            }
            result.tracks.push_back(std::move(track));
        }
    }

    if (document.contains("incidents")) {
        if (!document.at("incidents").is_array()) {
            throw std::invalid_argument("incidents must be an array");
        }
        for (const auto& row : document.at("incidents")) {
            AirOperationsIncident incident;
            incident.incidentId = row.value("incidentId", "");
            incident.trackId = row.value("trackId", "");
            incident.peakThreatLevel = row.value("peakThreatLevel", "None");
            incident.peakScore = row.value("peakScore", 0);
            incident.summary = row.value("summary", "");
            incident.status = row.value("status", "");
            if (incident.incidentId.empty() || incident.trackId.empty()) {
                throw std::invalid_argument("Air-operation incidents require incidentId and trackId");
            }
            result.incidents.push_back(std::move(incident));
        }
    }

    result.summary.trackCount = result.tracks.size();
    result.summary.incidentCount = result.incidents.size();
    if (document.contains("summary") && document.at("summary").is_object()) {
        const auto& summary = document.at("summary");
        result.summary.observations = summary.value("observations", static_cast<std::size_t>(0));
    }
    for (const auto& track : result.tracks) {
        if (track.threatLevel == "High" || track.threatLevel == "Critical") {
            ++result.summary.highOrAboveCount;
        }
    }

    return result;
}

} // namespace nexvary::avionics
