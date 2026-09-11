#pragma once
#include <cstdint>
#include <string>
#include <vector>

namespace nexvary::avionics {

enum class DiagnosticSeverity { Advisory, Warning, Fault };
enum class DiagnosticWorkflowState { Detected, Isolating, Recovering, Verifying, Closed };

inline const char* diagnosticSeverityName(DiagnosticSeverity severity) noexcept {
    switch (severity) {
        case DiagnosticSeverity::Advisory: return "ADVISORY";
        case DiagnosticSeverity::Warning: return "WARNING";
        case DiagnosticSeverity::Fault: return "FAULT";
    }
    return "ADVISORY";
}

inline const char* diagnosticWorkflowStateName(DiagnosticWorkflowState state) noexcept {
    switch (state) {
        case DiagnosticWorkflowState::Detected: return "DETECTED";
        case DiagnosticWorkflowState::Isolating: return "ISOLATING";
        case DiagnosticWorkflowState::Recovering: return "RECOVERING";
        case DiagnosticWorkflowState::Verifying: return "VERIFYING";
        case DiagnosticWorkflowState::Closed: return "CLOSED";
    }
    return "DETECTED";
}

struct DiagnosticEvidence {
    std::string source;
    std::string key;
    std::string observation;
    std::string expected;
    std::uint64_t sequence{0};
    double weight{1.0};
};

struct DiagnosticFinding {
    std::string code;
    std::string system;
    std::string category;
    DiagnosticSeverity severity{DiagnosticSeverity::Advisory};
    std::string title;
    std::string probableCause;
    std::string isolation;
    std::string recovery;
    double confidence{0.0};
    int priority{0};
    std::size_t occurrences{1};
    bool recoveryVerified{false};
    std::vector<DiagnosticEvidence> evidence;
};

struct DiagnosticSummary {
    std::string schema{"nexvary-avionics-diagnostic/v1"};
    std::string scope{"training-simulation"};
    std::string scenario;
    std::uint64_t generatedTick{0};
    std::size_t frameCount{0};
    std::size_t eventCount{0};
    std::size_t sensorCount{0};
    std::size_t advisoryCount{0};
    std::size_t warningCount{0};
    std::size_t faultCount{0};
    double healthScore{100.0};
    std::string fingerprint;
    std::vector<DiagnosticFinding> findings;
    std::vector<std::string> recommendations;
};

struct DiagnosticComparison {
    double healthDelta{0.0};
    std::vector<std::string> newCodes;
    std::vector<std::string> resolvedCodes;
    std::vector<std::string> persistentCodes;
};

struct DiagnosticCaseRecord {
    std::string id;
    std::string title;
    DiagnosticWorkflowState state{DiagnosticWorkflowState::Detected};
    std::uint64_t openedTick{0};
    std::uint64_t updatedTick{0};
    std::vector<std::string> findingCodes;
    std::vector<std::string> notes;
};

} // namespace nexvary::avionics
