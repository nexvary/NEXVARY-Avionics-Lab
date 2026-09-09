#pragma once
#include <string>
#include <string_view>
namespace nexvary::avionics {
struct TrainingRunProfile {
    std::string scenario{"nominal"};
    int ticks{40};
    int stepMs{100};
    std::string exportSession;
    std::string reportJson;
    std::string reportMarkdown;
};
class RunProfile {
public:
    static constexpr std::string_view Schema="nexvary-training-profile/v1";
    static constexpr std::size_t MaxFileBytes=1024U*1024U;
    static TrainingRunProfile parse(std::string_view jsonText);
    static TrainingRunProfile readFile(const std::string& path);
};
}
