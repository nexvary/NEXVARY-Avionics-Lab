#include "data/DataSourceRegistry.hpp"

#include <cassert>
#include <stdexcept>

using namespace nexvary::avionics;

int main() {
    auto registry = DataSourceRegistry::operationalDefaults();
    assert(registry.sources().size() == 9);

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

    const auto orbital = registry.find("public-orbital-elements");
    assert(orbital.has_value());
    assert(orbital->kind == DataSourceKind::PublicOrbitalElements);
    assert(orbital->networkCapable);
    assert(orbital->readOnly);
    assert(toString(orbital->kind) == "ORBITAL ELEMENTS");

    const auto remoteId = registry.find("open-drone-id");
    assert(remoteId.has_value());
    assert(remoteId->kind == DataSourceKind::OpenDroneId);
    assert(!remoteId->networkCapable);
    assert(remoteId->readOnly);
    assert(toString(remoteId->kind) == "OPEN DRONE ID");

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
