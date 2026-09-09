#pragma once
#include <string>
#include <string_view>

namespace nexvary::avionics {

enum class UiLanguage { English, Arabic };

class UiLocale {
public:
    [[nodiscard]] static UiLanguage fromCode(std::string_view code) noexcept;
    [[nodiscard]] static bool isRtl(UiLanguage language) noexcept;
    [[nodiscard]] static std::string text(UiLanguage language, std::string_view key);
};

} // namespace nexvary::avionics
