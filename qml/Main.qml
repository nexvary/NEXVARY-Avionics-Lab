import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 1440
    height: 900
    visible: true
    title: cockpit.text("app_title")
    property int selectedPage: 0

    function t(key) {
        const dependency = cockpit.language
        return cockpit.text(key)
    }

    LayoutMirroring.enabled: cockpit.rtl
    LayoutMirroring.childrenInherit: true

    background: Rectangle { color: "#03070a" }

    Timer {
        interval: 250
        running: true
        repeat: true
        onTriggered: cockpit.step()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            radius: 9
            color: "#071014"
            border.width: 1
            border.color: "#52646d"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    Text { text: root.t("app_title"); color: "#f1c75b"; font.pixelSize: 25; font.bold: true }
                    Text { text: root.t("training") + "  |  " + cockpit.scenario; color: "#39ff9b"; font.pixelSize: 13 }
                }
                Text { text: root.t("tick") + ": " + cockpit.tick; color: "#d4e2e7"; font.pixelSize: 16 }
                ComboBox {
                    id: scenarioBox
                    model: cockpit.scenarios
                    Layout.preferredWidth: 190
                    onActivated: cockpit.setScenario(currentText)
                }
                Button {
                    text: root.t("language")
                    onClicked: cockpit.setLanguage(cockpit.rtl ? "en" : "ar")
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Button { text: root.t("mfd"); checkable: true; checked: root.selectedPage === 0; onClicked: root.selectedPage = 0 }
            Button { text: root.t("systems"); checkable: true; checked: root.selectedPage === 1; onClicked: root.selectedPage = 1 }
            Button { text: root.t("alerts"); checkable: true; checked: root.selectedPage === 2; onClicked: root.selectedPage = 2 }
            Item { Layout.fillWidth: true }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.selectedPage

            Item {
                GridLayout {
                    anchors.fill: parent
                    columns: 4
                    columnSpacing: 12
                    rowSpacing: 12
                    Repeater {
                        model: cockpit.tiles
                        delegate: InstrumentTile {
                            Layout.fillWidth: true
                            tileLabel: modelData.label
                            tileValue: modelData.value
                            tileState: modelData.state
                        }
                    }
                }
            }

            Item {
                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: "#071014"
                    border.color: "#52646d"
                    Column {
                        anchors.centerIn: parent
                        spacing: 18
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.t("systems"); color: "#f1c75b"; font.pixelSize: 28; font.bold: true }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: cockpit.annunciators.length === 1 ? cockpit.annunciators[0] : cockpit.annunciators.length + " ACTIVE ALERTS"; color: cockpit.annunciators.length === 1 ? "#39ff9b" : "#ffb000"; font.pixelSize: 22 }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: cockpit.scenario; color: "#d4e2e7"; font.pixelSize: 16 }
                    }
                }
            }

            Item {
                ListView {
                    anchors.fill: parent
                    spacing: 8
                    model: cockpit.annunciators
                    delegate: Rectangle {
                        required property string modelData
                        width: ListView.view.width
                        height: 62
                        radius: 6
                        color: "#101519"
                        border.width: 1
                        border.color: modelData.indexOf("NOMINAL") >= 0 || modelData.indexOf("الاسمية") >= 0 ? "#39ff9b" : "#ffb000"
                        Text { anchors.fill: parent; anchors.margins: 14; text: modelData; color: "#e4edf0"; font.pixelSize: 16; verticalAlignment: Text.AlignVCenter; wrapMode: Text.Wrap }
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            text: root.t("simulation_only")
            color: "#748990"
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
