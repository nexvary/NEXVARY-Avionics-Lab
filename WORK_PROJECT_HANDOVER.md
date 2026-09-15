# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-15
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `ddef84435091e3e649dd30c5a91920eb2065243a`
Release identity: `v3.5.0 / Stage 1980 packaging identity + Stage 1990 aircraft-intelligence batch`

## Current stable state

Stage 1990 continues directly from the verified Stage 1980 implementation. It preserves the approved Deep Black + Royal Gold visual system, all existing Air Operations, Force Management, Space Domain, C-UAS awareness, avionics engineering, diagnostics, verification, replay, reports, ten locales and Presentation Mode.

The Stage 1990 application was verified on pull-request head `4fc9a7024204b0a3b7e515aab189164d09b1fdec` and squash-merged to `main` as `ddef84435091e3e649dd30c5a91920eb2065243a` through PR #3.

## Stage 1990 aircraft-intelligence implementation

- Rewrote About System in English and Arabic to describe the actual integrated air-force management platform: command overview, common air picture, readiness, bases, sustainment, training, C-UAS awareness, space-domain awareness and digital engineering.
- Replaced the limited public-flight selection with a compact professional aircraft popup and a full aircraft intelligence drawer.
- Added identification, operator, route, telemetry, airframe and provenance sections with explicit `N/A` handling instead of invented values.
- Extended the OpenSky parser for position time, last contact, barometric/geometric altitude, velocity, heading, vertical rate, squawk, category and position source.
- Added an extensible normalized metadata contract for aircraft registration/model/operator/route enrichment while keeping unavailable data empty.
- Added freshness states for recent, delayed, stale and synthetic data, with source/mode/last-update provenance.
- Added callsign/flight/registration/ICAO/type/operator/source search plus aircraft-type and altitude filters.
- Added selected-aircraft highlighting, short history trails, heading-oriented markers and load-sensitive decluttering.
- Preserved Arabic RTL and mirrored the flight-details composition correctly.
- Added `--aircraft-details-smoke`, expanded the QML runtime matrix from 52 to 53 checks, and expanded the real screenshot gate from 30 to 34 captures.
- No API keys or private datasets were added. The synthetic training feed is labelled explicitly and is never presented as live data.

## Visual review

The final real application captures were opened and reviewed manually after CI. The Stage 1990 review specifically covered:

- Flight Tracking aircraft intelligence in English and Arabic at 1920×1080.
- About System in English and Arabic at 1920×1080.
- Correct RTL mirroring, readable type sizes, selection hierarchy, drawer/map balance and provenance visibility.
- Regression coverage across the inherited 30 Stage 1980 captures, including 2560×1440 and all ten locales.

The first capture exposed overlap between the compact popup and the expanded details drawer. The popup was made mutually exclusive with the drawer and repositioned dynamically. A second review exposed dense About text; two excess lines were removed and the capability/comparison type floor was raised before the final verified captures.

## Verified gates

| Gate | Result |
|---|---:|
| Linux C++20 Release build, CTest and release smoke | PASS |
| Windows C++20 Release build, CTest and release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | PASS |
| QML routes, workspaces, Back, RTL, ten locales, radar/orbit motion and aircraft details | 53/53 PASS |
| Real application screenshot gate | 34/34 PASS |
| ASan/UBSan suite | PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt package verification | PASS |
| Portable ZIP and installer generation | PASS |

Final verified runs:

- CI: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34954440885
- CodeQL Security: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34954440978
- Windows Package: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34954440765

## Real screenshot artifact

- Name: `nexvary-avionics-stage1990-aircraft-intelligence-ui-release-gate`
- Artifact ID: `10390857858`
- Size: `11,110,474 bytes`
- SHA-256: `f0104893ace85fd64077594179fc11d03b5f836b5661d946e40e2c5ecba1106d`
- Contents: 34 real PNG captures, including the four new aircraft-intelligence/About EN/AR captures.

## Windows deliverables

- Artifact: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10390043709`
- Artifact size: `57,074,953 bytes`
- Artifact SHA-256: `98c2f2dd8d957a913eb119e058515252a1256bf7615c0da688e542980c631812`
- Contents include:
  - `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
  - `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`
- The package filename retains the Stage 1980 release identity, but the artifact was built and tested from the final Stage 1990 PR head `4fc9a7024204b0a3b7e515aab189164d09b1fdec`.

Expected build-tree paths:

- Linux HMI: `build-qt/nexvary_avionics_hmi`
- Linux CLI: `build/nexvary_avionics_lab`
- Windows HMI before packaging: `build-win/Release/nexvary_avionics_hmi.exe`
- Windows installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- Windows portable ZIP: `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

## Public-data and safety boundaries

- OpenSky live state vectors provide telemetry and callsign fields; rich aircraft/operator/route fields are exposed through the normalized provider contract but remain `N/A` until a licensed metadata provider is connected.
- Only short visual trails are implemented in this batch; persisted 5/15/30/60-minute histories are a future provider/cache task.
- The application remains limited to awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis.
- It contains no autonomous engagement, weapons assignment, fire control, live-aircraft control, jammer control, spoofing, takeover or destructive interception.
- External connectors and API keys remain disabled by default.

## Continuation point

Continue from Stage 1990 without repeating completed Stage 1970–1990 work. Preserve the Deep Black + Royal Gold hierarchy, restrained semantic colors, typography floor, Arabic RTL, 34-image visual gate, 53-case QML gate and independent Windows packaging verification.

The next useful functional batch is to connect a legally usable read-only aircraft metadata/route provider with cache and provenance, then add persisted history windows and operator/source filter controls. After that, continue with the real weather and airfield/runway condition providers using the same test → build → visual review → fix → commit → push → handover sequence.
