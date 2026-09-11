#pragma once
#include "diagnostics/DiagnosticTypes.hpp"

namespace nexvary::avionics {

class DiagnosticComparator {
public:
    [[nodiscard]] static DiagnosticComparison compare(const DiagnosticSummary& baseline, const DiagnosticSummary& current);
};

} // namespace nexvary::avionics
