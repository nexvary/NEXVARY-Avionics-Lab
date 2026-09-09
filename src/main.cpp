#include "app/AvionicsLab.hpp"
#include "app/ConsoleCockpit.hpp"
#include "sim/ScenarioEngine.hpp"
#include <chrono>
#include <exception>
#include <iostream>
#include <string>

using namespace nexvary::avionics;

int main(int argc, char** argv) {
    std::string scenarioName = "nominal";
    int ticks = 40;
    bool replay = false;

    for (int i = 1; i < argc; ++i) {
        const std::string arg = argv[i];
        if (arg == "--scenario" && i + 1 < argc) scenarioName = argv[++i];
        else if (arg == "--ticks" && i + 1 < argc) ticks = std::stoi(argv[++i]);
        else if (arg == "--replay") replay = true;
        else if (arg == "--list-scenarios") {
            for (const auto& name : ScenarioEngine::names()) std::cout << name << '\n';
            return 0;
        } else if (arg == "--help") {
            std::cout << "NEXVARY Avionics Lab (training/simulation only)\n"
                         "  --scenario <name>    nominal | power-transient | sensor-dropout | thermal-rise\n"
                         "  --ticks <n>          simulation ticks (default 40)\n"
                         "  --replay             replay recorded frame summaries\n"
                         "  --list-scenarios     list built-in scenarios\n";
            return 0;
        }
    }

    if (ticks < 1 || ticks > 100000) {
        std::cerr << "ticks must be between 1 and 100000\n";
        return 2;
    }

    try {
        AvionicsLab lab(ScenarioEngine::fromName(scenarioName));
        LabSnapshot last;
        for (int i = 0; i < ticks; ++i) last = lab.step(std::chrono::milliseconds{100});
        ConsoleCockpit::render(std::cout, last);
        std::cout << " RECORDED FRAMES: " << lab.recorder().size()
                  << " | EVENT COUNT: " << lab.eventLog().size() << "\n";

        if (replay) {
            ReplayCursor cursor(lab.recorder());
            std::size_t count = 0;
            while (auto frame = cursor.next()) {
                if (count % 10 == 0 || !cursor.hasNext()) {
                    std::cout << " REPLAY seq=" << frame->sequence
                              << " time_ms=" << frame->simTime.count()
                              << " sensors=" << frame->sensors.size() << '\n';
                }
                ++count;
            }
        }
        return 0;
    } catch (const std::exception& ex) {
        std::cerr << "error: " << ex.what() << '\n';
        return 1;
    }
}
