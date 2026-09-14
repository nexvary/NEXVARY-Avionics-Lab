# Stage 1970 — Ministerial Visual Architecture Audit

Date: 2026-09-14

## Scope and safety boundary

This audit studies only public imagery and public documentation to extract information hierarchy, presentation rhythm and display density. It does not reproduce a classified or proprietary interface, and it introduces no targeting, engagement, weapon-control, jamming, spoofing or takeover capability.

## Public visual references reviewed

- U.S. Air Forces Central, public Combined Air Operations Center imagery:
  https://www.afcent.af.mil/News/Photos/igphoto/2001773038/
- U.S. Air Forces Central, public Combat Operations Division overview:
  https://www.afcent.af.mil/About/Fact-Sheets/Display/Article/217807/combat-operations-division-cod/
- Republic of Türkiye Ministry of National Defence, public Air Operations Center imagery:
  https://www.msb.gov.tr/SlaytHaber/222022-67720
- Public imagery of the Russian National Defence Management Center was reviewed only for room-level presentation patterns: large central situation wall, briefing-first grouping and restrained secondary displays.
- NASA Open MCT public project material was used as a telemetry-layout reference:
  https://github.com/nasa/openmct

No third-party image, icon or UI asset from these references is embedded in the application.

## Rejected characteristics in Stage 1960

1. Large unused zones coexisted with compressed bottom-row content.
2. Too many equal-strength bordered cards weakened executive hierarchy.
3. Map rosters and labels competed with the geographic picture.
4. Aircraft silhouettes were crude, generic single polygons and appeared illustrative rather than engineered.
5. Fixed-width content did not use 2560×1440 effectively.
6. Secondary text remained too small when photographed from a presentation distance.

## Stage 1970 visual decisions

- One dominant Common Air Picture instead of a mosaic of equal cards.
- A single executive brief band with inline indicators and separators.
- Dedicated right decision column: force posture, squadron readiness, maintenance/training and incidents.
- Dedicated bottom airfield strip; no compressed page-wide widget row.
- Deep black and near-black surfaces, with gold used for command emphasis only.
- Electric blue for public flight information, green for nominal readiness, amber/red for exceptions and violet for RF/AEGIS classification.
- Continuously animated passive radar sweep with range rings and track trails.
- Original multi-path aircraft planform and side-elevation drawings with technical grid, reference dimensions, systems bus and health nodes.
- Larger shared type scale and Kufi-first Arabic rendering.
- Presentation mode removes navigation and footer while retaining brand, title and operational status.

## Verification targets

- Linux and Windows release builds.
- C++ test suite and Qt bridge tests.
- Sanitizers.
- QML runtime, navigation/back-stack, RTL and ten-locale gate.
- Real application screenshots at 1920×1080 and 2560×1440.
- Windows installer and portable ZIP.
