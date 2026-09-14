# Stage 1950 — Visual and Architecture Audit

Date: 2026-09-14  
Baseline commit: `fcf555f48cf9d9a580ea5745b0a0741656003b7f`

## Verified baseline

- Qt 6.4 / C++20 Release configuration builds locally with warnings-as-errors.
- All 29 registered CTest targets pass.
- Back-navigation smoke and ten-locale launch smoke complete.
- The source security baseline passes.
- Real baseline captures were produced at 1920×1080 (English/Arabic) and 2560×1440 (Arabic).

## Audit findings

### Information architecture

- The shell exposes one flat list of 15 pages. It does not communicate the six operational domains: Command, Air Operations, Force Management, Engineering, C-UAS, and System.
- Air Operations already contains six useful internal workspaces, but they are hidden behind one generic navigation entry.
- Force Management is a single dense page even though bases, fleet, squadrons, crews, training, and maintenance are distinct operator tasks.
- Route history stores only page indexes, so an operator cannot reliably return to a specific nested workspace.

### Visual hierarchy

- The Stage 1920 overview has a useful map-first composition, but the application chrome still uses 6–9 px labels in several primary areas.
- Sidebar labels, build state, platform metadata, and status captions do not meet the stated minimum visual scale.
- The sidebar is fixed to the left even for RTL languages.
- Several older pages retain card-dense layouts with weak task hierarchy.

### Runtime defects detected during visual smoke

- `AirForceOperationsCenter.qml` references the nonexistent `publicFlightStatus` property.
- `AirForceManagementPage.qml` expects base fields (`state`, `code`, and `region`) that the Qt bridge does not publish.
- `AirForceManagementPage.qml` references the nonexistent `forceCrewRows` property.
- `AirReadinessPage.qml` anchors a child managed by `StackLayout`, producing undefined layout behavior.
- A radar canvas may call `arc()` before it has a valid positive radius.
- Canvas font strings use unavailable/unquoted family names on Linux, producing repeated runtime warnings.

### Data architecture

- Public ADS-B, AEGIS replay/awareness, synthetic training, and local replay paths exist, but there is no unified provider-status contract for name, source, mode, health, freshness, last update, and record count.
- The overview therefore assembles status tiles ad hoc and currently references one invalid property.

## Architecture decisions for this increment

1. Replace the flat navigation with grouped, collapsible, route-based navigation. A route retains both page and nested workspace state.
2. Mirror the shell itself in RTL, not only the page body.
3. Apply shared typography tokens with a 10 px floor for command chrome and 11–13 px normal/secondary text.
4. Promote Common Air Picture as the dominant overview surface and keep engineering/RF/C-UAS detail in dedicated workspaces.
5. Introduce a typed provider registry in C++ and expose one source-status model to QML.
6. Treat QML runtime warnings as release-gate failures, not harmless console noise.
7. Apply the approved visual change request through the shared theme and legacy direct-color surfaces: Deep Black `#000000`/`#0A0A0A`, Royal Gold `#D4AF37`, Platinum `#F2F2F2`, and Metallic Silver `#9E9B98`. Structural frames are gold; green, amber, and red are reserved for operational state.

## Implemented result

- The shell now provides grouped route navigation for Command, Air Operations, Force Management, Engineering, C-UAS, and System, including nested-workspace back-stack restoration.
- The shell and navigation rail mirror correctly for Arabic, Persian, and Urdu; Noto Kufi Arabic is the preferred RTL face.
- Command Overview remains map-first. Fleet, squadrons, bases, crews, training, maintenance, aircraft visuals, C-UAS, data sources, audit, reports, and settings are independent workspaces.
- A typed seven-provider registry publishes source, mode, health, freshness, last update, record count, trust boundary, read-only status, and network capability without repository API keys.
- Real release images were captured for English and Arabic at 1920×1080, Arabic at 2560×1440, every major rebuilt workspace, and all ten locales.
- Local verification: 30/30 Qt-enabled CTest targets, 48/48 QML route/workspace/locale/back-stack/RTL cases, 21/21 image-gate files, release/diagnostic/manifest verification, and source security baseline.
- ASan/UBSan: 29/29 non-Qt targets pass with leak detection disabled locally. LeakSanitizer cannot run under the Work container's `ptrace` policy; GitHub CI retains `detect_leaks=1` for the unrestricted runner.

## Public-source design references

The implementation uses architecture and information-hierarchy ideas only; no third-party interface is copied.

- [NASA Open MCT documentation](https://nasa.github.io/openmct/documentation/): modular mission views, telemetry-source adapters, summary widgets, time context, and operator-composable information hierarchy.
- [NASA AMMOS MMGIS](https://github.com/NASA-AMMOS/MMGIS): layered 2D/3D mission mapping, nested layer organization, temporal controls, mission-specific data ownership, and plugin separation.
- [CesiumJS imagery layers](https://cesium.com/learn/cesiumjs-learn/cesiumjs-imagery/): explicit separation between imagery providers and displayed layers, plus data-driven entities for tracks, labels, paths, and polygons.
- [OpenSky API documentation](https://opensky-network.org/data/api-docs): a public/research ADS-B provider is distinct from commercial schedule data and must expose source/mode limitations.
- [FAA ADS-B capabilities](https://www.faa.gov/air_traffic/technology/equipadsb/capabilities/ins_outs): position, altitude, velocity, identity, weather, and traffic are awareness data with coverage and latency context.

## Safety boundary

This increment remains limited to awareness, management, training, simulation, diagnostics, readiness, maintenance, and analysis. It adds no engagement, weapons assignment, fire-control, jammer, spoofing, takeover, or destructive-interception function.
