#include "app/AvionicsLab.hpp"
#include "app/ConsoleCockpit.hpp"
#include "config/RunProfile.hpp"
#include "diagnostics/Diagnostics.hpp"
#include "io/SessionArchive.hpp"
#include "report/LabReport.hpp"
#include "sim/ScenarioEngine.hpp"
#include <CLI/CLI.hpp>
#include <chrono>
#include <exception>
#include <iostream>
#include <string>

using namespace nexvary::avionics;

int main(int argc, char** argv) {
    CLI::App app{"NEXVARY Avionics Lab — training/simulation only"};
    app.set_version_flag("--version", "NEXVARY Avionics Lab 0.12.0");

    std::string scenarioName = "nominal";
    std::string profilePath;
    std::string exportPath;
    std::string inspectPath;
    std::string reportJson;
    std::string reportMd;
    std::string logLevel = "warn";
    std::string logFile;
    int ticks = 40;
    int stepMs = 100;
    bool replay = false;
    bool list = false;

    auto* scenarioOpt = app.add_option("--scenario", scenarioName, "Synthetic scenario");
    auto* ticksOpt = app.add_option("--ticks", ticks, "Simulation ticks")->check(CLI::Range(1, 100000));
    auto* stepOpt = app.add_option("--step-ms", stepMs, "Simulation step milliseconds")->check(CLI::Range(10, 10000));
    app.add_option("--profile", profilePath, "JSON training run profile");
    app.add_flag("--replay", replay, "Replay summaries");
    app.add_flag("--list-scenarios", list, "List scenarios");
    app.add_option("--export-json", exportPath, "Export JSON training session");
    app.add_option("--inspect-json", inspectPath, "Inspect JSON training session");
    app.add_option("--report-json", reportJson, "Write verification report as JSON");
    app.add_option("--report-md", reportMd, "Write verification report as Markdown");
    app.add_option("--log-level", logLevel, "Diagnostics: trace|debug|info|warn|error|critical|off")
        ->check(CLI::IsMember({"trace", "debug", "info", "warn", "error", "critical", "off"}));
    app.add_option("--log-file", logFile, "Optional diagnostics log file");

    CLI11_PARSE(app, argc, argv);

    bool diagnosticsReady = false;
    try {
        Diagnostics::initialize(logLevel, logFile);
        diagnosticsReady = true;

        if (!profilePath.empty()) {
            const auto profile = RunProfile::readFile(profilePath);
            if (scenarioOpt->count() == 0) scenarioName = profile.scenario;
            if (ticksOpt->count() == 0) ticks = profile.ticks;
            if (stepOpt->count() == 0) stepMs = profile.stepMs;
            if (exportPath.empty()) exportPath = profile.exportSession;
            if (reportJson.empty()) reportJson = profile.reportJson;
            if (reportMd.empty()) reportMd = profile.reportMarkdown;
            Diagnostics::info("loaded synthetic training run profile");
        }

        if (list) {
            for (const auto& name : ScenarioEngine::names()) std::cout << name << '\n';
            Diagnostics::shutdown();
            return 0;
        }

        if (!inspectPath.empty()) {
            const auto data = SessionArchive::readFile(inspectPath);
            std::cout << "SESSION schema=" << data.schema
                      << " scenario=" << data.scenario
                      << " frames=" << data.frames.size()
                      << " events=" << data.events.size() << '\n';
            Diagnostics::info("inspected synthetic training session archive");
            Diagnostics::shutdown();
            return 0;
        }

        Diagnostics::info("starting synthetic simulation scenario=" + scenarioName +
                          " ticks=" + std::to_string(ticks) +
                          " step_ms=" + std::to_string(stepMs));

        AvionicsLab lab(ScenarioEngine::fromName(scenarioName));
        LabSnapshot last;
        for (int i = 0; i < ticks; ++i) {
            last = lab.step(std::chrono::milliseconds{stepMs});
        }

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

        if (!exportPath.empty()) {
            SessionArchive::writeFile(exportPath, scenarioName, lab.recorder(), lab.eventLog());
            std::cout << " SESSION EXPORTED: " << exportPath << '\n';
            Diagnostics::info("exported synthetic training session archive");
        }

        const auto report = LabReport::analyze(scenarioName, lab.recorder(), lab.eventLog());
        if (!reportJson.empty()) LabReport::writeJson(reportJson, report);
        if (!reportMd.empty()) LabReport::writeMarkdown(reportMd, report);

        Diagnostics::info("synthetic simulation completed");
        Diagnostics::shutdown();
        return 0;
    } catch (const std::exception& ex) {
        if (diagnosticsReady) {
            Diagnostics::error(ex.what());
            Diagnostics::shutdown();
        }
        std::cerr << "error: " << ex.what() << '\n';
        return 1;
    }
}
