import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirspaceLocale.js" as AirspaceLocale

Item {
    id: root
    property string releaseStage: "1980"
    property int selectedWorkspace: Math.max(0, Math.min(7, airOpsWorkspace))
    property int cuasSection: 0
    // Public web map reference only. This is intentionally separate from the
    // authorized HTTPS data-feed field inside Flight Tracking so a website URL
    // is never mistaken for an API endpoint.
    property string trackingWebsiteUrl: "https://map.opensky-network.org/"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: Theme.shell
            border.color: Theme.borderSoft
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Repeater {
                    model: [
                        {label: AirspaceLocale.chart(cockpit.language), index: 0, accent: Theme.signalCyan},
                        {label: AirspaceLocale.picture(cockpit.language), index: 1, accent: Theme.radarGreen},
                        {label: AirspaceLocale.dataHub(cockpit.language), index: 2, accent: Theme.royalGold},
                        {label: AirspaceLocale.routeLab(cockpit.language), index: 3, accent: Theme.rfViolet},
                        {label: AirspaceLocale.aircraft(cockpit.language), index: 4, accent: Theme.skyBlue},
                        {label: cockpit.rtl ? "تتبع الرحلات" : "FLIGHT TRACKING", index: 5, accent: Theme.signalCyan},
                        {label: cockpit.rtl ? "استجابة C-UAS" : "C-UAS RESPONSE", index: 6, accent: Theme.warmOrange},
                        {label: cockpit.rtl ? "المجال الفضائي" : "SPACE DOMAIN", index: 7, accent: Theme.royalGold}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 112
                        color: root.selectedWorkspace === modelData.index ? Theme.panel3 : Theme.panel2
                        border.color: root.selectedWorkspace === modelData.index ? modelData.accent : Theme.borderSoft
                        border.width: root.selectedWorkspace === modelData.index ? Theme.activeFrameWidth : Theme.frameWidth
                        radius: Theme.radius
                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: root.selectedWorkspace === modelData.index ? Theme.platinum : Theme.muted
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: Theme.smallPx
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

        Rectangle {
            id: trackingWebsiteBar
            objectName: "aircraftTrackingWebsiteBar"
            visible: root.selectedWorkspace === 5
            Layout.fillWidth: true
            Layout.preferredHeight: visible ? 48 : 0
            color: Theme.deepBlue
            border.color: Theme.royalGold
            border.width: Theme.activeFrameWidth

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                NexvaryMark {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                }

                ColumnLayout {
                    Layout.preferredWidth: 190
                    spacing: 0
                    Text {
                        Layout.fillWidth: true
                        text: cockpit.rtl ? "NEXVARY • موقع تتبع الطائرات" : "NEXVARY • AIRCRAFT TRACKING WEBSITE"
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.smallPx
                        font.bold: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        Layout.fillWidth: true
                        text: cockpit.rtl ? "مرجع ويب عام • ليس رابط API" : "PUBLIC WEB REFERENCE • NOT AN API FEED"
                        color: Theme.signalCyan
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: 10
                        font.bold: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }

                TextField {
                    id: trackingWebsiteField
                    objectName: "aircraftTrackingWebsiteUrl"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    text: root.trackingWebsiteUrl
                    readOnly: true
                    selectByMouse: true
                    color: Theme.platinum
                    selectionColor: Theme.royalGold
                    selectedTextColor: Theme.deepBlack
                    font.family: Theme.mono
                    font.pixelSize: Theme.smallPx
                    horizontalAlignment: Text.AlignLeft
                    background: Rectangle {
                        color: Theme.panel2
                        border.color: Theme.signalCyan
                        border.width: 1
                        radius: Theme.radius
                    }
                }

                Button {
                    id: openTrackingWebsiteButton
                    objectName: "openAircraftTrackingWebsiteButton"
                    Layout.preferredWidth: 132
                    Layout.preferredHeight: 34
                    text: cockpit.rtl ? "فتح الخريطة" : "OPEN MAP"
                    onClicked: Qt.openUrlExternally(root.trackingWebsiteUrl)
                    contentItem: Text {
                        text: parent.text
                        color: Theme.deepBlack
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.smallPx
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: openTrackingWebsiteButton.hovered ? "#E2C357" : Theme.royalGold
                        border.color: Theme.platinum
                        border.width: openTrackingWebsiteButton.activeFocus ? 1 : 0
                        radius: Theme.radius
                    }
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.selectedWorkspace
            AirspaceClassificationPage {}
            CommonAirPicturePage {}
            AeronauticalDataHubPage {}
            TrainingRouteLabPage {}
            AircraftStoryboardPage {}
            FlightTrackingPage {}
            CuasResponsePage { selectedSection: root.cuasSection }
            SpaceDomainAwarenessPage {}
        }
    }
}
