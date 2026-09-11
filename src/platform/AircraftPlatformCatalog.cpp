#include "platform/AircraftPlatformCatalog.hpp"
#include <algorithm>
namespace nexvary::avionics {
const std::vector<AircraftPlatformProfile>& AircraftPlatformCatalog::profiles() {
    static const std::vector<AircraftPlatformProfile> catalog{
        {"generic-jet","Generic Jet","FIXED-WING / JET","TWIN JET","Generic fixed-wing jet avionics profile for synthetic engineering, telemetry, diagnostics and verification training.",
         {"Power","Flight Sensors","Compute","Hydraulics","Fuel","Propulsion","Navigation","Recording"},
         {"bus_voltage_v","cpu_temp_c","altitude_m","airspeed_kph","imu_pitch_deg","imu_roll_deg","hydraulic_pressure_pct","fuel_level_pct","jet_engine_core_pct"},
         {"Power Quality","Air Data","Inertial Sensing","Compute Health","Hydraulic Health","Fuel State","Jet Propulsion Indication","Data Integrity"},
         {"Nominal Baseline","Power Transient","Sensor Dropout","Thermal Rise","Jet Propulsion Degradation"},
         {"imu-dropout","low-power-bus","compute-hot","jet-engine-low","jet-hydraulic-low"},
         {{"power","POWER",{"bus_voltage_v"}},{"compute","COMPUTE",{"cpu_temp_c"}},{"flight_sensors","FLIGHT SENSORS",{"altitude_m","airspeed_kph","imu_pitch_deg","imu_roll_deg"}},{"hydraulics","HYDRAULICS",{"hydraulic_pressure_pct"}},{"fuel","FUEL",{"fuel_level_pct"}},{"propulsion","PROPULSION",{"jet_engine_core_pct"}}},
         {{"NXP-JET-701","jet_engine_core_pct","PROPULSION","CORE SPEED","Jet core indication below training envelope","below",55.0,"WARNING"},{"NXP-JET-702","hydraulic_pressure_pct","HYDRAULICS","PRESSURE","Jet hydraulic pressure below platform envelope","below",65.0,"FAULT"}}},
        {"generic-turboprop","Generic Turboprop","FIXED-WING / TURBOPROP","TWIN TURBOPROP","Generic turboprop training profile emphasizing propulsion indication, electrical distribution, air-data and fuel-system monitoring.",
         {"Power","Flight Sensors","Compute","Propulsion Indication","Fuel","Navigation","Communications","Recording"},
         {"bus_voltage_v","cpu_temp_c","altitude_m","airspeed_kph","imu_pitch_deg","imu_roll_deg","fuel_level_pct","turboprop_torque_pct","prop_rpm_pct"},
         {"Electrical Distribution","Air Data","Propulsion Indication","Compute Health","Fuel State","Navigation Integrity","Data Integrity"},
         {"Nominal Baseline","Electrical Sag","Air-Data Dropout","Compute Thermal Rise","Propeller Indication Degradation"},
         {"imu-dropout","low-power-bus","compute-hot","turboprop-torque-low","turboprop-prop-rpm-low"},
         {{"power","POWER",{"bus_voltage_v"}},{"compute","COMPUTE",{"cpu_temp_c"}},{"flight_sensors","FLIGHT SENSORS",{"altitude_m","airspeed_kph","imu_pitch_deg","imu_roll_deg"}},{"propulsion","PROPULSION",{"turboprop_torque_pct","prop_rpm_pct"}},{"fuel","FUEL",{"fuel_level_pct"}}},
         {{"NXP-TPR-701","turboprop_torque_pct","PROPULSION","TORQUE","Turboprop torque indication below training envelope","below",50.0,"WARNING"},{"NXP-TPR-702","prop_rpm_pct","PROPULSION","PROP RPM","Propeller RPM indication below training envelope","below",85.0,"FAULT"}}},
        {"generic-helicopter","Generic Helicopter","ROTORCRAFT","TURBOSHAFT / ROTOR","Generic rotorcraft avionics profile for synthetic monitoring of rotor indication, flight sensing, power, compute, hydraulic and fuel support systems.",
         {"Power","Flight Sensors","Compute","Rotor Indication","Hydraulics","Fuel","Navigation","Communications"},
         {"bus_voltage_v","cpu_temp_c","altitude_m","airspeed_kph","imu_pitch_deg","imu_roll_deg","rotor_rpm_pct","hydraulic_pressure_pct","fuel_level_pct"},
         {"Rotor Indication","Power Quality","Attitude Sensing","Hydraulic Health","Compute Health","Fuel State","Navigation Integrity"},
         {"Nominal Hover Profile","Power Transient","Attitude Sensor Dropout","Hydraulic Degradation","Rotor Indication Degradation"},
         {"imu-dropout","low-power-bus","compute-hot","rotor-rpm-low","helicopter-hydraulic-low"},
         {{"power","POWER",{"bus_voltage_v"}},{"compute","COMPUTE",{"cpu_temp_c"}},{"flight_sensors","FLIGHT SENSORS",{"altitude_m","airspeed_kph","imu_pitch_deg","imu_roll_deg"}},{"rotor","ROTOR",{"rotor_rpm_pct"}},{"hydraulics","HYDRAULICS",{"hydraulic_pressure_pct"}},{"fuel","FUEL",{"fuel_level_pct"}}},
         {{"NXP-HEL-701","rotor_rpm_pct","ROTOR","ROTOR RPM","Rotor RPM indication below training envelope","below",90.0,"FAULT"},{"NXP-HEL-702","hydraulic_pressure_pct","HYDRAULICS","PRESSURE","Rotorcraft hydraulic pressure below platform envelope","below",60.0,"WARNING"}}},
        {"generic-uav","Generic UAV","UNCREWED AIR SYSTEM","ELECTRIC / GENERIC PROPULSION","Generic uncrewed-air-system profile for synthetic telemetry, energy-state, navigation and data-link health training without live vehicle control.",
         {"Power","Flight Sensors","Compute","Energy State","Data Link Health","Navigation","Communications","Recording"},
         {"bus_voltage_v","cpu_temp_c","altitude_m","airspeed_kph","imu_pitch_deg","imu_roll_deg","battery_soc_pct","link_quality_pct","nav_quality_pct"},
         {"Energy State","Sensor Integrity","Compute Health","Communications Health","Navigation Integrity","Data-Link Health","Recorder Integrity"},
         {"Nominal Mission Profile","Energy Sag","Sensor Dropout","Compute Thermal Rise","Data-Link Degradation"},
         {"imu-dropout","low-power-bus","compute-hot","uav-battery-low","uav-link-degrade","uav-nav-degrade"},
         {{"power","POWER",{"bus_voltage_v"}},{"compute","COMPUTE",{"cpu_temp_c"}},{"flight_sensors","FLIGHT SENSORS",{"altitude_m","airspeed_kph","imu_pitch_deg","imu_roll_deg"}},{"energy","ENERGY",{"battery_soc_pct"}},{"datalink","DATA LINK",{"link_quality_pct"}},{"navigation","NAVIGATION",{"nav_quality_pct"}}},
         {{"NXP-UAV-701","battery_soc_pct","ENERGY","BATTERY","UAV battery state below training reserve","below",25.0,"WARNING"},{"NXP-UAV-702","link_quality_pct","DATA LINK","LINK QUALITY","UAV data-link quality degraded","below",60.0,"FAULT"},{"NXP-UAV-703","nav_quality_pct","NAVIGATION","NAV QUALITY","UAV navigation quality degraded","below",70.0,"WARNING"}}}
    };
    return catalog;
}
std::optional<AircraftPlatformProfile> AircraftPlatformCatalog::find(std::string_view id) { const auto& c=profiles(); const auto it=std::find_if(c.begin(),c.end(),[&](const auto& p){return p.id==id;}); return it==c.end()?std::nullopt:std::optional<AircraftPlatformProfile>{*it}; }
} // namespace nexvary::avionics
