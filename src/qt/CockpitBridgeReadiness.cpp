#include "qt/CockpitBridge.hpp"
#include "platform/AircraftPlatformCatalog.hpp"

#include <QVariantMap>
#include <algorithm>
#include <array>

namespace nexvary::avionics {
namespace {
struct ReadinessSeed {
    const char* id;
    const char* tail;
    int readiness;
    const char* state;
    int maintenanceItems;
    int crewReady;
    int crewRequired;
    int hoursToInspection;
    const char* trainingSlot;
};

constexpr std::array<ReadinessSeed, 4> kSeeds{{
    {"generic-jet", "NXL-J01", 94, "READY", 1, 4, 4, 38, "SIM-ALPHA / 09:30"},
    {"generic-helicopter", "NXL-H01", 81, "LIMITED", 2, 3, 4, 14, "SIM-BRAVO / 11:15"},
    {"generic-uav", "NXL-U01", 89, "READY", 1, 3, 3, 26, "SIM-CHARLIE / 13:00"},
    {"generic-turboprop", "NXL-T01", 86, "READY", 1, 4, 4, 21, "SIM-DELTA / 15:30"}
}};
}

QVariantList CockpitBridge::readinessAssets() const {
    QVariantList rows;
    for (const auto& seed : kSeeds) {
        QVariantMap row;
        const auto profile = AircraftPlatformCatalog::find(seed.id);
        row["id"] = QString::fromUtf8(seed.id);
        row["tail"] = QString::fromUtf8(seed.tail);
        row["name"] = profile ? QString::fromStdString(profile->name) : QString::fromUtf8(seed.id);
        row["category"] = profile ? QString::fromStdString(profile->category) : QStringLiteral("GENERIC");
        row["readiness"] = seed.readiness;
        row["state"] = QString::fromUtf8(seed.state);
        row["maintenanceItems"] = seed.maintenanceItems;
        row["crewReady"] = seed.crewReady;
        row["crewRequired"] = seed.crewRequired;
        row["hoursToInspection"] = seed.hoursToInspection;
        row["trainingSlot"] = QString::fromUtf8(seed.trainingSlot);
        row["active"] = activePlatformId_ == seed.id;
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::readinessMaintenanceRows() const {
    return QVariantList{
        QVariantMap{{"priority", "P2"}, {"platform", "NXL-H01"}, {"system", "ROTOR / DRIVE"}, {"action", "Inspect vibration trend before next training block"}, {"due", "14 h"}, {"state", "PLANNED"}},
        QVariantMap{{"priority", "P2"}, {"platform", "NXL-H01"}, {"system", "HYDRAULICS"}, {"action", "Review synthetic pressure excursion evidence"}, {"due", "18 h"}, {"state", "REVIEW"}},
        QVariantMap{{"priority", "P3"}, {"platform", "NXL-T01"}, {"system", "POWERPLANT"}, {"action", "Scheduled trend review and training inspection"}, {"due", "21 h"}, {"state", "PLANNED"}},
        QVariantMap{{"priority", "P3"}, {"platform", "NXL-U01"}, {"system", "DATALINK"}, {"action", "Validate replay baseline against training profile"}, {"due", "26 h"}, {"state", "VERIFY"}},
        QVariantMap{{"priority", "P3"}, {"platform", "NXL-J01"}, {"system", "AVIONICS"}, {"action", "Routine synthetic health review"}, {"due", "38 h"}, {"state", "PLANNED"}}
    };
}

int CockpitBridge::readinessFleetPercent() const noexcept {
    int total = 0;
    for (const auto& seed : kSeeds) total += seed.readiness;
    return total / static_cast<int>(kSeeds.size());
}

int CockpitBridge::readinessReadyCount() const noexcept {
    return static_cast<int>(std::count_if(kSeeds.begin(), kSeeds.end(), [](const ReadinessSeed& seed) {
        return QString::fromUtf8(seed.state) == QStringLiteral("READY");
    }));
}

int CockpitBridge::readinessMaintenanceOpenCount() const noexcept {
    int total = 0;
    for (const auto& seed : kSeeds) total += seed.maintenanceItems;
    return total;
}

int CockpitBridge::readinessCrewPercent() const noexcept {
    int ready = 0;
    int required = 0;
    for (const auto& seed : kSeeds) {
        ready += seed.crewReady;
        required += seed.crewRequired;
    }
    return required == 0 ? 0 : (ready * 100) / required;
}

QString CockpitBridge::readinessStatus() const {
    const int fleet = readinessFleetPercent();
    if (fleet >= 90) return QStringLiteral("GREEN / TRAINING READY");
    if (fleet >= 80) return QStringLiteral("AMBER / MANAGED LIMITATIONS");
    return QStringLiteral("REVIEW REQUIRED");
}

} // namespace nexvary::avionics
