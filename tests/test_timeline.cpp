#include "timeline/UnifiedTimeline.hpp"
#include "app/AvionicsLab.hpp"
#include <cassert>
using namespace nexvary::avionics;
int main(){AvionicsLab lab;for(int i=0;i<10;++i)lab.step(std::chrono::milliseconds{100});const auto timeline=UnifiedTimeline::build(lab.recorder(),lab.eventLog());assert(timeline.frames.size()==10);assert(!timeline.events.empty());assert(timeline.simulationDuration==std::chrono::milliseconds{1000});const auto near=UnifiedTimeline::nearestFrame(timeline,std::chrono::milliseconds{455});assert(near.has_value());assert(near->simTime==std::chrono::milliseconds{500});const auto events=UnifiedTimeline::eventsBetween(timeline,std::chrono::milliseconds{0},std::chrono::milliseconds{1000});assert(!events.empty());return 0;}
