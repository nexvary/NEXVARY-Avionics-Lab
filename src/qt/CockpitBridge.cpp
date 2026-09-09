#include "qt/CockpitBridge.hpp"
#include "core/TelemetryTrend.hpp"
#include "sim/ScenarioEngine.hpp"
#include <QVariantMap>
#include <algorithm>
#include <cmath>
#include <stdexcept>

namespace nexvary::avionics {

CockpitBridge::CockpitBridge(QObject* parent)
    : QObject(parent), lab_(ScenarioKind::Nominal) {
    refresh(lab_.step());
}

QVariantList CockpitBridge::tiles() const { return tiles_; }
QVariantList CockpitBridge::sensorRows() const { return sensorRows_; }
QVariantList CockpitBridge::eventRows() const { return eventRows_; }
QVariantList CockpitBridge::trendRows() const { return trendRows_; }
QStringList CockpitBridge::annunciators() const { return annunciators_; }

QString CockpitBridge::scenario() const {
    return QString::fromUtf8(ScenarioEngine::toString(snapshot_.scenario));
}

qulonglong CockpitBridge::tick() const noexcept { return snapshot_.tick; }
int CockpitBridge::recordedFrames() const noexcept { return static_cast<int>(lab_.recorder().size()); }
int CockpitBridge::sensorCount() const noexcept { return static_cast<int>(snapshot_.sensors.size()); }
int CockpitBridge::eventCount() const noexcept { return static_cast<int>(lab_.eventLog().size()); }
int CockpitBridge::trendWindow() const noexcept { return trendWindow_; }

int CockpitBridge::activeAlertCount() const noexcept {
    int count = 0;
    for (const auto& alert : snapshot_.alerts) {
        if (alert.active) ++count;
    }
    return count;
}

bool CockpitBridge::replayMode() const noexcept { return replayMode_; }
int CockpitBridge::replayIndex() const noexcept { return replayIndex_; }
int CockpitBridge::replayMaximum() const noexcept {
    return lab_.recorder().size() > 0 ? static_cast<int>(lab_.recorder().size() - 1) : 0;
}

QString CockpitBridge::language() const {
    return language_ == UiLanguage::Arabic ? QStringLiteral("ar") : QStringLiteral("en");
}

bool CockpitBridge::rtl() const noexcept { return UiLocale::isRtl(language_); }

QStringList CockpitBridge::scenarios() const {
    QStringList result;
    for (const auto& name : ScenarioEngine::names()) {
        result.push_back(QString::fromStdString(name));
    }
    return result;
}

void CockpitBridge::step() {
    if (replayMode_) {
        if (replayIndex_ < replayMaximum()) ++replayIndex_;
        showReplayFrame();
        return;
    }
    refresh(lab_.step());
}

void CockpitBridge::resetLab() {
    replayMode_ = false;
    replayIndex_ = 0;
    lab_.reset();
    refresh(lab_.step());
}

void CockpitBridge::setScenario(const QString& name) {
    try {
        replayMode_ = false;
        replayIndex_ = 0;
        lab_.setScenario(ScenarioEngine::fromName(name.toStdString()));
        lab_.reset();
        refresh(lab_.step());
    } catch (const std::invalid_argument&) {
        // Ignore invalid UI input; scenario choices are normally constrained by the model.
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

void CockpitBridge::setReplayMode(bool enabled) {
    if (enabled && lab_.recorder().size() == 0) return;
    replayMode_ = enabled;
    if (enabled) {
        replayIndex_ = 0;
        showReplayFrame();
    } else {
        refresh(lab_.snapshot());
    }
}

void CockpitBridge::seekReplay(int index) {
    if (!replayMode_) return;
    replayIndex_ = std::clamp(index, 0, replayMaximum());
    showReplayFrame();
}

void CockpitBridge::setTrendWindow(int frames) {
    const int normalized = std::clamp(frames, 0, 5000);
    if (normalized == trendWindow_) return;
    trendWindow_ = normalized;
    refreshTrends();
    emit dataChanged();
}

void CockpitBridge::showReplayFrame() {
    const auto frame = lab_.recorder().frame(static_cast<std::size_t>(replayIndex_));
    if (!frame) return;

    LabSnapshot replay = snapshot_;
    replay.tick = frame->sequence;
    replay.simTime = frame->simTime;
    replay.sensors = frame->sensors;
    replay.issues.clear();
    replay.alerts.clear();
    refresh(replay);
}

void CockpitBridge::refreshTrends() {
    trendRows_.clear();
    const auto trends = TelemetryTrendAnalyzer::analyze(
        lab_.recorder().frames(),
        static_cast<std::size_t>(trendWindow_));

    for (const auto& [name, trend] : trends) {
        QVariantMap item;
        item["id"] = QString::fromStdString(name);
        item["label"] = QString::fromStdString(UiLocale::text(language_, name));
        item["unit"] = QString::fromStdString(trend.unit);
        item["samples"] = static_cast<qulonglong>(trend.samples);
        item["valid"] = static_cast<qulonglong>(trend.validSamples);
        item["invalid"] = static_cast<qulonglong>(trend.invalidSamples);
        item["missing"] = static_cast<qulonglong>(trend.missingSamples);
        item["minimum"] = trend.minimum;
        item["maximum"] = trend.maximum;
        item["mean"] = trend.mean;
        item["latest"] = trend.latest;
        item["delta"] = trend.delta;
        item["slope"] = trend.slopePerSecond;
        item["hasValid"] = trend.hasValidSamples;

        const auto selectedWindow = trend.samples + trend.missingSamples;
        const double quality = selectedWindow == 0
            ? 0.0
            : (100.0 * static_cast<double>(trend.validSamples) / static_cast<double>(selectedWindow));
        item["quality"] = std::round(quality * 10.0) / 10.0;
        trendRows_.push_back(item);
    }
}

void CockpitBridge::refresh(const LabSnapshot& snapshot) {
    snapshot_ = snapshot;
    const auto page = viewModel_.build(snapshot_);

    tiles_.clear();
    for (const auto& tile : page.tiles) {
        QVariantMap item;
        item["id"] = QString::fromStdString(tile.id);
        item["label"] = QString::fromStdString(UiLocale::text(language_, tile.id));
        item["value"] = QString::fromStdString(tile.value);
        item["state"] = QString::fromStdString(tile.state);
        tiles_.push_back(item);
    }

    sensorRows_.clear();
    for (const auto& [name, sample] : snapshot_.sensors) {
        QVariantMap item;
        item["id"] = QString::fromStdString(name);
        item["label"] = QString::fromStdString(UiLocale::text(language_, name));
        item["value"] = sample.value;
        item["unit"] = QString::fromStdString(sample.unit);
        item["valid"] = sample.valid;
        sensorRows_.push_back(item);
    }

    eventRows_.clear();
    for (const auto& event : lab_.eventLog().snapshot()) {
        QVariantMap item;
        item["severity"] = QString::fromLatin1(to_string(event.severity));
        item["source"] = QString::fromStdString(event.source);
        item["message"] = QString::fromStdString(event.message);
        eventRows_.push_back(item);
    }

    refreshTrends();

    annunciators_.clear();
    if (replayMode_) {
        annunciators_.push_back(QString::fromStdString(UiLocale::text(language_, "replay_mode")));
    }
    for (const auto& annunciator : page.annunciators) {
        annunciators_.push_back(QString::fromStdString(
            annunciator == "SYSTEMS NOMINAL"
                ? UiLocale::text(language_, "systems_nominal")
                : annunciator));
    }

    emit dataChanged();
}

} // namespace nexvary::avionics
