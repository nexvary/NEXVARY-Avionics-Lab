# Stage 1860 — Visual Command Center Redesign

Stage 1860 restructures the default dashboard into a denser visual command center for training, simulation, engineering review and situational awareness.

## Dashboard changes

- Enlarged radar / unified air picture as the primary visual surface.
- Public/civil ADS-B tracks and AEGIS awareness tracks shown in the same visual workspace with separate colors.
- Compact command metrics for air tracks, C-UAS review, fleet readiness, maintenance, passive RF and diagnostic health.
- Selected-aircraft engineering schematic moved directly onto the dashboard instead of being limited to the Aircraft workspace.
- Compact platform-readiness cards replace oversized low-density readiness blocks.
- C-UAS response summary is visible on the main dashboard with detect/classify/verify/coordinate/record workflow state.
- Passive RF spectrum is visible on the dashboard with peak frequency and level.
- Stronger visual differentiation: cyan for public flight data, royal gold for AEGIS/C-UAS context, violet for passive RF, green for nominal states and orange for review/high-priority context.

## Safety boundary

The dashboard is an awareness, simulation, diagnostics, readiness and review interface. C-UAS content is limited to detection, classification, verification, coordination and incident recording. The project does not provide live jamming, takeover, engagement control, weapons assignment or live-aircraft control.

## Release gate

The Stage 1860 UI gate captures:

- Command center at 1920x1080 and 2560x1440.
- Airspace classification.
- Air picture / passive RF.
- Aeronautical data hub.
- Training route lab.
- Aircraft storyboard.
- C-UAS response center.
- Air force management.
- Diagnostic center and About System.
- All ten supported UI languages.
