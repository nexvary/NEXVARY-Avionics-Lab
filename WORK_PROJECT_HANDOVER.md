# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-15
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `8bda7f74d6a4d66f3513b66aa8f993f7a84af9dc`
Release identity: `v3.5.0 / Stage 1980 packaging identity + Stage 2070 provider-cache closure`

## Current stable state

Stage 2070 continues directly from the verified Stage 2061 responsive-visual closure. It preserves the approved Deep Black + Royal Gold visual system, Air Operations, Force Management, Space Domain, C-UAS awareness, avionics engineering, diagnostics, verification, replay, reports, ten locales, Arabic RTL, Presentation Mode, compact 1366×768 support and the inherited real-screenshot release gate.

The stable implementation commit is `8bda7f74d6a4d66f3513b66aa8f993f7a84af9dc` on `main`.

## Stage 2070 — last-known-good aircraft provider cache

Stage 2070 adds a bounded, transactional cache layer for read-only aircraft metadata and route providers without changing telemetry coordinates, kinematics or the platform safety boundary.

Implemented files:

- `src/air_ops/PublicFlightProviderCache.hpp`
- `src/air_ops/PublicFlightProviderCache.cpp`
- `tests/test_public_flight_provider_cache.cpp`
- `CMakeLists.txt` updated to compile and test the new component.

Implemented behavior:

- Maximum provider payload is bounded; oversized or empty payloads are rejected before replacing active data.
- Valid refreshes are parsed through the existing `PublicFlightEnrichmentCache`, so provider name, license, source URL, TTL, metadata provenance and route provenance remain attached.
- Refresh is transactional: a malformed/new failed refresh never replaces an already valid provider snapshot.
- When a refresh fails after a valid snapshot exists, the cache explicitly enters a `FALLBACK / LAST GOOD` state and continues serving the prior licensed snapshot.
- The last-known-good raw provider payload can be persisted to local storage through a temporary-file + replace flow.
- A new application/process can restore that last-known-good payload and marks it explicitly as cache fallback rather than pretending it is newly fetched data.
- Cache status exposes availability, fallback state, record count, payload size, last refresh epoch and sanitized failure reason.
- Enrichment application remains read-only and reuses the existing FRESH/STALE TTL handling.

The release-safe unit test does not rely on side-effecting `assert(...)` expressions. It verifies valid refresh, enrichment/provenance, disk persistence, malformed-refresh fallback, last-good restore, continued enrichment from fallback and payload-limit rejection.

## Existing aircraft enrichment/history foundation preserved

The pre-existing Stage 2061 code already provides:

- `PublicFlightEnrichmentCache` for licensed metadata/route records with TTL and explicit provenance.
- Aircraft registration, type/model, manufacturer, operator, route, origin/destination and schedule fields when a legally usable provider supplies them.
- Explicit `N/A`/empty behavior instead of inventing unavailable metadata.
- `PublicFlightHistoryStore` with persistent track points and selectable 5/15/30/60-minute windows.
- Flight Tracking search plus aircraft-type, altitude, operator and source filters.
- HTTPS-only read-only feed/enrichment acquisition in the Qt bridge.
- Public/synthetic telemetry kept separate from metadata/route provenance.

Stage 2070 deliberately adds the missing last-known-good cache/failure-fallback primitive instead of duplicating those existing features.

## Stage 2061 responsive visual closure preserved

- Arabic Command Overview heading clipping at 1366×768 was corrected.
- About System capability-card code/title collision was corrected.
- The C-UAS compact-height composition was rebalanced so the professional radar remains the primary technical visualization.
- Final compact screenshots were manually opened and reviewed after CI.
- 1366×768 and 1440×900 remain part of the viewport/release verification matrix.

## Verified gates — Stage 2070

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

Final verified runs for stable implementation commit `8bda7f74d6a4d66f3513b66aa8f993f7a84af9dc`:

- CI: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35001808034`
- CodeQL Security: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35001809327`
- Windows Package: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35001808093`

## Real screenshot artifact

- Name: `nexvary-avionics-stage2060-responsive-ui-release-gate`
- Artifact ID: `10410476248`
- Size: `12,982,558 bytes`
- SHA-256: `069d9c5516960a4287bc085e833dd4852637aabe9b1ecfef857b2515d1d70d3c`
- Head SHA: `8bda7f74d6a4d66f3513b66aa8f993f7a84af9dc`
- The workflow/artifact name retains the Stage 2060 naming, but the captures were regenerated and verified from the Stage 2070 head.

## Windows deliverables

- Artifact: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10410411970`
- Artifact size: `57,209,643 bytes`
- Artifact SHA-256: `114454312c9a20eae787f2f569d6567db849f1832e54372477502af70d479b6b`
- Built and verified from Stage 2070 stable implementation commit `8bda7f74d6a4d66f3513b66aa8f993f7a84af9dc`.
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

- Public flight telemetry and legally usable metadata/route sources remain read-only.
- Provider provenance, license, cache state and freshness remain visible and auditable.
- Synthetic/replay data is labelled explicitly and is never represented as live data.
- The application remains limited to awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis.
- It contains no autonomous engagement, weapons assignment, fire control, live-aircraft control, jammer control, spoofing, takeover or destructive interception.
- External API keys/connectors remain disabled by default.

## Continuation point

Continue after Stage 2070 without repeating completed Stage 1970–2070 work. Preserve the Deep Black + Royal Gold hierarchy, Arabic RTL, 55-case QML gate, compact 1366×768/1440×900 coverage, real-screenshot review, CodeQL/security gates and independent Windows packaging verification.

The next implementation batch is Stage 2071: wire `PublicFlightProviderCache` into the Qt runtime path so the application restores the persisted last-known-good licensed provider at startup, persists only successful provider refreshes, and keeps the prior cache active with an explicit fallback status when network/parse refresh fails. Add Qt bridge tests for startup restore, successful refresh persistence and failure fallback before continuing to weather/airfield provider expansion.
