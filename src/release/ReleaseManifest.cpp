#include "release/ReleaseManifest.hpp"
#include "release/BuildIdentity.hpp"
#include <nlohmann/json.hpp>

namespace nexvary::avionics::build {
std::vector<DependencyRecord> ReleaseManifest::dependencies(){return {{"nlohmann-json","3.12.0","MIT","JSON session/report serialization","https://github.com/nlohmann/json",false},{"CLI11","2.6.2","BSD-3-Clause","developer CLI parsing","https://github.com/CLIUtils/CLI11",false},{"Qt","6.8.3","LGPL-3.0-or-later OR GPL-3.0-or-later OR commercial","Windows/Linux HMI runtime","https://www.qt.io/",true},{"Inno Setup","6.x","custom permissive/freeware terms","Windows installer build tool","https://jrsoftware.org/isinfo.php",true}};}
std::string ReleaseManifest::toJson(){nlohmann::json j;j["schema"]="nexvary-avionics-release-manifest/v1";j["product"]=std::string(BuildIdentity::product);j["version"]=std::string(BuildIdentity::version);j["stage"]=BuildIdentity::stage;j["channel"]=std::string(BuildIdentity::channel);j["scope"]="training-simulation-only";j["dependencies"]=nlohmann::json::array();for(const auto& dep:dependencies())j["dependencies"].push_back({{"name",dep.name},{"version",dep.version},{"license",dep.license},{"role",dep.role},{"source",dep.source},{"optional",dep.optional}});return j.dump(2);}
} // namespace nexvary::avionics::build
