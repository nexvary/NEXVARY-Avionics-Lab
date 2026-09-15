# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-16
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `d39c322783de63c48077e373f48da71091165b12`
Release identity: `v3.5.0 / Stage 1980 packaging identity + Stage 2090 visual/tracking-link closure`

## Current stable state

Stage 2090 closes the Flight Tracking visual regression reported against the Stage 2080 Windows package and preserves all verified Stage 2070–2080 aircraft/aerodrome last-known-good cache work.

The implementation was verified at `d39c322783de63c48077e373f48da71091165b12` on `main`.

## Stage 2090 — approved aviation visual identity restored

The user-supplied Stage 1980 Windows build and photographed Flight Tracking screen were used as the visual reference. The uploaded Windows ZIP is a built package, not editable QML source; the actual fix was made in the current GitHub source.

Completed visual work:

- Restored a deep black / deep aviation-blue structural base rather than flat black/gray-only panels.
- Preserved Royal Gold `#D4AF37` as the primary hierarchy, active frame and premium structural accent.
- Restored restrained cyan / aviation-blue telemetry, map, radar and data accents.
- Preserved platinum/white high-contrast text and metallic/silver secondary text.
- Preserved the existing `NexvaryMark` in the main left navigation identity block.
- Added an additional compact `NexvaryMark` directly in the Flight Tracking web-reference bar so NEXVARY identity remains visible in the relevant workflow.
- The resulting real CI screenshot was manually opened and visually reviewed after the QML release gate.

Theme implementation commit:

- `7b1abda715991197c73d89a98c81bba51075c3eb` — `Stage 2090: restore approved aviation black-gold-cyan visual identity`

Primary theme values now include:

- Deep Black: `#020406`
- Shell: `#070A0F`
- Deep aviation panel: `#0B1017`
- Secondary panel: `#101822`
- Elevated panel: `#1A2632`
- Royal Gold: `#D4AF37`
- Signal Cyan: `#72B7D6`
- Electric/Aviation Blue: `#6FA6CC`
- Radar Green: `#45D0A0`
- Platinum: `#F2F4F7`

## Stage 2090 — aircraft-tracking website link restored and separated from the feed

The photographed older build showed `https://map.opensky-network.org/` being entered into the data-feed field, which caused a feed-transfer error. Stage 2090 fixes the UI model so a human-facing tracking website can no longer be confused with the authorized HTTPS data-feed endpoint.

Completed work in `qml/AirOperationsPage.qml`:

- Added a dedicated Flight Tracking web-reference bar visible only in the Flight Tracking workspace.
- Added a read-only website field with:
  - `https://map.opensky-network.org/`
- Added a clear label:
  - `NEXVARY • AIRCRAFT TRACKING WEBSITE`
- Added an explicit clarification:
  - `PUBLIC WEB REFERENCE • NOT AN API FEED`
- Added an `OPEN MAP` button that opens the public website externally.
- Kept the existing `AUTHORIZED HTTPS TRACK FEED URL` field inside `FlightTrackingPage.qml` separate and unchanged for actual normalized/authorized feed acquisition.
- Kept the existing `LICENSED HTTPS METADATA / ROUTE URL` field separate for provider enrichment.
- No web-map URL is automatically submitted to `fetchPublicFlightFeed`.
- No third-party API credentials or unlicensed provider access were added.

Implementation commit:

- `d39c322783de63c48077e373f48da71091165b12` — `Stage 2090: restore flight-tracking web reference and NEXVARY identity`

## Preserved provider/runtime foundations

Stage 2090 does not rebuild or weaken the prior provider layers:

- `PublicFlightProviderCache` remains bounded and transactional with last-known-good startup restore/fallback.
- Public-flight metadata/route provenance, provider/license/source URL and freshness remain preserved.
- Public-flight history retains 5/15/30/60-minute windows.
- Public NOAA/NWS Aviation Weather Center METAR and licensed runway-condition caches remain separate.
- `AerodromeProviderCache` retains startup restore, persistence-after-validation and failure fallback.
- Public METAR and licensed runway-condition provenance remain separate.
- Synthetic/replay data remains explicitly labelled.

