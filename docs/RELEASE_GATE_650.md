# NEXVARY Avionics Lab — Release Gate 650

Stage 650 covers cross-platform C++20 builds, deterministic simulation tests, alert/replay/HMI models, telemetry archives, JSON session portability, verification reports, profile-driven reproducibility, sanitizer testing, and a headless Qt/QML smoke test.

Open-source acceleration is documented: Qt 6 for the optional HMI, nlohmann/json for JSON infrastructure, and CLI11 for robust CLI parsing. Future flight-dynamics integrations such as JSBSim remain optional until their own licensing/build/verification gate is implemented.

No live-aircraft control, targeting, guidance, weapon control, or combat automation interface is part of this release gate.
