import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    property bool rtl: false
    color: Theme.panel
    border.color: Theme.border
    border.width: 1
    radius: 7
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: root.rtl ? "مستكشف المنصة الجوية" : "AIRCRAFT VISUAL EXPLORER"
                color: Theme.platinum
                font.family: Theme.uiFont(root.rtl)
                font.pixelSize: Theme.sectionPx
                font.bold: true
                Layout.fillWidth: true
            }
            Text {
                text: Theme.platformCode(cockpit.activePlatformId)
                color: Theme.skyBlue
                font.family: Theme.mono
                font.pixelSize: Theme.smallPx
                font.bold: true
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 9

            Rectangle {
                Layout.preferredWidth: 205
                Layout.fillHeight: true
                color: "#111111"
                border.color: Theme.border
                border.width: 1
                radius: 6

                AircraftSchematic {
                    anchors.fill: parent
                    anchors.margins: 7
                    platformId: cockpit.activePlatformId
                    subsystemRows: cockpit.twinRows
                    accent: Theme.skyBlue
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 5

                Text {
                    text: cockpit.activePlatformName
                    color: Theme.platinum
                    font.family: Theme.uiFont(root.rtl)
                    font.pixelSize: Theme.bodyPx
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    text: cockpit.activePlatformCategory + " • " + cockpit.activePlatformPropulsion
                    color: Theme.skyBlue
                    font.family: Theme.uiFont(root.rtl)
                    font.pixelSize: Theme.smallPx
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Item { Layout.fillHeight: true }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 5
                    columnSpacing: 8
                    Text { text: root.rtl ? "الصحة التشخيصية" : "DX HEALTH"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                    Text { text: cockpit.diagnosticHealthScore + "%"; color: cockpit.diagnosticHealthScore >= 90 ? Theme.radarGreen : Theme.warmOrange; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                    Text { text: root.rtl ? "التوأم الرقمي" : "DIGITAL TWIN"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                    Text { text: cockpit.twinNominalCount + " NOM"; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx }
                    Text { text: root.rtl ? "التنبيهات" : "ALERTS"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                    Text { text: String(cockpit.activeAlertCount); color: cockpit.activeAlertCount ? Theme.warmOrange : Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 5
            Repeater {
                model: [
                    {id:"generic-jet",t:"JET"},
                    {id:"generic-helicopter",t:"ROTOR"},
                    {id:"generic-uav",t:"UAV"},
                    {id:"generic-turboprop",t:"TURBO"}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    color: cockpit.activePlatformId === modelData.id ? Theme.panel3 : Theme.panel2
                    border.color: cockpit.activePlatformId === modelData.id ? Theme.skyBlue : Theme.borderSoft
                    border.width: 1
                    radius: 5
                    Text {
                        anchors.centerIn: parent
                        text: modelData.t
                        color: cockpit.activePlatformId === modelData.id ? Theme.platinum : Theme.muted
                        font.family: Theme.mono
                        font.pixelSize: Theme.smallPx
                        font.bold: true
                    }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: cockpit.setActivePlatform(modelData.id) }
                }
            }
        }
    }
}
