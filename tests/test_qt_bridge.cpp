#include "qt/CockpitBridge.hpp"
#include <QVariantMap>
#include <cassert>

using namespace nexvary::avionics;

namespace {
QVariantMap findTrend(const QVariantList& rows, const QString& id) {
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

    for (int i = 0; i < 80; ++i) bridge.step();
    auto bus = findTrend(bridge.trendRows(), QStringLiteral("bus_voltage_v"));
    assert(!bus.isEmpty());
    assert(bus.value("samples").toULongLong() == 60);
    assert(bus.value("quality").toDouble() == 100.0);

    bridge.setTrendWindow(20);
    assert(bridge.trendWindow() == 20);
    bus = findTrend(bridge.trendRows(), QStringLiteral("bus_voltage_v"));
    assert(bus.value("samples").toULongLong() == 20);

    bridge.setTrendWindow(-1);
    assert(bridge.trendWindow() == 0);

    bridge.setScenario(QStringLiteral("sensor-dropout"));
    for (int i = 0; i < 40; ++i) bridge.step();
    const auto pitch = findTrend(bridge.trendRows(), QStringLiteral("imu_pitch_deg"));
    assert(!pitch.isEmpty());
    assert(pitch.value("invalid").toULongLong() > 0);
    assert(pitch.value("quality").toDouble() < 100.0);

    bridge.setLanguage(QStringLiteral("ar"));
    const auto arabicPitch = findTrend(bridge.trendRows(), QStringLiteral("imu_pitch_deg"));
    assert(!arabicPitch.value("label").toString().isEmpty());
    assert(bridge.rtl());
    return 0;
}
