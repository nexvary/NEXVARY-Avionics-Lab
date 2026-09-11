#include "diagnostics/DiagnosticComparator.hpp"
#include <algorithm>
#include <iterator>
#include <set>

namespace nexvary::avionics {

DiagnosticComparison DiagnosticComparator::compare(const DiagnosticSummary& baseline, const DiagnosticSummary& current) {
    std::set<std::string> before;
    std::set<std::string> after;
    for (const auto& finding : baseline.findings) before.insert(finding.code);
    for (const auto& finding : current.findings) after.insert(finding.code);

    DiagnosticComparison result;
    result.healthDelta = current.healthScore - baseline.healthScore;
    std::set_difference(after.begin(), after.end(), before.begin(), before.end(), std::back_inserter(result.newCodes));
    std::set_difference(before.begin(), before.end(), after.begin(), after.end(), std::back_inserter(result.resolvedCodes));
    std::set_intersection(before.begin(), before.end(), after.begin(), after.end(), std::back_inserter(result.persistentCodes));
    return result;
}

} // namespace nexvary::avionics
