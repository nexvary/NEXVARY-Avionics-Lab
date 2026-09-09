#include "config/RunProfile.hpp"
#include <cassert>
#include <stdexcept>
using namespace nexvary::avionics;
int main(){auto p=RunProfile::parse(R"({"schema":"nexvary-training-profile/v1","scenario":"thermal-rise","ticks":75,"step_ms":200,"report_json":"report.json"})");assert(p.scenario=="thermal-rise");assert(p.ticks==75);assert(p.stepMs==200);assert(p.reportJson=="report.json");bool rejected=false;try{(void)RunProfile::parse(R"({"schema":"nexvary-training-profile/v1","ticks":9999999})");}catch(const std::runtime_error&){rejected=true;}assert(rejected);}
