#include "instruments/InstrumentCatalog.hpp"
#include <cassert>
using namespace nexvary::avionics;
int main(){const auto& items=InstrumentCatalog::instruments();assert(items.size()==8);const auto validation=InstrumentCatalog::validate();assert(validation.valid);assert(validation.errors.empty());assert(items.front().kind==InstrumentKind::Attitude);assert(items.back().channels.size()==8);return 0;}
