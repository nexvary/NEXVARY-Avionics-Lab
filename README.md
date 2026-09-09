# NEXVARY Avionics Lab

**NEXVARY Avionics Lab** is a cross-platform C++20 training and simulation platform for learning avionics software architecture, deterministic telemetry, system-health monitoring, fault handling, recording/replay, verification reporting, reproducible run profiles and cockpit HMI design.

It is **not** flight-certified software and does not implement targeting, weapons control, guidance, firing logic, or live-aircraft control.

## Current engineering level: Stage 650 candidate

Current capabilities include:

- deterministic synthetic avionics simulation core and four training scenarios
- Sensor Bus, System Health, Watchdog, Event Log and Alert Manager
- fault injection, telemetry recording/replay and deterministic telemetry archive
- JSON session archive plus defensive import limits
- reproducible JSON training run profiles
- JSON/Markdown verification reports
- Qt 6/QML cockpit with MFD, Systems, Sensors, Events and Replay pages
- English/Arabic UI foundation with RTL behavior
- explicit Back and Reset controls in the cockpit shell
- reuse-first dependencies: nlohmann/json, CLI11 and optional-isolated spdlog diagnostics
- Windows + Ubuntu core CI and Ubuntu Qt HMI headless smoke gate

See the stage ledgers and [`docs/OPEN_SOURCE_REUSE.md`](docs/OPEN_SOURCE_REUSE.md).

## Core build

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build -C Release --output-on-failure
```

## Run examples

```bash
./build/nexvary_avionics_lab --scenario nominal --ticks 40
./build/nexvary_avionics_lab --profile configs/nominal.profile.json
./build/nexvary_avionics_lab --scenario power-transient --ticks 80 --report-md report.md
./build/nexvary_avionics_lab --scenario sensor-dropout --ticks 50 --log-level info --log-file avionics.log
```

Built-in synthetic scenarios: `nominal`, `power-transient`, `sensor-dropout`, `thermal-rise`.

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
