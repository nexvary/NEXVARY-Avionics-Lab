#pragma once
#include <chrono>
#include <mutex>
#include <string>
#include <vector>

namespace nexvary::avionics {

enum class Severity { Info, Warning, Fault };

struct Event {
    std::chrono::system_clock::time_point timestamp;
    Severity severity;
    std::string source;
    std::string message;
};

class EventLog {
public:
    void push(Severity severity, std::string source, std::string message);
    [[nodiscard]] std::vector<Event> snapshot() const;
    [[nodiscard]] std::size_t size() const;

private:
    mutable std::mutex mutex_;
    std::vector<Event> events_;
};

const char* to_string(Severity severity);

} // namespace nexvary::avionics
