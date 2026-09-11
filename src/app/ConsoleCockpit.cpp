#include "app/ConsoleCockpit.hpp"
#include "core/EventLog.hpp"
#include "release/BuildIdentity.hpp"
#include "sim/ScenarioEngine.hpp"
#include <iomanip>
#include <ostream>

namespace nexvary::avionics {

void ConsoleCockpit::render(std::ostream& out, const LabSnapshot& s) {
    out << "\n============================================================\n";
    out << " NEXVARY AVIONICS LAB | TRAINING COCKPIT | v"
        << build::BuildIdentity::version << " | STAGE " << build::BuildIdentity::stage << "\n";
    out << "============================================================\n";
    out << " SCENARIO: " << ScenarioEngine::toString(s.scenario)
        << "   TICK: " << s.tick
        << "   SIM: " << s.simTime.count() << " ms\n";
    out << "------------------------------------------------------------\n";
    out << " FLIGHT / VEHICLE DATA (SYNTHETIC)\n";
    for (const auto& [name, sample] : s.sensors) {
        out << "  " << std::left << std::setw(25) << name
            << std::right << std::setw(10) << std::fixed << std::setprecision(2) << sample.value
            << ' ' << std::setw(6) << sample.unit
            << (sample.valid ? "  [OK]" : "  [INVALID]") << '\n';
    }
    out << "------------------------------------------------------------\n";
    out << " SYSTEM HEALTH: " << (s.issues.empty() ? "NOMINAL" : "ATTENTION")
        << " | ACTIVE ALERTS: " << s.alerts.size() << '\n';
    for (const auto& alert : s.alerts) {
        out << "  [" << to_string(alert.severity) << "] " << alert.subsystem
            << " - " << alert.message << "\n";
    }
    out << "============================================================\n";
}

} // namespace nexvary::avionics
