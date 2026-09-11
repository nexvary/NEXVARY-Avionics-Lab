#include "qt/CockpitBridge.hpp"
#include "platform/AircraftPlatformCatalog.hpp"
#include <QVariantMap>

namespace nexvary::avionics {
namespace {
QStringList toQStringList(const std::vector<std::string>& values) {
    QStringList out;
    for (const auto& value : values) out.push_back(QString::fromStdString(value));
    return out;
}
}

QVariantList CockpitBridge::platformProfiles() const {
    QVariantList rows;
    for (const auto& profile : AircraftPlatformCatalog::profiles()) {
        QVariantMap row;
        row["id"] = QString::fromStdString(profile.id);
        row["name"] = QString::fromStdString(profile.name);
        row["category"] = QString::fromStdString(profile.category);
        row["propulsion"] = QString::fromStdString(profile.propulsion);
        row["description"] = QString::fromStdString(profile.description);
        row["systems"] = toQStringList(profile.systems);
        row["channels"] = toQStringList(profile.channels);
        row["diagnosticFamilies"] = toQStringList(profile.diagnosticFamilies);
        row["trainingScenarios"] = toQStringList(profile.trainingScenarios);
        row["systemCount"] = static_cast<int>(profile.systems.size());
        row["channelCount"] = static_cast<int>(profile.channels.size());
        row["diagnosticFamilyCount"] = static_cast<int>(profile.diagnosticFamilies.size());
        row["scenarioCount"] = static_cast<int>(profile.trainingScenarios.size());
        row["active"] = profile.id == activePlatformId_;
        rows.push_back(row);
    }
    return rows;
}

QString CockpitBridge::activePlatformId() const { return QString::fromStdString(activePlatformId_); }
QString CockpitBridge::activePlatformName() const {
    const auto profile = AircraftPlatformCatalog::find(activePlatformId_);
    return profile ? QString::fromStdString(profile->name) : QStringLiteral("Generic Platform");
}
QString CockpitBridge::activePlatformCategory() const {
    const auto profile = AircraftPlatformCatalog::find(activePlatformId_);
    return profile ? QString::fromStdString(profile->category) : QStringLiteral("GENERIC");
}
QString CockpitBridge::activePlatformPropulsion() const {
    const auto profile = AircraftPlatformCatalog::find(activePlatformId_);
    return profile ? QString::fromStdString(profile->propulsion) : QStringLiteral("GENERIC");
}

void CockpitBridge::setActivePlatform(const QString& id) {
    const auto requested = id.toStdString();
    if (requested == activePlatformId_) return;
    if (!AircraftPlatformCatalog::find(requested)) return;
    activePlatformId_ = requested;
    replayMode_ = false;
    replayPaused_ = false;
    replayIndex_ = 0;
    diagnosticHistory_.clear();
    diagnosticSummary_ = DiagnosticSummary{};
    lab_.reset();
    refresh(lab_.step());
}

} // namespace nexvary::avionics
