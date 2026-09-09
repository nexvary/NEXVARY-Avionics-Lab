#include "qt/CockpitBridge.hpp"
#include "sim/ScenarioEngine.hpp"
#include <QVariantMap>
#include <stdexcept>

namespace nexvary::avionics {

CockpitBridge::CockpitBridge(QObject* parent)
    : QObject(parent), lab_(ScenarioKind::Nominal) {
    refresh(lab_.step());
}

QVariantList CockpitBridge::tiles() const { return tiles_; }
QStringList CockpitBridge::annunciators() const { return annunciators_; }
QString CockpitBridge::scenario() const { return QString::fromUtf8(ScenarioEngine::toString(snapshot_.scenario)); }
qulonglong CockpitBridge::tick() const noexcept { return static_cast<qulonglong>(snapshot_.tick); }
QString CockpitBridge::language() const { return language_ == UiLanguage::Arabic ? QStringLiteral("ar") : QStringLiteral("en"); }
bool CockpitBridge::rtl() const noexcept { return UiLocale::isRtl(language_); }

QStringList CockpitBridge::scenarios() const {
    QStringList result;
    for (const auto& name : ScenarioEngine::names()) result.push_back(QString::fromStdString(name));
    return result;
}

void CockpitBridge::step() {
    refresh(lab_.step());
}

void CockpitBridge::setScenario(const QString& name) {
    try {
        lab_.setScenario(ScenarioEngine::fromName(name.toStdString()));
        lab_.reset();
        refresh(lab_.step());
    } catch (const std::invalid_argument&) {
        return;
    }
}

void CockpitBridge::setLanguage(const QString& code) {
    const auto next = UiLocale::fromCode(code.toStdString());
    if (next == language_) return;
    language_ = next;
    refresh(snapshot_);
    emit languageChanged();
}

QString CockpitBridge::text(const QString& key) const {
    return QString::fromStdString(UiLocale::text(language_, key.toStdString()));
}

void CockpitBridge::refresh(const LabSnapshot& snapshot) {
    snapshot_ = snapshot;
    const auto page = viewModel_.build(snapshot_);
    tiles_.clear();
    for (const auto& tile : page.tiles) {
        QVariantMap item;
        item.insert(QStringLiteral("id"), QString::fromStdString(tile.id));
        item.insert(QStringLiteral("label"), QString::fromStdString(UiLocale::text(language_, tile.id)));
        item.insert(QStringLiteral("value"), QString::fromStdString(tile.value));
        item.insert(QStringLiteral("state"), QString::fromStdString(tile.state));
        tiles_.push_back(item);
    }

    annunciators_.clear();
    for (const auto& item : page.annunciators) {
        if (item == "SYSTEMS NOMINAL") annunciators_.push_back(QString::fromStdString(UiLocale::text(language_, "systems_nominal")));
        else annunciators_.push_back(QString::fromStdString(item));
    }
    emit dataChanged();
}

} // namespace nexvary::avionics
