#pragma once
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace nexvary::avionics {

enum class PluginKind { SimulationProvider, Analysis, Visualization, Exporter };

struct PluginDescriptor {
    std::string id;
    std::string name;
    std::string version;
    PluginKind kind{PluginKind::Analysis};
    bool builtIn{false};
};

class PluginRegistry {
public:
    [[nodiscard]] bool registerPlugin(PluginDescriptor descriptor);
    [[nodiscard]] bool remove(std::string_view id);
    [[nodiscard]] std::optional<PluginDescriptor> find(std::string_view id) const;
    [[nodiscard]] std::vector<PluginDescriptor> list() const;
    [[nodiscard]] std::vector<PluginDescriptor> list(PluginKind kind) const;
    [[nodiscard]] static PluginRegistry withBuiltIns();
private:
    std::vector<PluginDescriptor> plugins_;
};

const char* to_string(PluginKind kind) noexcept;

} // namespace nexvary::avionics
