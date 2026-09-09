#pragma once
#include <string>
#include <vector>

namespace nexvary::avionics {

enum class InstrumentKind { Tape, Attitude, Numeric, Trend, Status };
struct InstrumentDefinition {
    std::string id;
    std::string titleKey;
    InstrumentKind kind{InstrumentKind::Numeric};
    std::vector<std::string> channels;
};
struct InstrumentCatalogValidation {
    bool valid{false};
    std::vector<std::string> errors;
};
class InstrumentCatalog {
public:
    [[nodiscard]] static const std::vector<InstrumentDefinition>& instruments();
    [[nodiscard]] static InstrumentCatalogValidation validate();
};
const char* to_string(InstrumentKind kind) noexcept;

} // namespace nexvary::avionics
