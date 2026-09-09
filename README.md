# NEXVARY Avionics Lab

**NEXVARY Avionics Lab** is a Windows-first, cross-platform C++20 training and simulation platform for learning avionics software architecture, deterministic telemetry, system-health monitoring, bounded fault handling, recording/replay, trend analysis, digital-twin concepts and cockpit HMI design.

It is **not** flight-certified software and does not implement targeting, weapons control, guidance, firing logic or live-aircraft control.

## Current engineering level: Stage 850

The repository now includes:

- deterministic synthetic avionics simulation core
- thread-safe Sensor Bus and Event Log
- Watchdog, System Health and Alert lifecycle
- four repeatable training scenarios
- Telemetry Recorder, Replay and session/report tooling
- telemetry trend intelligence: latest/min/max/mean/delta/slope/data quality
- verification reports and bounded run profiles
- English + Arabic localization with RTL semantics
- Qt 6 / QML cockpit HMI
- MFD, Systems, Sensors, Events, Replay, Trends and Digital Twin pages
- software-only Digital Twin for power, compute, flight sensors, hydraulics and fuel
- bounded Synthetic Fault Lab with IMU dropout, low-power bus and compute over-temperature presets
- separation between scenario faults and operator-selected training faults
- Windows + Ubuntu CI, warnings-as-errors, ASan/UBSan and Qt headless smoke tests

See `docs/STAGES_001_250.md` through `docs/STAGES_801_850.md` for the engineering gates, and `docs/OPEN_SOURCE_LANDSCAPE.md` for the maintained comparison of reusable open-source projects.

## Open-source strategy

NEXVARY Avionics Lab selectively learns from and interoperates with mature projects rather than reimplementing every generic subsystem. The maintained landscape currently evaluates NASA cFS, NASA/JPL F Prime, NASA Open MCT, JSBSim, FlightGear/SimGear, Gazebo, QGroundControl, PX4, ArduPilot, QML flight-instrument libraries, OpenGC, OpenEaagles and Basilisk. Dependencies or copied code are accepted only after license and maintenance review.

## Windows delivery direction

The engineering target is a normal Windows desktop application and installer so end users do not need development commands. Developer build instructions remain in repository documentation for CI and contributors, but they are not intended as the end-user workflow.
