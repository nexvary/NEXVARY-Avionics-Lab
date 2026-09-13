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
            Layout.preferredHeight: 42
            color: Theme.shell
            border.color: Theme.borderSoft
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5

                Repeater {
                    model: [
                        {label: AirspaceLocale.chart(cockpit.language), index: 0, accent: Theme.signalCyan},
                        {label: AirspaceLocale.picture(cockpit.language), index: 1, accent: Theme.radarGreen},
                        {label: AirspaceLocale.dataHub(cockpit.language), index: 2, accent: Theme.royalGold},
                        {label: AirspaceLocale.routeLab(cockpit.language), index: 3, accent: Theme.rfViolet},
                        {label: AirspaceLocale.aircraft(cockpit.language), index: 4, accent: Theme.skyBlue}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: workspace.currentIndex === modelData.index ? Theme.panel3 : Theme.panel2
                        border.color: workspace.currentIndex === modelData.index ? modelData.accent : Theme.borderSoft
                        border.width: workspace.currentIndex === modelData.index ? 2 : 1
                        radius: Theme.radius

                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: workspace.currentIndex === modelData.index ? modelData.accent : Theme.muted
                            font.pixelSize: 8
                            font.bold: true
                            elide: Text.ElideRight
                            width: parent.width - 10
                            horizontalAlignment: Text.AlignHCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: workspace.currentIndex = modelData.index
                        }
                    }
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
            AeronauticalDataHubPage {}
            TrainingRouteLabPage {}
            AircraftStoryboardPage {}
        }
    }
}
