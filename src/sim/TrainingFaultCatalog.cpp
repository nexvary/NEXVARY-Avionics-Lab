#include "sim/TrainingFaultCatalog.hpp"
#include <algorithm>

namespace nexvary::avionics {
namespace {
const std::vector<TrainingFaultPreset> kPresets{
    {"imu-dropout", "fault_imu_dropout", "fault_imu_dropout_detail",
     {"training-imu-dropout", "imu_pitch_deg", FaultMode::Invalidate, 0.0, true}},
    {"low-power-bus", "fault_low_power", "fault_low_power_detail",
     {"training-low-power", "bus_voltage_v", FaultMode::Override, 20.5, true}},
    {"compute-hot", "fault_compute_hot", "fault_compute_hot_detail",
     {"training-compute-hot", "cpu_temp_c", FaultMode::Override, 91.0, true}},
};
}

const std::vector<TrainingFaultPreset>& TrainingFaultCatalog::presets() { return kPresets; }

std::optional<TrainingFaultPreset> TrainingFaultCatalog::find(std::string_view id) {
    const auto it = std::find_if(kPresets.begin(), kPresets.end(),
        [id](const TrainingFaultPreset& preset) { return preset.id == id; });
    if (it == kPresets.end()) return std::nullopt;
    return *it;
}

} // namespace nexvary::avionics
