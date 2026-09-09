#include "instruments/InstrumentCatalog.hpp"
#include "telemetry/TelemetryDictionary.hpp"
#include <set>

namespace nexvary::avionics {
namespace {const std::vector<InstrumentDefinition> kInstruments{
 {"primary-attitude","attitude",InstrumentKind::Attitude,{"imu_pitch_deg","imu_roll_deg"}},
 {"airspeed-tape","airspeed_kph",InstrumentKind::Tape,{"airspeed_kph"}},
 {"altitude-tape","altitude_m",InstrumentKind::Tape,{"altitude_m"}},
 {"power-status","power",InstrumentKind::Status,{"bus_voltage_v"}},
 {"compute-status","compute",InstrumentKind::Status,{"cpu_temp_c"}},
 {"hydraulic-status","hydraulics",InstrumentKind::Status,{"hydraulic_pressure_pct"}},
 {"fuel-status","fuel",InstrumentKind::Status,{"fuel_level_pct"}},
 {"telemetry-workbench","trends",InstrumentKind::Trend,{"cpu_temp_c","bus_voltage_v","imu_pitch_deg","imu_roll_deg","altitude_m","airspeed_kph","hydraulic_pressure_pct","fuel_level_pct"}}
};}
const std::vector<InstrumentDefinition>& InstrumentCatalog::instruments(){return kInstruments;}
InstrumentCatalogValidation InstrumentCatalog::validate(){InstrumentCatalogValidation out;std::set<std::string> ids;for(const auto& instrument:kInstruments){if(instrument.id.empty()||instrument.titleKey.empty())out.errors.push_back("instrument metadata is empty");if(!ids.insert(instrument.id).second)out.errors.push_back("duplicate instrument id: "+instrument.id);if(instrument.channels.empty())out.errors.push_back("instrument has no telemetry channels: "+instrument.id);for(const auto& channel:instrument.channels)if(!TelemetryDictionary::find(channel))out.errors.push_back("unknown telemetry channel: "+channel);}out.valid=out.errors.empty();return out;}
const char* to_string(InstrumentKind kind) noexcept{switch(kind){case InstrumentKind::Tape:return "TAPE";case InstrumentKind::Attitude:return "ATTITUDE";case InstrumentKind::Numeric:return "NUMERIC";case InstrumentKind::Trend:return "TREND";case InstrumentKind::Status:return "STATUS";}return "UNKNOWN";}
} // namespace nexvary::avionics
