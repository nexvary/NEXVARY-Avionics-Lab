#pragma once
#include "sim/FaultInjector.hpp"
#include <optional>
#include <string>
#include <string_view>
#include <vector>
namespace nexvary::avionics {
struct TrainingFaultPreset{std::string id;std::string labelKey;std::string detailKey;FaultSpec fault;};
class TrainingFaultCatalog{public:[[nodiscard]]static const std::vector<TrainingFaultPreset>& presets();[[nodiscard]]static std::vector<TrainingFaultPreset> presets(std::string_view platformId);[[nodiscard]]static std::optional<TrainingFaultPreset> find(std::string_view id);[[nodiscard]]static std::optional<TrainingFaultPreset> find(std::string_view platformId,std::string_view id);};
} // namespace nexvary::avionics
