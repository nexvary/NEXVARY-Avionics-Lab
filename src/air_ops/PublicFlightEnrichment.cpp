#include "air_ops/PublicFlightEnrichment.hpp"

#include <algorithm>
#include <cctype>
#include <fstream>
#include <nlohmann/json.hpp>
#include <stdexcept>
#include <utility>

namespace nexvary::avionics {
namespace {
using json = nlohmann::json;
constexpr std::size_t kMaxEnrichmentRecords = 100000;
constexpr int kMinRetentionMinutes = 1;
constexpr int kMaxRetentionMinutes = 24 * 60;

std::string trim(const std::string& value) {
    const auto first = value.find_first_not_of(" \t\r\n");
    if (first == std::string::npos) return {};
    const auto last = value.find_last_not_of(" \t\r\n");
    return value.substr(first, last - first + 1);
}

std::string lower(std::string value) {
    std::transform(value.begin(), value.end(), value.begin(), [](unsigned char ch) {
        return static_cast<char>(std::tolower(ch));
    });
    return value;
}

std::string upper(std::string value) {
    std::transform(value.begin(), value.end(), value.begin(), [](unsigned char ch) {
        return static_cast<char>(std::toupper(ch));
    });
    return value;
}

std::string normalizeIcao(const std::string& value) { return lower(trim(value)); }
std::string normalizeCallsign(const std::string& value) { return upper(trim(value)); }

std::string stringOr(const json& value) {
    return value.is_string() ? trim(value.get<std::string>()) : std::string{};
}

std::string firstString(const json& item, std::initializer_list<const char*> keys) {
    for (const auto* key : keys) {
        if (!item.contains(key)) continue;
        const auto value = stringOr(item.at(key));
        if (!value.empty()) return value;
    }
    return {};
}

std::optional<long long> optionalInteger(const json& value) {
    if (value.is_number_integer()) return value.get<long long>();
    return std::nullopt;
}

std::optional<double> optionalNumber(const json& value) {
    if (value.is_number()) return value.get<double>();
    return std::nullopt;
}

void copyIfPresent(std::string& target, const std::string& source) {
    if (!source.empty()) target = source;
}

bool validCoordinate(double latitude, double longitude) {
    return latitude >= -90.0 && latitude <= 90.0 && longitude >= -180.0 && longitude <= 180.0;
}

long long effectiveCachedAt(const AircraftEnrichmentRecord& record,
                            const AircraftEnrichmentProviderInfo& provider,
                            long long nowEpoch) {
    if (record.cachedAtEpoch) return *record.cachedAtEpoch;
    if (provider.generatedAtEpoch > 0) return provider.generatedAtEpoch;
    return nowEpoch;
}

long long effectiveExpiresAt(const AircraftEnrichmentRecord& record,
                             const AircraftEnrichmentProviderInfo& provider,
                             long long cachedAt) {
    if (record.expiresAtEpoch) return *record.expiresAtEpoch;
    const auto ttl = std::max<long long>(provider.defaultTtlSeconds, 1);
    return cachedAt + ttl;
}

bool hasMetadata(const AircraftEnrichmentRecord& record) {
    return !record.registration.empty() || !record.aircraftTypeCode.empty() ||
           !record.aircraftModel.empty() || !record.manufacturer.empty() ||
           !record.serialNumber.empty() || !record.operatorName.empty() ||
           !record.marketingOperator.empty() || !record.operatorIcao.empty() ||
           !record.operatorIata.empty() || !record.registrationCountry.empty() ||
           !record.registrationStatus.empty() || !record.aircraftFamily.empty() ||
           !record.variant.empty() || !record.engineType.empty() || !record.yearBuilt.empty();
}

bool hasRoute(const AircraftEnrichmentRecord& record) {
    return !record.flightNumber.empty() || !record.originAirportIcao.empty() ||
           !record.originAirportIata.empty() || !record.destinationAirportIcao.empty() ||
           !record.destinationAirportIata.empty() || !record.route.empty() ||
           !record.scheduledDeparture.empty() || !record.estimatedArrival.empty();
}

AircraftEnrichmentRecord parseRecord(const json& item) {
    if (!item.is_object()) throw std::invalid_argument("invalid aircraft enrichment record");

    AircraftEnrichmentRecord record;
    record.icao24 = firstString(item, {"icao24", "icaoHex", "hex"});
    record.callsign = firstString(item, {"callsign", "callSign"});
    record.registration = firstString(item, {"registration", "tailNumber"});
    record.aircraftTypeCode = firstString(item, {"aircraftTypeCode", "typeCode", "icaoAircraftType"});
    record.aircraftModel = firstString(item, {"aircraftModel", "model"});
    record.manufacturer = firstString(item, {"manufacturer", "manufacturerName"});
    record.serialNumber = firstString(item, {"serialNumber", "msn"});
    record.operatorName = firstString(item, {"operatorName", "operator"});
    record.marketingOperator = firstString(item, {"marketingOperator", "marketingAirline"});
    record.operatorIcao = firstString(item, {"operatorIcao", "airlineIcao"});
    record.operatorIata = firstString(item, {"operatorIata", "airlineIata"});
    record.registrationCountry = firstString(item, {"registrationCountry", "countryOfRegistration"});
    record.registrationStatus = firstString(item, {"registrationStatus", "status"});
    record.aircraftFamily = firstString(item, {"aircraftFamily", "family"});
    record.variant = firstString(item, {"variant", "aircraftVariant"});
    record.engineType = firstString(item, {"engineType", "engine"});
    record.yearBuilt = firstString(item, {"yearBuilt", "built"});
    record.flightNumber = firstString(item, {"flightNumber", "flight", "flightIata"});
    record.originAirportIcao = firstString(item, {"originAirportIcao", "originIcao"});
    record.originAirportIata = firstString(item, {"originAirportIata", "originIata"});
    record.destinationAirportIcao = firstString(item, {"destinationAirportIcao", "destinationIcao"});
    record.destinationAirportIata = firstString(item, {"destinationAirportIata", "destinationIata"});
    record.route = firstString(item, {"route", "routeLabel"});
    record.scheduledDeparture = firstString(item, {"scheduledDeparture", "departureTime"});
    record.estimatedArrival = firstString(item, {"estimatedArrival", "arrivalTime"});
    if (item.contains("cachedAtEpoch")) record.cachedAtEpoch = optionalInteger(item.at("cachedAtEpoch"));
    if (item.contains("expiresAtEpoch")) record.expiresAtEpoch = optionalInteger(item.at("expiresAtEpoch"));
    return record;
}
}

PublicFlightEnrichmentCache PublicFlightEnrichmentCache::fromJson(const std::string& jsonText) {
    return parse(jsonText);
}

PublicFlightEnrichmentCache PublicFlightEnrichmentCache::fromFile(const std::filesystem::path& path) {
    std::ifstream input(path, std::ios::binary);
    if (!input) throw std::runtime_error("unable to open aircraft enrichment file");
    const std::string text((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
    return fromJson(text);
}

const AircraftEnrichmentProviderInfo& PublicFlightEnrichmentCache::provider() const noexcept {
    return provider_;
}

std::size_t PublicFlightEnrichmentCache::size() const noexcept { return records_.size(); }
bool PublicFlightEnrichmentCache::empty() const noexcept { return records_.empty(); }

std::size_t PublicFlightEnrichmentCache::apply(PublicFlightSnapshot& snapshot, long long nowEpoch) const {
    std::size_t applied = 0;
    for (auto& track : snapshot.tracks) {
        const AircraftEnrichmentRecord* record = nullptr;
        const auto icao = normalizeIcao(track.icao24);
        if (!icao.empty()) {
            const auto it = byIcao24_.find(icao);
            if (it != byIcao24_.end()) record = &records_.at(it->second);
        }
        if (!record) {
            const auto callsign = normalizeCallsign(track.callsign);
            if (!callsign.empty()) {
                const auto it = byCallsign_.find(callsign);
                if (it != byCallsign_.end()) record = &records_.at(it->second);
            }
        }
        if (!record) continue;

        const bool metadata = hasMetadata(*record);
        const bool route = hasRoute(*record);
        if (!metadata && !route) continue;

        copyIfPresent(track.registration, record->registration);
        copyIfPresent(track.aircraftTypeCode, record->aircraftTypeCode);
        copyIfPresent(track.aircraftModel, record->aircraftModel);
        copyIfPresent(track.manufacturer, record->manufacturer);
        copyIfPresent(track.serialNumber, record->serialNumber);
        copyIfPresent(track.operatorName, record->operatorName);
        copyIfPresent(track.marketingOperator, record->marketingOperator);
        copyIfPresent(track.operatorIcao, record->operatorIcao);
        copyIfPresent(track.operatorIata, record->operatorIata);
        copyIfPresent(track.registrationCountry, record->registrationCountry);
        copyIfPresent(track.registrationStatus, record->registrationStatus);
        copyIfPresent(track.aircraftFamily, record->aircraftFamily);
        copyIfPresent(track.variant, record->variant);
        copyIfPresent(track.engineType, record->engineType);
        copyIfPresent(track.yearBuilt, record->yearBuilt);
        copyIfPresent(track.flightNumber, record->flightNumber);
        copyIfPresent(track.originAirportIcao, record->originAirportIcao);
        copyIfPresent(track.originAirportIata, record->originAirportIata);
        copyIfPresent(track.destinationAirportIcao, record->destinationAirportIcao);
        copyIfPresent(track.destinationAirportIata, record->destinationAirportIata);
        copyIfPresent(track.route, record->route);
        copyIfPresent(track.scheduledDeparture, record->scheduledDeparture);
        copyIfPresent(track.estimatedArrival, record->estimatedArrival);

        const auto cachedAt = effectiveCachedAt(*record, provider_, nowEpoch);
        const auto expiresAt = effectiveExpiresAt(*record, provider_, cachedAt);
        track.enrichmentCachedAtEpoch = cachedAt;
        track.enrichmentExpiresAtEpoch = expiresAt;
        track.enrichmentCacheState = nowEpoch <= expiresAt ? "FRESH" : "STALE";
        if (metadata) {
            track.metadataSource = provider_.name;
            track.metadataLicense = provider_.license;
            track.metadataSourceUrl = provider_.sourceUrl;
        }
        if (route) {
            track.routeSource = provider_.name;
            track.routeLicense = provider_.license;
            track.routeSourceUrl = provider_.sourceUrl;
        }
        ++applied;
    }
    return applied;
}

PublicFlightEnrichmentCache PublicFlightEnrichmentCache::parse(const std::string& jsonText) {
    if (jsonText.empty()) throw std::invalid_argument("empty aircraft enrichment payload");
    const auto root = json::parse(jsonText);
    if (!root.is_object()) throw std::invalid_argument("aircraft enrichment payload must be a JSON object");
    if (!root.contains("provider") || !root.at("provider").is_object()) {
        throw std::invalid_argument("aircraft enrichment payload requires provider provenance");
    }

    PublicFlightEnrichmentCache cache;
    const auto& provider = root.at("provider");
    cache.provider_.name = firstString(provider, {"name", "providerName"});
    cache.provider_.license = firstString(provider, {"license", "licenseId", "licenseName"});
    cache.provider_.sourceUrl = firstString(provider, {"sourceUrl", "url"});
    cache.provider_.generatedAt = firstString(provider, {"generatedAt", "updatedAt"});
    if (provider.contains("generatedAtEpoch")) {
        cache.provider_.generatedAtEpoch = optionalInteger(provider.at("generatedAtEpoch")).value_or(0);
    }
    if (provider.contains("defaultTtlSeconds")) {
        cache.provider_.defaultTtlSeconds = std::max<long long>(
            optionalInteger(provider.at("defaultTtlSeconds")).value_or(86400), 1);
    }
    if (cache.provider_.name.empty()) {
        throw std::invalid_argument("aircraft enrichment provider name is required");
    }
    if (cache.provider_.license.empty()) {
        throw std::invalid_argument("aircraft enrichment provider license/provenance is required");
    }

    const json* records = nullptr;
    if (root.contains("records") && root.at("records").is_array()) records = &root.at("records");
    else if (root.contains("tracks") && root.at("tracks").is_array()) records = &root.at("tracks");
    if (!records) throw std::invalid_argument("aircraft enrichment payload requires records array");

    cache.records_.reserve(std::min<std::size_t>(records->size(), kMaxEnrichmentRecords));
    for (const auto& item : *records) {
        if (cache.records_.size() >= kMaxEnrichmentRecords) break;
        try {
            auto record = parseRecord(item);
            if (normalizeIcao(record.icao24).empty() && normalizeCallsign(record.callsign).empty()) continue;
            cache.records_.push_back(std::move(record));
        } catch (const std::invalid_argument&) {
            continue;
        }
    }
    cache.rebuildIndexes();
    return cache;
}

void PublicFlightEnrichmentCache::rebuildIndexes() {
    byIcao24_.clear();
    byCallsign_.clear();
    for (std::size_t i = 0; i < records_.size(); ++i) {
        const auto icao = normalizeIcao(records_[i].icao24);
        const auto callsign = normalizeCallsign(records_[i].callsign);
        if (!icao.empty() && !byIcao24_.contains(icao)) byIcao24_.emplace(icao, i);
        if (!callsign.empty() && !byCallsign_.contains(callsign)) byCallsign_.emplace(callsign, i);
    }
}

PublicFlightHistoryStore::PublicFlightHistoryStore(int retentionMinutes)
    : retentionMinutes_(std::clamp(retentionMinutes, kMinRetentionMinutes, kMaxRetentionMinutes)) {}

PublicFlightHistoryStore PublicFlightHistoryStore::fromJson(const std::string& jsonText) {
    if (jsonText.empty()) throw std::invalid_argument("empty public flight history payload");
    const auto root = json::parse(jsonText);
    if (!root.is_object()) throw std::invalid_argument("public flight history must be a JSON object");
    const int retention = root.value("retentionMinutes", 60);
    PublicFlightHistoryStore store(retention);
    if (!root.contains("tracks") || !root.at("tracks").is_array()) return store;

    for (const auto& track : root.at("tracks")) {
        if (!track.is_object()) continue;
        const auto icao = normalizeIcao(firstString(track, {"icao24"}));
        if (icao.empty() || !track.contains("points") || !track.at("points").is_array()) continue;
        auto& output = store.points_[icao];
        for (const auto& item : track.at("points")) {
            if (!item.is_object()) continue;
            const auto observed = item.contains("observedEpoch") ? optionalInteger(item.at("observedEpoch")) : std::nullopt;
            const auto latitude = item.contains("latitude") ? optionalNumber(item.at("latitude")) : std::nullopt;
            const auto longitude = item.contains("longitude") ? optionalNumber(item.at("longitude")) : std::nullopt;
            if (!observed || !latitude || !longitude || !validCoordinate(*latitude, *longitude)) continue;
            PublicFlightHistoryPoint point;
            point.observedEpoch = *observed;
            point.latitude = *latitude;
            point.longitude = *longitude;
            if (item.contains("altitudeMeters")) point.altitudeMeters = optionalNumber(item.at("altitudeMeters"));
            if (item.contains("velocityMetersPerSecond")) point.velocityMetersPerSecond = optionalNumber(item.at("velocityMetersPerSecond"));
            if (item.contains("headingDegrees")) point.headingDegrees = optionalNumber(item.at("headingDegrees"));
            point.telemetrySource = firstString(item, {"telemetrySource", "source"});
            output.push_back(std::move(point));
        }
        std::sort(output.begin(), output.end(), [](const auto& lhs, const auto& rhs) {
            return lhs.observedEpoch < rhs.observedEpoch;
        });
    }
    return store;
}

PublicFlightHistoryStore PublicFlightHistoryStore::fromFile(const std::filesystem::path& path) {
    std::ifstream input(path, std::ios::binary);
    if (!input) throw std::runtime_error("unable to open public flight history file");
    const std::string text((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
    return fromJson(text);
}

void PublicFlightHistoryStore::record(const PublicFlightSnapshot& snapshot, long long observedEpoch) {
    for (const auto& track : snapshot.tracks) {
        const auto icao = normalizeIcao(track.icao24);
        if (icao.empty() || !validCoordinate(track.latitude, track.longitude)) continue;
        PublicFlightHistoryPoint point;
        point.observedEpoch = track.lastContactEpoch.value_or(observedEpoch);
        if (point.observedEpoch <= 0) point.observedEpoch = observedEpoch;
        point.latitude = track.latitude;
        point.longitude = track.longitude;
        point.altitudeMeters = track.altitudeMeters;
        point.velocityMetersPerSecond = track.velocityMetersPerSecond;
        point.headingDegrees = track.headingDegrees;
        point.telemetrySource = track.telemetrySource;

        auto& output = points_[icao];
        const auto existing = std::find_if(output.begin(), output.end(), [&](const auto& candidate) {
            return candidate.observedEpoch == point.observedEpoch;
        });
        if (existing != output.end()) *existing = std::move(point);
        else output.push_back(std::move(point));
        std::sort(output.begin(), output.end(), [](const auto& lhs, const auto& rhs) {
            return lhs.observedEpoch < rhs.observedEpoch;
        });
    }
    prune(observedEpoch);
}

std::vector<PublicFlightHistoryPoint> PublicFlightHistoryStore::window(const std::string& icao24,
                                                                        int minutes,
                                                                        long long nowEpoch) const {
    const auto key = normalizeIcao(icao24);
    const auto it = points_.find(key);
    if (it == points_.end()) return {};
    const int bounded = std::clamp(minutes, kMinRetentionMinutes, retentionMinutes_);
    const long long threshold = nowEpoch - static_cast<long long>(bounded) * 60;
    std::vector<PublicFlightHistoryPoint> result;
    for (const auto& point : it->second) {
        if (point.observedEpoch >= threshold && point.observedEpoch <= nowEpoch) result.push_back(point);
    }
    return result;
}

std::size_t PublicFlightHistoryStore::pointCount(const std::string& icao24) const noexcept {
    const auto it = points_.find(normalizeIcao(icao24));
    return it == points_.end() ? 0 : it->second.size();
}

std::size_t PublicFlightHistoryStore::totalPointCount() const noexcept {
    std::size_t total = 0;
    for (const auto& [key, points] : points_) {
        static_cast<void>(key);
        total += points.size();
    }
    return total;
}

int PublicFlightHistoryStore::retentionMinutes() const noexcept { return retentionMinutes_; }

std::string PublicFlightHistoryStore::toJson() const {
    json root;
    root["version"] = 1;
    root["retentionMinutes"] = retentionMinutes_;
    root["tracks"] = json::array();

    std::vector<std::string> keys;
    keys.reserve(points_.size());
    for (const auto& [key, points] : points_) {
        static_cast<void>(points);
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());

    for (const auto& key : keys) {
        json track;
        track["icao24"] = key;
        track["points"] = json::array();
        for (const auto& point : points_.at(key)) {
            json item;
            item["observedEpoch"] = point.observedEpoch;
            item["latitude"] = point.latitude;
            item["longitude"] = point.longitude;
            if (point.altitudeMeters) item["altitudeMeters"] = *point.altitudeMeters;
            if (point.velocityMetersPerSecond) item["velocityMetersPerSecond"] = *point.velocityMetersPerSecond;
            if (point.headingDegrees) item["headingDegrees"] = *point.headingDegrees;
            if (!point.telemetrySource.empty()) item["telemetrySource"] = point.telemetrySource;
            track["points"].push_back(std::move(item));
        }
        root["tracks"].push_back(std::move(track));
    }
    return root.dump(2);
}

void PublicFlightHistoryStore::save(const std::filesystem::path& path) const {
    if (path.has_parent_path()) std::filesystem::create_directories(path.parent_path());
    std::ofstream output(path, std::ios::binary | std::ios::trunc);
    if (!output) throw std::runtime_error("unable to write public flight history file");
    output << toJson();
    if (!output) throw std::runtime_error("failed while writing public flight history file");
}

void PublicFlightHistoryStore::prune(long long nowEpoch) {
    const long long threshold = nowEpoch - static_cast<long long>(retentionMinutes_) * 60;
    for (auto it = points_.begin(); it != points_.end();) {
        auto& points = it->second;
        points.erase(std::remove_if(points.begin(), points.end(), [&](const auto& point) {
            return point.observedEpoch < threshold;
        }), points.end());
        if (points.empty()) it = points_.erase(it);
        else ++it;
    }
}

} // namespace nexvary::avionics
