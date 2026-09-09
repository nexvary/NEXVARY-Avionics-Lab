# Architecture — v0.1

The project begins with strict separation between the simulation core and future user interfaces.

```text
NEXVARY AVIONICS LAB
|
+-- avionics_core
|   +-- SensorBus
|   +-- SystemHealth
|   +-- Watchdog
|   +-- EventLog
|
+-- CLI demonstrator
|
+-- Tests
|
+-- Future Qt/QML Cockpit UI
```

## Design rules

1. Core logic must not depend on the GUI.
2. Synthetic/test data is the default.
3. Every subsystem exposes health state and faults.
4. Faults are logged rather than silently ignored.
5. CI must pass on Windows and Linux before a release tag.
6. Safety-related concepts are demonstrated as software-engineering patterns, not represented as certified avionics.
