import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function stateColor(value) {
        var s = String(value || "").toUpperCase()
        if (s === "READY" || s === "AVAILABLE" || s === "NOMINAL") return Theme.radarGreen
        if (s === "REVIEW" || s === "LIMITED" || s === "CAUTION") return Theme.amber
        return Theme.red
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 11
                spacing: 12
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle { width: 5; Layout.fillHeight: true; radius: 3; color: Theme.radarGreen }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: cockpit.rtl ? "الصورة الجوية المشتركة" : "COMMON AIR PICTURE"
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.pageTitlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "حركة ADS-B العامة • وعي AEGIS • القواعد • القطاعات • قيود الطقس" : "PUBLIC ADS-B • AEGIS AWARENESS • BASES • AIRSPACE SECTORS • WEATHER CONSTRAINTS"
                        color: Theme.signalCyan
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.secondaryPx
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }
                Repeater {
                    model: [
                        {label: cockpit.rtl ? "مسارات عامة" : "PUBLIC", value: cockpit.publicFlightTrackCount, color: Theme.signalCyan},
                        {label: cockpit.rtl ? "مسارات AEGIS" : "AEGIS", value: cockpit.airOperationsTrackCount, color: Theme.radarGreen},
                        {label: cockpit.rtl ? "القواعد" : "BASES", value: cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length, color: Theme.royalGold},
                        {label: cockpit.rtl ? "الطقس" : "WEATHER", value: cockpit.forceWeatherConstraintCount, color: cockpit.forceWeatherConstraintCount ? Theme.amber : Theme.radarGreen}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.preferredWidth: 112
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: modelData.color
                        border.width: 1
                        radius: Theme.radius
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.label; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: String(modelData.value); color: modelData.color; font.family: Theme.mono; font.pixelSize: 18; font.bold: true }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

            StrategicAirMap {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 760
                publicTracks: cockpit.publicFlightTracks
                aegisTracks: cockpit.airOperationsTracks
                bases: cockpit.forceBases
                rtl: cockpit.rtl
                modeLabel: cockpit.rtl ? "الصورة الجوية المشتركة" : "COMMON AIR PICTURE"
            }

            ColumnLayout {
                Layout.preferredWidth: 410
                Layout.minimumWidth: 380
                Layout.maximumWidth: 440
                Layout.fillHeight: true
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.signalCyan
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 6
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "الحركة العامة" : "PUBLIC AIR TRACKS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.publicFlightTrackCount); color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
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
                                height: 62
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 8
                                    Rectangle { width: 8; height: 8; radius: 4; color: Theme.signalCyan }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 1
                                        Text { text: modelData.callsign || modelData.icao24 || "PUBLIC TRACK"; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: Math.round(Number(modelData.altitudeMeters || 0)) + " m  •  " + Math.round(Number(modelData.velocityMetersPerSecond || 0)) + " m/s"; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                                    }
                                    Text { text: Math.round(Number(modelData.headingDegrees || 0)) + "°"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 212
                    color: Theme.panel
                    border.color: Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "وعي AEGIS" : "AEGIS AWARENESS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.airOperationsTrackCount); color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.airOperationsTracks
                            clip: true
                            spacing: 4
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width
                                height: 42
                                spacing: 7
                                Rectangle { width: 11; height: 11; rotation: 45; color: Theme.panel2; border.color: page.stateColor(modelData.threatLevel); border.width: 2 }
                                Text { text: modelData.trackId || "TRACK"; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.preferredWidth: 94; elide: Text.ElideRight }
                                Text { text: modelData.classification || "UNKNOWN"; color: page.stateColor(modelData.threatLevel); font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: Math.round(Number(modelData.confidence || 0) * 100) + "%"; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 96
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 3
                        Text { text: cockpit.rtl ? "صحة مصادر البيانات" : "DATA SOURCE HEALTH"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        Text { text: cockpit.publicFlightFeedSource; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: cockpit.publicFlightFeedStatus; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: cockpit.rtl ? "وعي وتدريب فقط — بلا تحكم حي" : "AWARENESS / TRAINING ONLY — NO LIVE CONTROL"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 122
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
                    Text { text: cockpit.rtl ? "القواعد والمطارات" : "BASES & AIRFIELDS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                    Text { text: cockpit.forceWeatherConstraintCount + (cockpit.rtl ? " قيود طقس" : " WEATHER CONSTRAINT"); color: cockpit.forceWeatherConstraintCount ? Theme.amber : Theme.radarGreen; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 7
                    Repeater {
                        model: cockpit.forceBases
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Theme.panel2
                            border.color: Number(modelData.supportPercent) >= 90 ? Theme.radarGreen : Theme.amber
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8
                                Rectangle { width: 34; height: 34; radius: 17; color: Theme.panel3; border.color: parent.parent.border.color; border.width: 1; Text { anchors.centerIn: parent; text: "✦"; color: parent.border.color; font.pixelSize: 14 } }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: modelData.name; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.runway + "  •  " + modelData.weather; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                                Text { text: modelData.supportPercent + "%"; color: Number(modelData.supportPercent) >= 90 ? Theme.radarGreen : Theme.amber; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                            }
                        }
                    }
                }
            }
        }
    }
}
