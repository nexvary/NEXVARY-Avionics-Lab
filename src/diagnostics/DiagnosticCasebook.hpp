#pragma once
#include "diagnostics/DiagnosticTypes.hpp"
#include <string>
#include <string_view>
#include <vector>

namespace nexvary::avionics {

class DiagnosticCasebook {
public:
    [[nodiscard]] static std::string toJson(const std::vector<DiagnosticCaseRecord>& records);
    [[nodiscard]] static std::vector<DiagnosticCaseRecord> fromJson(std::string_view jsonText);
    static void writeFile(const std::string& path, const std::vector<DiagnosticCaseRecord>& records);
    [[nodiscard]] static std::vector<DiagnosticCaseRecord> readFile(const std::string& path);
};

} // namespace nexvary::avionics
