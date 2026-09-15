# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-16
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `e6a9bee78215557e65b0085c954981078e9bb79d`
Release identity: `v3.5.0 / Stage 1980 packaging identity + Stage 2091 Flight Tracking layout closure`

## Current stable state

Stage 2091 closes the Flight Tracking regression demonstrated in the user-supplied 1908×964 Windows recording `Video_2026-09-15_152030.mp4`.

The implementation was verified at `e6a9bee78215557e65b0085c954981078e9bb79d` on `main`. It preserves all Stage 2070–2090 aircraft/aerodrome provider caches, provenance, history, weather/runway separation, Deep Black + Royal Gold identity and passive/read-only safety boundaries.

## Stage 2091 — video-confirmed layout fix

The supplied recording was inspected frame-by-frame. It confirmed that, after closing the right aircraft-details panel, the persistent selected-aircraft popup inside `StrategicAirMap` could cover map content and the `DATA FUSION / RADAR SWEEP` region on the user's Windows viewport.

Completed fixes:

- Removed the full-width Flight Tracking website banner from `AirOperationsPage.qml` to recover 48 px of vertical workspace.
- Kept the tracking website visible at all times, but localized it to a compact dedicated panel at the top of the Flight Tracking right-hand column.
- The compact panel includes the NEXVARY mark, the label `AIRCRAFT TRACKING WEBSITE`, the visible URL `https://map.opensky-network.org/` and an `OPEN` button.
- The displayed URL itself is underlined/clickable and opens externally.
- The human-facing website remains semantically separate from `AUTHORIZED HTTPS TRACK FEED URL` and `LICENSED HTTPS METADATA / ROUTE URL`.
- Disabled the persistent selected-aircraft map popup on the Flight Tracking page (`showSelectedPublicPopup: false`).
- Aircraft selection/highlighting is preserved; detailed text remains in the dedicated right-hand aircraft-details panel instead of floating over the map.
- The existing strategic map, radar/weather/airspace/routes controls, data-fusion badge, track cards, provider panel and RF spectrum remain intact.

Implementation commits:

- `e25e587d2ba65a70e70cddc17e808c6d333c3a2d` — remove global tracking banner and recover vertical workspace.
- `e6a9bee78215557e65b0085c954981078e9bb79d` — eliminate persistent map-popup overlap and localize the website link.

## Visual identity preserved

Stage 2091 keeps the Stage 2090 approved system:

- Deep Black / deep aviation-blue structural base.
- Royal Gold `#D4AF37` for active frames and hierarchy.
- Restrained cyan / aviation-blue telemetry and radar accents.
- Platinum/white primary text and metallic/silver secondary text.
- NEXVARY mark visible in the main identity block and Flight Tracking website panel.

## Verified gates — Stage 2091

| Gate | Result |
|---|---:|
| Linux C++20 Release build, CTest and release smoke | PASS |
| Windows C++20 Release build, CTest and release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | PASS |
| QML routes/workspaces/Back/RTL/ten locales/viewport gate | PASS |
| Responsive real-application screenshot gate | PASS |
| Manual review of regenerated Flight Tracking screenshot | PASS |
| ASan/UBSan suite | PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt package verification | PASS |
| Portable ZIP generation | PASS |
| One-click Windows installer generation | PASS |

Final verified runs for stable implementation commit `e6a9bee78215557e65b0085c954981078e9bb79d`:

- CI: `35030982773`
- CodeQL Security: `35030982933`
- Windows Package: `35030982995`

## Real screenshot artifact

- Artifact name: `nexvary-avionics-stage2060-responsive-ui-release-gate`
- Artifact ID: `10421806489`
- Size: `13,288,354 bytes`
- SHA-256: `088b18050167f41da6562c8c45a8216cf1bccfc17d1860523e5f6df2d677ae64`
- Head SHA: `e6a9bee78215557e65b0085c954981078e9bb79d`
- Reviewed image: `stage1980-flight-tracking-en.png`

Manual visual review confirms that the real rendered Flight Tracking image has:

- no persistent aircraft information window covering the map/data-fusion region;
- a dedicated right-hand details column;
- a compact always-visible `AIRCRAFT TRACKING WEBSITE` panel;
- visible OpenSky map URL and `OPEN` button;
- NEXVARY mark;
- restored black/aviation-blue + Royal Gold + cyan visual system.

## Windows deliverables

- Artifact name: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10421463388`
- Artifact size: `57,243,997 bytes`
- Artifact SHA-256: `9be5e585751635267e1c7032f13a45c50c860ccfcc0818f070062ce53e489bad`
- Head SHA: `e6a9bee78215557e65b0085c954981078e9bb79d`

Contents:

- `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

Locally extracted verification copies from that exact artifact:

- Installer SHA-256: `f0feed404180b46867f98f30392f59f5e52f348a1ff050d8fb02cc4314dededc`
- Portable ZIP SHA-256: `dee6c17921b43d7937c337e081bda4f6b11b022fee9da5870cb6a6a432866c09`

## Preserved runtime/provider foundations

- `PublicFlightProviderCache` remains bounded, transactional and last-known-good aware.
- Public-flight metadata/route provider provenance, license, source URL and cache freshness remain preserved.
- Public-flight history retains 5/15/30/60-minute windows.
- Public NOAA/NWS AWC METAR and licensed aerodrome/runway-condition caches remain separate.
- `AerodromeProviderCache` keeps startup restore, persistence-after-validation and failure fallback.
- Synthetic/replay data remains explicitly labelled and cannot be confused with live data.
- No third-party licensed provider credentials were added.

## Safety and external-data boundary

- `https://map.opensky-network.org/` is a human-facing public web reference, not automatically submitted as a programmatic API feed.
- The authorized feed field remains HTTPS read-only and separate.
- The application remains limited to awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis.
- No live-aircraft control, targeting, fire control, weapons assignment, jammer control, spoofing or takeover capability was added.

## Exact continuation point

Continue after Stage 2091 without repeating Stage 1970–2091. The stable implementation SHA is `e6a9bee78215557e65b0085c954981078e9bb79d`; later documentation-only commits may move `main`.

### Stage 2092 — next useful batch

Continue provider observability/auditability only after preserving the Stage 2091 video-confirmed layout closure. Surface provider name/license/source, cache age, freshness, fallback/last-good and last-refresh status consistently across Flight Tracking, Aeronautical Data Hub and Data Sources. Keep deterministic CI with no live-Internet dependency and rerun the full Linux/Windows/Qt/QML/screenshot/sanitizer/security/CodeQL/package gates.
