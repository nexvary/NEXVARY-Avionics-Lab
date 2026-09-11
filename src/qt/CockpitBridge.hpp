#pragma once

#include "app/AvionicsLab.hpp"
#include "diagnostics/DiagnosticHistory.hpp"
#include "diagnostics/DiagnosticTypes.hpp"
#include "hmi/CockpitViewModel.hpp"
#include "hmi/UiLocale.hpp"
#include <QObject>
#include <QStringList>
#include <QVariantList>
#include <string>

namespace nexvary::avionics {

class CockpitBridge final : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList tiles READ tiles NOTIFY dataChanged)
    Q_PROPERTY(QVariantList sensorRows READ sensorRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList eventRows READ eventRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList trendRows READ trendRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList twinRows READ twinRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList faultPresets READ faultPresets NOTIFY dataChanged)
    Q_PROPERTY(QVariantList presentationFaultPresets READ presentationFaultPresets NOTIFY dataChanged)
    Q_PROPERTY(QVariantList activeFaultRows READ activeFaultRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList performanceSeries READ performanceSeries NOTIFY dataChanged)
    Q_PROPERTY(QVariantList diagnosticFindings READ diagnosticFindings NOTIFY dataChanged)
    Q_PROPERTY(QVariantList diagnosticRecommendations READ diagnosticRecommendations NOTIFY dataChanged)
    Q_PROPERTY(QVariantList diagnosticHistoryRows READ diagnosticHistoryRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList platformProfiles READ platformProfiles NOTIFY dataChanged)
    Q_PROPERTY(QString activePlatformId READ activePlatformId NOTIFY dataChanged)
    Q_PROPERTY(QString activePlatformName READ activePlatformName NOTIFY dataChanged)
    Q_PROPERTY(QString activePlatformCategory READ activePlatformCategory NOTIFY dataChanged)
    Q_PROPERTY(QString activePlatformPropulsion READ activePlatformPropulsion NOTIFY dataChanged)
    Q_PROPERTY(QStringList annunciators READ annunciators NOTIFY dataChanged)
    Q_PROPERTY(QString scenario READ scenario NOTIFY dataChanged)
    Q_PROPERTY(qulonglong tick READ tick NOTIFY dataChanged)
    Q_PROPERTY(int recordedFrames READ recordedFrames NOTIFY dataChanged)
    Q_PROPERTY(int activeAlertCount READ activeAlertCount NOTIFY dataChanged)
    Q_PROPERTY(int activeTrainingFaultCount READ activeTrainingFaultCount NOTIFY dataChanged)
    Q_PROPERTY(int sensorCount READ sensorCount NOTIFY dataChanged)
    Q_PROPERTY(int eventCount READ eventCount NOTIFY dataChanged)
    Q_PROPERTY(int trendWindow READ trendWindow NOTIFY dataChanged)
    Q_PROPERTY(int twinNominalCount READ twinNominalCount NOTIFY dataChanged)
    Q_PROPERTY(int twinDegradedCount READ twinDegradedCount NOTIFY dataChanged)
    Q_PROPERTY(int twinFaultCount READ twinFaultCount NOTIFY dataChanged)
    Q_PROPERTY(int twinUnknownCount READ twinUnknownCount NOTIFY dataChanged)
    Q_PROPERTY(int diagnosticHealthScore READ diagnosticHealthScore NOTIFY dataChanged)
    Q_PROPERTY(int diagnosticFindingCount READ diagnosticFindingCount NOTIFY dataChanged)
    Q_PROPERTY(int diagnosticFaultCount READ diagnosticFaultCount NOTIFY dataChanged)
    Q_PROPERTY(int diagnosticWarningCount READ diagnosticWarningCount NOTIFY dataChanged)
    Q_PROPERTY(int diagnosticRecurrentCount READ diagnosticRecurrentCount NOTIFY dataChanged)
    Q_PROPERTY(qulonglong diagnosticScanTick READ diagnosticScanTick NOTIFY dataChanged)
    Q_PROPERTY(QString diagnosticFingerprint READ diagnosticFingerprint NOTIFY dataChanged)
    Q_PROPERTY(bool replayMode READ replayMode NOTIFY dataChanged)
    Q_PROPERTY(bool replayPaused READ replayPaused NOTIFY dataChanged)
    Q_PROPERTY(int replayIndex READ replayIndex NOTIFY dataChanged)
    Q_PROPERTY(int replayMaximum READ replayMaximum NOTIFY dataChanged)
    Q_PROPERTY(QString replayTime READ replayTime NOTIFY dataChanged)
    Q_PROPERTY(QString language READ language NOTIFY languageChanged)
    Q_PROPERTY(bool rtl READ rtl NOTIFY languageChanged)
    Q_PROPERTY(QStringList scenarios READ scenarios CONSTANT)

