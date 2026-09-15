# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-15
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `fe9b69a85e09d310fa9e8ef0cff89e8bb815e441`
Release identity: `v3.5.0 / Stage 1980 packaging identity + Stage 2000 professional-radar batch`

## Current stable state

Stage 2000 continues directly from the verified Stage 1990 implementation. It preserves the approved Deep Black + Royal Gold visual system, all existing Air Operations, Force Management, Space Domain, C-UAS awareness, avionics engineering, diagnostics, verification, replay, reports, ten locales and Presentation Mode.

The Stage 2000 application was verified on pull-request head `4535f7978f4c73ab385eafd7f8484145dd4812f1` and squash-merged to `main` as `fe9b69a85e09d310fa9e8ef0cff89e8bb815e441` through PR #4.

## Stage 2000 professional-radar implementation

- Replaced the primitive C-UAS radar canvas with reusable `ProfessionalRadarScope.qml`.
- Added a 360-degree PPI bezel, five-degree azimuth ticks, 30-degree labels and five-kilometre range-ring labels.
- Added alternating azimuth sectors, a restrained phosphor background and a seven-band animated sweep afterglow.
- Added classification-specific symbols for drone, aircraft, bird and unknown tracks.
- Added time-faded history dots, predicted velocity vectors and selected-track emphasis.
- Added distributed track data blocks with identity, classification, confidence, altitude, speed and heading.
- Added mouse selection plus calculated bearing/range/confidence summary for analytical review.
- Increased the radar's visual priority and corrected track-list clipping discovered during screenshot review.
- Added real 1920×1080 English and Arabic radar screenshots while preserving the passive-awareness/no-targeting safety boundary.

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
- Professional C-UAS radar in English and Arabic at 1920×1080, including PPI geometry, labels, trails, RF overlay and RTL composition.

The first Stage 2000 capture showed that the PPI remained too small and its labels clustered near the centre. The radar area was enlarged and the labels were distributed around the scope with leader lines. The second capture exposed slight clipping in the condensed track rows; row height was corrected before the final gate.

## Verified gates

| Gate | Result |
|---|---:|
| Linux C++20 Release build, CTest and release smoke | PASS |
| Windows C++20 Release build, CTest and release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | PASS |
| QML routes, workspaces, Back, RTL, ten locales, radar/orbit motion and aircraft details | 53/53 PASS |
| Real application screenshot gate | 36/36 PASS |
| ASan/UBSan suite | PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt package verification | PASS |
| Portable ZIP and installer generation | PASS |

Final verified runs:

- CI: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34957519332
- CodeQL Security: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34957519318
- Windows Package: https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/34957519312

## Real screenshot artifact

- Name: `nexvary-avionics-stage2000-professional-radar-ui-release-gate`
- Artifact ID: `10391708878`
- Size: `11,888,155 bytes`
- SHA-256: `353aaa46f2654f815a7da16a450d039ea13720a14f3dd3889ad3b402e385d739`
- Contents: 36 real PNG captures, including the Stage 2000 professional-radar EN/AR captures.

## Windows deliverables

- Artifact: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10391962190`
- Artifact size: `57,081,877 bytes`
- Artifact SHA-256: `76095eb9c7a774e844de227c803d9db849a7736d7a8a13f29ca8ac3e7ca020e8`
- Contents include:
  - `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
  - `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`
- The package filename retains the Stage 1980 release identity, but the artifact was built and tested from the final Stage 2000 PR head `4535f7978f4c73ab385eafd7f8484145dd4812f1`.

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

Continue from Stage 2000 without repeating completed Stage 1970–2000 work. Preserve the Deep Black + Royal Gold hierarchy, restrained semantic colors, typography floor, Arabic RTL, 36-image visual gate, 53-case QML gate and independent Windows packaging verification.

The next useful functional batch is to connect a legally usable read-only aircraft metadata/route provider with cache and provenance, then add persisted history windows and operator/source filter controls. After that, continue with the real weather and airfield/runway condition providers using the same test → build → visual review → fix → commit → push → handover sequence.
