#include "app/AvionicsLab.hpp"
#include "app/ConsoleCockpit.hpp"
#include "config/RunProfile.hpp"
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
    app.set_version_flag("--version", "NEXVARY Avionics Lab 1.3.0");
    std::string scenarioName{"nominal"}, profilePath, exportPath, inspectPath, reportJson, reportMd;
    int ticks = 40, stepMs = 100, trendWindow = 0;
    bool replay = false, list = false;
    auto* scenarioOpt = app.add_option("--scenario", scenarioName, "Synthetic scenario");
    auto* ticksOpt = app.add_option("--ticks", ticks, "Simulation ticks")->check(CLI::Range(1, 100000));
    auto* stepOpt = app.add_option("--step-ms", stepMs, "Simulation step milliseconds")->check(CLI::Range(10, 10000));
    app.add_option("--trend-window", trendWindow, "Report statistics over the latest N frames; 0 means all")->check(CLI::Range(0, 100000));
    app.add_option("--profile", profilePath, "JSON training run profile");
    app.add_flag("--replay", replay, "Replay summaries");
    app.add_flag("--list-scenarios", list, "List scenarios");
    app.add_option("--export-json", exportPath, "Export JSON training session");
    app.add_option("--inspect-json", inspectPath, "Inspect JSON training session");
    app.add_option("--report-json", reportJson, "Write verification/trend report as JSON");
    app.add_option("--report-md", reportMd, "Write verification/trend report as Markdown");
    CLI11_PARSE(app, argc, argv);
    try {
        if (!profilePath.empty()) {
            const auto profile = RunProfile::readFile(profilePath);
            if (scenarioOpt->count() == 0) scenarioName = profile.scenario;
            if (ticksOpt->count() == 0) ticks = profile.ticks;
            if (stepOpt->count() == 0) stepMs = profile.stepMs;
            if (exportPath.empty()) exportPath = profile.exportSession;
            if (reportJson.empty()) reportJson = profile.reportJson;
            if (reportMd.empty()) reportMd = profile.reportMarkdown;
        }
        if (list) { for (const auto& name : ScenarioEngine::names()) std::cout << name << '\n'; return 0; }
        if (!inspectPath.empty()) {
            const auto data = SessionArchive::readFile(inspectPath);
            std::cout << "SESSION schema=" << data.schema << " scenario=" << data.scenario << " frames=" << data.frames.size() << " events=" << data.events.size() << '\n';
            return 0;
        }
        AvionicsLab lab(ScenarioEngine::fromName(scenarioName));
        LabSnapshot last;
        for (int i = 0; i < ticks; ++i) last = lab.step(std::chrono::milliseconds{stepMs});
        ConsoleCockpit::render(std::cout, last);
        std::cout << " RECORDED FRAMES: " << lab.recorder().size() << " | EVENT COUNT: " << lab.eventLog().size() << '\n';
        if (replay) {
            ReplayCursor cursor(lab.recorder()); std::size_t count = 0;
            while (auto frame = cursor.next()) {
                if (count % 10 == 0 || !cursor.hasNext()) std::cout << " REPLAY seq=" << frame->sequence << " time_ms=" << frame->simTime.count() << " sensors=" << frame->sensors.size() << '\n';
                ++count;
            }
        }
        if (!exportPath.empty()) SessionArchive::writeFile(exportPath, scenarioName, lab.recorder(), lab.eventLog());
        const auto report = LabReport::analyze(scenarioName, lab.recorder(), lab.eventLog(), static_cast<std::size_t>(trendWindow));
        if (!reportJson.empty()) LabReport::writeJson(reportJson, report);
        if (!reportMd.empty()) LabReport::writeMarkdown(reportMd, report);
        return 0;
    } catch (const std::exception& ex) { std::cerr << "error: " << ex.what() << '\n'; return 1; }
}
