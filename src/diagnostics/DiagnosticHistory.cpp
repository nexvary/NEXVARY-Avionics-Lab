#include "diagnostics/DiagnosticHistory.hpp"
#include <algorithm>

namespace nexvary::avionics {

void DiagnosticHistory::ingest(const DiagnosticSummary& summary) {
    for (auto& row : rows_) row.active = false;
    for (const auto& finding : summary.findings) {
        const auto it = std::find_if(rows_.begin(), rows_.end(), [&](const DiagnosticHistoryRow& row) { return row.code == finding.code; });
        if (it == rows_.end()) {
            rows_.push_back({finding.code, summary.generatedTick, summary.generatedTick, 1, true});
        } else {
            it->lastTick = summary.generatedTick;
            ++it->scansSeen;
            it->active = true;
        }
    }
    std::sort(rows_.begin(), rows_.end(), [](const DiagnosticHistoryRow& a, const DiagnosticHistoryRow& b) {
        if (a.active != b.active) return a.active > b.active;
        if (a.lastTick != b.lastTick) return a.lastTick > b.lastTick;
        return a.code < b.code;
    });
}

void DiagnosticHistory::clear() noexcept { rows_.clear(); }
const std::vector<DiagnosticHistoryRow>& DiagnosticHistory::rows() const noexcept { return rows_; }

std::size_t DiagnosticHistory::activeCount() const noexcept {
    return static_cast<std::size_t>(std::count_if(rows_.begin(), rows_.end(), [](const DiagnosticHistoryRow& row) { return row.active; }));
}

std::size_t DiagnosticHistory::recurrentCount(std::size_t minimumScans) const noexcept {
    return static_cast<std::size_t>(std::count_if(rows_.begin(), rows_.end(), [&](const DiagnosticHistoryRow& row) { return row.scansSeen >= minimumScans; }));
}

} // namespace nexvary::avionics
