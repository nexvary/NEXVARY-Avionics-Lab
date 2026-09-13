import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirspaceLocale.js" as AirspaceLocale

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            color: Theme.shell
            border.color: Theme.borderSoft
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5

                Repeater {
                    model: [
                        {label: AirspaceLocale.chart(cockpit.language), index: 0, accent: Theme.royalGold},
                        {label: AirspaceLocale.picture(cockpit.language), index: 1, accent: Theme.signalCyan}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.preferredWidth: 190
                        Layout.fillHeight: true
                        color: workspace.currentIndex === modelData.index ? Theme.panel3 : Theme.panel2
                        border.color: workspace.currentIndex === modelData.index ? modelData.accent : Theme.borderSoft
                        border.width: 1
                        radius: Theme.radius

                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: workspace.currentIndex === modelData.index ? Theme.platinum : Theme.muted
                            font.pixelSize: 8
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: workspace.currentIndex = modelData.index
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: workspace.currentIndex === 0 ? "CLASS A–G / AIRPORTS / NAVAIDS / ADS-B" : "RADAR / RF / AIRCRAFT VISUALS"
                    color: workspace.currentIndex === 0 ? Theme.royalGold : Theme.signalCyan
                    font.family: "Consolas"
                    font.pixelSize: 7
                    font.bold: true
                }
            }
        }

        StackLayout {
            id: workspace
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0

            AirspaceClassificationPage {}
            AirPictureIntelligencePage {}
        }
    }
}
