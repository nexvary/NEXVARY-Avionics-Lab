#include "app/AvionicsLab.hpp"
#include "io/SessionArchive.hpp"
#include <cassert>
#include <stdexcept>
using namespace nexvary::avionics;
int main(){AvionicsLab lab{ScenarioKind::PowerTransient};for(int i=0;i<30;++i)lab.step();auto encoded=SessionArchive::serialize("power-transient",lab.recorder(),lab.eventLog());auto decoded=SessionArchive::parse(encoded);assert(decoded.schema==SessionArchive::Schema);assert(decoded.scenario=="power-transient");assert(decoded.frames.size()==lab.recorder().size());assert(!decoded.events.empty());bool rejected=false;try{(void)SessionArchive::parse("{\"schema\":\"bad\",\"frames\":[],\"events\":[]}");}catch(const std::runtime_error&){rejected=true;}assert(rejected);}
