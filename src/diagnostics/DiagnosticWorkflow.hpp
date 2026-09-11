#pragma once
#include "diagnostics/DiagnosticTypes.hpp"
#include <cstdint>
#include <string>

namespace nexvary::avionics {

class DiagnosticWorkflow {
public:
    [[nodiscard]] static bool canTransition(DiagnosticWorkflowState from, DiagnosticWorkflowState to) noexcept;
    static bool transition(DiagnosticCaseRecord& record, DiagnosticWorkflowState to, std::uint64_t tick, std::string note = {});
};

} // namespace nexvary::avionics
