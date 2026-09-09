#include "core/EventLog.hpp"
#include "core/SensorBus.hpp"
#include "core/SystemHealth.hpp"
#include "core/Watchdog.hpp"
#include <cassert>
#include <chrono>
#include <thread>

using namespace nexvary::avionics;

int main() {
    SensorBus bus;
    bus.publish("cpu_temp_c", {90.0, "C", true});
    bus.publish("bus_voltage_v", {27.0, "V", true});
    assert(bus.read("cpu_temp_c").has_value());

    SystemHealth health;
    const auto issues = health.evaluate(bus);
    assert(!issues.empty());

    EventLog log;
    log.push(Severity::Info, "test", "hello");
    assert(log.size() == 1);

    Watchdog watchdog(std::chrono::milliseconds(20));
    watchdog.kick();
    assert(!watchdog.expired());
    std::this_thread::sleep_for(std::chrono::milliseconds(30));
    assert(watchdog.expired());

    return 0;
}
