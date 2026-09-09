#pragma once
#include "app/AvionicsLab.hpp"
#include <iosfwd>

namespace nexvary::avionics {

class ConsoleCockpit {
public:
    static void render(std::ostream& out, const LabSnapshot& snapshot);
};

} // namespace nexvary::avionics
