#include "core/EventLog.hpp"
#include "core/SensorBus.hpp"
#include "core/SystemHealth.hpp"
#include "core/Watchdog.hpp"
#include <chrono>
#include <iostream>

using namespace nexvary::avionics;

int main() {
    std::cout << "NEXVARY AVIONICS LAB v0.1.0\n";
    std::cout << "TRAINING / SIMULATION CORE\n\n";

    SensorBus bus;
    EventLog log;
    Watchdog watchdog(std::chrono::milliseconds(1500));
    SystemHealth health;

    bus.publish("cpu_temp_c", {58.5, "C", true});
    bus.publish("bus_voltage_v", {27.4, "V", true});
    bus.publish("imu_pitch_deg", {2.1, "deg", true});
    bus.publish("imu_roll_deg", {-1.2, "deg", true});

    log.push(Severity::Info, "core", "simulation initialized");
    watchdog.kick();

    std::cout << "[SENSOR BUS]\n";
    for (const auto& [name, sample] : bus.snapshot()) {
        std::cout << "  " << name << " = " << sample.value << ' ' << sample.unit
                  << (sample.valid ? " [OK]" : " [INVALID]") << '\n';
    }

    const auto issues = health.evaluate(bus);
    std::cout << "\n[SYSTEM HEALTH] " << (issues.empty() ? "NOMINAL" : "ATTENTION") << '\n';
    for (const auto& issue : issues) {
        std::cout << "  [" << to_string(issue.severity) << "] "
                  << issue.subsystem << ": " << issue.detail << '\n';
    }

    std::cout << "\n[EVENT LOG] " << log.size() << " event(s)\n";
    std::cout << "[WATCHDOG] " << (watchdog.expired() ? "EXPIRED" : "ARMED") << '\n';
    return 0;
}
