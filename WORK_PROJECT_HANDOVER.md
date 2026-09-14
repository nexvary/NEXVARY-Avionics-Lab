# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-14
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `efa1d1d54585ee683613a4d1412672cf19807052`
Release identity: `v3.4.0 / Stage 1970`

## Current stable state

Stage 1970 continues directly from Stage 1960. It preserves the existing avionics engineering, Digital Twin, diagnostics, replay, trends, verification, Force Management, public ADS-B, AEGIS awareness, C-UAS management, reporting and provider functions while replacing the weak executive composition and crude aircraft graphics identified in the real-image review.

The stable implementation has been built and tested on Linux and Windows, exercised through the Qt/QML route and locale matrix, checked with sanitizers and CodeQL, captured in 28 real application screenshots, and packaged as both a Windows installer and portable ZIP.

## Approved visual system

The command identity remains Deep Black + Royal Gold, supported by controlled operational colors:

- Deep Black foundation: `#000000` / `#02070B`
- Near-black technical surfaces: `#050D13` / `#07131A` / `#0A1821`
- Royal Gold brand and selected executive state: `#D4AF37`
- Platinum primary text: `#F2F5F7`
- Metallic Silver secondary text: `#9EABB5`
- Electric Blue/Cyan: public flight information, active tracks and Air Operations context
- Radar Green: nominal readiness and healthy sources
- Violet: passive RF and classification evidence
- Amber/Orange/Red: caution, incidents and critical states only
- Structural borders remain 1 px; selected controls use approximately 1.5 px. Gold is intentionally restrained instead of surrounding every panel.

The shared scale is 24–30 px for main/display titles, 15–18 px for section headings, 12–15 px for normal information and at least 10–11 px for secondary text. Arabic prefers Noto Kufi Arabic, and the application shell mirrors for RTL.

## Stage 1970 implementation

- Rebuilt Command Overview around one dominant Common Air Picture rather than equal-strength dashboard cards.
- Introduced a briefing-first executive band, a dedicated decision column and a full-width airfield strip to remove the large unused zones and compressed lower content seen in Stage 1960.
- Added a code-native NEXVARY N/X avionics mark with platinum/silver geometry, electric-blue identity detail and restrained Royal Gold registration emphasis.
- Added Presentation Mode (`F11`) that removes navigation/footer clutter while retaining brand, title and operational status.
- Rebuilt the strategic map with geographic layers, range/grid context, public ADS-B tracks, AEGIS awareness tracks, track history, route/sector overlays and a continuously animated radar sweep.
- Replaced the childlike single-polygon aircraft drawings with original engineering-grade planform and side-elevation components for jet, turboprop, helicopter and UAV platforms.
- Added technical grids, reference dimensions, systems buses, subsystem nodes, health/diagnostic state, readiness, maintenance and Digital Twin evidence to aircraft views.
- Corrected the C-UAS startup route so workspace 6 opens the real Detection/Awareness surface instead of the Airspace page.
- Added a dense passive C-UAS tactical plot with 10-degree bearing ticks, 30-degree major ticks, range rings, geofence, track history, labels and animated sweep.
- Added a passive-only RF spectrum panel to the C-UAS surface and bound it to the live peak evidence (`-64.5 dBm` in the final captured scenario).
- Added a runtime radar-motion assertion; the QML gate now fails if the sweep angle does not advance.
- Corrected the C-UAS back-stack smoke test to exercise the real incidents route instead of an invalid blank StackLayout index.
- Increased C-UAS and shared UI typography and aligned About/System Governance surfaces with `v3.4.0 / Stage 1970`.
- Corrected the 1920×1080 Arabic/Urdu/Persian executive-header height so the safety line remains inside its panel and no longer overlaps the map.
- Preserved the safety boundary: awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis only. No weapons assignment, autonomous engagement, fire control, jamming, spoofing, takeover or destructive interception was added.

## Verified stable gates

Implementation commit `efa1d1d54585ee683613a4d1412672cf19807052` is verified by these completed GitHub runs:

| Gate | Result |
|---|---:|
| Linux C++20 Release build + tests + release smoke | PASS |
| Windows C++20 Release build + tests + release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | 30/30 PASS |
| QML route/workspace/locale/back-stack/RTL/radar-motion gate | 50/50 PASS |
| Stage 1970 real screenshot gate | 28/28 PASS |
| ASan/UBSan suite | 29/29 PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt verification | 30/30 + 50/50 PASS |
| Windows deploy, release manifest and archive integrity | PASS |
| Inno Setup installer and portable ZIP | GENERATED |

Runs:

- CI: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34898422533
- CodeQL Security: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34898422543
- Windows Package: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34898422517

## Real screenshot set

Artifact: `nexvary-avionics-stage1970-command-ui-release-gate`
Artifact ID: `10370116261`
Compressed size: `8,881,895 bytes`

The 28-image set includes:

- `stage1970-command-overview-en-1920x1080.png`
- `stage1970-command-overview-ar-1920x1080.png`
- `stage1970-command-overview-ar-2560x1440.png`
- `stage1970-cuas-detection-en.png`
- `stage1970-aircraft-visual-en.png`
- Jet, turboprop, helicopter and UAV engineering views
- Common Air Picture, Flight Tracking, Route Lab, Data Hub, Platform Library, Bases, Fleet, Data Sources and Diagnostics
- Ten-locale smoke captures: AR, EN, TR, ES, DE, IT, FR, UR, FA and RU

The committed application generated the images. Visual review explicitly checked executive density, empty space, text scale, clipping, RTL header flow, map labeling, C-UAS route identity, radar/RF evidence and aircraft drawing quality. These are real application captures, not mockups.

## Windows deliverables

Artifact: `NEXVARY-Avionics-Lab-Windows-v3.4.0-Stage1970`
Artifact ID: `10369578748`
Compressed artifact size: `57,031,354 bytes`
Artifact SHA-256: `cb398f5964d94c1433751e03e4020f62a332cf481cd40944c23ce105a14afb81`

Inside the artifact:

- Installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
  - Size: `23,201,398 bytes`
  - SHA-256: `63afe6cd747c17b95554b47682cbfb9bf3b1bc162fed5ee43d12205cded40f83`
- Portable package: `NEXVARY-Avionics-Lab-v3.4.0-Portable.zip`
  - Size: `34,938,267 bytes`
  - SHA-256: `afa0124e217788603bf16538f9192fa7f55cb0276f2bc3e09b686012b80acd10`
  - Archive integrity: PASS; 1,337 files; uncompressed size `87,757,790 bytes`
  - Release manifest: Qt `6.8.3`, version `3.4.0`, Stage `1970`, channel `training-simulation`

Expected build-tree paths:

- Linux HMI: `build-qt/nexvary_avionics_hmi`
- Linux CLI: `build/nexvary_avionics_lab`
- Windows HMI before packaging: `build-win/Release/nexvary_avionics_hmi.exe`
- Windows installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- Windows portable ZIP: `NEXVARY-Avionics-Lab-v3.4.0-Portable.zip`

## Continuation point

Continue from Stage 1970 without restarting or repeating the completed audit. Preserve the Deep Black + Royal Gold hierarchy, professional aircraft components, dominant command map, animated passive radar, semantic operational colors, typography floor, RTL behavior, route validation, presentation mode and safety boundary.

The next functional batch may deepen weather/airfield providers and operator-controlled map layers, but it must keep the release gates and should add visual evidence only when the surface is genuinely exercised by its route smoke.
