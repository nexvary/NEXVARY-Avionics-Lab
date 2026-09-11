#include "platform/AircraftPlatformCatalog.hpp"
#include <cassert>
#include <set>
#include <string>

using namespace nexvary::avionics;

int main() {
    const auto& profiles = AircraftPlatformCatalog::profiles();
    assert(profiles.size() == 4);
    std::set<std::string> ids;
    for (const auto& profile : profiles) {
        assert(!profile.id.empty());
        assert(!profile.name.empty());
        assert(!profile.category.empty());
        assert(!profile.propulsion.empty());
        assert(profile.systems.size() >= 8);
        assert(profile.channels.size() >= 8);
        assert(profile.diagnosticFamilies.size() >= 6);
        assert(profile.trainingScenarios.size() >= 4);
        assert(ids.insert(profile.id).second);
    }
    assert(AircraftPlatformCatalog::find("generic-jet").has_value());
    assert(AircraftPlatformCatalog::find("generic-turboprop").has_value());
    assert(AircraftPlatformCatalog::find("generic-helicopter").has_value());
    assert(AircraftPlatformCatalog::find("generic-uav").has_value());
    assert(!AircraftPlatformCatalog::find("unknown-platform").has_value());
    return 0;
}
