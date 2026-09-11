#include "qt/CockpitBridge.hpp"
#include "diagnostics/DiagnosticEngine.hpp"
#include "diagnostics/DiagnosticReport.hpp"
#include "sim/ScenarioEngine.hpp"
#include <QVariantMap>
#include <cmath>

namespace nexvary::avionics {

QVariantList CockpitBridge::diagnosticFindings() const { return diagnosticFindings_; }
QVariantList CockpitBridge::diagnosticRecommendations() const { return diagnosticRecommendations_; }
QVariantList CockpitBridge::diagnosticHistoryRows() const { return diagnosticHistoryRows_; }

int CockpitBridge::diagnosticHealthScore() const noexcept {
    return static_cast<int>(std::lround(diagnosticSummary_.healthScore));
}
int CockpitBridge::diagnosticFindingCount() const noexcept { return static_cast<int>(diagnosticSummary_.findings.size()); }
int CockpitBridge::diagnosticFaultCount() const noexcept { return static_cast<int>(diagnosticSummary_.faultCount); }
int CockpitBridge::diagnosticWarningCount() const noexcept { return static_cast<int>(diagnosticSummary_.warningCount); }
int CockpitBridge::diagnosticRecurrentCount() const noexcept { return static_cast<int>(diagnosticHistory_.recurrentCount()); }
qulonglong CockpitBridge::diagnosticScanTick() const noexcept { return static_cast<qulonglong>(diagnosticSummary_.generatedTick); }
QString CockpitBridge::diagnosticFingerprint() const { return QString::fromStdString(diagnosticSummary_.fingerprint); }

void CockpitBridge::runDiagnosticScan() {
    diagnosticSummary_ = DiagnosticEngine::analyze(
        ScenarioEngine::toString(snapshot_.scenario),
        snapshot_.tick,
        snapshot_.sensors,
        snapshot_.issues,
        lab_.recorder(),
        lab_.eventLog());
    diagnosticHistory_.ingest(diagnosticSummary_);
    rebuildDiagnosticRows();
    emit dataChanged();
}

void CockpitBridge::clearDiagnosticHistory() {
    diagnosticHistory_.clear();
    diagnosticHistoryRows_.clear();
    emit dataChanged();
}

QString CockpitBridge::diagnosticReportJson() const {
    return QString::fromStdString(DiagnosticReport::toJson(diagnosticSummary_));
}

QString CockpitBridge::diagnosticReportMarkdown() const {
    return QString::fromStdString(DiagnosticReport::toMarkdown(diagnosticSummary_));
}

void CockpitBridge::rebuildDiagnosticRows() {
    diagnosticFindings_.clear();
    for (const auto& finding : diagnosticSummary_.findings) {
        QVariantMap row;
        row["id"] = QString::fromStdString(finding.code);
        row["code"] = QString::fromStdString(finding.code);
        row["system"] = QString::fromStdString(finding.system);
        row["category"] = QString::fromStdString(finding.category);
        row["severity"] = QString::fromLatin1(diagnosticSeverityName(finding.severity));
        row["title"] = QString::fromStdString(finding.title);
        row["probableCause"] = QString::fromStdString(finding.probableCause);
        row["isolation"] = QString::fromStdString(finding.isolation);
        row["recovery"] = QString::fromStdString(finding.recovery);
        row["confidence"] = finding.confidence;
        row["confidencePercent"] = static_cast<int>(std::lround(finding.confidence * 100.0));
        row["priority"] = finding.priority;
        row["occurrences"] = static_cast<qulonglong>(finding.occurrences);
        row["evidenceCount"] = static_cast<qulonglong>(finding.evidence.size());
        if (!finding.evidence.empty()) {
            row["evidenceSource"] = QString::fromStdString(finding.evidence.front().source);
            row["evidenceKey"] = QString::fromStdString(finding.evidence.front().key);
            row["evidenceObservation"] = QString::fromStdString(finding.evidence.front().observation);
            row["evidenceExpected"] = QString::fromStdString(finding.evidence.front().expected);
        }
        diagnosticFindings_.push_back(row);
    }

    diagnosticRecommendations_.clear();
    for (const auto& recommendation : diagnosticSummary_.recommendations)
        diagnosticRecommendations_.push_back(QString::fromStdString(recommendation));

    diagnosticHistoryRows_.clear();
    for (const auto& history : diagnosticHistory_.rows()) {
        QVariantMap row;
        row["code"] = QString::fromStdString(history.code);
        row["firstTick"] = static_cast<qulonglong>(history.firstTick);
        row["lastTick"] = static_cast<qulonglong>(history.lastTick);
        row["scansSeen"] = static_cast<qulonglong>(history.scansSeen);
        row["active"] = history.active;
        diagnosticHistoryRows_.push_back(row);
    }
}

} // namespace nexvary::avionics
