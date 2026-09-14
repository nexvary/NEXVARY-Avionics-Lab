#pragma once
#include <string_view>

namespace nexvary::avionics::build {
struct BuildIdentity {
    static constexpr std::string_view product{"NEXVARY Avionics Lab"};
    static constexpr std::string_view version{"3.4.0"};
    static constexpr int stage{1970};
    static constexpr std::string_view channel{"training-simulation"};
};
} // namespace nexvary::avionics::build