## Verified gates — Stage 2090

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

Final verified runs for stable implementation commit `d39c322783de63c48077e373f48da71091165b12`:

- CI: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35029013766`
- CodeQL Security: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35029013837`
- Windows Package: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35029013718`

The CI jobs verified Qt HMI, Linux/Windows builds, tests, QML runtime/route/back-stack/RTL/ten-locale/viewport coverage, responsive screenshot capture, sanitizers and source-security baseline.

## Real screenshot artifact

- Artifact name: `nexvary-avionics-stage2060-responsive-ui-release-gate`
- Artifact ID: `10420533524`
- Size: `13,289,197 bytes`
- SHA-256: `4243affd16ada694f8d79c41796ee23a21dd6fa3b5b11aaae70960bcf9515410`
- Head SHA: `d39c322783de63c48077e373f48da71091165b12`
- Relevant reviewed image: `stage1980-flight-tracking-en.png`
- The artifact filename retains historical Stage 1980/2060 naming, but the screenshot was regenerated from the Stage 2090 implementation head.

Manual visual review confirmed:

- NEXVARY logo/mark visible.
- Deep black / aviation-blue background restored.
- Royal-gold frames/hierarchy visible.
- Cyan/blue telemetry/map accents visible.
- Dedicated aircraft-tracking website URL visible.
- `OPEN MAP` button visible.
- Public website is labelled as a web reference, not an API feed.
- Existing Flight Tracking filters, strategic map/radar composition and aircraft-details panel remain visible.

## Windows deliverables

- Artifact name: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10420663404`
- Artifact size: `57,240,676 bytes`
- SHA-256: `39e0a6228571a915d47cc30764a4f820f2fdd99834eeeda5cba55e1c2e48f614`
- Head SHA: `d39c322783de63c48077e373f48da71091165b12`
- Contents:
  - `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
  - `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

Expected build-tree paths:

- Linux HMI: `build-qt/nexvary_avionics_hmi`
- Linux CLI: `build/nexvary_avionics_lab`
- Windows HMI before packaging: `build-win/Release/nexvary_avionics_hmi.exe`
- Windows installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- Windows portable ZIP: `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

## External verification boundary

- The OpenSky map URL is used only as a human-facing public web reference and was not treated as a programmatic API contract.
- CI does not depend on the external map website being online.
- No external licensed aircraft metadata/route or runway-condition credentials were supplied or contacted in this batch.
- Provider-specific third-party compatibility beyond deterministic normalized test fixtures is therefore not claimed.

## Public-data and safety boundaries

- Public web/map references and legally usable telemetry/metadata/weather/condition sources remain read-only.
- Provider provenance, license, cache state and freshness remain visible and auditable.
- Synthetic/replay data is never represented as live data.
- The application remains limited to awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis.
- It contains no autonomous engagement, weapons assignment, fire control, strike planning, live-aircraft control, jammer control, spoofing, takeover or destructive interception.

## Exact continuation point

Continue after Stage 2090 without repeating Stage 1970–2090 work. The stable implementation SHA is `d39c322783de63c48077e373f48da71091165b12` even if later documentation-only commits move `main`.

### Stage 2091 — next useful batch

1. Continue the previously planned provider observability/auditability work without changing the restored Stage 2090 visual identity.
2. Surface provider name, license/source, cache age, freshness, fallback/last-good and last-refresh state consistently in Flight Tracking, Aeronautical Data Hub and Data Sources.
3. Add deterministic Qt/QML presentation checks for fresh/stale/fallback/provider-provenance states without live-Internet CI dependencies.
4. Preserve the dedicated aircraft-tracking website bar and keep website/feed/metadata URLs semantically separate.
5. Preserve Deep Black + Royal Gold + restrained aviation-blue/cyan as the locked visual system.
6. Run Linux, Windows, Qt CTest, QML/RTL/viewport gate, real screenshots, ASan/UBSan, security, CodeQL and Windows packaging before closure.
