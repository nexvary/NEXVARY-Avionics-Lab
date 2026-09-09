#pragma once
#include "app/AvionicsLab.hpp"
#include <string>
#include <vector>

namespace nexvary::avionics {

struct CockpitTile {
    std::string id;
    std::string label;
    std::string value;
    std::string state;
};

struct CockpitPage {
    std::string title;
    std::string subtitle;
    std::vector<CockpitTile> tiles;
    std::vector<std::string> annunciators;
};

class CockpitViewModel {
public:
    [[nodiscard]] CockpitPage build(const LabSnapshot& snapshot) const;
};

} // namespace nexvary::avionics
