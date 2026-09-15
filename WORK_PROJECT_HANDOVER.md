# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-15  
Repository: `nexvary/NEXVARY-Avionics-Lab`  
Branch: `main`  
Stable implementation commit: `031017e90cc4073c5047d0a80e0f6d049a7c41b9`  
Release identity: `v3.5.0 / Stage 1980`

## Current stable state

Stage 1980 continues from the verified Stage 1970 ministerial interface without restarting or removing existing capabilities. It preserves the approved Deep Black + Royal Gold identity, professional aircraft engineering views, dominant Command Overview, animated passive C-UAS radar, public ADS-B awareness, AEGIS integration, Force Management, engineering, diagnostics, verification, replay, reports, ten locales and Presentation Mode.

The final application and workflow tree was verified on pull-request head `348b40573d7cc5bf7476bc94ce827a5df05e9458`, then squash-merged without application changes to `main` as `031017e90cc4073c5047d0a80e0f6d049a7c41b9`.

## Stage 1980 implementation

- Added an independent Space Domain Awareness workspace rather than another executive-dashboard card.
- Added an animated MEO orbital picture with three orbital planes, object identity, altitude, inclination, period, access windows, source health and analytical conjunction review.
- Added `Public Orbital Elements` and passive `Open Drone ID` provider contracts to the C++ registry and Data Sources UI.
- Added explicit radar, weather, airspace and route layer controls to the Common Air Picture.
- Added weather cells with temperature/wind evidence while preserving the map-first command hierarchy.
- Added passive Remote ID correlation to the AEGIS C-UAS awareness surface.
- Expanded Air Operations navigation and back-stack restoration through the new Space Domain route.
- Added a runtime orbital-motion assertion alongside the existing radar-motion assertion.
- Expanded the QML runtime matrix from 50 to 52 cases.
- Expanded the real screenshot gate from 28 to 30 application captures, including Space Domain in English and Arabic.
- Reworked Data Sources to a responsive 3×3 provider grid at command resolution so all nine providers, including Open Drone ID, are visible without clipping.
- Added pull-request execution to the Windows packaging workflow so installer verification is not dependent on connector-originated push events.
- Recorded open-source visual/architectural references and license boundaries in `docs/OPEN-SOURCE-VISUAL-REFERENCES-STAGE1980.md`.

## Visual review

The generated application screenshots were opened and reviewed manually. The review covered:

- Command Overview: English 1920×1080, Arabic 1920×1080 and Arabic 2560×1440.
- Common Air Picture and operator layer controls.
- C-UAS Detection/Awareness with animated passive radar, Remote ID and RF evidence.
- Space Domain Awareness in English and Arabic.
- Data Sources, aircraft variants, Fleet, Bases/Airfields, Data Hub, Route Lab and Diagnostics.
- Ten-locale captures: AR, EN, TR, ES, DE, IT, FR, UR, FA and RU.

The first Stage 1980 screenshot set exposed one real defect: the ninth provider was below the visible 1920×1080 Data Sources area. The provider surface was changed from a fixed two-column list to a responsive 3×3 command-resolution grid, CI was rerun, and the final screenshot confirms all nine providers are visible and balanced.

## Verified gates

| Gate | Result |
|---|---:|
| Linux C++20 Release build, 29 CTest cases and release smoke | PASS |
| Windows C++20 Release build, 29 CTest cases and release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | 30/30 PASS |
| QML routes, workspaces, Back, RTL, ten locales, radar and orbit motion | 52/52 PASS |
| Stage 1980 real screenshot gate | 30/30 PASS |
| ASan/UBSan suite | 29/29 PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt package verification | 30/30 + 52/52 PASS |
| Portable ZIP and installer generation | PASS |

Final verified runs:

- CI: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34923093171
- CodeQL Security: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34923093004
- Windows Package: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34923093706

## Real screenshot artifact

- Name: `nexvary-avionics-stage1980-space-air-command-ui-release-gate`
- Artifact ID: `10378149262`
- Size: `9,902,038 bytes`
- SHA-256: `dc67368c84c83a0ecd058724eaf80c73a1b14df9b565c5cf1695365b3b843810`
- Contents: 30 real PNG captures at 1920×1080, 2560×1440 and 1720×1000.

## Windows deliverables

- Artifact: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10379230606`
- Artifact size: `57,050,770 bytes`
- Artifact SHA-256: `dcc940d5cdfc70b745f9512afa2d3d12675c37bc08b68cbe325c3d014f63d0ed`
- Installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
  - Size: `23,212,241 bytes`
  - SHA-256: `440aa31cbd583a9b111990efb2559306e6171ff538926d3755308a78430ae4e1`
- Portable ZIP: `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`
  - Size: `34,946,618 bytes`
  - SHA-256: `90103535cbdc1a8255aa2f0da3ff599246549b5e8f060dc458c70e0a46c91d75`
  - Archive integrity: PASS; 1,337 files; uncompressed size `87,769,054 bytes`.

Expected build-tree paths:

- Linux HMI: `build-qt/nexvary_avionics_hmi`
- Linux CLI: `build/nexvary_avionics_lab`
- Windows HMI before packaging: `build-win/Release/nexvary_avionics_hmi.exe`
- Windows installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- Windows portable ZIP: `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

## Open-source reference decisions

- KeepTrack (AGPL-3.0): orbital information hierarchy and dominant-globe composition only; no code or assets copied.
- CesiumJS (Apache-2.0): layer-driven geospatial architecture only; no Cesium runtime or assets embedded.
- OpenSpace (project-specific license): presentation-scale visual study only.
- Open Drone ID Core C (Apache-2.0): passive identification terminology and provider separation only; no transmitter or control path.

## Safety boundary

Stage 1980 remains limited to awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis. It contains no autonomous engagement, weapons assignment, fire control, live-aircraft control, orbital maneuver control, jammer control, spoofing, takeover or destructive interception. External network connectors and API keys are disabled by default.

## Continuation point

Continue from Stage 1980 without repeating the Stage 1970/1980 audits. Preserve the Deep Black + Royal Gold hierarchy, restrained semantic colors, typography floor, Arabic RTL, 30-image visual gate, 52-case QML gate and independent Windows pull-request package verification.

The next useful functional batch is a real read-only weather provider adapter with cache/freshness behavior and an airfield/runway condition provider, followed by route-specific screenshots and the same test → build → visual review → fix → commit → push → handover sequence.
