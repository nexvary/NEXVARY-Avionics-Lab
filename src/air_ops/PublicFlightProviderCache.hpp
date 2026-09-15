#pragma once

#include "air_ops/PublicFlightEnrichment.hpp"

#include <cstddef>
#include <filesystem>
#include <string>

namespace nexvary::avionics {

// Transactional last-known-good cache for read-only aircraft metadata/route
// providers. A failed refresh never replaces the active provider snapshot.
class PublicFlightProviderCache final {
public:
    explicit PublicFlightProviderCache(std::size_t maxPayloadBytes = 4u * 1024u * 1024u);

    bool refreshFromJson(const std::string& jsonText, long long nowEpoch) noexcept;
    bool refreshFromFile(const std::filesystem::path& path, long long nowEpoch) noexcept;
    bool restoreLastGood(const std::filesystem::path& path, long long nowEpoch) noexcept;
    bool persistLastGood(const std::filesystem::path& path) noexcept;

    std::size_t apply(PublicFlightSnapshot& snapshot, long long nowEpoch) const;

    bool available() const noexcept;
    bool usingFallback() const noexcept;
    std::size_t recordCount() const noexcept;
    std::size_t payloadBytes() const noexcept;
    long long lastRefreshEpoch() const noexcept;
    const AircraftEnrichmentProviderInfo& provider() const noexcept;
    const std::string& statusText() const noexcept;
    const std::string& lastError() const noexcept;

private:
    bool acceptPayload(std::string payload, long long nowEpoch, bool fallback) noexcept;
    bool readPayload(const std::filesystem::path& path,
                     std::string& payload,
                     std::string& error) const noexcept;
    void markRefreshFailure(std::string reason) noexcept;
    static std::string cleanStatus(std::string value);

    PublicFlightEnrichmentCache cache_;
    std::string rawPayload_;
    std::size_t maxPayloadBytes_{0};
    bool usingFallback_{false};
    long long lastRefreshEpoch_{0};
    std::string statusText_{"NO PROVIDER CACHE"};
    std::string lastError_;
};

} // namespace nexvary::avionics
