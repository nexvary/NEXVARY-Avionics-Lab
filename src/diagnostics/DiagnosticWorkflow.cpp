#include "diagnostics/DiagnosticWorkflow.hpp"
#include <utility>

namespace nexvary::avionics {

bool DiagnosticWorkflow::canTransition(DiagnosticWorkflowState from, DiagnosticWorkflowState to) noexcept {
    if (from == to) return true;
    switch (from) {
        case DiagnosticWorkflowState::Detected:
            return to == DiagnosticWorkflowState::Isolating;
        case DiagnosticWorkflowState::Isolating:
            return to == DiagnosticWorkflowState::Recovering || to == DiagnosticWorkflowState::Verifying;
        case DiagnosticWorkflowState::Recovering:
            return to == DiagnosticWorkflowState::Verifying || to == DiagnosticWorkflowState::Isolating;
        case DiagnosticWorkflowState::Verifying:
            return to == DiagnosticWorkflowState::Closed || to == DiagnosticWorkflowState::Recovering || to == DiagnosticWorkflowState::Isolating;
        case DiagnosticWorkflowState::Closed:
            return false;
    }
    return false;
}

bool DiagnosticWorkflow::transition(DiagnosticCaseRecord& record, DiagnosticWorkflowState to, std::uint64_t tick, std::string note) {
    if (!canTransition(record.state, to)) return false;
    record.state = to;
    record.updatedTick = tick;
    if (!note.empty()) record.notes.push_back(std::move(note));
    return true;
}

} // namespace nexvary::avionics
