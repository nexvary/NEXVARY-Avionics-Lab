# Architecture

NEXVARY Avionics Lab is a training/simulation software platform. It deliberately keeps synthetic data generation, fault handling, health evaluation, recording, and presentation separate so each layer can be tested independently.

```text
ScenarioEngine -> SensorBus -> SystemHealth -> AlertManager
      |              |                           |
FaultInjector        +------> TelemetryRecorder  |
      |                                          |
SimulationClock ------------------------------> AvionicsLab
                                                 |
                                          LabSnapshot
                                                 |
                                         ConsoleCockpit
                                      (future Qt/QML HMI)
```

## Design rules

1. **Synthetic by default:** no live aircraft buses, targeting systems, or weapons interfaces.
2. **Deterministic simulation:** time advances only through `SimulationClock`.
3. **Fail-observable behavior:** injected faults remain visible through health and alert layers.
4. **Separation of concerns:** presentation code does not own simulation logic.
5. **Portable core:** the CI-supported core uses standard C++20 and CMake on Windows and Linux.
6. **HMI-ready snapshots:** `LabSnapshot` is the boundary intended for future Qt/QML MFD presentation.
