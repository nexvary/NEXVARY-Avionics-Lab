#include "app/AvionicsLab.hpp"
#include "report/LabReport.hpp"
#include <cassert>
#include <string>
using namespace nexvary::avionics;
int main(){AvionicsLab nominal{ScenarioKind::Nominal};for(int i=0;i<40;++i)nominal.step();auto r=LabReport::analyze("nominal",nominal.recorder(),nominal.eventLog());assert(r.frameCount==40);assert(r.sensorSampleCount>r.frameCount);assert(r.sequenceMonotonic&&r.timeMonotonic);assert(!r.sensors.empty());auto json=LabReport::toJson(r);auto md=LabReport::toMarkdown(r);assert(json.find("nexvary-avionics-verification/v1")!=std::string::npos);assert(md.find("Sequence monotonic: PASS")!=std::string::npos);AvionicsLab dropout{ScenarioKind::SensorDropout};for(int i=0;i<50;++i)dropout.step();auto d=LabReport::analyze("sensor-dropout",dropout.recorder(),dropout.eventLog());assert(d.invalidSampleCount>0);}
