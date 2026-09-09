#pragma once
#include <map>
#include <mutex>
#include <optional>
#include <string>

namespace nexvary::avionics {

struct SensorSample {
    double value{};
    std::string unit;
    bool valid{true};
};

class SensorBus {
public:
    void publish(std::string name, SensorSample sample);
    [[nodiscard]] std::optional<SensorSample> read(const std::string& name) const;
    [[nodiscard]] std::map<std::string, SensorSample> snapshot() const;
    void clear();

private:
    mutable std::mutex mutex_;
    std::map<std::string, SensorSample> sensors_;
};

} // namespace nexvary::avionics
