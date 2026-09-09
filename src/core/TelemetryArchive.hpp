#pragma once
#include "core/TelemetryRecorder.hpp"
#include <cstddef>
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

namespace nexvary::avionics {

struct TelemetryArchiveSummary {
    std::size_t frameCount{0};
    std::size_t sensorSampleCount{0};
    std::size_t invalidSampleCount{0};
    bool sequenceMonotonic{true};
    bool timeMonotonic{true};
    std::uint64_t checksum{0};
};

class TelemetryArchive {
public:
    [[nodiscard]] static std::string encode(const std::vector<TelemetryFrame>& frames);
    [[nodiscard]] static std::vector<TelemetryFrame> decode(std::string_view archive);
    [[nodiscard]] static TelemetryArchiveSummary inspect(const std::vector<TelemetryFrame>& frames);
    [[nodiscard]] static std::uint64_t checksum(std::string_view bytes) noexcept;
    [[nodiscard]] static std::string verificationReport(const std::vector<TelemetryFrame>& frames);
};

} // namespace nexvary::avionics
