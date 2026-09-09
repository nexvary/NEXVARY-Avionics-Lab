#include "release/ReleaseManifest.hpp"
#include <nlohmann/json.hpp>
#include <cassert>
using namespace nexvary::avionics::build;
int main(){const auto deps=ReleaseManifest::dependencies();assert(deps.size()==4);const auto j=nlohmann::json::parse(ReleaseManifest::toJson());assert(j.at("schema")=="nexvary-avionics-release-manifest/v1");assert(j.at("scope")=="training-simulation-only");assert(j.at("dependencies").size()==4);for(const auto& dep:j.at("dependencies")){assert(!dep.at("name").get<std::string>().empty());assert(!dep.at("license").get<std::string>().empty());assert(!dep.at("source").get<std::string>().empty());}return 0;}
