#include "timeline/UnifiedTimeline.hpp"
#include <algorithm>
#include <cstdlib>

namespace nexvary::avionics {
UnifiedTimelineSnapshot UnifiedTimeline::build(const TelemetryRecorder& recorder,const EventLog& log){UnifiedTimelineSnapshot out;out.frames.reserve(recorder.frames().size());for(const auto& frame:recorder.frames()){out.frames.push_back({frame.sequence,frame.simTime});if(frame.simTime>out.simulationDuration)out.simulationDuration=frame.simTime;}const auto events=log.snapshot();if(!events.empty()){const auto base=events.front().timestamp;out.events.reserve(events.size());for(const auto& event:events){out.events.push_back({std::chrono::duration_cast<std::chrono::milliseconds>(event.timestamp-base),event.severity,event.source,event.message});}}return out;}
std::optional<TimelineFramePoint> UnifiedTimeline::nearestFrame(const UnifiedTimelineSnapshot& timeline,std::chrono::milliseconds target){if(timeline.frames.empty())return std::nullopt;const auto it=std::min_element(timeline.frames.begin(),timeline.frames.end(),[target](const auto& a,const auto& b){const auto da=std::llabs((a.simTime-target).count());const auto db=std::llabs((b.simTime-target).count());return da<db;});return *it;}
std::vector<TimelineEventPoint> UnifiedTimeline::eventsBetween(const UnifiedTimelineSnapshot& timeline,std::chrono::milliseconds begin,std::chrono::milliseconds end){if(begin>end)std::swap(begin,end);std::vector<TimelineEventPoint> out;for(const auto& event:timeline.events)if(event.wallOffset>=begin&&event.wallOffset<=end)out.push_back(event);return out;}
} // namespace nexvary::avionics
