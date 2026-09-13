# Air Force Management System Research Baseline

## Purpose

This document resets the product architecture around **air-force management, readiness, sustainment, training, airspace awareness, data integration and executive reporting** rather than trying to place every function on one dashboard.

The platform remains an **engineering / training / management / situational-awareness system**. It does not implement weapons assignment, target engagement, jamming, spoofing, takeover, interceptor guidance or live-aircraft control.

## Public systems reviewed

### United States — Air Operations Center / sustainment systems

Public U.S. Air Force material describes the Air Operations Center as a system-of-systems with distinct functional divisions rather than a single all-purpose display. Public descriptions consistently separate strategy/assessment, planning, current operations, mobility and ISR. Separate Air Force sustainment systems handle maintenance data and predictive maintenance; PANDA is publicly described as the Air Force system of record for predictive maintenance / CBM+.

Design lesson for NEXVARY: **separate operational awareness from readiness, maintenance, training, logistics and executive assessment**. The executive home should summarize these domains and let operators enter a dedicated workspace for each.

Sources:
- https://www.acc.af.mil/Portals/92/Docs/Fact%20Sheets%20-%202020%20Update/Facts%20Sheets%20-%202023%20Update/AIR%20OPERATIONS%20CENTER_AOC_FEB%202023.pdf
- https://www.afcent.af.mil/About/Fact-Sheets/Display/Article/217803/combined-air/combined-air-operations-center-caoc/
- https://www.aflcmc.af.mil/RSO-DAC/
- https://www.aflcmc.af.mil/RSO-CBM-Plus/

### Türkiye — HvBS and national Air C2 software

Public Turkish material describes HAVELSAN's HvBS / Air Force Information System as an integrated information system covering broad functional areas such as operations, intelligence, logistics/resource management, personnel, training, strategic planning, finance, evaluation and auditing. Turkey's Presidency of Defence Industries also describes a national early-warning and command-and-control software effort intended to provide a flexible integration architecture for the Turkish Air Force.

Design lesson for NEXVARY: use a **modular enterprise information architecture** with common data, identity, audit and integration services underneath separate management workspaces.

Sources:
- https://www.ssb.gov.tr/en/project/national-early-warning-and-command-and-control-software-development-project
- https://www.aa.com.tr/tr/savunma-sanayisi/milli-yazilim-hvbs-efes-2026da-hava-kuvvetlerine-guc-katti/3941008
- https://www.aa.com.tr/tr/bilim-teknoloji/milli-yazilim-azerbaycan-hava-kuvvetlerine-guc-katacak/4016165

### NATO — integrated, data-centric Air C2

NATO public material emphasizes an integrated Air C2 environment, a recognised air picture, air traffic / airspace management, sensor fusion, communications and information systems, and a move toward open standards and a common data foundation in the Enhanced Air C2 programme.

Design lesson for NEXVARY: build around a **common data layer and adapters** rather than hard-wiring the UI to individual feeds. The map is one view over the data foundation, not the system itself.

Sources:
- https://www.nato.int/en/what-we-do/deterrence-and-defence/nato-integrated-air-and-missile-defence
- https://www.ncia.nato.int/newsroom/news/nato-accelerates-transformation-of-air-command-and-control-with-key-contract-awards
- https://www.nato.int/en/about-us/organization/nato-structure/allied-command-operations-aco

### Russia — public automated-control system descriptions

Public Russian industry descriptions of automated air-control systems emphasize a fused air situation, integration of radar/sensor information, airfield and weather state, flight-safety support, command-post workstations, and automated recording/documentation. Public sources also describe mobile and fixed command-post configurations.

Design lesson for NEXVARY: the management console should keep **air picture, airfield status, weather, platform readiness and audit/history** synchronized, while retaining a clear separation between observation/management and any prohibited engagement functions.

Sources:
- https://rostec.ru/media/news/rostekh-pokazal-na-armii-2023-novye-vozmozhnosti-avtomatizirovannoy-sistemy-upravleniya-akatsiya-e/
- https://roe.ru/pdfs/pdf_6381.pdf

## Open-source software patterns reviewed

