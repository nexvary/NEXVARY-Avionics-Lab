#include "telemetry/TelemetryDictionary.hpp"
#include "platform/AircraftPlatformCatalog.hpp"
#include <algorithm>
#include <cmath>
namespace nexvary::avionics { namespace {
const std::vector<ChannelDefinition> kChannels{
 {"cpu_temp_c","cpu_temp_c","C",-40,125,10,true},{"bus_voltage_v","bus_voltage_v","V",0,40,10,true},{"imu_pitch_deg","imu_pitch_deg","deg",-90,90,20,true},{"imu_roll_deg","imu_roll_deg","deg",-180,180,20,true},{"altitude_m","altitude_m","m",-500,30000,10,true},{"airspeed_kph","airspeed_kph","km/h",0,2500,10,true},{"hydraulic_pressure_pct","hydraulic_pressure_pct","%",0,100,10,true},{"fuel_level_pct","fuel_level_pct","%",0,100,2,true},{"jet_engine_core_pct","jet_engine_core_pct","%",0,110,10,true},{"turboprop_torque_pct","turboprop_torque_pct","%",0,120,10,true},{"prop_rpm_pct","prop_rpm_pct","%",0,110,10,true},{"rotor_rpm_pct","rotor_rpm_pct","%",0,110,20,true},{"battery_soc_pct","battery_soc_pct","%",0,100,2,true},{"link_quality_pct","link_quality_pct","%",0,100,5,true},{"nav_quality_pct","nav_quality_pct","%",0,100,5,true}};
}
const std::vector<ChannelDefinition>& TelemetryDictionary::channels(){return kChannels;}
std::vector<ChannelDefinition> TelemetryDictionary::channels(std::string_view platformId){std::vector<ChannelDefinition> out;const auto p=AircraftPlatformCatalog::find(platformId);if(!p)return out;for(const auto& id:p->channels){const auto d=find(id);if(d)out.push_back(*d);}return out;}
std::optional<ChannelDefinition> TelemetryDictionary::find(std::string_view id){for(const auto& c:kChannels)if(c.id==id)return c;return std::nullopt;}
std::optional<ChannelDefinition> TelemetryDictionary::find(std::string_view platformId,std::string_view id){const auto p=AircraftPlatformCatalog::find(platformId);if(!p||std::find(p->channels.begin(),p->channels.end(),id)==p->channels.end())return std::nullopt;return find(id);}
ChannelValidation TelemetryDictionary::validate(std::string_view id,const SensorSample& s){ChannelValidation o;const auto d=find(id);if(!d)return o;o.known=true;o.unitMatches=s.unit==d->unit;o.finite=std::isfinite(s.value);o.inEngineeringRange=o.finite&&s.value>=d->minimum&&s.value<=d->maximum;return o;}
ChannelValidation TelemetryDictionary::validate(std::string_view p,std::string_view id,const SensorSample& s){ChannelValidation o;const auto d=find(p,id);if(!d)return o;o.known=true;o.unitMatches=s.unit==d->unit;o.finite=std::isfinite(s.value);o.inEngineeringRange=o.finite&&s.value>=d->minimum&&s.value<=d->maximum;return o;}
} // namespace nexvary::avionics
