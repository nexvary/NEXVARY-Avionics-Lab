#include "diagnostics/DiagnosticCasebook.hpp"
#include <nlohmann/json.hpp>
#include <fstream>
#include <iterator>
#include <stdexcept>
#include <utility>

namespace nexvary::avionics {
namespace {
using json = nlohmann::json;

DiagnosticWorkflowState stateFromString(const std::string& value) {
    if (value == "ISOLATING") return DiagnosticWorkflowState::Isolating;
    if (value == "RECOVERING") return DiagnosticWorkflowState::Recovering;
    if (value == "VERIFYING") return DiagnosticWorkflowState::Verifying;
    if (value == "CLOSED") return DiagnosticWorkflowState::Closed;
    return DiagnosticWorkflowState::Detected;
}
}

std::string DiagnosticCasebook::toJson(const std::vector<DiagnosticCaseRecord>& records) {
    json rows = json::array();
    for (const auto& record : records) {
        rows.push_back({
            {"id", record.id},
            {"title", record.title},
            {"state", diagnosticWorkflowStateName(record.state)},
            {"opened_tick", record.openedTick},
            {"updated_tick", record.updatedTick},
            {"finding_codes", record.findingCodes},
            {"notes", record.notes}});
    }
    return json{{"schema", "nexvary-diagnostic-casebook/v1"}, {"scope", "training-simulation"}, {"cases", rows}}.dump(2);
}

std::vector<DiagnosticCaseRecord> DiagnosticCasebook::fromJson(std::string_view jsonText) {
    const auto root = json::parse(jsonText.begin(), jsonText.end());
    std::vector<DiagnosticCaseRecord> records;
    if (!root.contains("cases")) return records;
    for (const auto& item : root.at("cases")) {
        DiagnosticCaseRecord record;
        record.id = item.value("id", "");
        record.title = item.value("title", "");
        record.state = stateFromString(item.value("state", "DETECTED"));
        record.openedTick = item.value("opened_tick", std::uint64_t{0});
        record.updatedTick = item.value("updated_tick", std::uint64_t{0});
        if (item.contains("finding_codes")) record.findingCodes = item.at("finding_codes").get<std::vector<std::string>>();
        if (item.contains("notes")) record.notes = item.at("notes").get<std::vector<std::string>>();
        records.push_back(std::move(record));
    }
    return records;
}

void DiagnosticCasebook::writeFile(const std::string& path, const std::vector<DiagnosticCaseRecord>& records) {
    std::ofstream output(path, std::ios::binary | std::ios::trunc);
    if (!output) throw std::runtime_error("unable to open diagnostic casebook for writing: " + path);
    output << toJson(records);
    if (!output) throw std::runtime_error("failed to write diagnostic casebook: " + path);
}

std::vector<DiagnosticCaseRecord> DiagnosticCasebook::readFile(const std::string& path) {
    std::ifstream input(path, std::ios::binary);
    if (!input) throw std::runtime_error("unable to open diagnostic casebook: " + path);
    const std::string text{std::istreambuf_iterator<char>{input}, std::istreambuf_iterator<char>{}};
    return fromJson(text);
}

} // namespace nexvary::avionics
