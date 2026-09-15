#include "air_ops/AerodromeProviderCache.hpp"

#include <algorithm>
#include <fstream>
#include <stdexcept>
#include <system_error>
#include <utility>

namespace nexvary::avionics {
namespace {
constexpr std::size_t kMinimumPayloadBytes = 2;
constexpr std::size_t kMaximumStatusChars = 180;
}

AerodromeProviderCache::AerodromeProviderCache(AerodromeProviderPayloadKind kind,
                                               std::size_t maxPayloadBytes)
    : kind_(kind),
      maxPayloadBytes_(std::max<std::size_t>(maxPayloadBytes, kMinimumPayloadBytes)) {}

bool AerodromeProviderCache::refreshFromJson(const std::string& jsonText,
                                             long long nowEpoch) noexcept {
    return acceptPayload(jsonText, nowEpoch, false);
}

bool AerodromeProviderCache::refreshFromFile(const std::filesystem::path& path,
                                             long long nowEpoch) noexcept {
    std::string payload;
    std::string error;
    if (!readPayload(path, payload, error)) {
        markRefreshFailure(std::move(error));
        return false;
    }
    return acceptPayload(std::move(payload), nowEpoch, false);
}

bool AerodromeProviderCache::restoreLastGood(const std::filesystem::path& path,
                                             long long nowEpoch) noexcept {
    std::string payload;
    std::string error;
    if (!readPayload(path, payload, error)) {
        markRefreshFailure(std::move(error));
        return false;
    }
    return acceptPayload(std::move(payload), nowEpoch, true);
}

bool AerodromeProviderCache::persistLastGood(const std::filesystem::path& path) noexcept {
    if (!available() || rawPayload_.empty()) {
        lastError_ = "no valid aerodrome provider payload is available to persist";
        statusText_ = modeLabel() + " UNAVAILABLE / " + lastError_;
        return false;
    }

    try {
        if (path.has_parent_path()) std::filesystem::create_directories(path.parent_path());
        auto temporary = path;
        temporary += ".tmp";
        {
            std::ofstream output(temporary, std::ios::binary | std::ios::trunc);
            if (!output) throw std::runtime_error("unable to open aerodrome cache temporary file");
            output.write(rawPayload_.data(), static_cast<std::streamsize>(rawPayload_.size()));
            output.flush();
            if (!output) throw std::runtime_error("failed while writing aerodrome cache temporary file");
        }

        std::error_code ec;
        std::filesystem::remove(path, ec);
        ec.clear();
        std::filesystem::rename(temporary, path, ec);
        if (ec) {
            ec.clear();
            std::filesystem::copy_file(temporary, path,
                                       std::filesystem::copy_options::overwrite_existing, ec);
            std::error_code removeError;
            std::filesystem::remove(temporary, removeError);
            if (ec) throw std::runtime_error("unable to replace aerodrome cache file");
        }

        lastError_.clear();
        statusText_ = modeLabel() + (usingFallback_ ? " CACHE FALLBACK / " : " ACTIVE / ") +
                      provider().name + " / " + std::to_string(recordCount()) +
                      " RECORDS / PERSISTED";
        return true;
    } catch (const std::exception& error) {
        lastError_ = cleanStatus(error.what());
        statusText_ = modeLabel() + " ACTIVE / " + provider().name + " / CACHE WRITE ERROR";
        return false;
    }
}

void AerodromeProviderCache::noteRefreshFailure(std::string reason) noexcept {
    markRefreshFailure(std::move(reason));
}

void AerodromeProviderCache::clear() noexcept {
    feed_ = AerodromeConditionFeed{};
    rawPayload_.clear();
    usingFallback_ = false;
    statusText_ = "NO AERODROME PROVIDER CACHE";
    lastError_.clear();
}

const AerodromeConditionFeed& AerodromeProviderCache::feed() const noexcept { return feed_; }
const AerodromeConditionProviderInfo& AerodromeProviderCache::provider() const noexcept {
    return feed_.provider();
}
AerodromeProviderPayloadKind AerodromeProviderCache::kind() const noexcept { return kind_; }

bool AerodromeProviderCache::available() const noexcept {
    if (feed_.empty() || provider().name.empty() || provider().license.empty()) return false;
    if (kind_ == AerodromeProviderPayloadKind::PublicMetar) return feed_.weatherCount() > 0;
    return true;
}

bool AerodromeProviderCache::usingFallback() const noexcept { return usingFallback_; }
std::size_t AerodromeProviderCache::recordCount() const noexcept {
    return feed_.weatherCount() + feed_.runwayCount();
}
std::size_t AerodromeProviderCache::payloadBytes() const noexcept { return rawPayload_.size(); }
const std::string& AerodromeProviderCache::statusText() const noexcept { return statusText_; }
const std::string& AerodromeProviderCache::lastError() const noexcept { return lastError_; }

bool AerodromeProviderCache::acceptPayload(std::string payload,
                                           long long nowEpoch,
                                           bool fallback) noexcept {
    if (payload.size() < kMinimumPayloadBytes) {
        markRefreshFailure("aerodrome provider payload is empty");
        return false;
    }
    if (payload.size() > maxPayloadBytes_) {
        markRefreshFailure("aerodrome provider payload exceeds configured cache limit");
        return false;
    }

    try {
        auto candidate = kind_ == AerodromeProviderPayloadKind::PublicMetar
            ? AerodromeConditionFeed::fromAviationWeatherMetarJson(payload, nowEpoch)
            : AerodromeConditionFeed::fromJson(payload, nowEpoch);
        if (candidate.empty()) {
            markRefreshFailure("aerodrome provider payload contains no usable records");
            return false;
        }
        if (kind_ == AerodromeProviderPayloadKind::PublicMetar && candidate.weatherCount() == 0) {
            markRefreshFailure("public METAR payload contains no usable weather records");
            return false;
        }

        feed_ = std::move(candidate);
        rawPayload_ = std::move(payload);
        usingFallback_ = fallback;
        lastError_.clear();
        statusText_ = modeLabel() + (fallback ? " CACHE FALLBACK / " : " ACTIVE / ") +
                      provider().name + " / " + std::to_string(recordCount()) +
                      " RECORDS / " + std::to_string(payloadBytes()) + " BYTES";
        return true;
    } catch (const std::exception& error) {
        markRefreshFailure(error.what());
        return false;
    }
}

bool AerodromeProviderCache::readPayload(const std::filesystem::path& path,
                                         std::string& payload,
                                         std::string& error) const noexcept {
    try {
        std::error_code ec;
        const auto size = std::filesystem::file_size(path, ec);
        if (ec) {
            error = "unable to inspect aerodrome cache file";
            return false;
        }
        if (size < kMinimumPayloadBytes) {
            error = "aerodrome cache file is empty";
            return false;
        }
        if (size > maxPayloadBytes_) {
            error = "aerodrome cache file exceeds configured cache limit";
            return false;
        }
        std::ifstream input(path, std::ios::binary);
        if (!input) {
            error = "unable to open aerodrome cache file";
            return false;
        }
        payload.assign(std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>());
        if (!input.eof() && input.fail()) {
            error = "failed while reading aerodrome cache file";
            return false;
        }
        if (payload.size() != size) {
            error = "aerodrome cache file changed while being read";
            return false;
        }
        return true;
    } catch (const std::exception& exception) {
        error = cleanStatus(exception.what());
        return false;
    }
}

void AerodromeProviderCache::markRefreshFailure(std::string reason) noexcept {
    lastError_ = cleanStatus(std::move(reason));
    if (available()) {
        usingFallback_ = true;
        statusText_ = modeLabel() + " FALLBACK / LAST GOOD / " + provider().name + " / " + lastError_;
    } else {
        usingFallback_ = false;
        statusText_ = modeLabel() + " UNAVAILABLE / " + lastError_;
    }
}

std::string AerodromeProviderCache::modeLabel() const {
    return kind_ == AerodromeProviderPayloadKind::PublicMetar
        ? std::string{"PUBLIC METAR"}
        : std::string{"LICENSED CONDITIONS"};
}

std::string AerodromeProviderCache::cleanStatus(std::string value) {
    for (auto& ch : value) {
        if (ch == '\r' || ch == '\n' || ch == '\t') ch = ' ';
    }
    while (!value.empty() && value.front() == ' ') value.erase(value.begin());
    while (!value.empty() && value.back() == ' ') value.pop_back();
    if (value.size() > kMaximumStatusChars) value.resize(kMaximumStatusChars);
    return value.empty() ? std::string{"unknown aerodrome provider error"} : value;
}

} // namespace nexvary::avionics