### NASA Open MCT

Open MCT demonstrates the right mission-control interaction model: time-synchronized telemetry, historical and live views, imagery, procedures, timelines and configurable layouts. It is a better reference for a professional operations UI than a wall of KPI cards.

Sources:
- https://nasa.github.io/openmct/
- https://ammos.nasa.gov/openmct/

### NASA MMGIS

MMGIS demonstrates a map-first workspace with configurable geospatial layers, mission overlays and operator-owned data. It is suitable as an architectural reference for the future geospatial layer.

Source:
- https://github.com/NASA-AMMOS/MMGIS

### OpenSky Network

OpenSky provides public research/non-commercial ADS-B state vectors and track data. It is appropriate as an external **public-airspace awareness adapter**, subject to its terms and rate limits. It must never be treated as an authoritative military air picture.

Source:
- https://openskynetwork.github.io/opensky-api/

### CesiumJS

CesiumJS provides an open-source, high-precision WGS84 globe and 3D geospatial visualization stack. It is a candidate for a future 3D geospatial viewer, while the present Qt/QML client can continue to use the existing map renderer.

Source:
- https://github.com/CesiumGS/cesium

## New product information architecture

The application should be treated as a **system of workspaces** sharing one data foundation.

1. **Executive / Command Overview**
   - force readiness
   - base availability
   - crew readiness
   - maintenance pressure
   - weather constraints
   - airspace-awareness summary
   - system/data health
   - executive reports

2. **Airspace & Flight Awareness**
   - public ADS-B adapter
   - AEGIS awareness/replay adapter
   - airspace classes and restricted/training overlays
   - airports, navigation aids and weather layers
   - track history and replay

3. **Fleet & Squadron Management**
   - assigned / ready / limited aircraft
   - squadron status
   - aircraft profile and digital twin
   - inspection horizon
   - platform configuration and engineering status

4. **Bases & Airfields**
   - base availability
   - runway / facility state
   - local weather constraints
   - communications/data-link health
   - support-resource status

5. **Maintenance & Sustainment**
   - open maintenance queue
   - inspection calendar
   - diagnostic findings
   - predictive-maintenance interface
   - parts / supply status (future adapter)
   - engineering evidence and verification

6. **Personnel & Training**
   - crew readiness percentage
   - qualification / currency status
   - training schedule
   - simulator and exercise schedule
   - handover / shift status

7. **C-UAS Awareness & Incident Coordination**
   - detection/classification history
   - incident record
   - confidence / provenance
   - operator verification state
   - non-kinetic coordination and documentation only

8. **Data, Integration & Audit**
   - adapter status
   - data freshness / provenance
   - event timeline
   - audit log
   - import/export and replay
   - role-based access boundaries

9. **Reports & Assessment**
   - executive summaries
   - readiness trends
   - maintenance trends
   - training completion
   - base availability trends
   - incident review

## UI principles for the rebuild

- **Map / primary operational picture gets the largest surface.**
- The home screen shows only a small number of executive metrics; detailed data lives in dedicated workspaces.
- Use three information depths: glanceable status, operational summary, drill-down detail.
- Use color semantically: cyan = public/airspace data, green = ready/nominal, gold = readiness/management attention, violet = RF/data-domain, orange/red = review/fault.
- Avoid large empty rectangles with tiny text. Content density should follow the available data.
- Avoid seven or more equal KPI cards across the top; this is visually flat and hides hierarchy.
- Use maps, timelines, status matrices, aircraft visuals and trend plots where they communicate better than text.
- Arabic, Persian and Urdu must preserve RTL layout; compact technical values may remain LTR inside clearly bounded fields.
- Every feed must expose source, freshness and confidence/provenance.
- Every operational-looking page must state whether it is live, replay, synthetic or public-source data.

## Stage 1890 redesign decision

Stage 1890 replaces the previous "everything on one dashboard" concept with a management-oriented overview: a dominant air picture, base/force status, squadron readiness, training/weather, maintenance and incident review. Detailed engineering, C-UAS, RF, route analysis and aircraft storyboards remain in their dedicated workspaces.
