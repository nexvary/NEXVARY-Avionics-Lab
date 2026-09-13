# Stage 1800 — Air Picture & Visual Intelligence

Stage 1800 turns the former Air Operations workspace into a denser visual-awareness surface.

## Implemented surfaces

- Public/civil flight feed adapter with OpenSky-compatible `states` parsing.
- Configurable HTTPS public-flight endpoint from the Qt/QML interface.
- Global visual air picture combining public/civil tracks with AEGIS replay tracks.
- Track cards for callsign/ICAO, altitude, speed and heading.
- Aircraft visual explorer for jet, rotorcraft, UAV and turboprop training profiles.
- Passive synthetic RF spectrum with peak frequency/level visualization.
- Expanded visual accent palette while retaining NEXVARY dark navy / gunmetal / metallic framing.
- Stage 1800 release-gate screenshots at 1920x1080 and 2560x1440.

## Public flight data boundary

The public feed is intended for public/civil ADS-B awareness and training. Network fetching accepts HTTPS only, limits response payload size, and parses awareness fields such as position, altitude, velocity and heading. It is not a targeting, interception or engagement interface.

The OpenSky-compatible endpoint shown in the interface is an example public data source. Availability, rate limits and authentication requirements belong to the external provider and may change.

## RF boundary

The Stage 1800 RF display is receive/visualization only and currently uses a deterministic synthetic spectrum for UI, replay and training. It provides no transmission, jamming, spoofing, takeover, demodulation or active control capability.

A future receive-only hardware adapter can replace the synthetic samples through a separate input provider without changing the UI contract.

## Aircraft imagery

Stage 1800 introduces a technical aircraft-render viewport and profile switching. Licensed photographic and 3D assets can be added to the same viewport in a later asset pass; they are intentionally not fetched implicitly from the internet or embedded without a documented license.
