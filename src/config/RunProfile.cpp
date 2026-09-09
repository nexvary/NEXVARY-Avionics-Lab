#include "config/RunProfile.hpp"
#include <nlohmann/json.hpp>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <stdexcept>
namespace nexvary::avionics {
static void validatePath(const std::string&p){if(p.size()>4096)throw std::runtime_error("profile output path too long");}
TrainingRunProfile RunProfile::parse(std::string_view text){auto j=nlohmann::json::parse(text.begin(),text.end());if(!j.is_object()||j.value("schema",std::string{})!=Schema)throw std::runtime_error("unsupported profile schema");TrainingRunProfile p;p.scenario=j.value("scenario",std::string{"nominal"});p.ticks=j.value("ticks",40);p.stepMs=j.value("step_ms",100);p.exportSession=j.value("export_session",std::string{});p.reportJson=j.value("report_json",std::string{});p.reportMarkdown=j.value("report_markdown",std::string{});if(p.scenario.empty()||p.scenario.size()>64)throw std::runtime_error("invalid profile scenario");if(p.ticks<1||p.ticks>100000)throw std::runtime_error("profile ticks outside 1..100000");if(p.stepMs<10||p.stepMs>10000)throw std::runtime_error("profile step_ms outside 10..10000");validatePath(p.exportSession);validatePath(p.reportJson);validatePath(p.reportMarkdown);return p;}
TrainingRunProfile RunProfile::readFile(const std::string&path){if(std::filesystem::file_size(path)>MaxFileBytes)throw std::runtime_error("profile exceeds 1 MiB");std::ifstream i(path,std::ios::binary);if(!i)throw std::runtime_error("unable to open profile");std::ostringstream b;b<<i.rdbuf();return parse(b.str());}
}
