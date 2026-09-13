#include "air_ops/PublicFlightFeed.hpp"

#include <fstream>
#include <nlohmann/json.hpp>
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

PublicFlightTrack parseOpenSkyState(const json& state) {
    if (!state.is_array() || state.size() < 11) {
        throw std::invalid_argument("invalid public flight state row");
    }

    PublicFlightTrack track;
    track.icao24 = stringOr(state.at(0));
    track.callsign = stringOr(state.at(1));
    track.country = stringOr(state.at(2));
    track.longitude = numberOr(state.at(5));
    track.latitude = numberOr(state.at(6));
    track.altitudeMeters = numberOr(state.at(7));
    track.onGround = state.at(8).is_boolean() ? state.at(8).get<bool>() : false;
    track.velocityMetersPerSecond = numberOr(state.at(9));
    track.headingDegrees = numberOr(state.at(10));
    return track;
}

PublicFlightTrack parseNormalizedTrack(const json& item) {
    if (!item.is_object()) throw std::invalid_argument("invalid normalized public flight track");

    PublicFlightTrack track;
    track.icao24 = stringOr(item.value("icao24", json{}));
    track.callsign = stringOr(item.value("callsign", json{}));
    track.country = stringOr(item.value("country", json{}));
    track.latitude = numberOr(item.value("latitude", json{}));
    track.longitude = numberOr(item.value("longitude", json{}));
    track.altitudeMeters = numberOr(item.value("altitudeMeters", json{}));
    track.velocityMetersPerSecond = numberOr(item.value("velocityMetersPerSecond", item.value("velocityMps", json{})));
    track.headingDegrees = numberOr(item.value("headingDegrees", json{}));
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
    snapshot.tracks = {
        {"4ca123", "NXR101", "Ireland", 31.215, 29.955, 9750.0, 221.0, 104.0, false},
        {"440abc", "NXR204", "Austria", 30.640, 30.280, 8120.0, 198.0, 72.0, false},
        {"738def", "NXR315", "Israel", 31.010, 30.720, 10980.0, 236.0, 287.0, false},
        {"406fed", "NXR427", "United Kingdom", 30.410, 29.610, 6420.0, 176.0, 12.0, false}
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
                auto track = parseOpenSkyState(state);
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
