# Stage 1820 — Aeronautical Data Hub

Stage 1820 adds a dedicated aeronautical-data catalog to the Air Operations workspace.

## Implemented

- Indexed catalog of training airspace sectors across Classes A–G.
- Aerodrome browser with ICAO-style identifiers from the existing training dataset.
- NAVAID browser for VOR/DME/DME training references.
- Public-flight feed health and provenance display.
- Dataset search/filter surface for sector name, identifier and class.
- Per-class coverage counters and source-health summary.
- Explicit provenance and non-navigation warning.

## Boundary

The bundled airspace geometry is synthetic training data. It is not an official aeronautical publication and must not be used for navigation. Public/civil traffic remains awareness-only through the existing HTTPS feed adapter.
