#pragma once
#include "core/SensorBus.hpp"
#include <map>
#include <string>
#include <vector>

namespace nexvary::avionics {

enum class FaultMode { Invalidate, Override, Offset };

struct FaultSpec {
    std::string id;
    std::string sensor;
    FaultMode mode{FaultMode::Invalidate};
    double value{0.0};
    bool enabled{true};
};

class FaultInjector {
public:
    void set(FaultSpec fault);
    void remove(const std::string& id);
    void clear();
    [[nodiscard]] std::vector<FaultSpec> active() const;
    void apply(SensorBus& bus) const;

private:
    std::map<std::string, FaultSpec> faults_;
};

} // namespace nexvary::avionics
