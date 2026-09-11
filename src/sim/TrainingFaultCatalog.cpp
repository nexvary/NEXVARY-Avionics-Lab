#include "sim/TrainingFaultCatalog.hpp"
#include "platform/AircraftPlatformCatalog.hpp"
#include <algorithm>
namespace nexvary::avionics { namespace { const std::vector<TrainingFaultPreset> kPresets{
 {"imu-dropout","fault_imu_dropout","fault_imu_dropout_detail",{"training-imu-dropout","imu_pitch_deg",FaultMode::Invalidate,0,true}},
 {"low-power-bus","fault_low_power","fault_low_power_detail",{"training-low-power","bus_voltage_v",FaultMode::Override,20.5,true}},
 {"compute-hot","fault_compute_hot","fault_compute_hot_detail",{"training-compute-hot","cpu_temp_c",FaultMode::Override,91,true}},
 {"jet-engine-low","fault_jet_engine_low","fault_jet_engine_low_detail",{"training-jet-engine-low","jet_engine_core_pct",FaultMode::Override,48,true}},
 {"jet-hydraulic-low","fault_jet_hydraulic_low","fault_jet_hydraulic_low_detail",{"training-jet-hydraulic-low","hydraulic_pressure_pct",FaultMode::Override,52,true}},
 {"turboprop-torque-low","fault_turboprop_torque_low","fault_turboprop_torque_low_detail",{"training-turboprop-torque-low","turboprop_torque_pct",FaultMode::Override,42,true}},
 {"turboprop-prop-rpm-low","fault_prop_rpm_low","fault_prop_rpm_low_detail",{"training-prop-rpm-low","prop_rpm_pct",FaultMode::Override,78,true}},
 {"rotor-rpm-low","fault_rotor_rpm_low","fault_rotor_rpm_low_detail",{"training-rotor-rpm-low","rotor_rpm_pct",FaultMode::Override,82,true}},
 {"helicopter-hydraulic-low","fault_helicopter_hydraulic_low","fault_helicopter_hydraulic_low_detail",{"training-helicopter-hydraulic-low","hydraulic_pressure_pct",FaultMode::Override,50,true}},
 {"uav-battery-low","fault_uav_battery_low","fault_uav_battery_low_detail",{"training-uav-battery-low","battery_soc_pct",FaultMode::Override,18,true}},
 {"uav-link-degrade","fault_uav_link_degrade","fault_uav_link_degrade_detail",{"training-uav-link-degrade","link_quality_pct",FaultMode::Override,45,true}},
 {"uav-nav-degrade","fault_uav_nav_degrade","fault_uav_nav_degrade_detail",{"training-uav-nav-degrade","nav_quality_pct",FaultMode::Override,58,true}}}; }
const std::vector<TrainingFaultPreset>& TrainingFaultCatalog::presets(){return kPresets;}
std::vector<TrainingFaultPreset> TrainingFaultCatalog::presets(std::string_view p){std::vector<TrainingFaultPreset> out;const auto profile=AircraftPlatformCatalog::find(p);if(!profile)return out;for(const auto& id:profile->faultPresetIds){const auto f=find(id);if(f)out.push_back(*f);}return out;}
std::optional<TrainingFaultPreset> TrainingFaultCatalog::find(std::string_view id){const auto it=std::find_if(kPresets.begin(),kPresets.end(),[&](const auto& p){return p.id==id;});return it==kPresets.end()?std::nullopt:std::optional<TrainingFaultPreset>{*it};}
std::optional<TrainingFaultPreset> TrainingFaultCatalog::find(std::string_view p,std::string_view id){const auto profile=AircraftPlatformCatalog::find(p);if(!profile||std::find(profile->faultPresetIds.begin(),profile->faultPresetIds.end(),id)==profile->faultPresetIds.end())return std::nullopt;return find(id);}
} // namespace nexvary::avionics
