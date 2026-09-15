import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    objectName: "flightTrackingPage"
    clip: true
    property var selectedTrack: cockpit.publicFlightTracks.length > 0 ? cockpit.publicFlightTracks[0] : ({})
    property bool detailsOpen: cockpit.publicFlightTracks.length > 0
    property var filteredTracks: filterTracks(cockpit.publicFlightTracks, searchField.text, typeFilter.currentText, altitudeFilter.currentIndex)

    function selectTrack(track, openDetails) {
        selectedTrack = track
        airMap.selectedPublicTrackId = String(track && track.icao24 ? track.icao24 : "").toLowerCase()
        airMap.selectedPublicTrack = track
        if (openDetails) detailsOpen = true
    }
    function filterTracks(tracks, query, typeName, altitudeIndex) {
        var q = String(query || "").trim().toLowerCase()
        var result = []
        for (var i = 0; i < tracks.length; ++i) {
            var t = tracks[i]
            var haystack = [t.callsign, t.flightNumber, t.registration, t.icao24, t.aircraftTypeCode, t.aircraftModel, t.operatorName, t.telemetrySource].join(" ").toLowerCase()
            if (q !== "" && haystack.indexOf(q) < 0) continue
            var category = String(t.aircraftTypeCode || "").toUpperCase()
            if (typeName === "JET" && (category.indexOf("A") !== 0 && category.indexOf("B") !== 0 && category.indexOf("E") !== 0)) continue
            if (typeName === "TURBOPROP" && category.indexOf("AT") !== 0 && category.indexOf("DH") !== 0) continue
            var altitude = Number(t.altitudeMeters)
            if (altitudeIndex === 1 && (!isFinite(altitude) || altitude >= 3000)) continue
            if (altitudeIndex === 2 && (!isFinite(altitude) || altitude < 3000 || altitude > 9000)) continue
            if (altitudeIndex === 3 && (!isFinite(altitude) || altitude <= 9000)) continue
            result.push(t)
        }
        return result
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
                Rectangle { width: 5; Layout.fillHeight: true; radius: 3; color: Theme.signalCyan }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: cockpit.rtl ? "تتبع الرحلات العامة" : "PUBLIC FLIGHT TRACKING"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.pageTitlePx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    Text { text: cockpit.rtl ? "مسارات ADS-B المدنية • الارتفاع والسرعة والاتجاه • مصدر وحالة التحديث" : "CIVIL ADS-B TRACKS • ALTITUDE / SPEED / HEADING • SOURCE AND UPDATE HEALTH"; color: Theme.signalCyan; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
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
                    Layout.preferredWidth: 210
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: Theme.signalCyan
                    border.width: 1
                    radius: Theme.radius
                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: cockpit.rtl ? "المسارات الحالية" : "CURRENT TRACKS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: String(page.filteredTracks.length) + " / " + String(cockpit.publicFlightTrackCount); color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 20; font.bold: true }
                    }
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
                Layout.minimumWidth: 760
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
                    showSelectedPublicPopup: !page.detailsOpen
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
                    border.color: Theme.signalCyan
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
                                Text { text: String(modelData.country || "PUBLIC ADS-B"); color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
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
                Layout.minimumWidth: 400
                Layout.maximumWidth: 460
                Layout.fillHeight: true
                spacing: 8

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
                    Layout.preferredHeight: 176
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    visible: !page.detailsOpen
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 6
                        Text { text: cockpit.rtl ? "مزود بيانات الرحلات" : "FLIGHT DATA PROVIDER"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        Text { text: cockpit.publicFlightFeedSource; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        TextField {
                            id: apiField
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            text: "https://opensky-network.org/api/states/all"
                            color: Theme.platinum
                            font.family: Theme.mono
                            font.pixelSize: Theme.smallPx
                            selectByMouse: true
                            background: Rectangle { color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Button {
                                id: fetchButton
                                Layout.fillWidth: true
                                Layout.preferredHeight: 34
                                enabled: !cockpit.publicFlightFeedBusy
                                text: cockpit.publicFlightFeedBusy
                                      ? (cockpit.rtl ? "جارٍ الجلب…" : "FETCHING…")
                                      : (cockpit.rtl ? "جلب HTTPS" : "FETCH HTTPS")
                                onClicked: cockpit.fetchPublicFlightFeed(apiField.text)
                                contentItem: Text { text: parent.text; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                background: Rectangle { color: fetchButton.enabled ? Theme.deepBlue : Theme.panel3; border.color: fetchButton.enabled ? Theme.signalCyan : Theme.border; border.width: 1; radius: Theme.radius }
                            }
                            Button {
                                Layout.preferredWidth: 82
                                Layout.preferredHeight: 34
                                text: "DEMO"
                                onClicked: cockpit.resetPublicFlightDemo()
                                contentItem: Text { text: parent.text; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                background: Rectangle { color: Theme.panel2; border.color: Theme.royalGold; border.width: 1; radius: Theme.radius }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 7
                            BusyIndicator {
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                running: cockpit.publicFlightFeedBusy
                                visible: running
                            }
                            Rectangle {
                                visible: !cockpit.publicFlightFeedBusy
                                width: 8
                                height: 8
                                radius: 4
                                color: cockpit.publicFlightFeedStatus.indexOf("ERROR") >= 0 || cockpit.publicFlightFeedStatus.indexOf("TIMEOUT") >= 0 ? Theme.amber : Theme.radarGreen
                            }
                            Text {
                                text: cockpit.publicFlightFeedStatus
                                color: cockpit.publicFlightFeedStatus.indexOf("ERROR") >= 0 || cockpit.publicFlightFeedStatus.indexOf("TIMEOUT") >= 0 ? Theme.amber : (cockpit.publicFlightFeedBusy ? Theme.signalCyan : Theme.radarGreen)
                                font.family: Theme.mono
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }
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
                            Text { text: "ADS-B"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
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
                                        Rectangle { width: 7; height: 7; radius: 4; color: Theme.signalCyan }
                                        Text { text: modelData.callsign || modelData.icao24; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: Math.round(Number(modelData.headingDegrees || 0)) + "°"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                    }
                                    Text { text: Math.round(Number(modelData.altitudeMeters || 0)) + " m  •  " + Math.round(Number(modelData.velocityMetersPerSecond || 0)) + " m/s  •  " + (modelData.country || "—"); color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }

                RfSpectrumMini {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 178
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
                Text { text: cockpit.rtl ? "مصدر عام / وضع سلبي / لا تحكم بالطائرة" : "PUBLIC SOURCE • PASSIVE AWARENESS • NO AIRCRAFT CONTROL"; color: Theme.radarGreen; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true }
                Text { text: "SOURCE  •  MODE  •  LAST UPDATE  •  HEALTH  •  FRESH/STALE"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
            }
        }
    }
}
