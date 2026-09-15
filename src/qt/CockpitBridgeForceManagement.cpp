#include "qt/CockpitBridge.hpp"

#include <QVariantMap>

namespace nexvary::avionics {

QVariantList CockpitBridge::forceBases() const {
    QVariantList rows;
    for (const auto& item : forceManagement_.bases()) {
        QVariantMap row;
        row[QStringLiteral("id")] = QString::fromStdString(item.id);
        row[QStringLiteral("name")] = QString::fromStdString(item.name);
        row[QStringLiteral("runway")] = QString::fromStdString(item.runwayState);
        row[QStringLiteral("weather")] = QString::fromStdString(item.weatherState);
        row[QStringLiteral("state")] = QString::fromStdString(item.runwayState);
        row[QStringLiteral("code")] = QString::fromStdString(item.id);
        row[QStringLiteral("region")] = QStringLiteral("TRAINING REGION");
        row[QStringLiteral("supportPercent")] = item.supportPercent;
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::forceSquadrons() const {
    QVariantList rows;
    for (const auto& item : forceManagement_.squadrons()) {
        QVariantMap row;
        row[QStringLiteral("id")] = QString::fromStdString(item.id);
        row[QStringLiteral("name")] = QString::fromStdString(item.name);
        row[QStringLiteral("platform")] = QString::fromStdString(item.platformClass);
        row[QStringLiteral("assigned")] = item.assigned;
        row[QStringLiteral("ready")] = item.ready;
        row[QStringLiteral("crewReady")] = item.crewReady;
        row[QStringLiteral("crewRequired")] = item.crewRequired;
        row[QStringLiteral("state")] = item.ready == item.assigned ? QStringLiteral("READY") : (item.ready * 100 / item.assigned >= 80 ? QStringLiteral("READY") : QStringLiteral("LIMITED"));
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::forceTrainingRows() const {
    QVariantList rows;
    for (const auto& item : forceManagement_.trainingSlots()) {
        QVariantMap row;
        row[QStringLiteral("time")] = QString::fromStdString(item.time);
        row[QStringLiteral("group")] = QString::fromStdString(item.unit);
        row[QStringLiteral("item")] = QString::fromStdString(item.activity);
        row[QStringLiteral("status")] = QString::fromStdString(item.status);
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::forceMaintenancePlanRows() const {
    QVariantList rows;
    for (const auto& item : forceManagement_.maintenancePlan()) {
        QVariantMap row;
        row[QStringLiteral("priority")] = QString::fromStdString(item.priority);
        row[QStringLiteral("platform")] = QString::fromStdString(item.platform);
        row[QStringLiteral("item")] = QString::fromStdString(item.action);
        row[QStringLiteral("due")] = QString::number(item.dueHours) + QStringLiteral(" h");
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::forceExecutiveReports() const {
    QVariantList rows;
    for (const auto& item : forceManagement_.executiveReports()) {
        QVariantMap row;
        row[QStringLiteral("title")] = QString::fromStdString(item.title);
        row[QStringLiteral("status")] = QString::fromStdString(item.status);
        row[QStringLiteral("stamp")] = QString::fromStdString(item.period);
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::forceCrewRows() const {
    QVariantList rows;
    for (const auto& item : forceManagement_.squadrons()) {
        QVariantMap row;
        row[QStringLiteral("id")] = QString::fromStdString(item.id);
        row[QStringLiteral("role")] = QString::fromStdString(item.name);
        row[QStringLiteral("ready")] = QStringLiteral("%1 / %2").arg(item.crewReady).arg(item.crewRequired);
        row[QStringLiteral("readyCount")] = item.crewReady;
        row[QStringLiteral("requiredCount")] = item.crewRequired;
        row[QStringLiteral("score")] = item.crewRequired == 0 ? 0 : (item.crewReady * 100) / item.crewRequired;
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::dataSourceRows() const {
    QVariantList rows;
    for (const auto& source : dataSources_.sources()) {
        QVariantMap row;
        const QString id = QString::fromStdString(source.id);
        row[QStringLiteral("id")] = id;
        row[QStringLiteral("name")] = QString::fromStdString(source.displayName);
        row[QStringLiteral("kind")] = QString::fromUtf8(toString(source.kind).data(), static_cast<qsizetype>(toString(source.kind).size()));
        row[QStringLiteral("mode")] = QString::fromStdString(source.defaultMode);
        row[QStringLiteral("boundary")] = QString::fromStdString(source.trustBoundary);
        row[QStringLiteral("networkCapable")] = source.networkCapable;
        row[QStringLiteral("readOnly")] = source.readOnly;
        row[QStringLiteral("source")] = QStringLiteral("LOCAL / CONFIGURED");
        row[QStringLiteral("health")] = QStringLiteral("NOMINAL");
        row[QStringLiteral("freshness")] = QStringLiteral("FRESH");
        row[QStringLiteral("lastUpdate")] = QStringLiteral("T+%1").arg(snapshot_.tick);
        row[QStringLiteral("records")] = 0;

        if (id == QStringLiteral("public-adsb")) {
            row[QStringLiteral("source")] = publicFlightFeedSource();
            row[QStringLiteral("mode")] = publicFlightFeedStatus();
            row[QStringLiteral("records")] = publicFlightTrackCount();
            if (publicFlightFeedStatus().contains(QStringLiteral("ERROR"), Qt::CaseInsensitive)
                || publicFlightFeedStatus().contains(QStringLiteral("REJECTED"), Qt::CaseInsensitive)) {
                row[QStringLiteral("health")] = QStringLiteral("DEGRADED");
                row[QStringLiteral("freshness")] = QStringLiteral("STALE");
            }
        } else if (id == QStringLiteral("aegis-awareness")) {
            row[QStringLiteral("source")] = airOperationsSource();
            row[QStringLiteral("mode")] = airOperationsMode();
            row[QStringLiteral("records")] = airOperationsTrackCount();
        } else if (id == QStringLiteral("synthetic-training")) {
            row[QStringLiteral("source")] = QStringLiteral("NATIVE SYNTHETIC PROVIDER");
            row[QStringLiteral("records")] = sensorCount();
        } else if (id == QStringLiteral("local-replay")) {
            row[QStringLiteral("source")] = QStringLiteral("SESSION ARCHIVE");
            row[QStringLiteral("records")] = recordedFrames();
            row[QStringLiteral("freshness")] = replayMode_ ? QStringLiteral("ACTIVE") : QStringLiteral("CURRENT");
        } else if (id == QStringLiteral("weather")) {
            if (aerodromeWeatherCount() > 0) {
                row[QStringLiteral("source")] = aerodromeWeatherSource();
                row[QStringLiteral("mode")] = aerodromeWeatherStatus();
                row[QStringLiteral("records")] = aerodromeWeatherCount();
                row[QStringLiteral("freshness")] = aerodromeWeatherStatus().contains(QStringLiteral("ACTIVE"), Qt::CaseInsensitive)
                    || aerodromeWeatherStatus().contains(QStringLiteral("LOADED"), Qt::CaseInsensitive)
                    ? QStringLiteral("LIVE / READ ONLY") : QStringLiteral("CHECK STATUS");
            } else {
                row[QStringLiteral("source")] = QStringLiteral("FORCE TRAINING SNAPSHOT");
                row[QStringLiteral("mode")] = aerodromeWeatherStatus();
                row[QStringLiteral("records")] = static_cast<int>(forceManagement_.bases().size());
                row[QStringLiteral("freshness")] = QStringLiteral("SYNTHETIC FALLBACK");
            }
            if (aerodromeWeatherStatus().contains(QStringLiteral("ERROR"), Qt::CaseInsensitive)
                || aerodromeWeatherStatus().contains(QStringLiteral("REJECTED"), Qt::CaseInsensitive)) {
                row[QStringLiteral("health")] = QStringLiteral("DEGRADED");
            } else {
                row[QStringLiteral("health")] = forceWeatherConstraintCount() > 0 ? QStringLiteral("LIMITED") : QStringLiteral("NOMINAL");
            }
        } else if (id == QStringLiteral("airspace")) {
            row[QStringLiteral("source")] = QStringLiteral("VERSIONED TRAINING SECTORS");
            row[QStringLiteral("records")] = 4;
            row[QStringLiteral("freshness")] = QStringLiteral("STATIC / VERIFIED");
        } else if (id == QStringLiteral("airfields")) {
            if (runwayConditionCount() > 0) {
                row[QStringLiteral("source")] = runwayConditionSource();
                row[QStringLiteral("mode")] = runwayConditionStatus();
                row[QStringLiteral("records")] = runwayConditionCount();
                row[QStringLiteral("freshness")] = QStringLiteral("LICENSED / READ ONLY");
            } else {
                row[QStringLiteral("source")] = QStringLiteral("FORCE MANAGEMENT");
                row[QStringLiteral("mode")] = runwayConditionStatus();
                row[QStringLiteral("records")] = static_cast<int>(forceManagement_.bases().size());
                row[QStringLiteral("freshness")] = QStringLiteral("SYNTHETIC FALLBACK");
            }
            if (runwayConditionStatus().contains(QStringLiteral("ERROR"), Qt::CaseInsensitive)
                || runwayConditionStatus().contains(QStringLiteral("REJECTED"), Qt::CaseInsensitive)) {
                row[QStringLiteral("health")] = QStringLiteral("DEGRADED");
            }
        } else if (id == QStringLiteral("public-orbital-elements")) {
            row[QStringLiteral("source")] = QStringLiteral("PUBLIC EPHEMERIS / TRAINING REPLAY");
            row[QStringLiteral("mode")] = QStringLiteral("MEO AWARENESS / READ ONLY");
            row[QStringLiteral("records")] = 12;
            row[QStringLiteral("freshness")] = QStringLiteral("REPLAY / VERIFIED");
        } else if (id == QStringLiteral("open-drone-id")) {
            row[QStringLiteral("source")] = QStringLiteral("REMOTE ID / TRAINING REPLAY");
            row[QStringLiteral("mode")] = QStringLiteral("PASSIVE RECEIVE ONLY");
            row[QStringLiteral("records")] = airOperationsTrackCount();
            row[QStringLiteral("freshness")] = QStringLiteral("FRESH / CORRELATED");
        }
        rows.push_back(row);
    }
    return rows;
}

int CockpitBridge::forceAvailableBaseCount() const noexcept { return forceManagement_.availableBaseCount(); }
int CockpitBridge::forceAssignedPlatformCount() const noexcept { return forceManagement_.assignedPlatformCount(); }
int CockpitBridge::forceReadyPlatformCount() const noexcept { return forceManagement_.readyPlatformCount(); }
int CockpitBridge::forceFleetReadinessPercent() const noexcept { return forceManagement_.fleetReadinessPercent(); }
int CockpitBridge::forceCrewReadinessPercent() const noexcept { return forceManagement_.crewReadinessPercent(); }
int CockpitBridge::forceWeatherConstraintCount() const noexcept { return forceManagement_.weatherConstraintCount(); }
int CockpitBridge::forceOpenMaintenanceCount() const noexcept { return forceManagement_.openMaintenanceCount(); }

} // namespace nexvary::avionics
