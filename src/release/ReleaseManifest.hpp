#pragma once
#include <string>
#include <vector>

namespace nexvary::avionics::build {

struct DependencyRecord {
    std::string name;
    std::string version;
    std::string license;
    std::string role;
    std::string source;
    bool optional{false};
};

class ReleaseManifest {
public:
    [[nodiscard]] static std::vector<DependencyRecord> dependencies();
    [[nodiscard]] static std::string toJson();
};

} // namespace nexvary::avionics::build
