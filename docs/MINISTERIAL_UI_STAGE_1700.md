# NEXVARY Avionics Lab — Ministerial UI Pass

This pass restructures the presentation layer without changing the safe training/simulation scope.

## Approved visual identity
- Dark Navy `#0C1319`
- Gunmetal `#2E3945`
- Metallic Silver `#9E9B98`
- Platinum `#D9D7D4`
- Electric Blue Accent `#6A88A0`

## Rebuilt presentation surfaces
- Executive Dashboard: denser platform overview, technical cutaway system map, compact MFD, live channel matrix, scenario controls and correlated events.
- Fault Lab: explicit ARM/INJECT/OBSERVE/RECOVER/VERIFY workflow, test-condition library, response evidence, live response channels, system-response matrix and recovery criteria.
- Verification Center: executive assurance summary, six-gate verification grid, evidence chain, channel evidence and traceable event panel.
- Engineering Workbench: telemetry analysis header, normalized multi-channel trend, structured channel matrix, statistics and run context.

## Visual rules
- Structural chrome uses Dark Navy, Gunmetal, Metallic Silver and Platinum.
- Electric Blue marks selection, synchronization and engineering emphasis.
- Green/amber/red are reserved for state/health only.
- No decorative neon glow in structural UI.
- No live aircraft control interface; synthetic training/simulation data only.

## Integration state
- Ministerial shell and internal layouts are implemented in QML.
- Visual QA must pass on Windows/Linux/Qt before release labeling changes.
