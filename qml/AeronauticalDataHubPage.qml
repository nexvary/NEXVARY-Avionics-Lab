import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirspaceData.js" as AirspaceData
import "AirspaceLocale.js" as AirspaceLocale

Item {
    id: page
    clip: true
    property string filterText: ""

    function classCount(code) {
        var count = 0
        for (var i = 0; i < AirspaceData.zones.length; ++i)
            if (AirspaceData.zones[i].classCode === code) count++
        return count
    }

    function matches(value) {
        if (!filterText || filterText.length === 0) return true
        return String(value).toLowerCase().indexOf(filterText.toLowerCase()) >= 0
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: cockpit.rtl ? "مركز البيانات الملاحية الجوية" : "AERONAUTICAL DATA HUB"
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "فهرسة طبقات المجال الجوي والمطارات والمساعدات الملاحية ومصادر الحركة العامة" : "CATALOG, PROVENANCE AND LAYER HEALTH FOR AIRSPACE, AERODROMES, NAVAIDS AND PUBLIC TRAFFIC"
                        color: Theme.signalCyan
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 46
                    color: Theme.panel2
                    border.color: Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 1
                        Text { text: "DATASET HEALTH  •  READY"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                        Text { text: "SYNTHETIC / TRAINING PROVENANCE"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 88
            spacing: 7
            Repeater {
                model: [
                    {title: cockpit.rtl ? "قطاعات المجال" : "AIRSPACE ZONES", value: AirspaceData.zones.length, color: Theme.signalCyan},
                    {title: cockpit.rtl ? "المطارات" : "AERODROMES", value: AirspaceData.airports.length, color: Theme.royalGold},
                    {title: cockpit.rtl ? "المساعدات" : "NAVAIDS", value: AirspaceData.navaids.length, color: Theme.rfViolet},
                    {title: cockpit.rtl ? "حركة عامة" : "PUBLIC TRACKS", value: cockpit.publicFlightTrackCount, color: Theme.radarGreen}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: modelData.color
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 2
                        Text { text: modelData.title; color: Theme.silver; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true }
                        Text { text: String(modelData.value); color: modelData.color; font.family: "Consolas"; font.pixelSize: 22; font.bold: true }
                        Text { text: "INDEXED / AVAILABLE"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7

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
                        Text { text: cockpit.rtl ? "كتالوج المجال الجوي" : "AIRSPACE CATALOG"; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                        TextField {
                            id: searchBox
                            Layout.preferredWidth: 220
                            placeholderText: cockpit.rtl ? "بحث" : "FILTER"
                            color: Theme.platinum
                            font.pixelSize: 8
                            background: Rectangle { color: Theme.panel2; border.color: Theme.borderSoft; border.width: 1; radius: Theme.radius }
                            onTextChanged: page.filterText = text
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 54
                        spacing: 5
                        Repeater {
                            model: ["A","B","C","D","E","F","G"]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 1
                                    Text { text: modelData; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 13; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: String(page.classCount(modelData)); color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
                                }
                            }
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: AirspaceData.zones
                        clip: true
                        spacing: 4
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: page.matches(modelData.name) || page.matches(modelData.id) || page.matches(modelData.classCode) ? 58 : 0
                            visible: height > 0
                            color: Theme.panel2
                            border.color: modelData.controlled ? Theme.signalCyan : Theme.radarGreen
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 8
                                Rectangle {
                                    width: 34; height: 34; radius: 17
                                    color: Theme.panel3
                                    border.color: modelData.controlled ? Theme.signalCyan : Theme.radarGreen
                                    border.width: 1
                                    Text { anchors.centerIn: parent; text: modelData.classCode; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 12; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.floor + " → " + modelData.ceiling + "  •  " + (modelData.controlled ? AirspaceLocale.controlled(cockpit.language) : AirspaceLocale.uncontrolled(cockpit.language)); color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7 }
                                }
                                Text { text: modelData.id; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 390
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "المطارات" : "AERODROMES"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: AirspaceData.airports
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 24
                                color: Theme.panel2
                                border.color: Theme.borderSoft
                                border.width: 1
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    Text { text: modelData.code; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.preferredWidth: 46 }
                                    Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 7; Layout.fillWidth: true }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 170
                    color: Theme.panel
                    border.color: Theme.rfViolet
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: "NAVAIDS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: AirspaceData.navaids
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                Text { text: modelData.code; color: Theme.rfViolet; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.preferredWidth: 74 }
                                Text { text: modelData.type; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true }
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
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "المصدر والتدقيق" : "PROVENANCE & AUDIT"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: "AIRSPACE: SYNTHETIC TRAINING DATASET"; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 7 }
                        Text { text: "TRAFFIC: " + cockpit.publicFlightFeedSource; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 7 }
                        Text { text: cockpit.publicFlightFeedStatus; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        Item { Layout.fillHeight: true }
                        Text { text: AirspaceLocale.notForNavigation(cockpit.language); color: Theme.warmOrange; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                    }
                }
            }
        }
    }
}
