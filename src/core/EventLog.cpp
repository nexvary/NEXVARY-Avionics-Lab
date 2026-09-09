#include "core/EventLog.hpp"

namespace nexvary::avionics {

void EventLog::push(Severity severity, std::string source, std::string message) {
    std::scoped_lock lock(mutex_);
    events_.push_back({std::chrono::system_clock::now(), severity, std::move(source), std::move(message)});
}

std::vector<Event> EventLog::snapshot() const {
    std::scoped_lock lock(mutex_);
    return events_;
}

std::size_t EventLog::size() const {
    std::scoped_lock lock(mutex_);
    return events_.size();
}

const char* to_string(Severity severity) {
    switch (severity) {
        case Severity::Info: return "INFO";
        case Severity::Warning: return "WARN";
        case Severity::Fault: return "FAULT";
    }
    return "UNKNOWN";
}

} // namespace nexvary::avionics
