#include "hmi/UiLocale.hpp"
#include <array>
#include <cassert>
#include <string_view>

using namespace nexvary::avionics;

int main() {
    const std::array<std::string_view, 10> codes{"ar","en","tr","es","de","it","fr","ur","fa","ru"};
    for (const auto code : codes) {
        const auto language = UiLocale::fromCode(code);
        assert(UiLocale::code(language) == code);
        assert(!UiLocale::text(language, "app_title").empty());
        assert(!UiLocale::text(language, "back").empty());
        assert(!UiLocale::text(language, "about_us").empty());
    }

    assert(UiLocale::isRtl(UiLanguage::Arabic));
    assert(UiLocale::isRtl(UiLanguage::Urdu));
    assert(UiLocale::isRtl(UiLanguage::Persian));
    assert(!UiLocale::isRtl(UiLanguage::English));
    assert(!UiLocale::isRtl(UiLanguage::Turkish));
    assert(UiLocale::text(UiLanguage::English, "altitude_m") == "ALTITUDE");
    assert(UiLocale::text(UiLanguage::Arabic, "altitude_m") != "ALTITUDE");
    assert(UiLocale::text(UiLanguage::Turkish, "mfd") == "KOMUTA PANELİ");
    assert(UiLocale::text(UiLanguage::Russian, "about_system") == "О СИСТЕМЕ");
    return 0;
}
