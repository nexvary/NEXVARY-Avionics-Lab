# NEXVARY AVIONICS LAB

A safe, non-weaponized avionics training and simulation platform focused on:

- cockpit/HMI experimentation
- synthetic sensor telemetry
- system-health monitoring
- watchdog/fault-handling concepts
- event logging and replay
- digital-twin foundations
- automated verification

> This repository is for education, research, simulation, reliability engineering, and defensive aerospace software practice. It intentionally excludes weapon control, targeting, guidance, or real-world combat functions.

## Status

**v0.1.0 — Foundation Core**

The first milestone is dependency-light C++20 so CI can validate the architecture before adding a graphical cockpit.

## Build

### Windows / Linux / macOS

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build -C Release --output-on-failure
```

Run:

```bash
./build/nexvary_avionics_lab
```

On Windows with a multi-config generator:

```powershell
.\build\Release\nexvary_avionics_lab.exe
```

## Architecture

See `docs/ARCHITECTURE.md`.

## Next milestone

v0.2.0 adds the first **Cockpit System Monitor** UI with Qt 6/QML, while keeping `avionics_core` independent from the UI.
