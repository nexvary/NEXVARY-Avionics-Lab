#include "hmi/UiLocale.hpp"
#include <cassert>

using namespace nexvary::avionics;

int main() {
    assert(UiLocale::fromCode("ar") == UiLanguage::Arabic);
    assert(UiLocale::fromCode("en") == UiLanguage::English);
    assert(UiLocale::isRtl(UiLanguage::Arabic));
    assert(!UiLocale::isRtl(UiLanguage::English));
    assert(UiLocale::text(UiLanguage::English, "altitude_m") == "ALTITUDE");
    assert(UiLocale::text(UiLanguage::Arabic, "altitude_m") != "ALTITUDE");
    return 0;
}
