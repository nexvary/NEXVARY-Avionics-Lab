#pragma once
#include "core/EventLog.hpp"
#include "core/TelemetryRecorder.hpp"
#include <string>
#include <string_view>
#include <vector>
namespace nexvary::avionics {
struct SessionDocument { std::string schema; std::string scenario; std::vector<TelemetryFrame> frames; std::vector<Event> events; };
class SessionArchive {
public:
 static constexpr std::string_view Schema="nexvary-avionics-session/v1";
 static constexpr std::size_t MaxFileBytes=50U*1024U*1024U, MaxFrames=200000U, MaxEvents=200000U, MaxSensorsPerFrame=512U;
 static std::string serialize(std::string_view scenario,const TelemetryRecorder& recorder,const EventLog& log);
 static SessionDocument parse(std::string_view jsonText);
 static void writeFile(const std::string& path,std::string_view scenario,const TelemetryRecorder& recorder,const EventLog& log);
 static SessionDocument readFile(const std::string& path);
};
}
