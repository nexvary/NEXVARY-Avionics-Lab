#include "air_ops/PublicFlightFeed.hpp"

#include <fstream>
#include <initializer_list>
#include <nlohmann/json.hpp>
#include <optional>
#include <stdexcept>
#include <utility>

namespace nexvary::avionics {
namespace {
using json = nlohmann::json;

constexpr std::size_t kMaxTracks = 2000;

std::string trim(const std::string& value) {
    const auto first = value.find_first_not_of(" \t\r\n");
    if (first == std::string::npos) return {};
    const auto last = value.find_last_not_of(" \t\r\n");
    return value.substr(first, last - first + 1);
}

double numberOr(const json& value, double fallback = 0.0) {
    if (value.is_number()) return value.get<double>();
    return fallback;
}

std::string stringOr(const json& value, const std::string& fallback = {}) {
    return value.is_string() ? trim(value.get<std::string>()) : fallback;
}

std::optional<double> optionalNumber(const json& value) {
    if (value.is_number()) return value.get<double>();
    return std::nullopt;
}

std::optional<long long> optionalInteger(const json& value) {
    if (value.is_number_integer()) return value.get<long long>();
    return std::nullopt;
}

std::string firstString(const json& item, std::initializer_list<const char*> keys) {
    for (const auto* key : keys) {
        if (item.contains(key)) {
            const auto value = stringOr(item.at(key));
            if (!value.empty()) return value;
        }
    }
    return {};
}

std::optional<double> firstNumber(const json& item, std::initializer_list<const char*> keys) {
    for (const auto* key : keys) {
        if (item.contains(key)) {
            const auto value = optionalNumber(item.at(key));
            if (value) return value;
        }
    }
    return std::nullopt;
}

std::string positionSourceLabel(int value) {
    switch (value) {
    case 0: return "ADS-B";
    case 1: return "ASTERIX";
    case 2: return "MLAT";
    case 3: return "FLARM";
    default: return {};
    }
}

PublicFlightTrack parseOpenSkyState(const json& state, const std::optional<long long>& snapshotTime) {
    if (!state.is_array() || state.size() < 11) {
        throw std::invalid_argument("invalid public flight state row");
    }

    PublicFlightTrack track;
    track.icao24 = stringOr(state.at(0));
    track.callsign = stringOr(state.at(1));
    track.country = stringOr(state.at(2));
    track.flightNumber = track.callsign;
    track.telemetrySource = "OpenSky Network";
    track.longitude = numberOr(state.at(5));
    track.latitude = numberOr(state.at(6));
    track.altitudeMeters = optionalNumber(state.at(7));
    track.onGround = state.at(8).is_boolean() ? state.at(8).get<bool>() : false;
    track.velocityMetersPerSecond = optionalNumber(state.at(9));
    track.headingDegrees = optionalNumber(state.at(10));
    if (state.size() > 11) track.verticalRateMetersPerSecond = optionalNumber(state.at(11));
    if (state.size() > 13) track.geometricAltitudeMeters = optionalNumber(state.at(13));
    if (state.size() > 14) track.squawk = stringOr(state.at(14));
    if (state.size() > 16 && state.at(16).is_number_integer()) {
        track.positionSource = positionSourceLabel(state.at(16).get<int>());
    }
    if (state.size() > 17 && state.at(17).is_number_integer()) track.category = state.at(17).get<int>();
    if (state.size() > 4) track.lastContactEpoch = optionalInteger(state.at(4));
    if (snapshotTime && track.lastContactEpoch && *snapshotTime >= *track.lastContactEpoch) {
        track.dataAgeSeconds = *snapshotTime - *track.lastContactEpoch;
    }
    return track;
}

PublicFlightTrack parseNormalizedTrack(const json& item) {
    if (!item.is_object()) throw std::invalid_argument("invalid normalized public flight track");

    PublicFlightTrack track;
    track.icao24 = stringOr(item.value("icao24", json{}));
    track.callsign = stringOr(item.value("callsign", json{}));
    track.country = stringOr(item.value("country", json{}));
    track.flightNumber = firstString(item, {"flightNumber", "flight", "flightIata"});
    track.aircraftTypeCode = firstString(item, {"aircraftTypeCode", "typeCode", "icaoAircraftType"});
    track.registration = firstString(item, {"registration", "tailNumber"});
    track.aircraftModel = firstString(item, {"aircraftModel", "model"});
    track.manufacturer = firstString(item, {"manufacturer", "manufacturerName"});
    track.serialNumber = firstString(item, {"serialNumber", "msn"});
    track.operatorName = firstString(item, {"operatorName", "operator"});
    track.marketingOperator = firstString(item, {"marketingOperator", "marketingAirline"});
    track.operatorIcao = firstString(item, {"operatorIcao", "airlineIcao"});
    track.operatorIata = firstString(item, {"operatorIata", "airlineIata"});
    track.originAirportIcao = firstString(item, {"originAirportIcao", "originIcao"});
    track.originAirportIata = firstString(item, {"originAirportIata", "originIata"});
    track.destinationAirportIcao = firstString(item, {"destinationAirportIcao", "destinationIcao"});
    track.destinationAirportIata = firstString(item, {"destinationAirportIata", "destinationIata"});
    track.route = firstString(item, {"route", "routeLabel"});
    track.scheduledDeparture = firstString(item, {"scheduledDeparture", "departureTime"});
    track.estimatedArrival = firstString(item, {"estimatedArrival", "arrivalTime"});
    track.aircraftFamily = firstString(item, {"aircraftFamily", "family"});
    track.variant = firstString(item, {"variant", "aircraftVariant"});
    track.engineType = firstString(item, {"engineType", "engine"});
    track.yearBuilt = firstString(item, {"yearBuilt", "built"});
    track.registrationStatus = firstString(item, {"registrationStatus", "status"});
    track.registrationCountry = firstString(item, {"registrationCountry", "countryOfRegistration"});
    track.telemetrySource = firstString(item, {"telemetrySource", "source"});
    if (track.telemetrySource.empty()) track.telemetrySource = "PUBLIC ADS-B";
    track.metadataSource = firstString(item, {"metadataSource", "aircraftDataSource"});
    track.routeSource = firstString(item, {"routeSource", "flightDataSource"});
    track.positionSource = firstString(item, {"positionSource", "positionMode"});
    track.latitude = numberOr(item.value("latitude", json{}));
    track.longitude = numberOr(item.value("longitude", json{}));
    track.altitudeMeters = firstNumber(item, {"altitudeMeters", "barometricAltitudeMeters"});
    track.geometricAltitudeMeters = firstNumber(item, {"geometricAltitudeMeters", "geoAltitudeMeters"});
    track.velocityMetersPerSecond = firstNumber(item, {"velocityMetersPerSecond", "velocityMps", "groundSpeedMps"});
    track.trueAirspeedMetersPerSecond = firstNumber(item, {"trueAirspeedMetersPerSecond", "trueAirspeedMps"});
    track.headingDegrees = firstNumber(item, {"headingDegrees", "trackDegrees", "trueTrack"});
    track.verticalRateMetersPerSecond = firstNumber(item, {"verticalRateMetersPerSecond", "verticalRateMps"});
    track.signalQualityPercent = firstNumber(item, {"signalQualityPercent", "signalQuality"});
    track.squawk = firstString(item, {"squawk", "transponderCode"});
    if (item.contains("lastContactEpoch")) track.lastContactEpoch = optionalInteger(item.at("lastContactEpoch"));
    if (item.contains("dataAgeSeconds")) track.dataAgeSeconds = optionalInteger(item.at("dataAgeSeconds"));
    if (item.contains("category") && item.at("category").is_number_integer()) track.category = item.at("category").get<int>();
    track.onGround = item.value("onGround", false);
    return track;
}

bool validCoordinate(const PublicFlightTrack& track) {
    return track.latitude >= -90.0 && track.latitude <= 90.0 &&
           track.longitude >= -180.0 && track.longitude <= 180.0;
}
}

PublicFlightFeed::PublicFlightFeed(PublicFlightSnapshot snapshot)
    : snapshot_(std::move(snapshot)) {}

PublicFlightFeed PublicFlightFeed::fromJson(const std::string& jsonText) {
    return PublicFlightFeed(parse(jsonText));
}

PublicFlightFeed PublicFlightFeed::fromFile(const std::filesystem::path& path) {
    std::ifstream input(path, std::ios::binary);
    if (!input) throw std::runtime_error("unable to open public flight feed file");
    const std::string text((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
    return fromJson(text);
}

PublicFlightFeed PublicFlightFeed::demo() {
    PublicFlightSnapshot snapshot;
    snapshot.source = "PUBLIC ADS-B / DEMO";
    snapshot.generatedAt = "synthetic";
    const auto makeDemoTrack = [](std::string icao24, std::string callsign, std::string country,
                                  double latitude, double longitude, double altitude,
                                  double velocity, double heading, std::string typeCode,
                                  std::string model, std::string registration) {
        PublicFlightTrack track;
        track.icao24 = std::move(icao24);
        track.callsign = std::move(callsign);
        track.flightNumber = track.callsign;
        track.country = std::move(country);
        track.latitude = latitude;
        track.longitude = longitude;
        track.altitudeMeters = altitude;
        track.geometricAltitudeMeters = altitude + 35.0;
        track.velocityMetersPerSecond = velocity;
        track.headingDegrees = heading;
        track.verticalRateMetersPerSecond = 0.0;
        track.aircraftTypeCode = std::move(typeCode);
        track.aircraftModel = std::move(model);
        track.registration = std::move(registration);
        track.telemetrySource = "SYNTHETIC TRAINING ADS-B";
        track.metadataSource = "NEXVARY DEMO DATASET";
        track.routeSource = "SYNTHETIC TRAINING ROUTE";
        track.positionSource = "ADS-B";
        track.signalQualityPercent = 96.0;
        track.dataAgeSeconds = 2;
        track.squawk = "N/A";
        return track;
    };
    snapshot.tracks = {
        makeDemoTrack("4ca123", "NXR101", "Ireland", 31.215, 29.955, 9750.0, 221.0, 104.0, "A320", "Generic narrow-body jet", "DEMO-101"),
        makeDemoTrack("440abc", "NXR204", "Austria", 30.640, 30.280, 8120.0, 198.0, 72.0, "B738", "Generic narrow-body jet", "DEMO-204"),
        makeDemoTrack("738def", "NXR315", "Israel", 31.010, 30.720, 10980.0, 236.0, 287.0, "E190", "Generic regional jet", "DEMO-315"),
        makeDemoTrack("406fed", "NXR427", "United Kingdom", 30.410, 29.610, 6420.0, 176.0, 12.0, "AT76", "Generic turboprop", "DEMO-427")
    };
    return PublicFlightFeed(std::move(snapshot));
}

const PublicFlightSnapshot& PublicFlightFeed::snapshot() const noexcept {
    return snapshot_;
}

std::size_t PublicFlightFeed::trackCount() const noexcept {
    return snapshot_.tracks.size();
}

bool PublicFlightFeed::empty() const noexcept {
    return snapshot_.tracks.empty();
}

PublicFlightSnapshot PublicFlightFeed::parse(const std::string& jsonText) {
    if (jsonText.empty()) throw std::invalid_argument("empty public flight feed payload");

    const auto root = json::parse(jsonText);
    if (!root.is_object()) throw std::invalid_argument("public flight feed must be a JSON object");

    PublicFlightSnapshot snapshot;
    snapshot.source = root.value("source", std::string("PUBLIC ADS-B"));
    if (root.contains("time") && root.at("time").is_number_integer()) {
        snapshot.generatedAt = std::to_string(root.at("time").get<long long>());
    } else {
        snapshot.generatedAt = root.value("generatedAt", std::string{});
    }

    if (root.contains("states") && root.at("states").is_array()) {
        for (const auto& state : root.at("states")) {
            if (snapshot.tracks.size() >= kMaxTracks) break;
            try {
                const std::optional<long long> responseTime = root.contains("time")
                    ? optionalInteger(root.at("time")) : std::nullopt;
                auto track = parseOpenSkyState(state, responseTime);
                if (track.icao24.empty() || !validCoordinate(track)) continue;
                snapshot.tracks.push_back(std::move(track));
            } catch (const std::invalid_argument&) {
                continue;
            }
        }
    } else if (root.contains("tracks") && root.at("tracks").is_array()) {
        for (const auto& item : root.at("tracks")) {
            if (snapshot.tracks.size() >= kMaxTracks) break;
            auto track = parseNormalizedTrack(item);
            if (track.icao24.empty() || !validCoordinate(track)) continue;
            snapshot.tracks.push_back(std::move(track));
        }
    } else {
        throw std::invalid_argument("public flight feed contains neither states nor tracks");
    }

    return snapshot;
}

} // namespace nexvary::avionics
