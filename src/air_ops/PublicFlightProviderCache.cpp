#include "air_ops/PublicFlightProviderCache.hpp"

#include <algorithm>
#include <fstream>
#include <system_error>
#include <utility>

namespace nexvary::avionics {
namespace {
constexpr std::size_t kMinimumPayloadBytes = 2;
constexpr std::size_t kMaximumStatusChars = 180;
}

PublicFlightProviderCache::PublicFlightProviderCache(std::size_t maxPayloadBytes)
    : maxPayloadBytes_(std::max<std::size_t>(maxPayloadBytes, kMinimumPayloadBytes)) {}

bool PublicFlightProviderCache::refreshFromJson(const std::string& jsonText,
                                                long long nowEpoch) noexcept {
    return acceptPayload(jsonText, nowEpoch, false);
}

bool PublicFlightProviderCache::refreshFromFile(const std::filesystem::path& path,
                                                long long nowEpoch) noexcept {
    std::string payload;
    std::string error;
    if (!readPayload(path, payload, error)) {
        markRefreshFailure(std::move(error));
        return false;
    }
    return acceptPayload(std::move(payload), nowEpoch, false);
}

bool PublicFlightProviderCache::restoreLastGood(const std::filesystem::path& path,
                                                long long nowEpoch) noexcept {
    std::string payload;
    std::string error;
    if (!readPayload(path, payload, error)) {
        markRefreshFailure(std::move(error));
        return false;
    }
    return acceptPayload(std::move(payload), nowEpoch, true);
}

bool PublicFlightProviderCache::persistLastGood(const std::filesystem::path& path) noexcept {
    if (!available() || rawPayload_.empty()) {
        lastError_ = "no valid provider payload is available to persist";
        statusText_ = "UNAVAILABLE / " + lastError_;
        return false;
    }

    try {
        if (path.has_parent_path()) std::filesystem::create_directories(path.parent_path());
        auto temporary = path;
        temporary += ".tmp";

        {
            std::ofstream output(temporary, std::ios::binary | std::ios::trunc);
            if (!output) {
                lastError_ = "unable to open provider cache temporary file";
                statusText_ = "ACTIVE / " + provider().name + " / CACHE WRITE ERROR";
                return false;
            }
            output.write(rawPayload_.data(), static_cast<std::streamsize>(rawPayload_.size()));
            output.flush();
            if (!output) {
                lastError_ = "failed while writing provider cache temporary file";
                statusText_ = "ACTIVE / " + provider().name + " / CACHE WRITE ERROR";
                return false;
            }
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
            if (ec) {
                lastError_ = "unable to replace provider cache file";
                statusText_ = "ACTIVE / " + provider().name + " / CACHE WRITE ERROR";
                return false;
            }
        }

        lastError_.clear();
        statusText_ = (usingFallback_ ? "CACHE FALLBACK / " : "ACTIVE / ") + provider().name +
                      " / " + std::to_string(recordCount()) + " RECORDS / PERSISTED";
        return true;
    } catch (const std::exception& error) {
        lastError_ = cleanStatus(error.what());
        statusText_ = "ACTIVE / " + provider().name + " / CACHE WRITE ERROR";
        return false;
    }
}

void PublicFlightProviderCache::noteRefreshFailure(std::string reason) noexcept {
    markRefreshFailure(std::move(reason));
}

std::size_t PublicFlightProviderCache::apply(PublicFlightSnapshot& snapshot,
                                             long long nowEpoch) const {
    return available() ? cache_.apply(snapshot, nowEpoch) : 0;
}

bool PublicFlightProviderCache::available() const noexcept {
    return !cache_.empty() && !provider().name.empty() && !provider().license.empty();
}

bool PublicFlightProviderCache::usingFallback() const noexcept { return usingFallback_; }
std::size_t PublicFlightProviderCache::recordCount() const noexcept { return cache_.size(); }
std::size_t PublicFlightProviderCache::payloadBytes() const noexcept { return rawPayload_.size(); }
long long PublicFlightProviderCache::lastRefreshEpoch() const noexcept { return lastRefreshEpoch_; }

const AircraftEnrichmentProviderInfo& PublicFlightProviderCache::provider() const noexcept {
    return cache_.provider();
}

const std::string& PublicFlightProviderCache::statusText() const noexcept { return statusText_; }
const std::string& PublicFlightProviderCache::lastError() const noexcept { return lastError_; }

bool PublicFlightProviderCache::acceptPayload(std::string payload,
                                              long long nowEpoch,
                                              bool fallback) noexcept {
    if (payload.size() < kMinimumPayloadBytes) {
        markRefreshFailure("provider payload is empty");
        return false;
    }
    if (payload.size() > maxPayloadBytes_) {
        markRefreshFailure("provider payload exceeds configured cache limit");
        return false;
    }

    try {
        auto candidate = PublicFlightEnrichmentCache::fromJson(payload);
        if (candidate.empty()) {
            markRefreshFailure("provider payload contains no usable records");
            return false;
        }

        cache_ = std::move(candidate);
        rawPayload_ = std::move(payload);
        usingFallback_ = fallback;
        lastRefreshEpoch_ = nowEpoch;
        lastError_.clear();
        statusText_ = (fallback ? "CACHE FALLBACK / " : "ACTIVE / ") + provider().name +
                      " / " + std::to_string(recordCount()) + " RECORDS / " +
                      std::to_string(payloadBytes()) + " BYTES";
        return true;
    } catch (const std::exception& error) {
        markRefreshFailure(error.what());
        return false;
    }
}

bool PublicFlightProviderCache::readPayload(const std::filesystem::path& path,
                                            std::string& payload,
                                            std::string& error) const noexcept {
    try {
        std::error_code ec;
        const auto size = std::filesystem::file_size(path, ec);
        if (ec) {
            error = "unable to inspect provider cache file";
            return false;
        }
        if (size < kMinimumPayloadBytes) {
            error = "provider cache file is empty";
            return false;
        }
        if (size > maxPayloadBytes_) {
            error = "provider cache file exceeds configured cache limit";
            return false;
        }

        std::ifstream input(path, std::ios::binary);
        if (!input) {
            error = "unable to open provider cache file";
            return false;
        }
        payload.assign(std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>());
        if (!input.eof() && input.fail()) {
            error = "failed while reading provider cache file";
            return false;
        }
        if (payload.size() != size) {
            error = "provider cache file changed while being read";
            return false;
        }
        return true;
    } catch (const std::exception& exception) {
        error = cleanStatus(exception.what());
        return false;
    }
}

void PublicFlightProviderCache::markRefreshFailure(std::string reason) noexcept {
    lastError_ = cleanStatus(std::move(reason));
    if (available()) {
        usingFallback_ = true;
        statusText_ = "FALLBACK / LAST GOOD / " + provider().name + " / " + lastError_;
    } else {
        usingFallback_ = false;
        statusText_ = "UNAVAILABLE / " + lastError_;
    }
}

std::string PublicFlightProviderCache::cleanStatus(std::string value) {
    for (auto& ch : value) {
        if (ch == '\r' || ch == '\n' || ch == '\t') ch = ' ';
    }
    while (!value.empty() && value.front() == ' ') value.erase(value.begin());
    while (!value.empty() && value.back() == ' ') value.pop_back();
    if (value.size() > kMaximumStatusChars) value.resize(kMaximumStatusChars);
    return value.empty() ? std::string{"unknown provider cache error"} : value;
}

} // namespace nexvary::avionics
