#include "data/DataSourceRegistry.hpp"

#include <cassert>
#include <stdexcept>

using namespace nexvary::avionics;

int main() {
    auto registry = DataSourceRegistry::operationalDefaults();
    assert(registry.sources().size() == 7);

    const auto adsb = registry.find("public-adsb");
    assert(adsb.has_value());
    assert(adsb->networkCapable);
    assert(adsb->readOnly);
    assert(adsb->kind == DataSourceKind::PublicAdsb);
    assert(toString(adsb->kind) == "PUBLIC ADS-B");

    const auto aegis = registry.find("aegis-awareness");
    assert(aegis.has_value());
    assert(!aegis->networkCapable);
    assert(aegis->readOnly);

    bool duplicateRejected = false;
    try {
        registry.registerSource(*adsb);
    } catch (const std::invalid_argument&) {
        duplicateRejected = true;
    }
    assert(duplicateRejected);
    assert(!registry.find("missing-provider").has_value());
    return 0;
}
