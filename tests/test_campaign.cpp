#include "campaign/CampaignRunner.hpp"
#include <cassert>
using namespace nexvary::avionics;
int main(){const auto suite=CampaignRunner::regressionSuite();assert(suite.size()==4);const auto summary=CampaignRunner::run(suite);assert(summary.results.size()==4);assert(summary.passed());assert(summary.passedCount==4);const auto invalid=CampaignRunner::run({{"bad",ScenarioKind::Nominal,0,100,0,0}});assert(!invalid.passed());assert(invalid.failedCount==1);return 0;}
