# NEXVARY Avionics Lab — Work Project Handover

Last updated: 2026-09-16
Repository: `nexvary/NEXVARY-Avionics-Lab`
Branch: `main`
Stable implementation commit: `5487fe4a62b67417d1c0ead9b263ca887517075e`
Release identity: `v3.5.0 / Stage 1980 packaging identity + Stage 2080 aerodrome-provider runtime-cache closure`

## Current stable state

Stage 2080 continues directly from the verified Stage 2071 aircraft-provider runtime closure. It preserves the approved Deep Black + Royal Gold visual system, Air Operations, Force Management, avionics engineering, diagnostics, telemetry, verification, replay, reports, ten locales, Arabic RTL, Presentation Mode, responsive 1366×768 / 1440×900 coverage and the inherited real-application screenshot gate.

The current stable implementation commit is `5487fe4a62b67417d1c0ead9b263ca887517075e` on `main`.

## Stage 2080 — aerodrome last-known-good runtime caches

Stage 2080 extends the transactional last-known-good runtime model to the existing aerodrome provider path without rebuilding the weather/airfield modules already completed in Stages 2030–2040.

### Completed work

- Added a dedicated bounded transactional `AerodromeProviderCache` core component.
- Public NOAA/NWS Aviation Weather Center METAR data and licensed aerodrome/runway-condition data use separate cache instances and separate persisted last-good files.
- Qt runtime restores the latest verified public METAR cache automatically at startup when available.
- Qt runtime restores the latest verified licensed aerodrome/runway-condition cache automatically at startup when available.
- Restored data is explicitly marked as `CACHE FALLBACK / LAST GOOD` / startup restore rather than being represented as newly fetched live data.
- Public METAR refreshes retain the prior verified dataset until the new network payload has passed size and parser validation.
- Licensed runway-condition refreshes retain the prior verified dataset on invalid URL, network error, oversized payload or parse/validation failure.
- Only successfully parsed and validated replacements are persisted to the local last-known-good files.
- Public METAR provenance and licensed runway-condition provenance remain separate at the persistence layer and in runtime status/source reporting.
- The existing Aviation Weather Center connector remains HTTPS read-only and limits station requests to sanitized ICAO identifiers.
- The existing licensed aerodrome-condition path remains HTTPS/file based, read-only and provider/license/provenance aware.
- Weather and runway observations retain source, license, source URL, cache state, cached/expires timestamps and observation fields.
- Public METAR remains preferred for weather rows where available; licensed weather may provide fallback coverage without replacing the public-source provenance.
- No control, targeting, flight-control or active RF behavior was added.

### Changed files

Stage 2080 is a single implementation commit over its parent and changed exactly these files:

- `CMakeLists.txt`
- `src/air_ops/AerodromeProviderCache.cpp` — added
- `src/air_ops/AerodromeProviderCache.hpp` — added
- `src/qt/CockpitBridge.cpp`
- `src/qt/CockpitBridge.hpp`
- `src/qt/CockpitBridgeAerodrome.cpp`
- `tests/test_aerodrome_provider_cache.cpp` — added
- `tests/test_qt_bridge.cpp`

The commit adds the new core cache to the build/test matrix and extends Qt bridge tests for runtime persistence/fallback behavior.

## Stage 2080 persistence model

The runtime uses two intentionally separate persisted last-known-good datasets:

- Public METAR cache: `public-metar-last-good.json`
- Licensed aerodrome/runway cache: `licensed-aerodrome-conditions-last-good.json`

This separation is an architectural decision. Public weather data and licensed runway/condition data must not be merged into one persisted provider envelope because their provenance, licensing and refresh behavior are different.

### Public METAR behavior

- Existing endpoint remains `https://aviationweather.gov/api/data/metar`.
- Requests are read-only and station IDs are sanitized and capped.
- Response payload is size bounded.
- New data is parsed through the existing Aviation Weather METAR adapter.
- A failed replacement leaves the previous verified METAR dataset active.
- A successful replacement is persisted only after validation.
- Startup restore is visibly marked as cached/fallback data.

### Licensed runway / aerodrome-condition behavior

- Source must be a validated local file or HTTPS provider endpoint.
- Provider name and license/provenance remain mandatory in the normalized envelope.
- New refresh is transactional: invalid data never replaces an active valid cache.
- Last-known-good data is preserved across network/parse failures and process restart.
- Runway and licensed-weather records keep their provider provenance distinct from public METAR.

## Stage 2071 aircraft-provider runtime foundation preserved

Stage 2071 remains fully intact beneath Stage 2080:

- `PublicFlightProviderCache` restores `public-flight-provider-last-good.json` at startup.
- Successful aircraft metadata/route provider refreshes persist only after validation.
- Malformed/oversized/network-failed refreshes preserve the previous licensed provider and expose explicit fallback status.
- Aircraft provider name, license, source URL, TTL/cache provenance and 5/15/30/60-minute history remain available.
- Public/synthetic telemetry remains separated from aircraft metadata/route provenance.

