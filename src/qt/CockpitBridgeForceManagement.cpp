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

int CockpitBridge::forceAvailableBaseCount() const noexcept { return forceManagement_.availableBaseCount(); }
int CockpitBridge::forceAssignedPlatformCount() const noexcept { return forceManagement_.assignedPlatformCount(); }
int CockpitBridge::forceReadyPlatformCount() const noexcept { return forceManagement_.readyPlatformCount(); }
int CockpitBridge::forceFleetReadinessPercent() const noexcept { return forceManagement_.fleetReadinessPercent(); }
int CockpitBridge::forceCrewReadinessPercent() const noexcept { return forceManagement_.crewReadinessPercent(); }
int CockpitBridge::forceWeatherConstraintCount() const noexcept { return forceManagement_.weatherConstraintCount(); }
int CockpitBridge::forceOpenMaintenanceCount() const noexcept { return forceManagement_.openMaintenanceCount(); }

} // namespace nexvary::avionics
