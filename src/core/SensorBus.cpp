#include "core/SensorBus.hpp"

namespace nexvary::avionics {

void SensorBus::publish(std::string name, SensorSample sample) {
    std::scoped_lock lock(mutex_);
    sensors_[std::move(name)] = std::move(sample);
}

std::optional<SensorSample> SensorBus::read(const std::string& name) const {
    std::scoped_lock lock(mutex_);
    const auto it = sensors_.find(name);
    if (it == sensors_.end()) return std::nullopt;
    return it->second;
}

std::map<std::string, SensorSample> SensorBus::snapshot() const {
    std::scoped_lock lock(mutex_);
    return sensors_;
}

} // namespace nexvary::avionics