## Verified gates — Stage 2080

| Gate | Result |
|---|---:|
| Linux C++20 Release build, CTest and release smoke | PASS |
| Windows C++20 Release build, CTest and release smoke | PASS |
| Qt 6 Release build and Qt-enabled CTest | PASS |
| Aerodrome provider cache core tests | PASS |
| Qt startup restore / persistence / failure-fallback tests | PASS |
| QML routes/workspaces/Back/RTL/ten locales/viewport matrix | PASS |
| Responsive real-application screenshot gate | PASS |
| ASan/UBSan suite | PASS |
| Source security baseline | PASS |
| CodeQL C++ analysis | PASS |
| Windows MSVC/Qt package verification | PASS |
| Portable ZIP generation | PASS |
| One-click Windows installer generation | PASS |

Final verified runs for stable implementation commit `5487fe4a62b67417d1c0ead9b263ca887517075e`:

- CI: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35018324055`
- CodeQL Security: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35018324002`
- Windows Package: `https://github.com/nexvary/NEXVARY-Avionics-Lab/actions/runs/35018324065`

The CI run completed successfully for all five jobs: Qt HMI Linux, Windows build/test, Ubuntu build/test, security baseline and sanitizer suite.

## Real screenshot artifact

- Name: `nexvary-avionics-stage2060-responsive-ui-release-gate`
- Artifact ID: `10416588431`
- Size: `12,982,879 bytes`
- SHA-256: `b79e6e1eb9c95ad3d281dd6f3713904881c394b478bad60e49541a08f97d59f8`
- Head SHA: `5487fe4a62b67417d1c0ead9b263ca887517075e`
- The workflow artifact name retains the inherited Stage 2060 naming, but the captures were regenerated successfully from the Stage 2080 head.

## Windows deliverables

- Artifact: `NEXVARY-Avionics-Lab-Windows-v3.5.0-Stage1980`
- Artifact ID: `10417031633`
- Artifact size: `57,232,057 bytes`
- Artifact SHA-256: `1da1e783a3348ccb5380823a6e05847219fc5736bcf4568e6e7370c43bb43a79`
- Head SHA: `5487fe4a62b67417d1c0ead9b263ca887517075e`
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

- Stage 2080 verified the runtime cache, parser, persistence, startup restore and failure-fallback behavior with deterministic tests.
- No external licensed runway-condition provider endpoint was contacted because no legally usable licensed endpoint/credentials were supplied.
- Therefore provider-specific compatibility for a future third-party licensed runway source is not claimed as verified.
- The existing public Aviation Weather Center connector is implemented and preserved, but CI does not depend on live external-network availability; deterministic fixtures are used for release verification.

## Known issues / constraints

- No known build, CTest, Qt, QML, sanitizer, security, CodeQL or Windows-packaging regression remains at Stage 2080.
- The inherited workflow/artifact release names still contain historical Stage 1980 / Stage 2060 labels even though their head SHA is Stage 2080. This is naming debt only; the generated binaries/screenshots are from the Stage 2080 implementation SHA.
- No default third-party licensed runway-condition provider is configured.
- External API keys/connectors remain disabled by default.

## Public-data and safety boundaries

- Public flight, public METAR and legally usable metadata/runway-condition sources remain read-only.
- Provider provenance, license, cache state and freshness remain visible and auditable.
- Synthetic/replay data is labelled explicitly and is never represented as live data.
- The application remains limited to awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis.
- It contains no autonomous engagement, weapons assignment, fire control, strike planning, live-aircraft control, jammer control, spoofing, takeover or destructive interception.

## Exact continuation point

Continue after Stage 2080 without repeating completed Stage 1970–2080 work. GitHub `main` and this handoff are the source of truth.

### Stage 2090 — exact next step

Do not rebuild the aircraft, METAR or aerodrome cache layers. The next useful batch should focus on provider observability and operator-facing auditability:

1. Surface last-known-good/fallback state, provider name, license/source, freshness/cache age and last refresh status consistently in Aeronautical Data Hub and Data Sources.
2. Add clear visual distinction between fresh public METAR, restored cached METAR and licensed-condition fallback without changing the Deep Black + Royal Gold system.
3. Add deterministic Qt/QML checks for fallback/stale/provider-provenance presentation; do not make CI depend on live Internet access.
4. Preserve the current separate public-METAR and licensed-condition persistence model.
5. Keep a future third-party licensed runway provider behind the existing normalized HTTPS/file contract until a legally usable endpoint/credentials are supplied.
6. Run Linux, Windows, Qt CTest, QML gate, responsive real screenshots, ASan/UBSan, security, CodeQL and independent Windows packaging before closing Stage 2090.
