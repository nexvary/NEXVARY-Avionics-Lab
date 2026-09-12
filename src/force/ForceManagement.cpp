#include "force/ForceManagement.hpp"

#include <algorithm>
#include <numeric>

namespace nexvary::avionics {

ForceManagementSnapshot ForceManagementSnapshot::syntheticTraining() {
    ForceManagementSnapshot snapshot;
    snapshot.bases_ = {
        {"base-alpha", "TRAINING BASE ALPHA", "AVAILABLE", "VMC", 92},
        {"base-bravo", "TRAINING BASE BRAVO", "AVAILABLE", "VMC", 86},
        {"base-coastal", "COASTAL TRAINING FIELD", "REVIEW", "WIND", 81},
    };
    snapshot.squadrons_ = {
        {"wing-01", "TRAINING WING 01", "GENERIC JET", 8, 7, 4, 4},
        {"wing-02", "TRAINING WING 02", "TURBOPROP", 6, 5, 4, 4},
        {"wing-03", "TRAINING WING 03", "ROTORCRAFT", 5, 4, 3, 4},
        {"wing-04", "TRAINING WING 04", "UAV LAB", 7, 6, 3, 3},
    };
    snapshot.trainingSlots_ = {
        {"08:00", "WING 01", "Simulator systems familiarization", "CONFIRMED"},
        {"10:30", "WING 02", "Telemetry replay and trend analysis", "CONFIRMED"},
        {"13:00", "WING 03", "Fault Lab diagnostic exercise", "PLANNED"},
        {"15:30", "WING 04", "Digital Twin verification session", "PLANNED"},
    };
    snapshot.maintenancePlan_ = {
        {"P2", "JET-101", "Hydraulic evidence review", 14},
        {"P2", "JET-103", "Sensor calibration follow-up", 18},
        {"P3", "TRB-201", "Scheduled systems inspection", 21},
        {"P3", "UAV-402", "Telemetry archive integrity check", 26},
    };
    snapshot.executiveReports_ = {
        {"Executive readiness brief", "READY", "TODAY"},
        {"Maintenance risk summary", "READY", "TODAY"},
        {"Training throughput report", "DRAFT", "WEEK"},
        {"Fleet availability trend", "READY", "30 DAYS"},
    };
    return snapshot;
}

int ForceManagementSnapshot::availableBaseCount() const noexcept {
    return static_cast<int>(std::count_if(bases_.begin(), bases_.end(), [](const ForceBaseStatus& row) {
        return row.runwayState == "AVAILABLE";
    }));
}

int ForceManagementSnapshot::assignedPlatformCount() const noexcept {
    return std::accumulate(squadrons_.begin(), squadrons_.end(), 0, [](int total, const ForceSquadronStatus& row) {
        return total + row.assigned;
    });
}

int ForceManagementSnapshot::readyPlatformCount() const noexcept {
    return std::accumulate(squadrons_.begin(), squadrons_.end(), 0, [](int total, const ForceSquadronStatus& row) {
        return total + row.ready;
    });
}

int ForceManagementSnapshot::fleetReadinessPercent() const noexcept {
    const int assigned = assignedPlatformCount();
    return assigned == 0 ? 0 : (readyPlatformCount() * 100) / assigned;
}

int ForceManagementSnapshot::crewReadinessPercent() const noexcept {
    int ready = 0;
    int required = 0;
    for (const auto& row : squadrons_) {
        ready += row.crewReady;
        required += row.crewRequired;
    }
    return required == 0 ? 0 : (ready * 100) / required;
}

int ForceManagementSnapshot::weatherConstraintCount() const noexcept {
    return static_cast<int>(std::count_if(bases_.begin(), bases_.end(), [](const ForceBaseStatus& row) {
        return row.weatherState != "VMC";
    }));
}

int ForceManagementSnapshot::openMaintenanceCount() const noexcept {
    return static_cast<int>(maintenancePlan_.size());
}

} // namespace nexvary::avionics
