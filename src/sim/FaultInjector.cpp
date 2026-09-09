#include "sim/FaultInjector.hpp"

namespace nexvary::avionics {

void FaultInjector::set(FaultSpec fault) {
    faults_[fault.id] = std::move(fault);
}

void FaultInjector::remove(const std::string& id) { faults_.erase(id); }
void FaultInjector::clear() { faults_.clear(); }

std::vector<FaultSpec> FaultInjector::active() const {
    std::vector<FaultSpec> result;
    for (const auto& [id, fault] : faults_) {
        (void)id;
        if (fault.enabled) result.push_back(fault);
    }
    return result;
}

void FaultInjector::apply(SensorBus& bus) const {
    for (const auto& [id, fault] : faults_) {
        (void)id;
        if (!fault.enabled) continue;
        auto sample = bus.read(fault.sensor);
        if (!sample) continue;
        switch (fault.mode) {
            case FaultMode::Invalidate:
                sample->valid = false;
                break;
            case FaultMode::Override:
                sample->value = fault.value;
                break;
            case FaultMode::Offset:
                sample->value += fault.value;
                break;
        }
        bus.publish(fault.sensor, *sample);
    }
}

} // namespace nexvary::avionics
