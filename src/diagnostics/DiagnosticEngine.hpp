#pragma once
#include "core/EventLog.hpp"
#include "core/SensorBus.hpp"
#include "core/SystemHealth.hpp"
#include "core/TelemetryRecorder.hpp"
#include "diagnostics/DiagnosticTypes.hpp"
#include <cstdint>
#include <map>
#include <string_view>
#include <vector>

namespace nexvary::avionics {

class DiagnosticEngine {
public:
    [[nodiscard]] static DiagnosticSummary analyze(
        std::string_view scenario,
        std::uint64_t tick,
        const std::map<std::string, SensorSample>& sensors,
        const std::vector<HealthIssue>& issues,
        const TelemetryRecorder& recorder,
        const EventLog& events);

    [[nodiscard]] static bool containsCode(const DiagnosticSummary& summary, std::string_view code) noexcept;
};

} // namespace nexvary::avionics
