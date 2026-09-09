#include "release/BuildIdentity.hpp"
#include <cassert>
using nexvary::avionics::build::BuildIdentity;
int main(){static_assert(BuildIdentity::stage==1700);assert(BuildIdentity::product=="NEXVARY Avionics Lab");assert(BuildIdentity::version=="3.0.0");assert(BuildIdentity::channel=="training-simulation");return 0;}
