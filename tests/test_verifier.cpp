#include "verify/SessionVerifier.hpp"
#include "app/AvionicsLab.hpp"
#include <cassert>
#include <limits>
using namespace nexvary::avionics;
int main(){AvionicsLab lab;for(int i=0;i<10;++i)lab.step();const auto good=SessionVerifier::verify(lab.recorder().frames());assert(good.passed());auto broken=lab.recorder().frames();broken[1].sequence=broken[0].sequence;broken[2].sensors.erase("bus_voltage_v");broken[3].sensors["cpu_temp_c"].value=std::numeric_limits<double>::quiet_NaN();const auto bad=SessionVerifier::verify(broken);assert(!bad.passed());assert(bad.errorCount>=3);const auto empty=SessionVerifier::verify({});assert(!empty.passed());return 0;}
