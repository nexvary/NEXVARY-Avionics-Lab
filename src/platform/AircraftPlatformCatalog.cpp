#include "platform/AircraftPlatformCatalog.hpp"
#include <algorithm>

namespace nexvary::avionics {

const std::vector<AircraftPlatformProfile>& AircraftPlatformCatalog::profiles() {
    static const std::vector<AircraftPlatformProfile> catalog{
        {
            "generic-jet", "Generic Jet", "FIXED-WING / JET", "TWIN JET",
            "Generic fixed-wing jet avionics profile for synthetic engineering, telemetry, diagnostics and verification training.",
            {"Power", "Flight Sensors", "Compute", "Hydraulics", "Fuel", "Navigation", "Communications", "Recording"},
            {"airspeed_kph", "altitude_m", "imu_pitch_deg", "imu_roll_deg", "bus_voltage_v", "cpu_temp_c", "hydraulic_pressure_pct", "fuel_level_pct"},
            {"Power Quality", "Air Data", "Inertial Sensing", "Compute Health", "Hydraulic Health", "Fuel State", "Data Integrity"},
            {"Nominal Baseline", "Power Transient", "Sensor Dropout", "Thermal Rise"}
        },
        {
            "generic-turboprop", "Generic Turboprop", "FIXED-WING / TURBOPROP", "TWIN TURBOPROP",
            "Generic turboprop training profile emphasizing propulsion indication, electrical distribution and environmental/air-data monitoring.",
            {"Power", "Flight Sensors", "Compute", "Propulsion Indication", "Fuel", "Navigation", "Communications", "Recording"},
            {"airspeed_kph", "altitude_m", "imu_pitch_deg", "imu_roll_deg", "bus_voltage_v", "cpu_temp_c", "fuel_level_pct", "hydraulic_pressure_pct"},
            {"Electrical Distribution", "Air Data", "Propulsion Indication", "Compute Health", "Fuel State", "Navigation Integrity", "Data Integrity"},
            {"Nominal Baseline", "Electrical Sag", "Air-Data Dropout", "Compute Thermal Rise"}
        },
        {
            "generic-helicopter", "Generic Helicopter", "ROTORCRAFT", "TURBOSHAFT / ROTOR",
            "Generic rotorcraft avionics profile for synthetic monitoring of flight sensing, rotor-system indication, power, compute and hydraulic support systems.",
            {"Power", "Flight Sensors", "Compute", "Rotor Indication", "Hydraulics", "Fuel", "Navigation", "Communications"},
            {"altitude_m", "airspeed_kph", "imu_pitch_deg", "imu_roll_deg", "bus_voltage_v", "cpu_temp_c", "hydraulic_pressure_pct", "fuel_level_pct"},
            {"Rotor Indication", "Power Quality", "Attitude Sensing", "Hydraulic Health", "Compute Health", "Fuel State", "Navigation Integrity"},
            {"Nominal Hover Profile", "Power Transient", "Attitude Sensor Dropout", "Hydraulic Degradation"}
        },
        {
            "generic-uav", "Generic UAV", "UNCREWED AIR SYSTEM", "ELECTRIC / GENERIC PROPULSION",
            "Generic uncrewed-air-system profile for synthetic telemetry, platform-health, communications and diagnostic workflow training without live vehicle control.",
            {"Power", "Flight Sensors", "Compute", "Communications", "Navigation", "Energy State", "Data Link Health", "Recording"},
            {"altitude_m", "airspeed_kph", "imu_pitch_deg", "imu_roll_deg", "bus_voltage_v", "cpu_temp_c", "fuel_level_pct", "hydraulic_pressure_pct"},
            {"Energy State", "Sensor Integrity", "Compute Health", "Communications Health", "Navigation Integrity", "Data-Link Health", "Recorder Integrity"},
            {"Nominal Mission Profile", "Energy Sag", "Sensor Dropout", "Compute Thermal Rise"}
        }
    };
    return catalog;
}

std::optional<AircraftPlatformProfile> AircraftPlatformCatalog::find(std::string_view id) {
    const auto& catalog = profiles();
    const auto it = std::find_if(catalog.begin(), catalog.end(), [&](const auto& profile) { return profile.id == id; });
    if (it == catalog.end()) return std::nullopt;
    return *it;
}

} // namespace nexvary::avionics
