#pragma once
#include "core/TelemetryRecorder.hpp"
#include <cstddef>
#include <string>
#include <vector>

namespace nexvary::avionics {

enum class VerificationLevel { Info, Warning, Error };
struct VerificationFinding { VerificationLevel level{VerificationLevel::Info}; std::string code; std::string message; std::size_t frameIndex{0}; };
struct VerificationSummary {
    std::vector<VerificationFinding> findings;
    std::size_t warningCount{0};
    std::size_t errorCount{0};
    [[nodiscard]] bool passed() const noexcept { return errorCount == 0; }
};
class SessionVerifier {
public:
    [[nodiscard]] static VerificationSummary verify(const std::vector<TelemetryFrame>& frames);
};
const char* to_string(VerificationLevel level) noexcept;

} // namespace nexvary::avionics
