#pragma once

#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace nexvary::avionics {

enum class DataSourceKind {
    PublicAdsb,
    Replay,
    SyntheticTraining,
    AegisAwareness,
    Weather,
    Airspace,
    Airfield
};

struct DataSourceDefinition {
    std::string id;
    std::string displayName;
    DataSourceKind kind{DataSourceKind::SyntheticTraining};
    std::string defaultMode;
    std::string trustBoundary;
    bool networkCapable{false};
    bool readOnly{true};
};

class DataSourceRegistry {
public:
    static DataSourceRegistry operationalDefaults();

    void registerSource(DataSourceDefinition source);
    const std::vector<DataSourceDefinition>& sources() const noexcept { return sources_; }
    std::optional<DataSourceDefinition> find(std::string_view id) const;

private:
    std::vector<DataSourceDefinition> sources_;
};

std::string_view toString(DataSourceKind kind) noexcept;

} // namespace nexvary::avionics
