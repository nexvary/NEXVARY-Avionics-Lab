#pragma once
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace nexvary::avionics {

struct AircraftPlatformProfile {
    std::string id;
    std::string name;
    std::string category;
    std::string propulsion;
    std::string description;
    std::vector<std::string> systems;
    std::vector<std::string> channels;
    std::vector<std::string> diagnosticFamilies;
    std::vector<std::string> trainingScenarios;
};

class AircraftPlatformCatalog {
public:
    [[nodiscard]] static const std::vector<AircraftPlatformProfile>& profiles();
    [[nodiscard]] static std::optional<AircraftPlatformProfile> find(std::string_view id);
};

} // namespace nexvary::avionics
