# Open-Source Avionics & Simulation Landscape

This is the maintained reference list for NEXVARY Avionics Lab. It is intentionally focused on simulation, flight-software architecture, telemetry, HMI, verification and digital-twin concepts. Weapon-control, targeting and live combat functions are out of scope.

| Project | Strongest capability | License | NEXVARY decision |
|---|---|---|---|
| NASA cFS | Layered flight-software framework, health/safety, scheduler, telemetry apps | Apache-2.0 | Adopt architectural patterns; evaluate adapters, do not replace the Windows lab core wholesale |
| NASA/JPL F Prime | Component model, generated interfaces, commands/events/telemetry, testing | Apache-2.0 | Adopt component/dictionary ideas and stronger interface contracts |
| NASA Open MCT | Real-time + historical telemetry visualization, timelines, plugins | Apache-2.0 | Benchmark telemetry UX and future remote observer dashboard |
| JSBSim | Cross-platform 6-DoF flight dynamics model | LGPL-2.1 | Candidate optional physics plugin behind a clean interface |
| FlightGear / SimGear | Mature cross-platform simulator and simulation building blocks | GPL / LGPL | Use as interoperability/reference target; avoid copying GPL UI into core |
| Gazebo Sim | Plugin-based 3D simulation, integration/regression/performance testing | Apache-2.0 | Candidate optional external world/visualization adapter |
| QGroundControl | Mature Qt/QML cross-platform operational UX | Apache-2.0 + GPLv3 dual | Benchmark layout, settings, health/status UX; reuse only clearly Apache-compatible material |
| PX4 | SITL/HITL patterns and simulator separation | BSD-3-Clause ecosystem | Adopt test-layer concepts only; NEXVARY is not an autopilot |
| ArduPilot | Rich SITL and failure-mode simulation | GPLv3 | Learn from testing concepts; do not copy GPL implementation into a permissive core |
| QmlFlightInstruments | Ready QML EFIS/basic-six gauges | MIT | Strong candidate for optional instrument widgets after visual/license review |
| QFlightInstruments | Qt flight instrument widgets | MIT | Candidate source for conventional training gauges |
| OpenGC | Networked glass-cockpit concepts | Modified BSD | Useful historical architecture reference; code age requires caution |
| OpenEaagles | Real-time interactive simulation framework | License must be verified per source tree | Architecture/reference only until license provenance is unambiguous |
| Basilisk | Modular simulation and scenario examples | ISC | Reference for deterministic scenario composition and testing |

## Community/forum evidence

Public simulator communities such as F-16.net and Secret Projects contain useful historical experience about COTS-based cockpit trainers, distributed displays, simulator timing and early-development mockups. These are treated as secondary evidence only: design decisions must be supported by primary documentation or validated experiments before entering the codebase.

## Competitive direction

NEXVARY should differentiate by combining in one Windows-first training product: deterministic telemetry, replay, trend intelligence, health monitoring, bilingual RTL cockpit UI, synthetic fault lab, digital-twin summary, verification reports and strict cross-platform CI. Large upstream projects usually excel in one or two of these areas rather than packaging this exact combination for an accessible desktop avionics laboratory.
