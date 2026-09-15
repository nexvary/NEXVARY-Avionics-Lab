# Stage 1980 — Open-source visual and architecture references

Date: 2026-09-15

## Purpose

Stage 1980 uses public open-source projects to study information hierarchy, geospatial layering, orbital visualization and passive Remote ID evidence. No third-party screenshot, icon, aircraft drawing, satellite asset or source file is copied into the application.

## Reviewed projects

| Project | License | Extracted design lesson | Integration decision |
|---|---|---|---|
| [KeepTrack](https://github.com/thkruz/keeptrack.space) | AGPL-3.0 | Separate orbital planes, object identity, sensor/source state, access windows and analytical alerts around one dominant globe | Visual/architectural study only; no code or assets imported |
| [CesiumJS](https://github.com/CesiumGS/cesium) | Apache-2.0 | Layer-driven geospatial composition, restrained map controls and clear distinction between base geography and operational overlays | Native Qt/QML implementation; no JavaScript engine or Cesium asset embedded |
| [OpenSpace](https://github.com/OpenSpace/OpenSpace) | Project-specific | Presentation-scale astrovisualization, depth cues and object-centric detail panels | Visual study only because the license requires separate review |
| [Open Drone ID Core C](https://github.com/opendroneid/opendroneid-core-c) | Apache-2.0 | Basic ID, location, system and authentication evidence should remain distinct and auditable | Provider contract and passive identification terminology only; no transmitter or control path |

## Resulting Stage 1980 architecture

- Space Domain Awareness is an independent workspace, not another executive-dashboard card.
- The orbital picture is animation-driven and object-centric, with MEO planes, altitude, inclination, period, pass windows, provider freshness and conjunction review.
- Public orbital-element input is represented by a read-only provider contract. The bundled scenario remains deterministic training/replay data and is explicitly not for navigation.
- Open Drone ID is represented as passive receive/replay evidence correlated with AEGIS tracks.
- The Common Air Picture exposes explicit radar, weather, airspace and route layer controls.
- Every new provider reports source, mode, freshness, health, record count and trust boundary through the existing Data Sources workspace.
- New external connectors and API keys remain disabled by default; the committed build uses deterministic replay/training inputs.

## Safety boundary

This work provides awareness, management, training, simulation and analysis only. It includes no autonomous engagement, weapon assignment, fire control, orbital maneuver control, jammer control, spoofing, takeover or destructive interception.
