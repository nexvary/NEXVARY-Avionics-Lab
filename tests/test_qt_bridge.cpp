#include "qt/CockpitBridge.hpp"
#include <QVariantMap>
#include <cassert>
using namespace nexvary::avionics;
namespace {
QVariantMap findRow(const QVariantList& rows, const QString& id) {
    for (const auto& value : rows) {
        const auto map = value.toMap();
        if (map.value("id").toString() == id) return map;
    }
    return {};
}
}
int main() {
    CockpitBridge b;
    assert(b.platformProfiles().size() == 4);
    assert(b.activePlatformId() == "generic-jet");
    assert(b.sensorCount() == 9);
    assert(b.sensorRows().size() == 9);
    assert(b.faultPresets().size() == 5);
    assert(b.twinRows().size() == 6);

    assert(b.airOperationsSource() == "Aegis-CUAS-Command");
    assert(b.airOperationsMode() == "simulation-replay");
    assert(b.airOperationsTrackCount() == 3);
    assert(b.airOperationsIncidentCount() == 1);
    assert(b.airOperationsHighCount() == 1);
    assert(b.airOperationsObservationCount() == 48);
    assert(b.airOperationsTracks().size() == 3);
    assert(b.airOperationsIncidents().size() == 1);

    assert(b.publicFlightTrackCount() == 4);
    assert(b.publicFlightTracks().size() == 4);
    assert(b.publicFlightFeedSource() == "PUBLIC ADS-B / DEMO");
    assert(b.rfSpectrumBins().size() == 64);
    assert(b.rfSpectrumMode() == "PASSIVE / SYNTHETIC");
    assert(b.rfPeakFrequencyMhz() >= 100.0);
    assert(b.rfPeakFrequencyMhz() <= 500.0);
    assert(b.rfPeakLevelDbm() > -100.0);
    assert(b.rfPeakLevelDbm() < -30.0);
    b.fetchPublicFlightFeed("http://example.invalid/feed");
    assert(b.publicFlightFeedStatus().contains("HTTPS"));
    b.resetPublicFlightDemo();
    assert(b.publicFlightTrackCount() == 4);

    assert(b.readinessAssets().size() == 4);
    assert(b.readinessMaintenanceRows().size() == 5);
    assert(b.readinessFleetPercent() == 87);
    assert(b.readinessReadyCount() == 3);
    assert(b.readinessMaintenanceOpenCount() == 5);
    assert(b.readinessCrewPercent() == 93);
    assert(b.readinessStatus() == "AMBER / MANAGED LIMITATIONS");
    const auto uavReadiness = findRow(b.readinessAssets(), "generic-uav");
    assert(!uavReadiness.isEmpty());
    assert(uavReadiness.value("readiness").toInt() == 89);
    assert(uavReadiness.value("state").toString() == "READY");

    assert(b.forceBases().size() == 3);
    assert(b.forceSquadrons().size() == 4);
    assert(b.forceTrainingRows().size() == 4);
    assert(b.forceMaintenancePlanRows().size() == 4);
    assert(b.forceExecutiveReports().size() == 4);
    assert(b.forceAvailableBaseCount() == 2);
    assert(b.forceAssignedPlatformCount() == 26);
    assert(b.forceReadyPlatformCount() == 22);
    assert(b.forceFleetReadinessPercent() == 84);
    assert(b.forceCrewReadinessPercent() == 93);
    assert(b.forceWeatherConstraintCount() == 1);
    assert(b.forceOpenMaintenanceCount() == 4);

    for (int i = 0; i < 20; ++i) b.step();
    b.runDiagnosticScan();
    assert(b.diagnosticHealthScore() >= 90);
    b.setActivePlatform("generic-uav");
    assert(b.activePlatformId() == "generic-uav");
    assert(b.sensorRows().size() == 9);
    assert(b.faultPresets().size() == 6);
    assert(findRow(b.sensorRows(), "link_quality_pct").value("unit").toString() == "%");
    assert(findRow(b.twinRows(), "datalink").value("state").toString() == "NOMINAL");
    assert(findRow(b.readinessAssets(), "generic-uav").value("active").toBool());
    b.applyTrainingFault("uav-link-degrade");
    b.runDiagnosticScan();
    assert(!findRow(b.diagnosticFindings(), "NXP-UAV-702").isEmpty());
    b.clearTrainingFaults();
    b.setActivePlatform("generic-helicopter");
    assert(b.faultPresets().size() == 5);
    b.applyTrainingFault("rotor-rpm-low");
    b.runDiagnosticScan();
    assert(!findRow(b.diagnosticFindings(), "NXP-HEL-701").isEmpty());
    b.setLanguage("ar");
    assert(b.rtl());
    return 0;
}
