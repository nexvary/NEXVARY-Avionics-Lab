#include "data/DataSourceRegistry.hpp"

#include <algorithm>
#include <stdexcept>
#include <utility>

namespace nexvary::avionics {

std::string_view toString(DataSourceKind kind) noexcept {
    switch (kind) {
        case DataSourceKind::PublicAdsb: return "PUBLIC ADS-B";
        case DataSourceKind::Replay: return "REPLAY";
        case DataSourceKind::SyntheticTraining: return "SYNTHETIC TRAINING";
        case DataSourceKind::AegisAwareness: return "AEGIS AWARENESS";
        case DataSourceKind::Weather: return "WEATHER";
        case DataSourceKind::Airspace: return "AIRSPACE DATASET";
        case DataSourceKind::Airfield: return "AIRFIELD";
    }
    return "UNKNOWN";
}

DataSourceRegistry DataSourceRegistry::operationalDefaults() {
    DataSourceRegistry registry;
    registry.registerSource({"public-adsb", "Public ADS-B", DataSourceKind::PublicAdsb, "PUBLIC / READ ONLY", "UNCLASSIFIED PUBLIC AWARENESS", true, true});
    registry.registerSource({"aegis-awareness", "AEGIS C-UAS", DataSourceKind::AegisAwareness, "REPLAY / AWARENESS", "TRAINING AND INCIDENT REVIEW", false, true});
    registry.registerSource({"synthetic-training", "Synthetic Training", DataSourceKind::SyntheticTraining, "DETERMINISTIC SIMULATION", "OFFLINE LAB", false, true});
    registry.registerSource({"local-replay", "Local Replay", DataSourceKind::Replay, "LOCAL SESSION ARCHIVE", "OFFLINE EVIDENCE", false, true});
    registry.registerSource({"weather", "Weather Constraints", DataSourceKind::Weather, "PROVIDER ADAPTER", "READ-ONLY CONSTRAINT LAYER", true, true});
    registry.registerSource({"airspace", "Airspace Dataset", DataSourceKind::Airspace, "VERSIONED DATASET", "READ-ONLY GEOMETRY", false, true});
    registry.registerSource({"airfields", "Airfields & Bases", DataSourceKind::Airfield, "MANAGEMENT SNAPSHOT", "TRAINING READINESS", false, true});
    return registry;
}

void DataSourceRegistry::registerSource(DataSourceDefinition source) {
    if (source.id.empty() || source.displayName.empty() || source.defaultMode.empty()) {
        throw std::invalid_argument("data source definition requires id, display name and mode");
    }
    const auto duplicate = std::find_if(sources_.begin(), sources_.end(), [&source](const DataSourceDefinition& existing) {
        return existing.id == source.id;
    });
    if (duplicate != sources_.end()) throw std::invalid_argument("duplicate data source id");
    sources_.push_back(std::move(source));
}

std::optional<DataSourceDefinition> DataSourceRegistry::find(std::string_view id) const {
    const auto match = std::find_if(sources_.begin(), sources_.end(), [id](const DataSourceDefinition& source) {
        return source.id == id;
    });
    if (match == sources_.end()) return std::nullopt;
    return *match;
}

} // namespace nexvary::avionics
