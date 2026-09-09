#include "telemetry/TelemetryDictionary.hpp"
#include <cmath>

namespace nexvary::avionics {
namespace {
const std::vector<ChannelDefinition> kChannels{
    {"cpu_temp_c","cpu_temp_c","C",-40.0,125.0,10.0,true},
    {"bus_voltage_v","bus_voltage_v","V",0.0,40.0,10.0,true},
    {"imu_pitch_deg","imu_pitch_deg","deg",-90.0,90.0,20.0,true},
    {"imu_roll_deg","imu_roll_deg","deg",-180.0,180.0,20.0,true},
    {"altitude_m","altitude_m","m",-500.0,30000.0,10.0,true},
    {"airspeed_kph","airspeed_kph","km/h",0.0,2500.0,10.0,true},
    {"hydraulic_pressure_pct","hydraulic_pressure_pct","%",0.0,100.0,10.0,true},
    {"fuel_level_pct","fuel_level_pct","%",0.0,100.0,2.0,true},
};
}
const std::vector<ChannelDefinition>& TelemetryDictionary::channels(){return kChannels;}
std::optional<ChannelDefinition> TelemetryDictionary::find(std::string_view id){for(const auto& channel:kChannels)if(channel.id==id)return channel;return std::nullopt;}
ChannelValidation TelemetryDictionary::validate(std::string_view id,const SensorSample& sample){ChannelValidation out;const auto def=find(id);if(!def)return out;out.known=true;out.unitMatches=sample.unit==def->unit;out.finite=std::isfinite(sample.value);out.inEngineeringRange=out.finite&&sample.value>=def->minimum&&sample.value<=def->maximum;return out;}
} // namespace nexvary::avionics
