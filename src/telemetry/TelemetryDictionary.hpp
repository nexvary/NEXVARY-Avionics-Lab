#pragma once
#include "core/SensorBus.hpp"
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace nexvary::avionics {

struct ChannelDefinition {
    std::string id;
    std::string labelKey;
    std::string unit;
    double minimum{0.0};
    double maximum{0.0};
    double nominalRateHz{0.0};
    bool required{true};
};

struct ChannelValidation {
    bool known{false};
    bool unitMatches{false};
    bool finite{false};
    bool inEngineeringRange{false};
    [[nodiscard]] bool acceptable() const noexcept { return known && unitMatches && finite && inEngineeringRange; }
};

class TelemetryDictionary {
public:
    [[nodiscard]] static const std::vector<ChannelDefinition>& channels();
    [[nodiscard]] static std::optional<ChannelDefinition> find(std::string_view id);
    [[nodiscard]] static ChannelValidation validate(std::string_view id, const SensorSample& sample);
};

} // namespace nexvary::avionics