public:
    explicit CockpitBridge(QObject* parent = nullptr);

    QVariantList tiles() const;
    QVariantList sensorRows() const;
    QVariantList eventRows() const;
    QVariantList trendRows() const;
    QVariantList twinRows() const;
    QVariantList faultPresets() const;
    QVariantList presentationFaultPresets() const;
    QVariantList activeFaultRows() const;
    QVariantList performanceSeries() const;
    QVariantList diagnosticFindings() const;
    QVariantList diagnosticRecommendations() const;
    QVariantList diagnosticHistoryRows() const;
    QVariantList platformProfiles() const;
    QString activePlatformId() const;
    QString activePlatformName() const;
    QString activePlatformCategory() const;
    QString activePlatformPropulsion() const;
    QStringList annunciators() const;
    QString scenario() const;
    qulonglong tick() const noexcept;
    int recordedFrames() const noexcept;
    int activeAlertCount() const noexcept;
    int activeTrainingFaultCount() const noexcept;
    int sensorCount() const noexcept;
    int eventCount() const noexcept;
    int trendWindow() const noexcept;
    int twinNominalCount() const noexcept;
    int twinDegradedCount() const noexcept;
    int twinFaultCount() const noexcept;
    int twinUnknownCount() const noexcept;
    int diagnosticHealthScore() const noexcept;
    int diagnosticFindingCount() const noexcept;
    int diagnosticFaultCount() const noexcept;
    int diagnosticWarningCount() const noexcept;
    int diagnosticRecurrentCount() const noexcept;
    qulonglong diagnosticScanTick() const noexcept;
    QString diagnosticFingerprint() const;
    bool replayMode() const noexcept;
    bool replayPaused() const noexcept;
    int replayIndex() const noexcept;
    int replayMaximum() const noexcept;
    QString replayTime() const;
    QString language() const;
    bool rtl() const noexcept;
    QStringList scenarios() const;

    Q_INVOKABLE void step();
    Q_INVOKABLE void resetLab();
    Q_INVOKABLE void setScenario(const QString& name);
    Q_INVOKABLE void setLanguage(const QString& code);
    Q_INVOKABLE QString text(const QString& key) const;
    Q_INVOKABLE void setReplayMode(bool enabled);
    Q_INVOKABLE void setReplayPaused(bool paused);
    Q_INVOKABLE void seekReplay(int index);
    Q_INVOKABLE void setTrendWindow(int frames);
    Q_INVOKABLE void applyTrainingFault(const QString& presetId);
    Q_INVOKABLE void clearTrainingFaults();
    Q_INVOKABLE void runDiagnosticScan();
    Q_INVOKABLE void clearDiagnosticHistory();
    Q_INVOKABLE QString diagnosticReportJson() const;
    Q_INVOKABLE QString diagnosticReportMarkdown() const;
    Q_INVOKABLE void setActivePlatform(const QString& id);

signals:
    void dataChanged();
    void languageChanged();

private:
    void refresh(const LabSnapshot& snapshot);
    void showReplayFrame();
    void refreshTrends();
    void refreshTwin();
    void rebuildDiagnosticRows();

    AvionicsLab lab_;
    CockpitViewModel viewModel_;
    UiLanguage language_{UiLanguage::English};
    LabSnapshot snapshot_;
    QVariantList tiles_;
    QVariantList sensorRows_;
    QVariantList eventRows_;
    QVariantList trendRows_;
    QVariantList twinRows_;
    QVariantList diagnosticFindings_;
    QVariantList diagnosticRecommendations_;
    QVariantList diagnosticHistoryRows_;
    QStringList annunciators_;
    DiagnosticSummary diagnosticSummary_;
    DiagnosticHistory diagnosticHistory_;
    std::string activePlatformId_{"generic-jet"};
    bool replayMode_{false};
    bool replayPaused_{false};
    int replayIndex_{0};
    int trendWindow_{60};
    int twinNominalCount_{0};
    int twinDegradedCount_{0};
    int twinFaultCount_{0};
    int twinUnknownCount_{0};
};

} // namespace nexvary::avionics
