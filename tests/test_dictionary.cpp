#include "telemetry/TelemetryDictionary.hpp"
#include <cassert>
#include <limits>
using namespace nexvary::avionics;
int main(){assert(TelemetryDictionary::channels().size()==8);const auto voltage=TelemetryDictionary::find("bus_voltage_v");assert(voltage.has_value());assert(voltage->unit=="V");assert(TelemetryDictionary::validate("bus_voltage_v",{27.0,"V",true}).acceptable());assert(!TelemetryDictionary::validate("bus_voltage_v",{99.0,"V",true}).acceptable());assert(!TelemetryDictionary::validate("bus_voltage_v",{27.0,"mV",true}).acceptable());assert(!TelemetryDictionary::validate("bus_voltage_v",{std::numeric_limits<double>::quiet_NaN(),"V",true}).acceptable());assert(!TelemetryDictionary::find("unknown").has_value());return 0;}
