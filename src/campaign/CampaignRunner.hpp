#pragma once
#include "sim/ScenarioEngine.hpp"
#include <cstddef>
#include <cstdint>
#include <string>
#include <vector>

namespace nexvary::avionics {
struct CampaignCase {std::string name;ScenarioKind scenario{ScenarioKind::Nominal};int ticks{40};int stepMs{100};std::size_t minActiveAlerts{0};std::size_t maxActiveAlerts{0};};
struct CampaignResult {std::string name;bool passed{false};std::size_t observedActiveAlerts{0};std::uint64_t finalTick{0};std::string message;};
struct CampaignSummary {std::vector<CampaignResult> results;std::size_t passedCount{0};std::size_t failedCount{0};[[nodiscard]] bool passed() const noexcept{return failedCount==0;}};
class CampaignRunner {public:[[nodiscard]] static CampaignSummary run(const std::vector<CampaignCase>& cases);[[nodiscard]] static std::vector<CampaignCase> regressionSuite();};
} // namespace nexvary::avionics
