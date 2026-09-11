#pragma once
#include "diagnostics/DiagnosticTypes.hpp"
#include <cstdint>
#include <string>
#include <vector>

namespace nexvary::avionics {

struct DiagnosticHistoryRow {
    std::string code;
    std::uint64_t firstTick{0};
    std::uint64_t lastTick{0};
    std::size_t scansSeen{0};
    bool active{false};
};

class DiagnosticHistory {
public:
    void ingest(const DiagnosticSummary& summary);
    void clear() noexcept;
    [[nodiscard]] const std::vector<DiagnosticHistoryRow>& rows() const noexcept;
    [[nodiscard]] std::size_t activeCount() const noexcept;
    [[nodiscard]] std::size_t recurrentCount(std::size_t minimumScans = 2) const noexcept;
private:
    std::vector<DiagnosticHistoryRow> rows_;
};

} // namespace nexvary::avionics
