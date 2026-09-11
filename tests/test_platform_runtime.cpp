#include "app/AvionicsLab.hpp"
#include "diagnostics/DiagnosticEngine.hpp"
#include "diagnostics/PlatformDiagnosticRules.hpp"
#include "platform/AircraftPlatformCatalog.hpp"
#include "sim/TrainingFaultCatalog.hpp"
#include "telemetry/TelemetryDictionary.hpp"
#include "twin/DigitalTwin.hpp"
#include <cassert>
#include <set>
#include <string>
using namespace nexvary::avionics;
namespace {bool hasNode(const DigitalTwinSnapshot& t,const std::string& id){for(const auto& n:t.subsystems)if(n.id==id)return true;return false;} }
int main(){
 const auto jet=TelemetryDictionary::channels("generic-jet");const auto turb=TelemetryDictionary::channels("generic-turboprop");const auto heli=TelemetryDictionary::channels("generic-helicopter");const auto uav=TelemetryDictionary::channels("generic-uav");assert(jet.size()==9&&turb.size()==9&&heli.size()==9&&uav.size()==9);assert(TelemetryDictionary::find("generic-jet","jet_engine_core_pct"));assert(!TelemetryDictionary::find("generic-uav","jet_engine_core_pct"));assert(TelemetryDictionary::find("generic-uav","link_quality_pct"));
 assert(TrainingFaultCatalog::presets("generic-jet").size()==5);assert(TrainingFaultCatalog::presets("generic-uav").size()==6);assert(!TrainingFaultCatalog::find("generic-jet","uav-link-degrade"));
 AvionicsLab lab;for(int i=0;i<5;++i)lab.step();auto snap=lab.snapshot();auto twin=DigitalTwinModel::build("generic-uav",snap.sensors,snap.issues);assert(hasNode(twin,"datalink")&&hasNode(twin,"energy")&&!hasNode(twin,"hydraulics"));
 lab.reset();assert(lab.applyTrainingFault("generic-uav","uav-link-degrade"));snap=lab.step();auto summary=DiagnosticEngine::analyze("NOMINAL",snap.tick,snap.sensors,snap.issues,lab.recorder(),lab.eventLog());PlatformDiagnosticRules::augment("generic-uav",snap.tick,snap.sensors,summary);assert(DiagnosticEngine::containsCode(summary,"NXP-UAV-702"));assert(summary.faultCount>0);
 lab.reset();assert(lab.applyTrainingFault("generic-helicopter","rotor-rpm-low"));snap=lab.step();summary=DiagnosticEngine::analyze("NOMINAL",snap.tick,snap.sensors,snap.issues,lab.recorder(),lab.eventLog());PlatformDiagnosticRules::augment("generic-helicopter",snap.tick,snap.sensors,summary);assert(DiagnosticEngine::containsCode(summary,"NXP-HEL-701"));
 return 0;
}
