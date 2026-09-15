# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-15
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `007209d2b317ce29cf95237e607b8ecde3801f14`
Release identity: `v3.5.0 / Stage 1980 packaging identity + Stage 2071 Qt provider-runtime closure`

## Current stable state

Stage 2071 continues directly from the verified Stage 2070 provider-cache closure. It preserves the approved Deep Black + Royal Gold visual system, Air Operations, Force Management, avionics engineering, diagnostics, telemetry, verification, replay, reports, ten locales, Arabic RTL, Presentation Mode, responsive 1366×768 / 1440×900 coverage and the inherited real-application screenshot gate.

The stable implementation commit is `007209d2b317ce29cf95237e607b8ecde3801f14` on `main`.

## Stage 2071 — Qt runtime last-known-good provider integration

Stage 2071 wires the Stage 2070 transactional `PublicFlightProviderCache` into the live Qt runtime path instead of leaving it as an isolated core primitive.

### Completed work

- Qt runtime now restores `public-flight-provider-last-good.json` automatically during `CockpitBridge` startup.
- A restored provider is explicitly marked as `CACHE FALLBACK / LAST GOOD` and is never presented as a newly fetched live provider.
- Restored metadata/route records are applied immediately to the current public-flight snapshot with provider name, license, source URL and TTL/cache provenance preserved.
- Successful provider-file imports pass through the transactional provider cache and persist only after validation succeeds.
- Successful HTTPS provider refreshes persist only after the new payload parses and validates successfully.
- Malformed JSON, invalid provider payloads and oversized payloads do not replace the existing last-known-good provider.
- HTTPS URL validation and network failures now mark the existing provider explicitly as fallback while keeping it active.
- During a refresh, status states that the last-known-good provider is retained until the replacement is verified.
- Public-flight telemetry coordinates and kinematics remain separate from metadata/route enrichment; the cache remains read-only.
- Public-flight history persistence and 5/15/30/60-minute windows continue unchanged.

### Changed files

- `src/air_ops/PublicFlightProviderCache.hpp`
- `src/air_ops/PublicFlightProviderCache.cpp`
- `src/qt/CockpitBridge.hpp`
- `src/qt/CockpitBridge.cpp`
- `src/qt/CockpitBridgeFlightFeed.cpp`
- `tests/test_qt_bridge.cpp`

### Qt bridge verification added

The Qt bridge test now uses an isolated `QStandardPaths` test location and verifies:

- no provider exists in a clean startup state;
- valid licensed provider import enriches tracks and persists the exact last-good payload;
- a second `CockpitBridge` process restores the provider automatically at startup;
- startup-restored status includes `LICENSED`, `FALLBACK` and `STARTUP RESTORE`;
- provider source/license provenance survives restart;
- malformed provider refresh returns failure without replacing the last-good provider;
- invalid non-HTTPS refresh request preserves the last-good provider and exposes the HTTPS failure reason;
- existing enriched track values remain available during fallback.

## Existing foundations preserved

- `PublicFlightProviderCache` remains bounded and transactional.
- `PublicFlightEnrichmentCache` continues to parse provider records and attach FRESH/STALE TTL state.
- `PublicFlightHistoryStore` retains persisted public-flight history with 5/15/30/60-minute windows.
- Flight Tracking retains search, type, altitude, operator and source filters.
- Public ADS-B/synthetic telemetry remains distinct from licensed metadata/route provenance.
- NOAA/NWS Aviation Weather Center public METAR support and licensed runway-condition ingress from Stages 2030–2040 remain present and must not be duplicated.

## Verified gates — Stage 2071

| Gate | Result |
|---|---:|
| Linux C++20 Release build, CTest and release smoke | PASS |
| Windows C++20 Release build, CTest and release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | PASS |
| Stage 2071 startup restore / persistence / failure fallback Qt tests | PASS |
| QML routes/workspaces/Back/RTL/ten locales/viewport matrix | 55/55 PASS |
| Responsive real-application screenshot gate | PASS |
| ASan/UBSan suite | PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt package verification | PASS |
| Portable ZIP generation | PASS |
| One-click Windows installer generation | PASS |

