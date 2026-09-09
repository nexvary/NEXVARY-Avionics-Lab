#include "plugin/PluginRegistry.hpp"
#include <cassert>
using namespace nexvary::avionics;
int main(){auto registry=PluginRegistry::withBuiltIns();assert(registry.list().size()==4);assert(registry.find("native-synthetic").has_value());assert(!registry.remove("native-synthetic"));assert(registry.registerPlugin({"test-analysis","Test Analysis","1.0",PluginKind::Analysis,false}));assert(!registry.registerPlugin({"test-analysis","Duplicate","1.0",PluginKind::Analysis,false}));assert(registry.list(PluginKind::Analysis).size()==2);assert(registry.remove("test-analysis"));assert(!registry.find("test-analysis").has_value());return 0;}
