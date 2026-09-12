#include "qt/CockpitBridge.hpp"
#include "platform/AircraftPlatformCatalog.hpp"

#include <QVariantMap>
#include <algorithm>
#include <array>
#include <string_view>

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

QVariantMap maintenanceRow(const QString& priority,
                           const QString& platform,
                           const QString& system,
                           const QString& action,
                           const QString& due,
                           const QString& state) {
    QVariantMap row;
    row[QStringLiteral("priority")] = priority;
    row[QStringLiteral("platform")] = platform;
    row[QStringLiteral("system")] = system;
    row[QStringLiteral("action")] = action;
    row[QStringLiteral("due")] = due;
    row[QStringLiteral("state")] = state;
    return row;
}
}

QVariantList CockpitBridge::readinessAssets() const {
    QVariantList rows;
    for (const auto& seed : kSeeds) {
        QVariantMap row;
        const auto profile = AircraftPlatformCatalog::find(seed.id);
        row[QStringLiteral("id")] = QString::fromUtf8(seed.id);
        row[QStringLiteral("tail")] = QString::fromUtf8(seed.tail);
        row[QStringLiteral("name")] = profile ? QString::fromStdString(profile->name) : QString::fromUtf8(seed.id);
        row[QStringLiteral("category")] = profile ? QString::fromStdString(profile->category) : QStringLiteral("GENERIC");
        row[QStringLiteral("readiness")] = seed.readiness;
        row[QStringLiteral("state")] = QString::fromUtf8(seed.state);
        row[QStringLiteral("maintenanceItems")] = seed.maintenanceItems;
        row[QStringLiteral("crewReady")] = seed.crewReady;
        row[QStringLiteral("crewRequired")] = seed.crewRequired;
        row[QStringLiteral("hoursToInspection")] = seed.hoursToInspection;
        row[QStringLiteral("trainingSlot")] = QString::fromUtf8(seed.trainingSlot);
        row[QStringLiteral("active")] = activePlatformId_ == seed.id;
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::readinessMaintenanceRows() const {
    return QVariantList{
        maintenanceRow(QStringLiteral("P2"), QStringLiteral("NXL-H01"), QStringLiteral("ROTOR / DRIVE"), QStringLiteral("Inspect vibration trend before next training block"), QStringLiteral("14 h"), QStringLiteral("PLANNED")),
        maintenanceRow(QStringLiteral("P2"), QStringLiteral("NXL-H01"), QStringLiteral("HYDRAULICS"), QStringLiteral("Review synthetic pressure excursion evidence"), QStringLiteral("18 h"), QStringLiteral("REVIEW")),
        maintenanceRow(QStringLiteral("P3"), QStringLiteral("NXL-T01"), QStringLiteral("POWERPLANT"), QStringLiteral("Scheduled trend review and training inspection"), QStringLiteral("21 h"), QStringLiteral("PLANNED")),
        maintenanceRow(QStringLiteral("P3"), QStringLiteral("NXL-U01"), QStringLiteral("DATALINK"), QStringLiteral("Validate replay baseline against training profile"), QStringLiteral("26 h"), QStringLiteral("VERIFY")),
        maintenanceRow(QStringLiteral("P3"), QStringLiteral("NXL-J01"), QStringLiteral("AVIONICS"), QStringLiteral("Routine synthetic health review"), QStringLiteral("38 h"), QStringLiteral("PLANNED"))
    };
}

int CockpitBridge::readinessFleetPercent() const noexcept {
    int total = 0;
    for (const auto& seed : kSeeds) total += seed.readiness;
    return total / static_cast<int>(kSeeds.size());
}

int CockpitBridge::readinessReadyCount() const noexcept {
    return static_cast<int>(std::count_if(kSeeds.begin(), kSeeds.end(), [](const ReadinessSeed& seed) {
        return std::string_view(seed.state) == std::string_view("READY");
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
