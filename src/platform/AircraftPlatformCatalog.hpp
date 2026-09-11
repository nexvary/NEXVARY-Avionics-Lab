#pragma once
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace nexvary::avionics {
struct PlatformTwinNode { std::string id; std::string label; std::vector<std::string> channels; };
struct PlatformDiagnosticRule { std::string code; std::string channel; std::string system; std::string category; std::string title; std::string comparison; double threshold{0.0}; std::string severity; };
struct AircraftPlatformProfile {
    std::string id; std::string name; std::string category; std::string propulsion; std::string description;
    std::vector<std::string> systems; std::vector<std::string> channels; std::vector<std::string> diagnosticFamilies; std::vector<std::string> trainingScenarios;
    std::vector<std::string> faultPresetIds; std::vector<PlatformTwinNode> twinTopology; std::vector<PlatformDiagnosticRule> diagnosticRules;
};
class AircraftPlatformCatalog {
public:
    [[nodiscard]] static const std::vector<AircraftPlatformProfile>& profiles();
    [[nodiscard]] static std::optional<AircraftPlatformProfile> find(std::string_view id);
};
} // namespace nexvary::avionics
