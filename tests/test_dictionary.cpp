#include "telemetry/TelemetryDictionary.hpp"
#include <cassert>
#include <limits>
using namespace nexvary::avionics;
int main(){assert(TelemetryDictionary::channels().size()==15);assert(TelemetryDictionary::channels("generic-jet").size()==9);assert(TelemetryDictionary::channels("generic-uav").size()==9);const auto voltage=TelemetryDictionary::find("bus_voltage_v");assert(voltage&&voltage->unit=="V");assert(TelemetryDictionary::find("generic-uav","battery_soc_pct"));assert(!TelemetryDictionary::find("generic-uav","hydraulic_pressure_pct"));assert(TelemetryDictionary::validate("bus_voltage_v",{27,"V",true}).acceptable());assert(!TelemetryDictionary::validate("bus_voltage_v",{99,"V",true}).acceptable());assert(!TelemetryDictionary::validate("bus_voltage_v",{27,"mV",true}).acceptable());assert(!TelemetryDictionary::validate("bus_voltage_v",{std::numeric_limits<double>::quiet_NaN(),"V",true}).acceptable());return 0;}
