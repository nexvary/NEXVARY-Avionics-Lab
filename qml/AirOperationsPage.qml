import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirspaceLocale.js" as AirspaceLocale

Item {
    id: root
    property string releaseStage: "1850"
    property int selectedWorkspace: Math.max(0, Math.min(5, airOpsWorkspace))
    property int cuasSection: 0

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
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
                        {label: AirspaceLocale.aircraft(cockpit.language), index: 4, accent: Theme.skyBlue},
                        {label: cockpit.rtl ? "استجابة C-UAS" : "C-UAS RESPONSE", index: 5, accent: Theme.warmOrange}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 132
                        color: root.selectedWorkspace === modelData.index ? Theme.panel3 : Theme.panel2
                        border.color: root.selectedWorkspace === modelData.index ? Theme.royalGold : Theme.borderSoft
                        border.width: root.selectedWorkspace === modelData.index ? Theme.activeFrameWidth : Theme.frameWidth
                        radius: Theme.radius

                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: root.selectedWorkspace === modelData.index ? Theme.platinum : Theme.muted
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: modelData.label.length > 22 ? 10 : 11
                            font.bold: true
                            elide: Text.ElideRight
                            width: parent.width - 12
                            horizontalAlignment: Text.AlignHCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectedWorkspace = modelData.index
                        }
                    }
                }
            }
        }

        StackLayout {
            id: workspace
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.selectedWorkspace

            AirspaceClassificationPage {}
            AirPictureIntelligencePage {}
            AeronauticalDataHubPage {}
            TrainingRouteLabPage {}
            AircraftStoryboardPage {}
            CuasResponsePage { selectedSection: root.cuasSection }
        }
    }
}
