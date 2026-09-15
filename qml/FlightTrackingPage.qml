import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true
    property string trackingWebsiteUrl: "https://map.opensky-network.org/"
    property var selectedTrack: cockpit.publicFlightTracks.length > 0 ? cockpit.publicFlightTracks[0] : ({})
    property bool detailsOpen: cockpit.publicFlightTracks.length > 0
    property int historyMinutes: historyFilter.currentIndex === 0 ? 5 : historyFilter.currentIndex === 1 ? 15 : historyFilter.currentIndex === 2 ? 30 : 60
    property var operatorOptions: filterOptions(cockpit.publicFlightTracks, "operatorName", "ALL OPERATORS")
    property var sourceOptions: filterOptions(cockpit.publicFlightTracks, "telemetrySource", "ALL SOURCES")
    property var filteredTracks: filterTracks(cockpit.publicFlightTracks, searchField.text, typeFilter.currentText, altitudeFilter.currentIndex, operatorFilter.currentText, sourceFilter.currentText)
    property var selectedHistory: selectedTrack && selectedTrack.icao24 ? cockpit.publicFlightHistory(String(selectedTrack.icao24), historyMinutes) : []

    function filterOptions(tracks, key, allLabel) {
        var seen = ({})
        var values = [allLabel]
        for (var i = 0; i < tracks.length; ++i) {
            var value = String(tracks[i][key] || "").trim()
            if (value === "" || seen[value]) continue
            seen[value] = true
            values.push(value)
        }
        if (values.length > 2) {
            var tail = values.slice(1)
            tail.sort()
            values = [allLabel].concat(tail)
        }
        return values
    }

    function selectTrack(track, openDetails) {
        selectedTrack = track || ({})
        airMap.selectedPublicTrackId = String(track && track.icao24 ? track.icao24 : "").toLowerCase()
        airMap.selectedPublicTrack = track || ({})
        if (openDetails) detailsOpen = true
    }

    function syncSelection() {
        var tracks = cockpit.publicFlightTracks
        if (tracks.length === 0) {
            selectedTrack = ({})
            detailsOpen = false
            return
        }
        var currentId = String(selectedTrack && selectedTrack.icao24 ? selectedTrack.icao24 : "").toLowerCase()
        for (var i = 0; i < tracks.length; ++i) {
            if (String(tracks[i].icao24 || "").toLowerCase() === currentId) {
                selectedTrack = tracks[i]
                airMap.selectedPublicTrack = tracks[i]
                return
            }
        }
        selectTrack(tracks[0], false)
    }

    function filterTracks(tracks, query, typeName, altitudeIndex, operatorName, sourceName) {
        var q = String(query || "").trim().toLowerCase()
        var result = []
        for (var i = 0; i < tracks.length; ++i) {
            var t = tracks[i]
            var haystack = [t.callsign, t.flightNumber, t.registration, t.icao24, t.aircraftTypeCode, t.aircraftModel, t.operatorName, t.telemetrySource, t.metadataSource, t.routeSource].join(" ").toLowerCase()
            if (q !== "" && haystack.indexOf(q) < 0) continue
            var category = String(t.aircraftTypeCode || "").toUpperCase()
            if (typeName === "JET" && (category.indexOf("A") !== 0 && category.indexOf("B") !== 0 && category.indexOf("E") !== 0)) continue
            if (typeName === "TURBOPROP" && category.indexOf("AT") !== 0 && category.indexOf("DH") !== 0) continue
            var altitude = Number(t.altitudeMeters)
            if (altitudeIndex === 1 && (!isFinite(altitude) || altitude >= 3000)) continue
            if (altitudeIndex === 2 && (!isFinite(altitude) || altitude < 3000 || altitude > 9000)) continue
            if (altitudeIndex === 3 && (!isFinite(altitude) || altitude <= 9000)) continue
            if (operatorName !== "" && operatorName !== "ALL OPERATORS" && String(t.operatorName || "") !== operatorName) continue
            if (sourceName !== "" && sourceName !== "ALL SOURCES" && String(t.telemetrySource || "") !== sourceName) continue
            result.push(t)
        }
        return result
    }

    Connections {
        target: cockpit
        function onDataChanged() { page.syncSelection() }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 84
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 11
                spacing: 12
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle { width: 5; Layout.fillHeight: true; radius: 3; color: Theme.royalGold }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: cockpit.rtl ? "تتبع الرحلات العامة" : "PUBLIC FLIGHT TRACKING"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.pageTitlePx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    Text { text: cockpit.rtl ? "وعي جوي سلبي • بيانات عامة أو مرخصة • مصدر وسجل قابلان للتدقيق" : "PASSIVE AIR AWARENESS • PUBLIC / LICENSED DATA • AUDITABLE SOURCE + HISTORY"; color: Theme.royalGold; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                }
                TextField {
                    id: searchField
                    objectName: "aircraftSearchField"
                    Layout.preferredWidth: 245
                    Layout.preferredHeight: 42
                    placeholderText: cockpit.rtl ? "بحث: النداء / التسجيل / HEX / النوع" : "SEARCH CALLSIGN / REG / HEX / TYPE"
                    color: Theme.platinum
                    placeholderTextColor: Theme.muted
                    font.family: Theme.uiFont(cockpit.rtl)
                    font.pixelSize: Theme.smallPx
                    selectByMouse: true
                    background: Rectangle { color: Theme.panel2; border.color: searchField.activeFocus ? Theme.royalGold : Theme.border; border.width: 1; radius: Theme.radius }
                }
                ComboBox {
                    id: typeFilter
                    Layout.preferredWidth: 118
                    Layout.preferredHeight: 42
                    model: ["ALL TYPES", "JET", "TURBOPROP"]
                    contentItem: Text { text: typeFilter.displayText; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; verticalAlignment: Text.AlignVCenter; leftPadding: 9 }
                    background: Rectangle { color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius }
                }
                ComboBox {
                    id: altitudeFilter
                    Layout.preferredWidth: 126
                    Layout.preferredHeight: 42
                    model: ["ALL ALT", "< 3 KM", "3–9 KM", "> 9 KM"]
                    contentItem: Text { text: altitudeFilter.displayText; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; verticalAlignment: Text.AlignVCenter; leftPadding: 9 }
                    background: Rectangle { color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius }
                }
                Rectangle {
                    Layout.preferredWidth: 168
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: cockpit.rtl ? "المسارات" : "TRACKS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: String(page.filteredTracks.length) + " / " + String(cockpit.publicFlightTrackCount); color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: 20; font.bold: true }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 52
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 7
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Text { text: cockpit.rtl ? "فلاتر تشغيلية" : "OPERATIONAL FILTERS"; color: Theme.royalGold; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                ComboBox {
                    id: operatorFilter
                    objectName: "aircraftOperatorFilter"
                    Layout.fillWidth: true
                    Layout.maximumWidth: 260
                    Layout.preferredHeight: 36
                    model: page.operatorOptions
                    contentItem: Text { text: operatorFilter.displayText; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; verticalAlignment: Text.AlignVCenter; leftPadding: 9; elide: Text.ElideRight }
                    background: Rectangle { color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius }
                }
                ComboBox {
                    id: sourceFilter
                    objectName: "aircraftSourceFilter"
                    Layout.fillWidth: true
                    Layout.maximumWidth: 260
                    Layout.preferredHeight: 36
                    model: page.sourceOptions
                    contentItem: Text { text: sourceFilter.displayText; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; verticalAlignment: Text.AlignVCenter; leftPadding: 9; elide: Text.ElideRight }
                    background: Rectangle { color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius }
                }
                ComboBox {
                    id: historyFilter
                    objectName: "aircraftHistoryWindow"
                    Layout.preferredWidth: 112
                    Layout.preferredHeight: 36
                    model: ["5 MIN", "15 MIN", "30 MIN", "60 MIN"]
                    currentIndex: 1
                    contentItem: Text { text: historyFilter.displayText; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; verticalAlignment: Text.AlignVCenter; leftPadding: 9 }
                    background: Rectangle { color: Theme.panel2; border.color: Theme.royalGold; border.width: 1; radius: Theme.radius }
                }
                Rectangle {
                    Layout.preferredWidth: 178
                    Layout.preferredHeight: 36
                    color: Theme.panel2
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        Text { text: cockpit.rtl ? "سجل" : "HISTORY"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: String(page.selectedHistory.length) + " pts"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                    }
                }
                Text {
                    Layout.fillWidth: true
                    text: page.selectedTrack && page.selectedTrack.enrichmentCacheState ? ("CACHE " + page.selectedTrack.enrichmentCacheState) : "CACHE —"
                    color: page.selectedTrack && page.selectedTrack.enrichmentCacheState === "STALE" ? Theme.warning : Theme.muted
                    font.family: Theme.mono
                    font.pixelSize: Theme.smallPx
                    horizontalAlignment: cockpit.rtl ? Text.AlignLeft : Text.AlignRight
                    elide: Text.ElideRight
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 740
                spacing: 8
                StrategicAirMap {
                    id: airMap
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    publicTracks: page.filteredTracks
                    aegisTracks: []
                    bases: []
                    rtl: cockpit.rtl
                    modeLabel: cockpit.rtl ? "تتبع الرحلات العامة" : "PUBLIC FLIGHT TRACKING"
                    // Keep the selected aircraft highlighted on the map, but use the
                    // dedicated right-hand details panel for text. The old persistent
                    // map popup overlapped radar/data-fusion controls on 1908x964 and
                    // smaller Windows viewports.
                    showSelectedPublicPopup: false
                    Component.onCompleted: {
                        if (page.selectedTrack && page.selectedTrack.icao24)
                            selectedPublicTrackId = String(page.selectedTrack.icao24).toLowerCase()
                    }
                    onPublicTrackSelected: function(track) { page.selectTrack(track, false) }
                    onAircraftDetailsRequested: function(track) { page.selectTrack(track, true) }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 126
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ListView {
                        anchors.fill: parent
                        anchors.margins: 7
                        orientation: ListView.Horizontal
                        spacing: 7
                        model: page.filteredTracks
                        clip: true
                        delegate: Rectangle {
                            required property var modelData
                            width: 218
                            height: ListView.view.height
                            color: Theme.panel2
                            border.width: 1
                            radius: Theme.radius
                            border.color: page.selectedTrack && String(page.selectedTrack.icao24) === String(modelData.icao24) ? Theme.royalGold : Theme.border
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: page.selectTrack(modelData, true) }
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 2
                                Text { text: modelData.callsign || modelData.icao24 || "PUBLIC TRACK"; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: String(modelData.operatorName || modelData.country || "PUBLIC ADS-B"); color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: "ALT " + Math.round(Number(modelData.altitudeMeters || 0)) + " m"; color: Theme.skyBlue; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true }
                                    Text { text: "HDG " + Math.round(Number(modelData.headingDegrees || 0)) + "°"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                                }
                                Text { text: "SPD " + Math.round(Number(modelData.velocityMetersPerSecond || 0)) + " m/s"; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 430
                Layout.minimumWidth: 390
                Layout.maximumWidth: 460
                Layout.fillHeight: true
                spacing: 8

                Rectangle {
                    id: trackingWebsitePanel
                    objectName: "aircraftTrackingWebsitePanel"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44
                    color: Theme.deepBlue
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 7
                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                        NexvaryMark { Layout.preferredWidth: 28; Layout.preferredHeight: 28 }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text {
                                Layout.fillWidth: true
                                text: cockpit.rtl ? "موقع تتبع الطائرات" : "AIRCRAFT TRACKING WEBSITE"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: 11
                                font.bold: true
                                elide: Text.ElideRight
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                            Text {
                                Layout.fillWidth: true
                                text: page.trackingWebsiteUrl
                                color: Theme.signalCyan
                                font.family: Theme.mono
                                font.pixelSize: 10
                                font.underline: true
                                elide: Text.ElideMiddle
                                horizontalAlignment: Text.AlignLeft
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Qt.openUrlExternally(page.trackingWebsiteUrl)
                                }
                            }
                        }
                        Button {
                            id: openTrackingWebsiteButton
                            objectName: "openAircraftTrackingWebsiteButton"
                            Layout.preferredWidth: 72
                            Layout.preferredHeight: 30
                            text: cockpit.rtl ? "فتح" : "OPEN"
                            onClicked: Qt.openUrlExternally(page.trackingWebsiteUrl)
                            contentItem: Text { text: parent.text; color: Theme.deepBlack; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                            background: Rectangle { color: Theme.royalGold; radius: Theme.radius }
                        }
                    }
                }

                AircraftDetailsPanel {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: page.detailsOpen
                    track: page.selectedTrack
                    rtl: cockpit.rtl
                    onCloseRequested: page.detailsOpen = false
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 278
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    visible: !page.detailsOpen
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "مصادر البيانات المرخصة" : "LICENSED DATA SOURCES"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: "READ ONLY"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                        }
                        Text { text: cockpit.publicFlightFeedSource; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        TextField {
                            id: apiField
                            objectName: "authorizedTrackFeedUrl"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 34
                            placeholderText: cockpit.rtl ? "رابط HTTPS لمصدر المسارات المصرح به" : "AUTHORIZED HTTPS TRACK FEED URL"
                            color: Theme.platinum
                            placeholderTextColor: Theme.muted
                            font.family: Theme.mono
                            font.pixelSize: Theme.smallPx
                            selectByMouse: true
                            background: Rectangle { color: Theme.panel2; border.color: apiField.activeFocus ? Theme.royalGold : Theme.border; border.width: 1; radius: Theme.radius }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Button {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 32
                                text: cockpit.rtl ? "جلب المسارات" : "FETCH TRACKS"
                                enabled: apiField.text.trim().length > 0
                                onClicked: cockpit.fetchPublicFlightFeed(apiField.text)
                                contentItem: Text { text: parent.text; color: parent.enabled ? Theme.platinum : Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                background: Rectangle { color: Theme.panel2; border.color: parent.enabled ? Theme.royalGold : Theme.border; border.width: 1; radius: Theme.radius }
                            }
                            Button {
                                Layout.preferredWidth: 82
                                Layout.preferredHeight: 32
                                text: "DEMO"
                                onClicked: cockpit.resetPublicFlightDemo()
                                contentItem: Text { text: parent.text; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                background: Rectangle { color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius }
                            }
                        }
                        TextField {
                            id: enrichmentField
                            objectName: "licensedEnrichmentUrl"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 34
                            placeholderText: cockpit.rtl ? "رابط HTTPS لوصف الطائرة/المشغل/المسار المرخص" : "LICENSED HTTPS METADATA / ROUTE URL"
                            color: Theme.platinum
                            placeholderTextColor: Theme.muted
                            font.family: Theme.mono
                            font.pixelSize: Theme.smallPx
                            selectByMouse: true
                            background: Rectangle { color: Theme.panel2; border.color: enrichmentField.activeFocus ? Theme.royalGold : Theme.border; border.width: 1; radius: Theme.radius }
                        }
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 32
                            text: cockpit.rtl ? "تطبيق إثراء مرخص" : "APPLY LICENSED ENRICHMENT"
                            enabled: enrichmentField.text.trim().length > 0
                            onClicked: cockpit.fetchPublicFlightEnrichment(enrichmentField.text)
                            contentItem: Text { text: parent.text; color: parent.enabled ? Theme.platinum : Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                            background: Rectangle { color: Theme.panel2; border.color: parent.enabled ? Theme.royalGold : Theme.border; border.width: 1; radius: Theme.radius }
                        }
                        Text { text: cockpit.publicFlightFeedStatus; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: cockpit.publicFlightEnrichmentStatus; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: cockpit.publicFlightHistoryStatus; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    visible: !page.detailsOpen
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "سجل المسارات" : "TRACK ROSTER"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.publicFlightEnrichmentProvider; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; elide: Text.ElideRight }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: page.filteredTracks
                            clip: true
                            spacing: 5
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 70
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: page.selectTrack(modelData, true) }
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 2
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Rectangle { width: 7; height: 7; radius: 4; color: Theme.royalGold }
                                        Text { text: modelData.callsign || modelData.icao24; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: Math.round(Number(modelData.headingDegrees || 0)) + "°"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                    }
                                    Text { text: Math.round(Number(modelData.altitudeMeters || 0)) + " m  •  " + Math.round(Number(modelData.velocityMetersPerSecond || 0)) + " m/s  •  " + (modelData.operatorName || modelData.country || "—"); color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }

                RfSpectrumMini {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 156
                    bins: cockpit.rfSpectrumBins
                    peakFrequencyMhz: cockpit.rfPeakFrequencyMhz
                    peakLevelDbm: cockpit.rfPeakLevelDbm
                    rtl: cockpit.rtl
                    visible: !page.detailsOpen
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 10
                Rectangle { width: 8; height: 8; radius: 4; color: Theme.radarGreen }
                Text { text: cockpit.rtl ? "وعي سلبي فقط • مصدر عام/مرخص • لا تحكم بالطائرة" : "PASSIVE AWARENESS ONLY • PUBLIC/LICENSED SOURCE • NO AIRCRAFT CONTROL"; color: Theme.radarGreen; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true }
                Text { text: "SOURCE  •  LICENSE  •  CACHE  •  HISTORY  •  FRESH/STALE"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
            }
        }
    }
}
