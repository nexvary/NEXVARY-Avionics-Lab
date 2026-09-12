#pragma once

#include <cstddef>
#include <string>
#include <vector>

namespace nexvary::avionics {

struct ForceBaseStatus {
    std::string id;
    std::string name;
    std::string runwayState;
    std::string weatherState;
    int supportPercent{0};
};

struct ForceSquadronStatus {
    std::string id;
    std::string name;
    std::string platformClass;
    int assigned{0};
    int ready{0};
    int crewReady{0};
    int crewRequired{0};
};

struct ForceTrainingSlot {
    std::string time;
    std::string unit;
    std::string activity;
    std::string status;
};

struct ForceMaintenancePlanItem {
    std::string priority;
    std::string platform;
    std::string action;
    int dueHours{0};
};

struct ForceExecutiveReport {
    std::string title;
    std::string status;
    std::string period;
};

class ForceManagementSnapshot {
public:
    static ForceManagementSnapshot syntheticTraining();

    const std::vector<ForceBaseStatus>& bases() const noexcept { return bases_; }
    const std::vector<ForceSquadronStatus>& squadrons() const noexcept { return squadrons_; }
    const std::vector<ForceTrainingSlot>& trainingSlots() const noexcept { return trainingSlots_; }
    const std::vector<ForceMaintenancePlanItem>& maintenancePlan() const noexcept { return maintenancePlan_; }
    const std::vector<ForceExecutiveReport>& executiveReports() const noexcept { return executiveReports_; }

    int availableBaseCount() const noexcept;
    int assignedPlatformCount() const noexcept;
    int readyPlatformCount() const noexcept;
    int fleetReadinessPercent() const noexcept;
    int crewReadinessPercent() const noexcept;
    int weatherConstraintCount() const noexcept;
    int openMaintenanceCount() const noexcept;

    bool syntheticOnly() const noexcept { return true; }
    bool supportsOperationalOrders() const noexcept { return false; }
    bool supportsWeaponsDirection() const noexcept { return false; }

private:
    std::vector<ForceBaseStatus> bases_;
    std::vector<ForceSquadronStatus> squadrons_;
    std::vector<ForceTrainingSlot> trainingSlots_;
    std::vector<ForceMaintenancePlanItem> maintenancePlan_;
    std::vector<ForceExecutiveReport> executiveReports_;
};

} // namespace nexvary::avionics
