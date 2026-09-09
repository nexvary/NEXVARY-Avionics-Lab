#include "core/AlertManager.hpp"
#include <cassert>

using namespace nexvary::avionics;

int main() {
    AlertManager manager;
    manager.update({{Severity::Warning, "power", "low voltage"}}, 3);
    assert(manager.activeCount() == 1);
    const auto first = manager.active().front();
    assert(first.firstSeenTick == 3);

    manager.update({{Severity::Warning, "power", "low voltage"}}, 4);
    assert(manager.activeCount() == 1);
    assert(manager.active().front().lastSeenTick == 4);

    manager.update({}, 5);
    assert(manager.activeCount() == 0);
    assert(manager.history().size() == 1);
    return 0;
}
