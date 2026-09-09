#include "diagnostics/Diagnostics.hpp"
#include <cassert>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <stdexcept>
#include <string>

using namespace nexvary::avionics;

int main() {
    const auto path = std::filesystem::temp_directory_path() / "nexvary-avionics-diagnostics-test.log";
    std::filesystem::remove(path);

    Diagnostics::initialize("debug", path.string());
    assert(Diagnostics::initialized());
    Diagnostics::debug("diagnostic debug smoke");
    Diagnostics::info("diagnostic info smoke");
    Diagnostics::warn("diagnostic warning smoke");
    Diagnostics::flush();
    Diagnostics::shutdown();
    assert(!Diagnostics::initialized());

    std::ifstream input(path, std::ios::binary);
    const std::string contents{std::istreambuf_iterator<char>{input}, std::istreambuf_iterator<char>{}};
    assert(contents.find("diagnostic debug smoke") != std::string::npos);
    assert(contents.find("diagnostic warning smoke") != std::string::npos);
    input.close();
    std::filesystem::remove(path);

    bool rejected = false;
    try {
        Diagnostics::initialize("unknown-level");
    } catch (const std::invalid_argument&) {
        rejected = true;
    }
    assert(rejected);
    return 0;
}
