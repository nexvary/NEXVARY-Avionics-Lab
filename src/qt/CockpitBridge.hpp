#pragma once

#include "air_ops/AirOperationsIntegration.hpp"
#include "app/AvionicsLab.hpp"
#include "diagnostics/DiagnosticHistory.hpp"
#include "diagnostics/DiagnosticTypes.hpp"
#include "force/ForceManagement.hpp"
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
    Q_PROPERTY(QVariantList airOperationsTracks READ airOperationsTracks NOTIFY dataChanged)
    Q_PROPERTY(QVariantList airOperationsIncidents READ airOperationsIncidents NOTIFY dataChanged)
    Q_PROPERTY(QString airOperationsSource READ airOperationsSource NOTIFY dataChanged)
    Q_PROPERTY(QString airOperationsMode READ airOperationsMode NOTIFY dataChanged)
    Q_PROPERTY(QString airOperationsStatus READ airOperationsStatus NOTIFY dataChanged)
    Q_PROPERTY(int airOperationsTrackCount READ airOperationsTrackCount NOTIFY dataChanged)
    Q_PROPERTY(int airOperationsIncidentCount READ airOperationsIncidentCount NOTIFY dataChanged)
    Q_PROPERTY(int airOperationsHighCount READ airOperationsHighCount NOTIFY dataChanged)
    Q_PROPERTY(qulonglong airOperationsObservationCount READ airOperationsObservationCount NOTIFY dataChanged)
    Q_PROPERTY(QVariantList readinessAssets READ readinessAssets NOTIFY dataChanged)
    Q_PROPERTY(QVariantList readinessMaintenanceRows READ readinessMaintenanceRows NOTIFY dataChanged)
    Q_PROPERTY(int readinessFleetPercent READ readinessFleetPercent NOTIFY dataChanged)
    Q_PROPERTY(int readinessReadyCount READ readinessReadyCount NOTIFY dataChanged)
    Q_PROPERTY(int readinessMaintenanceOpenCount READ readinessMaintenanceOpenCount NOTIFY dataChanged)
    Q_PROPERTY(int readinessCrewPercent READ readinessCrewPercent NOTIFY dataChanged)
    Q_PROPERTY(QString readinessStatus READ readinessStatus NOTIFY dataChanged)
    Q_PROPERTY(QVariantList forceBases READ forceBases NOTIFY dataChanged)
    Q_PROPERTY(QVariantList forceSquadrons READ forceSquadrons NOTIFY dataChanged)
    Q_PROPERTY(QVariantList forceTrainingRows READ forceTrainingRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList forceMaintenancePlanRows READ forceMaintenancePlanRows NOTIFY dataChanged)
    Q_PROPERTY(QVariantList forceExecutiveReports READ forceExecutiveReports NOTIFY dataChanged)
    Q_PROPERTY(int forceAvailableBaseCount READ forceAvailableBaseCount NOTIFY dataChanged)
    Q_PROPERTY(int forceAssignedPlatformCount READ forceAssignedPlatformCount NOTIFY dataChanged)
    Q_PROPERTY(int forceReadyPlatformCount READ forceReadyPlatformCount NOTIFY dataChanged)
    Q_PROPERTY(int forceFleetReadinessPercent READ forceFleetReadinessPercent NOTIFY dataChanged)
    Q_PROPERTY(int forceCrewReadinessPercent READ forceCrewReadinessPercent NOTIFY dataChanged)
    Q_PROPERTY(int forceWeatherConstraintCount READ forceWeatherConstraintCount NOTIFY dataChanged)
    Q_PROPERTY(int forceOpenMaintenanceCount READ forceOpenMaintenanceCount NOTIFY dataChanged)
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
    QVariantList airOperationsTracks() const;
    QVariantList airOperationsIncidents() const;
    QString airOperationsSource() const;
    QString airOperationsMode() const;
    QString airOperationsStatus() const;
    int airOperationsTrackCount() const noexcept;
    int airOperationsIncidentCount() const noexcept;
    int airOperationsHighCount() const noexcept;
    qulonglong airOperationsObservationCount() const noexcept;
    QVariantList readinessAssets() const;
    QVariantList readinessMaintenanceRows() const;
    int readinessFleetPercent() const noexcept;
    int readinessReadyCount() const noexcept;
    int readinessMaintenanceOpenCount() const noexcept;
    int readinessCrewPercent() const noexcept;
    QString readinessStatus() const;
    QVariantList forceBases() const;
    QVariantList forceSquadrons() const;
    QVariantList forceTrainingRows() const;
    QVariantList forceMaintenancePlanRows() const;
    QVariantList forceExecutiveReports() const;
    int forceAvailableBaseCount() const noexcept;
    int forceAssignedPlatformCount() const noexcept;
    int forceReadyPlatformCount() const noexcept;
    int forceFleetReadinessPercent() const noexcept;
    int forceCrewReadinessPercent() const noexcept;
    int forceWeatherConstraintCount() const noexcept;
    int forceOpenMaintenanceCount() const noexcept;
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
    Q_INVOKABLE bool loadAirOperationsReplay(const QString& path);
    Q_INVOKABLE void resetAirOperationsDemo();

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
    AirOperationsIntegration airOperations_{AirOperationsIntegration::demo()};
    ForceManagementSnapshot forceManagement_{ForceManagementSnapshot::syntheticTraining()};
    QString airOperationsStatus_{QStringLiteral("DEMO / REPLAY READY")};
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
