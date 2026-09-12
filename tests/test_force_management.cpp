#include "force/ForceManagement.hpp"

#include <cassert>

using namespace nexvary::avionics;

int main() {
    const auto snapshot = ForceManagementSnapshot::syntheticTraining();

    assert(snapshot.syntheticOnly());
    assert(!snapshot.supportsOperationalOrders());
    assert(!snapshot.supportsWeaponsDirection());

    assert(snapshot.bases().size() == 3);
    assert(snapshot.availableBaseCount() == 2);
    assert(snapshot.weatherConstraintCount() == 1);

    assert(snapshot.squadrons().size() == 4);
    assert(snapshot.assignedPlatformCount() == 26);
    assert(snapshot.readyPlatformCount() == 22);
    assert(snapshot.fleetReadinessPercent() == 84);
    assert(snapshot.crewReadinessPercent() == 93);

    assert(snapshot.trainingSlots().size() == 4);
    assert(snapshot.maintenancePlan().size() == 4);
    assert(snapshot.openMaintenanceCount() == 4);
    assert(snapshot.executiveReports().size() == 4);
    return 0;
}