Final verified runs for stable implementation commit `007209d2b317ce29cf95237e607b8ecde3801f14`:

- CI: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35016805262`
- CodeQL Security: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35016805296`
- Windows Package: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35016805381`

## Real screenshot artifact

- Name: `nexvary-avionics-stage2060-responsive-ui-release-gate`
- Artifact ID: `10416366228`
- Size: `12,980,971 bytes`
- SHA-256: `2802822d79a8133a9cf12c1f9bf61e817e2e12b349745fcea3663f4842ad0153`
- Head SHA: `007209d2b317ce29cf95237e607b8ecde3801f14`
- The inherited workflow artifact name retains Stage 2060 naming, but this artifact was regenerated successfully from the Stage 2071 head.

## Windows deliverables

- Artifact: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10416331992`
- Artifact size: `57,224,221 bytes`
- Artifact SHA-256: `57e39e4b63ae857be603cab62773cb867ea6298cc861ab5fae0e0f0becc4908b`
- Head SHA: `007209d2b317ce29cf95237e607b8ecde3801f14`
- Contents include:
  - `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
  - `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

Expected build-tree paths:

- Linux HMI: `build-qt/nexvary_avionics_hmi`
- Linux CLI: `build/nexvary_avionics_lab`
- Windows HMI before packaging: `build-win/Release/nexvary_avionics_hmi.exe`
- Windows installer: `dist-installer/NEXVARY-Avionics-Lab-Setup.exe`
- Windows portable ZIP: `NEXVARY-Avionics-Lab-v3.5.0-Portable.zip`

## Tests not performed / external verification boundary

- No external licensed aircraft metadata/route provider endpoint was contacted in Stage 2071 because no legally usable licensed endpoint/credentials were supplied.
- Therefore live external-provider availability and provider-specific response compatibility are not claimed as verified.
- Runtime acquisition, transactional validation, persistence, startup restore and failure fallback are verified using deterministic local licensed-provider fixtures and the Qt runtime tests.

## Known issues / constraints

- No known build, test, QML, sanitizer, security or packaging regression remains in Stage 2071.
- The runtime has no default third-party aircraft metadata/route provider configured; a legally usable licensed provider must be supplied before external live enrichment can be validated.
- External API keys/connectors remain disabled by default.

## Public-data and safety boundaries

- Public flight telemetry and legally usable metadata/route sources remain read-only.
- Provider provenance, license, cache state and freshness remain visible and auditable.
- Synthetic/replay data is labelled explicitly and is never represented as live data.
- The application remains limited to awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis.
- It contains no autonomous engagement, weapons assignment, fire control, strike planning, live-aircraft control, jammer control, spoofing, takeover or destructive interception.

## Exact continuation point

Continue after Stage 2071 without repeating completed Stage 1970–2071 work.

### Stage 2080 — exact next step

Extend the same last-known-good transactional runtime model to the existing aerodrome-provider path without rebuilding the weather/airfield modules already completed in Stages 2030–2040:

1. Preserve the existing NOAA/NWS Aviation Weather Center public METAR connector and provenance.
2. Add bounded startup restore and explicit stale/fallback state for the existing aerodrome weather cache where appropriate.
3. Persist licensed runway-condition refreshes only after successful validation; never persist a failed replacement over a valid last-good runway dataset.
4. Keep public METAR and licensed runway-condition provenance separate and visible in Aeronautical Data Hub / Data Sources.
5. Add Qt bridge tests for startup restore, successful persistence and network/parse fallback for aerodrome/runway providers.
6. Run Linux, Windows, Qt CTest, QML 55-case gate, responsive screenshots, ASan/UBSan, security, CodeQL and independent Windows packaging before closing the batch.
