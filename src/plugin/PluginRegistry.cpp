#include "plugin/PluginRegistry.hpp"
#include <algorithm>

namespace nexvary::avionics {
bool PluginRegistry::registerPlugin(PluginDescriptor descriptor){if(descriptor.id.empty()||descriptor.name.empty()||descriptor.version.empty()||find(descriptor.id))return false;plugins_.push_back(std::move(descriptor));return true;}
bool PluginRegistry::remove(std::string_view id){const auto before=plugins_.size();plugins_.erase(std::remove_if(plugins_.begin(),plugins_.end(),[id](const auto& p){return p.id==id&&!p.builtIn;}),plugins_.end());return plugins_.size()!=before;}
std::optional<PluginDescriptor> PluginRegistry::find(std::string_view id) const{for(const auto& p:plugins_)if(p.id==id)return p;return std::nullopt;}
std::vector<PluginDescriptor> PluginRegistry::list() const{return plugins_;}
std::vector<PluginDescriptor> PluginRegistry::list(PluginKind kind) const{std::vector<PluginDescriptor> out;for(const auto& p:plugins_)if(p.kind==kind)out.push_back(p);return out;}
PluginRegistry PluginRegistry::withBuiltIns(){PluginRegistry r;static_cast<void>(r.registerPlugin({"native-synthetic","Native Synthetic Simulation","1",PluginKind::SimulationProvider,true}));static_cast<void>(r.registerPlugin({"telemetry-trends","Telemetry Trend Analyzer","2",PluginKind::Analysis,true}));static_cast<void>(r.registerPlugin({"digital-twin","Synthetic Digital Twin","1",PluginKind::Visualization,true}));static_cast<void>(r.registerPlugin({"session-json","Session JSON Exporter","2",PluginKind::Exporter,true}));return r;}
const char* to_string(PluginKind kind) noexcept{switch(kind){case PluginKind::SimulationProvider:return "SIMULATION_PROVIDER";case PluginKind::Analysis:return "ANALYSIS";case PluginKind::Visualization:return "VISUALIZATION";case PluginKind::Exporter:return "EXPORTER";}return "UNKNOWN";}
} // namespace nexvary::avionics
