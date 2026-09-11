#pragma once
#include "core/SensorBus.hpp"
#include "diagnostics/DiagnosticTypes.hpp"
#include <cstdint>
#include <map>
#include <string_view>
namespace nexvary::avionics {class PlatformDiagnosticRules{public:static void augment(std::string_view platformId,std::uint64_t tick,const std::map<std::string,SensorSample>& sensors,DiagnosticSummary& summary);};}
