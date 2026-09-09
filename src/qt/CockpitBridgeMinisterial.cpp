#include "qt/CockpitBridge.hpp"
#include "sim/TrainingFaultCatalog.hpp"
#include <QVariantMap>
#include <algorithm>
#include <array>
#include <limits>

namespace nexvary::avionics {

QVariantList CockpitBridge::presentationFaultPresets() const {
    QVariantList rows;
    const auto active = lab_.activeTrainingFaults();
    for (const auto& preset : TrainingFaultCatalog::presets()) {
        QVariantMap item;
        item["id"] = QString::fromStdString(preset.id);
        item["faultId"] = QString::fromStdString(preset.fault.id);
        item["label"] = QString::fromStdString(UiLocale::text(language_, preset.labelKey));
        item["detail"] = QString::fromStdString(UiLocale::text(language_, preset.detailKey));
        item["sensor"] = QString::fromStdString(UiLocale::text(language_, preset.fault.sensor));
        switch (preset.fault.mode) {
            case FaultMode::Invalidate: item["mode"] = QStringLiteral("INVALIDATE"); break;
            case FaultMode::Override: item["mode"] = QStringLiteral("OVERRIDE"); break;
            case FaultMode::Offset: item["mode"] = QStringLiteral("OFFSET"); break;
        }
        const bool isActive = std::any_of(active.begin(), active.end(), [&](const auto& fault) {
            return fault.id == preset.fault.id;
        });
        item["active"] = isActive;
        rows.push_back(item);
    }
    return rows;
}

QVariantList CockpitBridge::performanceSeries() const {
    struct Definition { const char* id; };
    static constexpr std::array<Definition, 4> definitions{{
        {"cpu_temp_c"}, {"bus_voltage_v"}, {"hydraulic_pressure_pct"}, {"fuel_level_pct"}
    }};

    QVariantList rows;
    const auto& frames = lab_.recorder().frames();
    const std::size_t begin = frames.size() > 60 ? frames.size() - 60 : 0;

    for (const auto& definition : definitions) {
        QVariantList values;
        double minimum = std::numeric_limits<double>::infinity();
        double maximum = -std::numeric_limits<double>::infinity();
        QString unit;
        for (std::size_t i = begin; i < frames.size(); ++i) {
            const auto sensor = frames[i].sensors.find(definition.id);
            if (sensor == frames[i].sensors.end() || !sensor->second.valid) continue;
            const double value = sensor->second.value;
            values.push_back(value);
            minimum = std::min(minimum, value);
            maximum = std::max(maximum, value);
            unit = QString::fromStdString(sensor->second.unit);
        }
        if (values.isEmpty()) {
            minimum = 0.0;
            maximum = 1.0;
        } else if (minimum == maximum) {
            minimum -= 1.0;
            maximum += 1.0;
        }
        QVariantMap row;
        row["id"] = QString::fromLatin1(definition.id);
        row["label"] = QString::fromStdString(UiLocale::text(language_, definition.id));
        row["unit"] = unit;
        row["values"] = values;
        row["minimum"] = minimum;
        row["maximum"] = maximum;
        row["latest"] = values.isEmpty() ? 0.0 : values.constLast().toDouble();
        rows.push_back(row);
    }
    return rows;
}

} // namespace nexvary::avionics
