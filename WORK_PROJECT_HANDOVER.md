# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-14  
Repository: `nexvary/NEXVARY-Avionics-Lab`  
Branch: `main`  
Stable implementation commit: `1fc3029ebbe25306be333b8653686b400c20fd91`  
Release identity: `v3.3.0 / Stage 1960`

## Current stable state

Stage 1960 continues directly from Stage 1950 and preserves all existing avionics engineering, Digital Twin, diagnostics, replay, trends, verification, Force Management, public ADS-B, AEGIS awareness, C-UAS management, reporting and provider functions.

The recorded UI review identified mixed routing, crowded dashboard composition, map-label collisions, undersized text, collapsed Route Lab/Data Hub panes, a sparse Platform Library center, and a generic legacy mark. Those defects are addressed in the stable implementation commit.

## Approved visual system

The command identity remains Deep Black + Royal Gold:

- Deep Black foundation: `#000000` / `#02070B`
- Navy-black technical surfaces: `#050D13` / `#07131A` / `#0A1821`
- Royal Gold brand/selected executive state: `#D4AF37`
- Platinum primary text: `#F2F5F7`
- Metallic Silver secondary text: `#9EABB5`
- Electric Blue/Cyan: operational tracks, data and active Air Operations context
- Radar Green: nominal readiness and healthy sources
- Violet: passive RF and airspace classification
- Amber/Orange/Red: caution, incident and critical states only
- Structural borders remain 1 px; selected controls use 1.5 px. Gold is used deliberately instead of covering every card.

The shared scale is 24–30 px for main/display titles, 16 px section headings, 14 px body information, 12 px secondary information, and 11 px small labels. No changed QML surface contains a numeric font size below 10 px. Arabic prefers Noto Kufi Arabic and the shell mirrors correctly for RTL.

## Stage 1960 implementation

- Replaced the generic gold aircraft badge with a code-native NEXVARY silver/electric-blue N/X avionics monogram and restrained gold registration point.
- Enlarged and clarified the navigation rail branding and connected each group to a meaningful accent while keeping Royal Gold as the command identity.
- Corrected route mapping:
  - Command / Common Air Picture → dedicated Common Air Picture workspace.
  - Air Operations / Flight Tracking → dedicated Public Flight Tracking workspace.
  - C-UAS sections → dedicated workspace index 6 with correct back-stack restoration.
- Expanded Air Operations from six to seven independent workspaces.
- Reorganized the Command Overview around the large Common Air Picture, Force Readiness, Squadron Readiness, Bases/Airfields, Maintenance, Training and a compact Alerts/Incidents strip.
- Removed the crowded Aircraft Explorer/Data Integration detail row from the executive hierarchy; those functions remain available in their own workspaces.
- Added fixed collision-free ADS-B and AEGIS annotation rails to the strategic map, with cyan public tracks and semantic awareness colors.
- Repaired QML layout constraints that collapsed the Route Lab map and Aeronautical Data Hub catalog.
- Converted the Data Hub catalog into readable 72 px records with class colors, altitude bands, provenance notes and controlled/advisory state.
- Added a large aircraft technical schematic, subsystem nodes, Digital Twin status and diagnostic-health display to Platform Library.
- Increased shared Arabic/Latin typography and passive RF labels without introducing sub-10 px text.
- Preserved the safety boundary: awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis only. No weapons assignment, engagement, fire control, jamming, spoofing, takeover or destructive interception was added.

## Verified stable gates

Implementation commit `1fc3029` is verified by the following completed GitHub runs:

| Gate | Result |
|---|---:|
| Linux C++20 Release build + tests + release smoke | PASS |
| Windows C++20 Release build + tests + release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | 30/30 PASS |
| QML route/workspace/locale/back-stack/RTL gate | 49/49 PASS |
| Stage 1960 real screenshot gate | 25/25 PASS |
| ASan/UBSan suite | 29/29 PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt verification | 30/30 + 49/49 PASS |
| Windows deploy, manifest and diagnostics verification | PASS |
| Inno Setup installer and portable ZIP | GENERATED |

Runs:

- CI: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34866674589
- CodeQL Security: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34866674587
- Windows Package: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34866674586

## Real screenshot set

Artifact: `nexvary-avionics-stage1960-command-ui-release-gate`  
Artifact ID: `10356808944`  
Compressed size: `6,401,882 bytes`

It contains:

- `stage1960-command-overview-en-1920x1080.png`
- `stage1960-command-overview-ar-1920x1080.png`
- `stage1960-command-overview-ar-2560x1440.png`
- Common Air Picture, Flight Tracking, Route Lab, Aeronautical Data Hub, Aircraft Visual, Platform Library, Airspace, Fleet, Bases/Airfields, C-UAS Detection, Data Sources and Arabic Diagnostics captures
- Ten locale captures: AR, EN, TR, ES, DE, IT, FR, UR, FA and RU

The local visual review covered the 1920×1080 English and Arabic overview plus affected Common Air Picture, Flight Tracking, Route Lab, Data Hub and Platform Library surfaces. CI regenerated the final 25-image set from the committed application and verified PNG signatures, dimensions and minimum file size.

## Windows deliverables

Artifact: `NEXVARY-Avionics-Lab-Windows-v3.3.0-Stage1960`  
Artifact ID: `10357756920`  
Compressed artifact size: `57,023,614 bytes`

Inside the artifact:

- Installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- Portable package: `NEXVARY-Avionics-Lab-v3.3.0-Portable.zip`

Expected build-tree paths:

- Linux HMI: `build-qt/nexvary_avionics_hmi`
- Linux CLI: `build/nexvary_avionics_lab`
- Windows HMI before packaging: `build-win/Release/nexvary_avionics_hmi.exe`
- Windows installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- Windows portable ZIP: `NEXVARY-Avionics-Lab-v3.3.0-Portable.zip`

## Continuation point

Continue from Stage 1960 without restarting or repeating the completed visual audit. Preserve the Deep Black + Royal Gold brand hierarchy and semantic operational colors. The next functional batch may deepen weather/airfield provider views and map-layer controls, but must retain the current route separation, typography floor, RTL behavior, safety boundary and release gates.
