#include "app/AvionicsLab.hpp"
#include "twin/DigitalTwin.hpp"
#include <cassert>
#include <string>
using namespace nexvary::avionics;namespace{TwinSubsystem find(const DigitalTwinSnapshot&s,const std::string&id){for(const auto&x:s.subsystems)if(x.id==id)return x;assert(false);return{};}}
int main(){AvionicsLab lab;for(int i=0;i<20;++i)lab.step();auto snap=lab.snapshot();auto jet=DigitalTwinModel::build("generic-jet",snap.sensors,snap.issues);assert(jet.subsystems.size()==6);assert(find(jet,"propulsion").state==TwinState::Nominal);auto uav=DigitalTwinModel::build("generic-uav",snap.sensors,snap.issues);assert(uav.subsystems.size()==6);assert(find(uav,"datalink").state==TwinState::Nominal);assert(find(uav,"navigation").state==TwinState::Nominal);AvionicsLab dropout{ScenarioKind::SensorDropout};for(int i=0;i<15;++i)dropout.step();snap=dropout.snapshot();auto heli=DigitalTwinModel::build("generic-helicopter",snap.sensors,snap.issues);assert(find(heli,"flight_sensors").state==TwinState::Fault);return 0;}
