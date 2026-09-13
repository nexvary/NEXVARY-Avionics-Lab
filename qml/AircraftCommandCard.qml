import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    property bool rtl: false
    color: Theme.panel
    border.color: Theme.skyBlue
    border.width: 1
    radius: Theme.radius
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 5
        RowLayout {
            Layout.fillWidth: true
            Text { text: root.rtl ? "مستكشف المنصة الجوية" : "AIRCRAFT VISUAL EXPLORER"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
            Text { text: Theme.platformCode(cockpit.activePlatformId); color: Theme.skyBlue; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
        }
        Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
            Rectangle {
                Layout.preferredWidth: 142
                Layout.fillHeight: true
                color: "#0E1820"
                border.color: Theme.deepBlue
                border.width: 1
                radius: Theme.radius
                AircraftSchematic {
                    anchors.fill: parent
                    anchors.margins: 5
                    platformId: cockpit.activePlatformId
                    subsystemRows: cockpit.twinRows
                    accent: Theme.skyBlue
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 2
                Text { text: cockpit.activePlatformName; color: Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                Text { text: cockpit.activePlatformCategory + " • " + cockpit.activePlatformPropulsion; color: Theme.skyBlue; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight }
                Item { Layout.fillHeight:true }
                GridLayout {
                    Layout.fillWidth:true
                    columns:2
                    rowSpacing:2
                    columnSpacing:6
                    Text { text: root.rtl ? "الصحة" : "DX HEALTH"; color: Theme.muted; font.pixelSize:5 }
                    Text { text: cockpit.diagnosticHealthScore + "%"; color: cockpit.diagnosticHealthScore >= 90 ? Theme.radarGreen : Theme.warmOrange; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                    Text { text: root.rtl ? "التوأم" : "TWIN"; color: Theme.muted; font.pixelSize:5 }
                    Text { text: cockpit.twinNominalCount + " NOM"; color: Theme.radarGreen; font.family:"Consolas"; font.pixelSize:7 }
                    Text { text: root.rtl ? "تنبيهات" : "ALERTS"; color: Theme.muted; font.pixelSize:5 }
                    Text { text: String(cockpit.activeAlertCount); color: cockpit.activeAlertCount ? Theme.warmOrange : Theme.radarGreen; font.family:"Consolas"; font.pixelSize:7 }
                }
            }
        }
        RowLayout {
            Layout.fillWidth:true
            spacing:4
            Repeater {
                model: [
                    {id:"generic-jet",t:"JET"},
                    {id:"generic-helicopter",t:"ROTOR"},
                    {id:"generic-uav",t:"UAV"},
                    {id:"generic-turboprop",t:"TURBO"}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth:true
                    Layout.preferredHeight:22
                    color: cockpit.activePlatformId === modelData.id ? Theme.panel3 : Theme.panel2
                    border.color: cockpit.activePlatformId === modelData.id ? Theme.skyBlue : Theme.borderSoft
                    border.width:1
                    radius:Theme.radius
                    Text { anchors.centerIn:parent; text:modelData.t; color:cockpit.activePlatformId === modelData.id ? Theme.platinum : Theme.muted; font.pixelSize:6; font.bold:true }
                    MouseArea { anchors.fill:parent; cursorShape:Qt.PointingHandCursor; onClicked:cockpit.setActivePlatform(modelData.id) }
                }
            }
        }
    }
}
