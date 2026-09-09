#pragma once
#include "app/AvionicsLab.hpp"
#include "hmi/CockpitViewModel.hpp"
#include "hmi/UiLocale.hpp"
#include <QObject>
#include <QStringList>
#include <QVariantList>

namespace nexvary::avionics {

class CockpitBridge final : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList tiles READ tiles NOTIFY dataChanged)
    Q_PROPERTY(QVariantList sensorRows READ sensorRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList eventRows READ eventRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList trendRows READ trendRows NOTIFY dataChanged)
    Q_PROPERTY(QStringList annunciators READ annunciators NOTIFY dataChanged)
    Q_PROPERTY(QString scenario READ scenario NOTIFY dataChanged)
    Q_PROPERTY(qulonglong tick READ tick NOTIFY dataChanged)
    Q_PROPERTY(int recordedFrames READ recordedFrames NOTIFY dataChanged)
    Q_PROPERTY(int activeAlertCount READ activeAlertCount NOTIFY dataChanged)
    Q_PROPERTY(int sensorCount READ sensorCount NOTIFY dataChanged)
    Q_PROPERTY(int eventCount READ eventCount NOTIFY dataChanged)
    Q_PROPERTY(int trendWindow READ trendWindow NOTIFY dataChanged)
    Q_PROPERTY(bool replayMode READ replayMode NOTIFY dataChanged)
    Q_PROPERTY(int replayIndex READ replayIndex NOTIFY dataChanged)
    Q_PROPERTY(int replayMaximum READ replayMaximum NOTIFY dataChanged)
    Q_PROPERTY(QString language READ language NOTIFY languageChanged)
    Q_PROPERTY(bool rtl READ rtl NOTIFY languageChanged)
    Q_PROPERTY(QStringList scenarios READ scenarios CONSTANT)

public:
    explicit CockpitBridge(QObject* parent = nullptr);

    QVariantList tiles() const;
    QVariantList sensorRows() const;
    QVariantList eventRows() const;
    QVariantList trendRows() const;
    QStringList annunciators() const;
    QString scenario() const;
    qulonglong tick() const noexcept;
    int recordedFrames() const noexcept;
    int activeAlertCount() const noexcept;
    int sensorCount() const noexcept;
    int eventCount() const noexcept;
    int trendWindow() const noexcept;
    bool replayMode() const noexcept;
    int replayIndex() const noexcept;
    int replayMaximum() const noexcept;
    QString language() const;
    bool rtl() const noexcept;
    QStringList scenarios() const;

    Q_INVOKABLE void step();
    Q_INVOKABLE void resetLab();
    Q_INVOKABLE void setScenario(const QString& name);
    Q_INVOKABLE void setLanguage(const QString& code);
    Q_INVOKABLE QString text(const QString& key) const;
    Q_INVOKABLE void setReplayMode(bool enabled);
    Q_INVOKABLE void seekReplay(int index);
    Q_INVOKABLE void setTrendWindow(int frames);

signals:
    void dataChanged();
    void languageChanged();

private:
    void refresh(const LabSnapshot& snapshot);
    void showReplayFrame();
    void refreshTrends();

    AvionicsLab lab_;
    CockpitViewModel viewModel_;
    UiLanguage language_{UiLanguage::English};
    LabSnapshot snapshot_;
    QVariantList tiles_;
    QVariantList sensorRows_;
    QVariantList eventRows_;
    QVariantList trendRows_;
    QStringList annunciators_;
    bool replayMode_{false};
    int replayIndex_{0};
    int trendWindow_{60};
};

} // namespace nexvary::avionics
