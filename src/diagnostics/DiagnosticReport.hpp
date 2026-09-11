#pragma once
#include "diagnostics/DiagnosticTypes.hpp"
#include <string>
#include <string_view>

namespace nexvary::avionics {

class DiagnosticReport {
public:
    [[nodiscard]] static std::string toJson(const DiagnosticSummary& summary);
    [[nodiscard]] static DiagnosticSummary fromJson(std::string_view jsonText);
    [[nodiscard]] static std::string toMarkdown(const DiagnosticSummary& summary);
    static void writeJson(const std::string& path, const DiagnosticSummary& summary);
    static void writeMarkdown(const std::string& path, const DiagnosticSummary& summary);
};

} // namespace nexvary::avionics
