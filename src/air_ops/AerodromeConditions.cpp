#include "air_ops/AerodromeConditions.hpp"

#include <algorithm>
#include <cctype>
#include <fstream>
#include <limits>
#include <nlohmann/json.hpp>
#include <stdexcept>
#include <utility>

namespace nexvary::avionics {
namespace {
using json = nlohmann::json;
constexpr std::size_t kMaxWeatherRows = 1000;
constexpr std::size_t kMaxRunwayRows = 5000;

std::string trim(const std::string& value) {
    const auto first = value.find_first_not_of(" \t\r\n");
    if (first == std::string::npos) return {};
    const auto last = value.find_last_not_of(" \t\r\n");
    return value.substr(first, last - first + 1);
}

std::string upper(std::string value) {
    value = trim(value);
    std::transform(value.begin(), value.end(), value.begin(), [](unsigned char ch) {
        return static_cast<char>(std::toupper(ch));
    });
    return value;
}

std::string stringValue(const json& value) {
    if (value.is_string()) return trim(value.get<std::string>());
    return {};
}

std::string firstString(const json& item, std::initializer_list<const char*> keys) {
    for (const auto* key : keys) {
        if (!item.contains(key)) continue;
        const auto value = stringValue(item.at(key));
        if (!value.empty()) return value;
    }
    return {};
}

std::optional<double> numberValue(const json& value) {
    if (value.is_number()) return value.get<double>();
    if (value.is_string()) {
        const auto text = trim(value.get<std::string>());
        if (text.empty()) return std::nullopt;
        try {
            std::size_t consumed = 0;
            const auto parsed = std::stod(text, &consumed);
            if (consumed == text.size()) return parsed;
        } catch (...) {
        }
    }
    return std::nullopt;
}

std::optional<long long> integerValue(const json& value) {
    if (value.is_number_integer()) return value.get<long long>();
    if (value.is_number_unsigned()) return static_cast<long long>(value.get<unsigned long long>());
    if (value.is_number_float()) return static_cast<long long>(value.get<double>());
    if (value.is_string()) {
        const auto text = trim(value.get<std::string>());
        if (text.empty()) return std::nullopt;
        try {
            std::size_t consumed = 0;
            const auto parsed = std::stoll(text, &consumed);
            if (consumed == text.size()) return parsed;
        } catch (...) {
        }
    }
    return std::nullopt;
}

std::optional<double> firstNumber(const json& item, std::initializer_list<const char*> keys) {
    for (const auto* key : keys) {
        if (!item.contains(key)) continue;
        if (const auto value = numberValue(item.at(key))) return value;
    }
    return std::nullopt;
}

std::optional<long long> firstInteger(const json& item, std::initializer_list<const char*> keys) {
    for (const auto* key : keys) {
        if (!item.contains(key)) continue;
        if (const auto value = integerValue(item.at(key))) return value;
    }
    return std::nullopt;
}

bool boolValue(const json& value, bool fallback = false) {
    if (value.is_boolean()) return value.get<bool>();
    if (value.is_number_integer()) return value.get<int>() != 0;
    if (value.is_string()) {
        const auto text = upper(value.get<std::string>());
        if (text == "TRUE" || text == "YES" || text == "CLOSED" || text == "1") return true;
        if (text == "FALSE" || text == "NO" || text == "OPEN" || text == "0") return false;
    }
    return fallback;
}

long long effectiveNow(long long nowEpoch, const AerodromeConditionProviderInfo& provider) {
    if (nowEpoch > 0) return nowEpoch;
    if (provider.generatedAtEpoch > 0) return provider.generatedAtEpoch;
    return 1;
}

long long cachedAt(const std::optional<long long>& recordCached,
                   const AerodromeConditionProviderInfo& provider,
                   long long nowEpoch) {
    if (recordCached && *recordCached > 0) return *recordCached;
    if (provider.generatedAtEpoch > 0) return provider.generatedAtEpoch;
    return effectiveNow(nowEpoch, provider);
}

long long expiresAt(const std::optional<long long>& recordExpires,
                    const AerodromeConditionProviderInfo& provider,
                    long long cached) {
    if (recordExpires && *recordExpires > 0) return *recordExpires;
    return cached + std::max<long long>(provider.defaultTtlSeconds, 1);
}

std::optional<double> computeCeiling(const json& item) {
    if (const auto direct = firstNumber(item, {"ceilingFeet", "ceilingFt", "ceiling"})) return direct;
    if (!item.contains("clouds") || !item.at("clouds").is_array()) return std::nullopt;
    std::optional<double> ceiling;
    for (const auto& cloud : item.at("clouds")) {
        if (!cloud.is_object()) continue;
        const auto cover = upper(firstString(cloud, {"cover", "skyCover"}));
        if (cover != "BKN" && cover != "OVC" && cover != "VV") continue;
        const auto base = firstNumber(cloud, {"base", "baseFeet", "baseFt"});
        if (!base) continue;
        if (!ceiling || *base < *ceiling) ceiling = base;
    }
    return ceiling;
}

std::string computeSkyCover(const json& item) {
    const auto direct = firstString(item, {"skyCover", "cover"});
    if (!direct.empty()) return upper(direct);
    if (!item.contains("clouds") || !item.at("clouds").is_array()) return {};
    std::string result;
    for (const auto& cloud : item.at("clouds")) {
        if (!cloud.is_object()) continue;
        const auto cover = upper(firstString(cloud, {"cover", "skyCover"}));
        if (cover.empty()) continue;
        if (!result.empty()) result += "/";
        result += cover;
    }
    return result;
}

AerodromeWeatherObservation parseWeather(const json& item) {
    if (!item.is_object()) throw std::invalid_argument("invalid aerodrome weather row");
    AerodromeWeatherObservation row;
    row.airportIcao = upper(firstString(item, {"airportIcao", "icaoId", "stationId", "id"}));
    row.airportIata = upper(firstString(item, {"airportIata", "iataId", "iata"}));
    row.airportName = firstString(item, {"airportName", "name", "site"});
    row.observedAt = firstString(item, {"observedAt", "reportTime", "receiptTime"});
    row.observedAtEpoch = firstInteger(item, {"observedAtEpoch", "obsTime", "reportTimeEpoch"});
    row.rawMetar = firstString(item, {"rawMetar", "rawOb", "rawText"});
    row.flightCategory = upper(firstString(item, {"flightCategory", "fltCat"}));
    row.weatherPhenomena = firstString(item, {"weatherPhenomena", "wxString", "wx"});
    row.skyCover = computeSkyCover(item);
    row.windDirectionDegrees = firstNumber(item, {"windDirectionDegrees", "wdir", "windDir"});
    row.windSpeedKnots = firstNumber(item, {"windSpeedKnots", "wspd", "windSpeed"});
    row.windGustKnots = firstNumber(item, {"windGustKnots", "wgst", "windGust"});
    row.visibilityStatuteMiles = firstNumber(item, {"visibilityStatuteMiles", "visib", "visibility"});
    row.ceilingFeet = computeCeiling(item);
    row.temperatureCelsius = firstNumber(item, {"temperatureCelsius", "temp", "temperature"});
    row.dewpointCelsius = firstNumber(item, {"dewpointCelsius", "dewp", "dewpoint"});
    row.altimeterInHg = firstNumber(item, {"altimeterInHg", "altim", "altimeter"});
    row.cachedAtEpoch = firstInteger(item, {"cachedAtEpoch"});
    row.expiresAtEpoch = firstInteger(item, {"expiresAtEpoch"});
    return row;
}

RunwayConditionObservation parseRunway(const json& item) {
    if (!item.is_object()) throw std::invalid_argument("invalid runway condition row");
    RunwayConditionObservation row;
    row.airportIcao = upper(firstString(item, {"airportIcao", "icaoId", "stationId"}));
    row.runway = upper(firstString(item, {"runway", "runwayId", "designation"}));
    row.state = upper(firstString(item, {"state", "condition", "runwayState"}));
    row.surface = firstString(item, {"surface", "surfaceType"});
    row.brakingAction = firstString(item, {"brakingAction", "braking"});
    row.contamination = firstString(item, {"contamination", "contaminant"});
    row.observedAt = firstString(item, {"observedAt", "reportTime", "updatedAt"});
    row.observedAtEpoch = firstInteger(item, {"observedAtEpoch", "reportTimeEpoch", "updatedAtEpoch"});
    if (const auto value = firstInteger(item, {"runwayConditionCode", "rcc"})) {
        if (*value >= 0 && *value <= 6) row.runwayConditionCode = static_cast<int>(*value);
    }
    row.frictionCoefficient = firstNumber(item, {"frictionCoefficient", "friction"});
    if (item.contains("closed")) row.closed = boolValue(item.at("closed"));
    else row.closed = row.state == "CLOSED";
    row.cachedAtEpoch = firstInteger(item, {"cachedAtEpoch"});
    row.expiresAtEpoch = firstInteger(item, {"expiresAtEpoch"});
    return row;
}

AerodromeConditionProviderInfo parseProvider(const json& provider) {
    if (!provider.is_object()) throw std::invalid_argument("aerodrome provider must be an object");
    AerodromeConditionProviderInfo info;
    info.name = firstString(provider, {"name", "providerName"});
    info.license = firstString(provider, {"license", "licenseName", "provenance"});
    info.sourceUrl = firstString(provider, {"sourceUrl", "url"});
    info.generatedAt = firstString(provider, {"generatedAt", "updatedAt"});
    info.generatedAtEpoch = firstInteger(provider, {"generatedAtEpoch", "updatedAtEpoch"}).value_or(0);
    info.defaultTtlSeconds = std::max<long long>(firstInteger(provider, {"defaultTtlSeconds", "ttlSeconds"}).value_or(3600), 1);
    if (info.name.empty()) throw std::invalid_argument("aerodrome provider name is required");
    if (info.license.empty()) throw std::invalid_argument("aerodrome provider license/provenance is required");
    return info;
}
}

AerodromeConditionFeed::AerodromeConditionFeed(AerodromeConditionSnapshot snapshot)
    : snapshot_(std::move(snapshot)) {
    rebuildIndexes();
}

AerodromeConditionFeed AerodromeConditionFeed::fromJson(const std::string& jsonText, long long nowEpoch) {
    return parseNormalized(jsonText, nowEpoch);
}

AerodromeConditionFeed AerodromeConditionFeed::fromFile(const std::filesystem::path& path, long long nowEpoch) {
    std::ifstream input(path, std::ios::binary);
    if (!input) throw std::runtime_error("unable to open aerodrome condition file");
    const std::string text((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
    return fromJson(text, nowEpoch);
}

AerodromeConditionFeed AerodromeConditionFeed::fromAviationWeatherMetarJson(const std::string& jsonText,
                                                                             long long nowEpoch) {
    if (jsonText.empty()) throw std::invalid_argument("empty Aviation Weather METAR payload");
    const auto root = json::parse(jsonText);
    if (!root.is_array()) throw std::invalid_argument("Aviation Weather METAR payload must be a JSON array");

    AerodromeConditionSnapshot snapshot;
    snapshot.provider.name = "NOAA/NWS Aviation Weather Center Data API";
    snapshot.provider.license = "U.S. Government public-domain data unless specifically annotated otherwise";
    snapshot.provider.sourceUrl = "https://aviationweather.gov/api/data/metar";
    snapshot.provider.generatedAtEpoch = nowEpoch > 0 ? nowEpoch : 1;
    snapshot.provider.defaultTtlSeconds = 3600;

    snapshot.weather.reserve(std::min<std::size_t>(root.size(), kMaxWeatherRows));
    for (const auto& item : root) {
        if (snapshot.weather.size() >= kMaxWeatherRows) break;
        try {
            auto row = parseWeather(item);
            if (row.airportIcao.empty()) continue;
            snapshot.weather.push_back(std::move(row));
        } catch (const std::invalid_argument&) {
            continue;
        }
    }

    AerodromeConditionFeed feed(std::move(snapshot));
    feed.normalizeFreshness(nowEpoch);
    feed.rebuildIndexes();
    return feed;
}

const AerodromeConditionSnapshot& AerodromeConditionFeed::snapshot() const noexcept { return snapshot_; }
const AerodromeConditionProviderInfo& AerodromeConditionFeed::provider() const noexcept { return snapshot_.provider; }

const AerodromeWeatherObservation* AerodromeConditionFeed::weatherFor(const std::string& airportIcao) const noexcept {
    const auto it = weatherByIcao_.find(upper(airportIcao));
    if (it == weatherByIcao_.end()) return nullptr;
    return &snapshot_.weather[it->second];
}

std::vector<RunwayConditionObservation> AerodromeConditionFeed::runwaysFor(const std::string& airportIcao) const {
    std::vector<RunwayConditionObservation> rows;
    const auto [first, last] = runwaysByIcao_.equal_range(upper(airportIcao));
    for (auto it = first; it != last; ++it) rows.push_back(snapshot_.runways[it->second]);
    std::sort(rows.begin(), rows.end(), [](const auto& lhs, const auto& rhs) { return lhs.runway < rhs.runway; });
    return rows;
}

std::size_t AerodromeConditionFeed::weatherCount() const noexcept { return snapshot_.weather.size(); }
std::size_t AerodromeConditionFeed::runwayCount() const noexcept { return snapshot_.runways.size(); }
bool AerodromeConditionFeed::empty() const noexcept { return snapshot_.weather.empty() && snapshot_.runways.empty(); }

AerodromeConditionFeed AerodromeConditionFeed::parseNormalized(const std::string& jsonText, long long nowEpoch) {
    if (jsonText.empty()) throw std::invalid_argument("empty aerodrome condition payload");
    const auto root = json::parse(jsonText);
    if (!root.is_object()) throw std::invalid_argument("aerodrome condition payload must be a JSON object");
    if (!root.contains("provider")) throw std::invalid_argument("aerodrome condition payload requires provider provenance");

    AerodromeConditionSnapshot snapshot;
    snapshot.provider = parseProvider(root.at("provider"));
    if (root.contains("weather") && root.at("weather").is_array()) {
        for (const auto& item : root.at("weather")) {
            if (snapshot.weather.size() >= kMaxWeatherRows) break;
            try {
                auto row = parseWeather(item);
                if (row.airportIcao.empty()) continue;
                snapshot.weather.push_back(std::move(row));
            } catch (const std::invalid_argument&) {
            }
        }
    }
    if (root.contains("runways") && root.at("runways").is_array()) {
        for (const auto& item : root.at("runways")) {
            if (snapshot.runways.size() >= kMaxRunwayRows) break;
            try {
                auto row = parseRunway(item);
                if (row.airportIcao.empty() || row.runway.empty()) continue;
                snapshot.runways.push_back(std::move(row));
            } catch (const std::invalid_argument&) {
            }
        }
    }
    if (snapshot.weather.empty() && snapshot.runways.empty()) {
        throw std::invalid_argument("aerodrome condition payload contains no usable rows");
    }

    AerodromeConditionFeed feed(std::move(snapshot));
    feed.normalizeFreshness(nowEpoch);
    feed.rebuildIndexes();
    return feed;
}

void AerodromeConditionFeed::normalizeFreshness(long long nowEpoch) {
    const auto now = effectiveNow(nowEpoch, snapshot_.provider);
    for (auto& row : snapshot_.weather) {
        const auto cached = cachedAt(row.cachedAtEpoch, snapshot_.provider, now);
        const auto expires = expiresAt(row.expiresAtEpoch, snapshot_.provider, cached);
        row.cachedAtEpoch = cached;
        row.expiresAtEpoch = expires;
        row.cacheState = now <= expires ? "FRESH" : "STALE";
    }
    for (auto& row : snapshot_.runways) {
        const auto cached = cachedAt(row.cachedAtEpoch, snapshot_.provider, now);
        const auto expires = expiresAt(row.expiresAtEpoch, snapshot_.provider, cached);
        row.cachedAtEpoch = cached;
        row.expiresAtEpoch = expires;
        row.cacheState = now <= expires ? "FRESH" : "STALE";
    }
}

void AerodromeConditionFeed::rebuildIndexes() {
    weatherByIcao_.clear();
    runwaysByIcao_.clear();
    for (std::size_t i = 0; i < snapshot_.weather.size(); ++i) {
        const auto key = upper(snapshot_.weather[i].airportIcao);
        if (!key.empty()) weatherByIcao_.insert_or_assign(key, i);
    }
    for (std::size_t i = 0; i < snapshot_.runways.size(); ++i) {
        const auto key = upper(snapshot_.runways[i].airportIcao);
        if (!key.empty()) runwaysByIcao_.emplace(key, i);
    }
}

} // namespace nexvary::avionics
