# NEXVARY Avionics Lab

**NEXVARY Avionics Lab** is a cross-platform C++20 training and simulation platform for learning avionics software architecture, deterministic telemetry, system-health monitoring, fault handling, recording/replay, and cockpit HMI data modeling.

It is **not** flight-certified software and does not implement targeting, weapons control, or operational combat functions.

## Current engineering level: Stage 250 core

The Stage 001–250 release train provides:

- thread-safe synthetic Sensor Bus
- deterministic Simulation Clock
- System Health evaluation
- Watchdog and Event Log
- persistent Alert Manager
- Fault Injection (`invalidate`, `override`, `offset`)
- four safe synthetic scenarios
- Telemetry Recorder and Replay Cursor
- unified `AvionicsLab` orchestration layer
- cockpit-friendly `LabSnapshot` data model
- cross-platform training console
- Windows + Ubuntu CI and three test executables

See [`docs/STAGES_001_250.md`](docs/STAGES_001_250.md) for the release-gate ledger.

## Build

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build -C Release --output-on-failure
```

## Run

```bash
./build/nexvary_avionics_lab --scenario nominal --ticks 40
./build/nexvary_avionics_lab --scenario power-transient --ticks 25 --replay
./build/nexvary_avionics_lab --list-scenarios
```

On Windows with a multi-config generator the executable is normally under `build/Release/`.

## Built-in scenarios

- `nominal`
- `power-transient`
- `sensor-dropout`
- `thermal-rise`

All scenarios are synthetic and intended only for software training and reliability testing.

## Next engineering train

Stage 251+ will build the optional Qt/QML cockpit HMI, MFD layout system, localization/RTL foundation, richer scenario authoring, and visual release gates while preserving the portable simulation core.
