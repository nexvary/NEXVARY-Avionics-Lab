import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

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
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: String(cockpit.publicFlightTrackCount); color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 20; font.bold: true }
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
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    publicTracks: cockpit.publicFlightTracks
                    aegisTracks: []
                    bases: []
                    rtl: cockpit.rtl
                    modeLabel: cockpit.rtl ? "تتبع الرحلات العامة" : "PUBLIC FLIGHT TRACKING"
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
                        model: cockpit.publicFlightTracks
                        clip: true
                        delegate: Rectangle {
                            required property var modelData
                            width: 218
                            height: ListView.view.height
                            color: Theme.panel2
                            border.color: Theme.border
                            border.width: 1
                            radius: Theme.radius
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

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 176
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
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
                                Layout.fillWidth: true
                                Layout.preferredHeight: 34
                                text: cockpit.rtl ? "جلب HTTPS" : "FETCH HTTPS"
                                onClicked: cockpit.fetchPublicFlightFeed(apiField.text)
                                contentItem: Text { text: parent.text; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                background: Rectangle { color: Theme.deepBlue; border.color: Theme.signalCyan; border.width: 1; radius: Theme.radius }
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
                        Text { text: cockpit.publicFlightFeedStatus; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
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
                            model: cockpit.publicFlightTracks
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
