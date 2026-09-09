#include "report/LabReport.hpp"
#include "core/TelemetryArchive.hpp"
#include <nlohmann/json.hpp>
#include <fstream>
#include <iomanip>
#include <limits>
#include <sstream>
#include <stdexcept>

namespace nexvary::avionics {
LabReportData LabReport::analyze(std::string_view scenario,const TelemetryRecorder& recorder,const EventLog& log){
    LabReportData r; r.scenario=std::string(scenario); r.frameCount=recorder.size(); r.eventCount=log.size();
    const auto summary=TelemetryArchive::inspect(recorder.frames()); r.sensorSampleCount=summary.sensorSampleCount; r.invalidSampleCount=summary.invalidSampleCount; r.sequenceMonotonic=summary.sequenceMonotonic; r.timeMonotonic=summary.timeMonotonic; r.checksum=summary.checksum;
    struct Acc{std::size_t samples=0,valid=0,invalid=0;double min=std::numeric_limits<double>::infinity(),max=-std::numeric_limits<double>::infinity(),sum=0.0;};
    std::map<std::string,Acc> acc;
    for(const auto&frame:recorder.frames())for(const auto&[name,s]:frame.sensors){auto&a=acc[name];++a.samples;if(!s.valid){++a.invalid;continue;}++a.valid;a.min=std::min(a.min,s.value);a.max=std::max(a.max,s.value);a.sum+=s.value;}
    for(const auto&[name,a]:acc){SensorStatistic s;s.samples=a.samples;s.validSamples=a.valid;s.invalidSamples=a.invalid;if(a.valid){s.minimum=a.min;s.maximum=a.max;s.mean=a.sum/static_cast<double>(a.valid);}r.sensors.emplace(name,s);}return r;
}
std::string LabReport::toJson(const LabReportData&r){nlohmann::json j{{"schema","nexvary-avionics-verification/v1"},{"scope","synthetic-training"},{"scenario",r.scenario},{"frame_count",r.frameCount},{"event_count",r.eventCount},{"sensor_sample_count",r.sensorSampleCount},{"invalid_sample_count",r.invalidSampleCount},{"sequence_monotonic",r.sequenceMonotonic},{"time_monotonic",r.timeMonotonic},{"checksum",r.checksum}};j["sensors"]=nlohmann::json::object();for(const auto&[n,s]:r.sensors)j["sensors"][n]={{"samples",s.samples},{"valid_samples",s.validSamples},{"invalid_samples",s.invalidSamples},{"minimum",s.minimum},{"maximum",s.maximum},{"mean",s.mean}};return j.dump(2);}
std::string LabReport::toMarkdown(const LabReportData&r){std::ostringstream o;o<<"# NEXVARY Avionics Verification Report\n\nSynthetic training/simulation data only. No live-aircraft control interface.\n\n"<<"- Scenario: `"<<r.scenario<<"`\n- Frames: "<<r.frameCount<<"\n- Events: "<<r.eventCount<<"\n- Sensor samples: "<<r.sensorSampleCount<<"\n- Invalid samples: "<<r.invalidSampleCount<<"\n- Sequence monotonic: "<<(r.sequenceMonotonic?"PASS":"FAIL")<<"\n- Time monotonic: "<<(r.timeMonotonic?"PASS":"FAIL")<<"\n- Checksum: `"<<r.checksum<<"`\n\n| Sensor | Samples | Valid | Invalid | Min | Max | Mean |\n|---|---:|---:|---:|---:|---:|---:|\n";o<<std::fixed<<std::setprecision(3);for(const auto&[n,s]:r.sensors)o<<'|'<<n<<'|'<<s.samples<<'|'<<s.validSamples<<'|'<<s.invalidSamples<<'|'<<s.minimum<<'|'<<s.maximum<<'|'<<s.mean<<"|\n";return o.str();}
static void writeText(const std::string&p,const std::string&v){std::ofstream f(p,std::ios::binary|std::ios::trunc);if(!f)throw std::runtime_error("unable to open report output");f<<v;if(!f)throw std::runtime_error("unable to write report output");}
void LabReport::writeJson(const std::string&p,const LabReportData&r){writeText(p,toJson(r));} void LabReport::writeMarkdown(const std::string&p,const LabReportData&r){writeText(p,toMarkdown(r));}
}
