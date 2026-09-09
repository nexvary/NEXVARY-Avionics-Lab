#include "campaign/CampaignRunner.hpp"
#include "app/AvionicsLab.hpp"
#include <chrono>
#include <stdexcept>

namespace nexvary::avionics {
CampaignSummary CampaignRunner::run(const std::vector<CampaignCase>& cases){CampaignSummary summary;for(const auto& c:cases){CampaignResult result;result.name=c.name;if(c.name.empty()||c.ticks<1||c.ticks>100000||c.stepMs<10||c.stepMs>10000||c.minActiveAlerts>c.maxActiveAlerts){result.message="invalid campaign case";++summary.failedCount;summary.results.push_back(std::move(result));continue;}AvionicsLab lab(c.scenario);LabSnapshot snapshot;for(int i=0;i<c.ticks;++i)snapshot=lab.step(std::chrono::milliseconds{c.stepMs});std::size_t active=0;for(const auto& alert:snapshot.alerts)if(alert.active)++active;result.observedActiveAlerts=active;result.finalTick=snapshot.tick;result.passed=active>=c.minActiveAlerts&&active<=c.maxActiveAlerts;result.message=result.passed?"expectation satisfied":"active alert expectation failed";if(result.passed)++summary.passedCount;else ++summary.failedCount;summary.results.push_back(std::move(result));}return summary;}
std::vector<CampaignCase> CampaignRunner::regressionSuite(){return {{"nominal-baseline",ScenarioKind::Nominal,40,100,0,0},{"power-transient-detection",ScenarioKind::PowerTransient,25,100,1,8},{"sensor-dropout-detection",ScenarioKind::SensorDropout,15,100,1,8},{"thermal-rise-detection",ScenarioKind::ThermalRise,35,100,1,8}};}
} // namespace nexvary::avionics
