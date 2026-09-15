# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-15
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `08d9cfa3343ccda0a23f345222a8b0ec269d68ab`
Release identity: `v3.5.0 / Stage 1980 packaging identity + Stage 2061 responsive visual closure`

## Current stable state

Stage 2061 continues directly from the verified Stage 2000 professional-radar implementation and preserves the approved Deep Black + Royal Gold visual system, all Air Operations, Force Management, Space Domain, C-UAS awareness, avionics engineering, diagnostics, verification, replay, reports, ten locales and Presentation Mode.

The stable implementation commit is `08d9cfa3343ccda0a23f345222a8b0ec269d68ab` on `main`. It has passed the complete Linux/Windows/Qt/QML/security/CodeQL/package verification set described below.

## Stage 2052 test reliability fix

- Removed a Release-only Qt test failure caused by side-effecting calls being placed inside `assert(...)` expressions that disappear under `NDEBUG`.
- Ensured `QTemporaryFile::open()` and write operations execute independently from assertion macros.
- Added the required `QCoreApplication` test context.
- Corrected the stale provider-count expectation from seven sources to the actual nine-source registry after `Orbital Elements` and `Open Drone ID` were added.
- Re-ran Qt-enabled CTest and QML gates successfully after the fixes.

## Stage 2060 responsive verification

- Removed the practical 800px-height floor that prevented genuine 1366×768 support.
- Added real viewport coverage for 1366×768 and 1440×900 instead of relying only on large desktop resolutions.
- Expanded the QML runtime/viewport matrix to 55 checks, covering routes, workspaces, Back behavior, RTL, ten locales, radar/orbit motion and compact viewport support.
- Added real application captures for:
  - Command Overview EN at 1440×900.
  - Command Overview EN at 1366×768.
  - Command Overview AR at 1366×768.
  - About System EN at 1366×768.
  - Professional C-UAS radar EN at 1366×768.
- Preserved the inherited Stage 1980/1990/2000 screenshot evidence set.

## Stage 2061 visual closure

Manual review of the real Stage 2060 captures found three defects that automated gates did not reject. Stage 2061 corrects all three:

1. **Arabic Command Overview compact masthead**
   - The Arabic executive heading was clipped at the compact width.
   - The title now uses width-aware fitting while preserving the approved hierarchy and RTL alignment.
   - The final 1366×768 Arabic capture was opened and reviewed manually; the title is complete and readable.

2. **About System capability cards**
   - Compact four-column capability cards allowed the capability code chip to collide with wrapped titles.
   - The row now reserves stable space for the code chip and constrains the title region correctly.
   - The final 1366×768 About capture was opened and reviewed manually; card headings no longer overlap.

3. **Professional radar compact-height composition**
   - At 1366×768 the track list consumed too much vertical space, reducing the radar to a secondary strip.
   - The compact-height layout now shortens the list area and guarantees a substantial radar region.
   - The final 1366×768 C-UAS capture was opened and reviewed manually; the professional PPI radar is again the dominant technical visualization.

The safety boundary remains unchanged: the radar is passive awareness/analysis only and provides no live interception, jammer control, takeover, weapons assignment or engagement control.

## Existing Stage 2000 professional radar

- Reusable `ProfessionalRadarScope.qml` with 360-degree PPI bezel, azimuth ticks/labels and range rings.
- Alternating sectors, restrained phosphor background and animated sweep afterglow.
- Classification-specific symbols for drone, aircraft, bird and unknown tracks.
- Time-faded history dots, predicted velocity vectors and selected-track emphasis.
- Distributed track labels with identity, classification, confidence, altitude, speed and heading.
- Mouse selection and calculated bearing/range/confidence analytical summary.
- Passive RF spectrum overlay and receive-only provenance.

## Existing Stage 1990 aircraft intelligence

- Integrated About System brief in English and Arabic.
- Aircraft intelligence popup/drawer with identification, operator, route, telemetry, airframe and provenance sections.
- OpenSky parser coverage for position time, last contact, barometric/geometric altitude, velocity, heading, vertical rate, squawk, category and position source.
- Normalized metadata contract for registration/model/operator/route enrichment with explicit `N/A` handling when data is unavailable.
- Freshness states and visible source/mode/last-update provenance.
- Callsign/flight/registration/ICAO/type/operator/source search plus aircraft-type and altitude filters.
- Selected-aircraft highlighting, short trails, heading-oriented markers and decluttering.
- Arabic RTL composition preserved.

## Verified gates — Stage 2061

| Gate | Result |
|---|---:|
| Linux C++20 Release build, CTest and release smoke | PASS |
| Windows C++20 Release build, CTest and release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | PASS |
| QML routes/workspaces/Back/RTL/ten locales/viewport matrix | 55/55 PASS |
| Responsive real-application screenshot gate | PASS |
| ASan/UBSan suite | PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt package verification | PASS |
| Portable ZIP generation | PASS |
| One-click Windows installer generation | PASS |

Final verified runs for stable implementation commit `08d9cfa3343ccda0a23f345222a8b0ec269d68ab`:

- CI: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35000154430`
- CodeQL Security: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35000154269`
- Windows Package: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35000154275`

## Real screenshot artifact

- Name: `nexvary-avionics-stage2060-responsive-ui-release-gate`
- Artifact ID: `10408884610`
- Size: `12,980,138 bytes`
- SHA-256: `823c21332e086c39c66664d9b854f931be38716ae8667dfe7f59cceb03557d65`
- Head SHA: `08d9cfa3343ccda0a23f345222a8b0ec269d68ab`
- Contents: inherited release evidence plus Stage 2060 compact-resolution captures regenerated from the Stage 2061 fixes.
- Final compact Command Overview AR, About System EN and Professional Radar EN images were manually opened and reviewed after CI.

## Windows deliverables

- Artifact: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10409911132`
- Artifact size: `57,204,477 bytes`
- Artifact SHA-256: `2f1f845207e0e1381865dbdc5bb3b8b1126cf80ab46405c8a48327bee44e1f96`
- Built from Stage 2061 stable implementation commit `08d9cfa3343ccda0a23f345222a8b0ec269d68ab`.
- Contents include:
  - `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
  - `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

Expected build-tree paths:

- Linux HMI: `build-qt/nexvary_avionics_hmi`
- Linux CLI: `build/nexvary_avionics_lab`
- Windows HMI before packaging: `build-win/Release/nexvary_avionics_hmi.exe`
- Windows installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- Windows portable ZIP: `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

## Public-data and safety boundaries

- OpenSky live state vectors provide public telemetry/callsign data. Rich registration/operator/route metadata remains `N/A` until a legally usable metadata provider is connected.
- Synthetic/replay data is labelled explicitly and is never presented as live data.
- The application is limited to awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis.
- It contains no autonomous engagement, weapons assignment, fire control, live-aircraft control, jammer control, spoofing, takeover or destructive interception.
- External API keys/connectors remain disabled by default.

## Continuation point

Continue after Stage 2061 without repeating completed Stage 1970–2061 work. Preserve the Deep Black + Royal Gold hierarchy, restrained semantic colors, typography floor, Arabic RTL, 55-case QML gate, compact 1366×768 and 1440×900 verification, manual visual review and independent Windows packaging verification.

The next useful functional batch is a **read-only aircraft metadata/route provider with cache, provenance and failure fallback**, followed by persisted 5/15/30/60-minute history windows and operator/source filters. After that, proceed to read-only weather and airfield/runway-condition providers using the same sequence: implement → build/test → real screenshots → manual review → fix → commit/push → handoff.
