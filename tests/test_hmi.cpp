#include "hmi/CockpitViewModel.hpp"
#include <cassert>
#include <string>

using namespace nexvary::avionics;

int main() {
    CockpitViewModel vm;
    AvionicsLab nominal{ScenarioKind::Nominal};
    const auto page = vm.build(nominal.step());
    assert(page.tiles.size() == 8);
    for (const auto& tile : page.tiles) assert(tile.state == "NOMINAL");
    assert(!page.annunciators.empty());
    assert(page.annunciators.front() == "SYSTEMS NOMINAL");

    AvionicsLab power{ScenarioKind::PowerTransient};
    CockpitPage faultPage;
    for (int i = 0; i < 25; ++i) faultPage = vm.build(power.step());
    bool observed = false;
    for (const auto& text : faultPage.annunciators) {
        if (text.find("power") != std::string::npos) observed = true;
    }
    assert(observed);
    return 0;
}
