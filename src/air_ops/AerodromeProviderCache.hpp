#pragma once

#include "air_ops/AerodromeConditions.hpp"

#include <cstddef>
#include <filesystem>
#include <string>

namespace nexvary::avionics {

enum class AerodromeProviderPayloadKind {
    PublicMetar,
    LicensedConditions
};

// Transactional last-known-good cache for existing aerodrome provider paths.
// Public METAR and licensed condition payloads use separate cache instances and
// are never merged at the persistence layer.
class AerodromeProviderCache final {
public:
    explicit AerodromeProviderCache(AerodromeProviderPayloadKind kind,
                                    std::size_t maxPayloadBytes = 2u * 1024u * 1024u);

    bool refreshFromJson(const std::string& jsonText, long long nowEpoch) noexcept;
    bool refreshFromFile(const std::filesystem::path& path, long long nowEpoch) noexcept;
    bool restoreLastGood(const std::filesystem::path& path, long long nowEpoch) noexcept;
    bool persistLastGood(const std::filesystem::path& path) noexcept;
    void noteRefreshFailure(std::string reason) noexcept;
    void clear() noexcept;

    const AerodromeConditionFeed& feed() const noexcept;
    const AerodromeConditionProviderInfo& provider() const noexcept;
    AerodromeProviderPayloadKind kind() const noexcept;
    bool available() const noexcept;
    bool usingFallback() const noexcept;
    std::size_t recordCount() const noexcept;
    std::size_t payloadBytes() const noexcept;
    const std::string& statusText() const noexcept;
    const std::string& lastError() const noexcept;

private:
    bool acceptPayload(std::string payload, long long nowEpoch, bool fallback) noexcept;
    bool readPayload(const std::filesystem::path& path,
                     std::string& payload,
                     std::string& error) const noexcept;
    void markRefreshFailure(std::string reason) noexcept;
    std::string modeLabel() const;
    static std::string cleanStatus(std::string value);

    AerodromeProviderPayloadKind kind_;
    AerodromeConditionFeed feed_;
    std::string rawPayload_;
    std::size_t maxPayloadBytes_{0};
    bool usingFallback_{false};
    std::string statusText_{"NO AERODROME PROVIDER CACHE"};
    std::string lastError_;
};

} // namespace nexvary::avionics
