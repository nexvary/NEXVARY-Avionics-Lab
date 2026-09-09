#include "qt/CockpitBridge.hpp"
#include <QVariantMap>
#include <cassert>

using namespace nexvary::avionics;

namespace {
QVariantMap findRow(const QVariantList& rows, const QString& id) {
    for (const auto& row : rows) {
        const auto map = row.toMap();
        if (map.value("id").toString() == id) return map;
    }
    return {};
}
}

int main() {
    CockpitBridge bridge;
    assert(bridge.trendWindow() == 60);
    assert(!bridge.trendRows().isEmpty());
    assert(bridge.twinRows().size() == 5);
    assert(bridge.twinNominalCount() == 5);
    assert(bridge.faultPresets().size() == 3);
    assert(bridge.activeTrainingFaultCount() == 0);

    for (int i = 0; i < 80; ++i) bridge.step();
    auto bus = findRow(bridge.trendRows(), QStringLiteral("bus_voltage_v"));
    assert(bus.value("samples").toULongLong() == 60);
    assert(bus.value("quality").toDouble() == 100.0);

    bridge.setTrendWindow(20);
    assert(bridge.trendWindow() == 20);
    bus = findRow(bridge.trendRows(), QStringLiteral("bus_voltage_v"));
    assert(bus.value("samples").toULongLong() == 20);

    bridge.setScenario(QStringLiteral("sensor-dropout"));
    for (int i = 0; i < 15; ++i) bridge.step();
    const auto pitch = findRow(bridge.trendRows(), QStringLiteral("imu_pitch_deg"));
    assert(pitch.value("invalid").toULongLong() > 0);
    auto flightTwin = findRow(bridge.twinRows(), QStringLiteral("flight_sensors"));
    assert(flightTwin.value("state").toString() == QStringLiteral("FAULT"));
    assert(bridge.twinFaultCount() > 0);

    bridge.setScenario(QStringLiteral("nominal"));
    bridge.applyTrainingFault(QStringLiteral("low-power-bus"));
    assert(bridge.activeTrainingFaultCount() == 1);
    assert(bridge.activeFaultRows().size() == 1);
    auto powerTwin = findRow(bridge.twinRows(), QStringLiteral("power"));
    assert(powerTwin.value("state").toString() == QStringLiteral("DEGRADED"));

    bridge.clearTrainingFaults();
    assert(bridge.activeTrainingFaultCount() == 0);
    powerTwin = findRow(bridge.twinRows(), QStringLiteral("power"));
    assert(powerTwin.value("state").toString() == QStringLiteral("NOMINAL"));

    bridge.applyTrainingFault(QStringLiteral("imu-dropout"));
    flightTwin = findRow(bridge.twinRows(), QStringLiteral("flight_sensors"));
    assert(flightTwin.value("state").toString() == QStringLiteral("FAULT"));
    bridge.resetLab();
    assert(bridge.activeTrainingFaultCount() == 0);

    bridge.setLanguage(QStringLiteral("ar"));
    assert(bridge.rtl());
    const auto arabicTwin = findRow(bridge.twinRows(), QStringLiteral("flight_sensors"));
    assert(!arabicTwin.value("label").toString().isEmpty());
    const auto presets = bridge.faultPresets();
    assert(!presets.first().toMap().value("label").toString().isEmpty());
    return 0;
}
