#include "qt/CockpitBridge.hpp"
#include <QCoreApplication>
#include <QTemporaryFile>
#include <QVariantMap>

#ifdef NDEBUG
#undef NDEBUG
#endif
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
int main(int argc, char** argv) {
    QCoreApplication app(argc, argv);
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
    const auto publicTrack = b.publicFlightTracks().at(0).toMap();
    assert(publicTrack.value("icao24").toString() == "4ca123");
    assert(publicTrack.value("aircraftTypeCode").toString() == "A320");
    assert(publicTrack.value("registration").toString() == "DEMO-101");
    assert(publicTrack.value("telemetrySource").toString() == "SYNTHETIC TRAINING ADS-B");
    assert(publicTrack.value("dataAgeSeconds").toLongLong() == 2);
    assert(b.rfSpectrumBins().size() == 64);
    assert(b.rfSpectrumMode() == "PASSIVE / SYNTHETIC");
    assert(b.rfPeakFrequencyMhz() >= 100.0);
    assert(b.rfPeakFrequencyMhz() <= 500.0);
    assert(b.rfPeakLevelDbm() > -100.0);
    assert(b.rfPeakLevelDbm() < -30.0);
    b.fetchPublicFlightFeed("http://example.invalid/feed");
    assert(b.publicFlightFeedStatus().contains("HTTPS"));
    b.fetchPublicFlightEnrichment("http://example.invalid/enrichment");
    assert(b.publicFlightEnrichmentStatus().contains("HTTPS"));
    b.resetPublicFlightDemo();
    assert(b.publicFlightTrackCount() == 4);
    assert(!b.publicFlightHistory("4ca123", 60).isEmpty());
    assert(b.publicFlightHistoryStatus().contains("HISTORY"));

    QTemporaryFile enrichmentFile;
    assert(enrichmentFile.open());
    const QByteArray enrichmentPayload = R"({
        "provider":{"name":"QT TEST PROVIDER","license":"QT-TEST-LICENSE","sourceUrl":"https://licensed.example.test/data","defaultTtlSeconds":300},
        "records":[{"icao24":"4ca123","registration":"QT-REG","operatorName":"QT Test Operator","route":"TEST-A → TEST-B"}]
    })";
    assert(enrichmentFile.write(enrichmentPayload) == enrichmentPayload.size());
    assert(enrichmentFile.flush());
    assert(b.loadPublicFlightEnrichmentFile(enrichmentFile.fileName()));
    assert(b.publicFlightEnrichmentProvider() == "QT TEST PROVIDER");
    assert(b.publicFlightEnrichmentStatus().contains("LICENSED"));
    const auto enrichedTrack = b.publicFlightTracks().at(0).toMap();
    assert(enrichedTrack.value("registration").toString() == "QT-REG");
    assert(enrichedTrack.value("operatorName").toString() == "QT Test Operator");
    assert(enrichedTrack.value("route").toString() == "TEST-A → TEST-B");
    assert(enrichedTrack.value("metadataSource").toString() == "QT TEST PROVIDER");
    assert(enrichedTrack.value("metadataLicense").toString() == "QT-TEST-LICENSE");
    assert(enrichedTrack.value("enrichmentCacheState").toString() == "FRESH");
    assert(!b.publicFlightHistory("4ca123", 15).isEmpty());

    assert(b.aerodromeWeatherCount() == 0);
    assert(b.runwayConditionCount() == 0);
    assert(b.aerodromeWeatherSource() == "NONE");
    assert(b.runwayConditionSource() == "NONE");
    b.fetchPublicAerodromeWeather("BAD");
    assert(b.aerodromeWeatherStatus().contains("REJECTED"));
    b.fetchLicensedAerodromeConditions("http://example.invalid/conditions");
    assert(b.runwayConditionStatus().contains("HTTPS"));

    QTemporaryFile aerodromeFile;
    assert(aerodromeFile.open());
    const QByteArray aerodromePayload = R"({
        "provider":{"name":"QT AERODROME PROVIDER","license":"QT-AERODROME-LICENSE","sourceUrl":"https://licensed.example.test/aerodrome","defaultTtlSeconds":300},
        "weather":[{"airportIcao":"HECA","rawMetar":"HECA QT TEST","flightCategory":"VFR","windDirectionDegrees":310,"windSpeedKnots":11,"visibilityStatuteMiles":6.0}],
        "runways":[{"airportIcao":"HECA","runway":"05R/23L","state":"OPEN","surface":"ASPHALT","runwayConditionCode":6,"closed":false}]
    })";
    assert(aerodromeFile.write(aerodromePayload) == aerodromePayload.size());
    assert(aerodromeFile.flush());
    assert(b.loadAerodromeConditionFile(aerodromeFile.fileName()));
    assert(b.aerodromeWeatherCount() == 1);
    assert(b.runwayConditionCount() == 1);
    assert(b.aerodromeWeatherSource() == "QT AERODROME PROVIDER");
    assert(b.runwayConditionSource() == "QT AERODROME PROVIDER");
    const auto weatherRow = b.aerodromeWeatherRows().at(0).toMap();
    assert(weatherRow.value("icao").toString() == "HECA");
    assert(weatherRow.value("flightCategory").toString() == "VFR");
    assert(weatherRow.value("source").toString() == "QT AERODROME PROVIDER");
    assert(weatherRow.value("license").toString() == "QT-AERODROME-LICENSE");
    const auto runwayRow = b.runwayConditionRows().at(0).toMap();
    assert(runwayRow.value("icao").toString() == "HECA");
    assert(runwayRow.value("runway").toString() == "05R/23L");
    assert(runwayRow.value("runwayConditionCode").toInt() == 6);
    assert(!runwayRow.value("closed").toBool());
    assert(findRow(b.dataSourceRows(), "weather").value("source").toString() == "QT AERODROME PROVIDER");
    assert(findRow(b.dataSourceRows(), "airfields").value("source").toString() == "QT AERODROME PROVIDER");
    b.clearAerodromeConditions();
    assert(b.aerodromeWeatherCount() == 0);
    assert(b.runwayConditionCount() == 0);

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
    assert(b.forceCrewRows().size() == 4);
    assert(b.dataSourceRows().size() == 9);
    assert(findRow(b.dataSourceRows(), "public-adsb").value("readOnly").toBool());
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
