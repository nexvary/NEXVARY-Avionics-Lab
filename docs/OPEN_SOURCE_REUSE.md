# Reuse-first engineering policy

NEXVARY Avionics Lab uses mature open-source components to reduce duplicated infrastructure work while keeping NEXVARY domain logic small, reviewable and replaceable.

## Decision order

1. Search for a mature component that solves the non-domain problem.
2. Verify repository provenance, maintenance status and license.
3. Prefer MIT, BSD or Apache-2.0 for core dependencies.
4. Pin a reviewed release or commit.
5. Put large or copyleft projects behind a narrow optional adapter.
6. Keep avionics training domain logic independent of the third-party API where practical.
7. Re-run Windows, Ubuntu and Qt HMI release gates after every dependency change.

## Integrated accelerators

- `nlohmann/json` v3.12.0: session/profile JSON parsing and serialization.
- `CLI11` v2.6.2: command-line parsing, range checks and help generation.
- `spdlog` v1.17.0: diagnostics levels, thread-safe sinks and optional file logging.
- Qt 6 Quick/QML: desktop cockpit HMI rather than building a custom rendering toolkit.

## Adapter candidates

- JSBSim: civilian flight-dynamics source for a future optional simulation adapter only.
- NASA Open MCT: web telemetry visualization option without replacing the native Qt cockpit.
- NASA F´: architecture reference for component/port/telemetry patterns; review exact file licenses before reuse.
- Zephyr / FreeRTOS: separate embedded demonstrator targets rather than desktop-core dependencies.

This policy does not permit importing targeting, weapon-control, guidance, firing, live-aircraft-control or operational combat functionality.
