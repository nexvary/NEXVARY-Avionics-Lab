#pragma once
#include "core/SensorBus.hpp"
#include "core/SystemHealth.hpp"
#include <cstddef>
#include <map>
#include <string>
#include <string_view>
#include <vector>
namespace nexvary::avionics { enum class TwinState{Unknown,Nominal,Degraded,Fault}; struct TwinSubsystem{std::string id;TwinState state{TwinState::Unknown};std::size_t expectedChannels{0};std::size_t observedChannels{0};std::size_t validChannels{0};std::size_t issueCount{0};double healthPercent{0};};struct DigitalTwinSnapshot{std::vector<TwinSubsystem> subsystems;std::size_t nominalCount{0};std::size_t degradedCount{0};std::size_t faultCount{0};std::size_t unknownCount{0};};class DigitalTwinModel{public:[[nodiscard]]static DigitalTwinSnapshot build(const std::map<std::string,SensorSample>& sensors,const std::vector<HealthIssue>& issues);[[nodiscard]]static DigitalTwinSnapshot build(std::string_view platformId,const std::map<std::string,SensorSample>& sensors,const std::vector<HealthIssue>& issues);};const char* to_string(TwinState state) noexcept;} // namespace nexvary::avionics
