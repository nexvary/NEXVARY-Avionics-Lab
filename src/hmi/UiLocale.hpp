#pragma once
#include <string>
#include <string_view>

namespace nexvary::avionics {

enum class UiLanguage {
    English,
    Arabic,
    Turkish,
    Spanish,
    German,
    Italian,
    French,
    Urdu,
    Persian,
    Russian
};

class UiLocale {
public:
    [[nodiscard]] static UiLanguage fromCode(std::string_view code) noexcept;
    [[nodiscard]] static std::string code(UiLanguage language);
    [[nodiscard]] static bool isRtl(UiLanguage language) noexcept;
    [[nodiscard]] static std::string text(UiLanguage language, std::string_view key);
};

} // namespace nexvary::avionics
