# NEXVARY Avionics Lab

**NEXVARY Avionics Lab** is a cross-platform C++20 training and simulation platform for learning avionics software architecture, deterministic telemetry, system-health monitoring, fault handling, recording/replay, and cockpit HMI design.

It is **not** flight-certified software and does not implement targeting, weapons control, guidance, firing logic, or live-aircraft control.

## Current engineering level: Stage 350

The repository now includes:

- deterministic avionics simulation core
- synthetic Sensor Bus and four training scenarios
- System Health, Watchdog, Event Log and Alert Manager
- Fault Injection, Telemetry Recorder and Replay
- cockpit-friendly HMI data model
- corrected instrument/sensor mapping
- English + Arabic localization foundation with RTL semantics
- optional Qt 6 / QML cockpit application
- functional MFD, Systems and Alerts pages
- live scenario selector and language switch
- Windows + Ubuntu core CI
- dedicated Ubuntu Qt HMI build and headless UI smoke gate
- five portable CTest executables

See [`docs/STAGES_001_250.md`](docs/STAGES_001_250.md), [`docs/STAGES_251_300.md`](docs/STAGES_251_300.md), and [`docs/STAGES_301_350.md`](docs/STAGES_301_350.md).

## Core build

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build -C Release --output-on-failure
```

## Qt/QML cockpit build

Install Qt 6 with Quick and Quick Controls 2, then:

```bash
cmake -S . -B build-qt -DCMAKE_BUILD_TYPE=Release -DNEXVARY_BUILD_QT_HMI=ON
cmake --build build-qt --config Release --target nexvary_avionics_hmi
```

Linux:

```bash
./build-qt/nexvary_avionics_hmi
```

On Windows with a multi-config generator the executable is normally under `build-qt/Release/`.

## Core CLI

```bash
./build/nexvary_avionics_lab --scenario nominal --ticks 40
./build/nexvary_avionics_lab --scenario power-transient --ticks 25 --replay
./build/nexvary_avionics_lab --list-scenarios
```

Built-in synthetic scenarios: `nominal`, `power-transient`, `sensor-dropout`, `thermal-rise`.
