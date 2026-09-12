import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

ApplicationWindow {
    id: root
    width: 1720
    height: 1000
    minimumWidth: 1360
    minimumHeight: 800
    visible: true
    title: cockpit.text("app_title")
    color: Theme.bg

    property int selectedPage: 0
    property string workMode: "EXECUTIVE"

    onSelectedPageChanged: {
        if (selectedPage === 0) workMode = "EXECUTIVE"
        else if (selectedPage === 5) workMode = "ENGINEERING"
        else if (selectedPage === 9) workMode = "DIAGNOSTIC"
    }

    function setWorkMode(mode) {
        workMode = mode
        if (mode === "EXECUTIVE") selectedPage = 0
        else if (mode === "ENGINEERING") selectedPage = 5
        else selectedPage = 9
    }

    Timer { interval: 250; running: true; repeat: true; onTriggered: cockpit.step() }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 206
            Layout.fillHeight: true
            color: Theme.shell
            border.color: Theme.borderSoft
            border.width: 1
            LayoutMirroring.enabled: false

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 5

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    spacing: 10
                    NexvaryMark { Layout.preferredWidth: 40; Layout.preferredHeight: 40 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text { text: "NEXVARY"; color: Theme.platinum; font.pixelSize: 17; font.bold: true; font.letterSpacing: 2.4 }
                        Text { text: "AVIONICS LAB"; color: Theme.silver; font.pixelSize: 8; font.letterSpacing: 1.5 }
                        Text { text: "COMMAND INTERFACE"; color: Theme.accent; font.pixelSize: 6; font.letterSpacing: 1.0 }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                Text { text: "MISSION WORKSPACES"; color: Theme.muted; font.pixelSize: 7; font.bold: true; font.letterSpacing: 1.1; leftPadding: 4; topPadding: 5; bottomPadding: 3 }

                Repeater {
                    model: [
                        {"text": cockpit.text("mfd"), "icon": "dashboard"},
                        {"text": cockpit.text("systems"), "icon": "health"},
                        {"text": cockpit.text("sensors"), "icon": "sensors"},
                        {"text": cockpit.text("events"), "icon": "events"},
                        {"text": cockpit.text("replay"), "icon": "replay"},
                        {"text": cockpit.text("trends"), "icon": "trends"},
                        {"text": cockpit.text("digital_twin"), "icon": "twin"},
                        {"text": cockpit.rtl ? "مكتبة المنصات" : "Platform Library", "icon": "platform"},
                        {"text": cockpit.text("fault_lab"), "icon": "fault"},
                        {"text": cockpit.rtl ? "مركز التشخيص" : "Diagnostic Center", "icon": "diagnostic"},
                        {"text": cockpit.rtl ? "مركز التحقق" : "Verification Center", "icon": "verify"}
                    ]
                    delegate: SideNavButton {
                        required property int index
                        required property var modelData
                        text: modelData.text
                        iconKind: modelData.icon
                        checked: root.selectedPage === index
                        Layout.fillWidth: true
                        onClicked: root.selectedPage = index
                    }
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 112
                    color: Theme.panel
                    border.color: Theme.border
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 3
                        RowLayout {
                            Layout.fillWidth: true
                            Rectangle { width: 7; height: 7; radius: 3; color: cockpit.activeAlertCount === 0 ? Theme.green : Theme.amber }
                            Text { text: "LAB STATUS"; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.activeAlertCount === 0 ? "READY" : "CHECK"; color: cockpit.activeAlertCount === 0 ? Theme.green : Theme.amber; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: "OFFLINE / SYNTHETIC"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7 }
                        Text { text: "NO LIVE AIRCRAFT I/O"; color: Theme.muted; font.pixelSize: 7 }
                        Text { text: "TRAINING / VERIFICATION"; color: Theme.accent; font.pixelSize: 7; font.bold: true }
                        Item { Layout.fillHeight: true }
                        Text { text: "v3.2.0  •  STAGE 1720"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            LayoutMirroring.enabled: cockpit.rtl
            LayoutMirroring.childrenInherit: true

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: Theme.panel
                border.color: Theme.borderSoft
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    spacing: 12

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text {
                            text: cockpit.text("app_title")
                            color: Theme.platinum
                            font.pixelSize: 20
                            font.bold: true
                            font.letterSpacing: 0.35
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            Layout.fillWidth: true
                        }
                        Text {
                            text: (cockpit.rtl ? "منصة هندسية متعددة الأنظمة" : "MULTI-PLATFORM AVIONICS ENGINEERING ENVIRONMENT") + "  /  " + cockpit.activePlatformName.toUpperCase()
                            color: Theme.accent
                            font.pixelSize: 8
                            font.bold: true
                            font.letterSpacing: 0.7
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }

                    RowLayout {
                        spacing: 4
                        MinisterialButton { text: "EXEC"; checkable: true; checked: root.workMode === "EXECUTIVE"; implicitWidth: 70; accent: Theme.accent; onClicked: root.setWorkMode("EXECUTIVE") }
                        MinisterialButton { text: "ENG"; checkable: true; checked: root.workMode === "ENGINEERING"; implicitWidth: 70; accent: Theme.accent; onClicked: root.setWorkMode("ENGINEERING") }
                        MinisterialButton { text: "DIAG"; checkable: true; checked: root.workMode === "DIAGNOSTIC"; implicitWidth: 70; accent: Theme.accent; onClicked: root.setWorkMode("DIAGNOSTIC") }
                    }

                    Rectangle { width: 1; Layout.fillHeight: true; color: Theme.borderSoft }

                    Rectangle {
                        Layout.preferredWidth: 188
                        Layout.preferredHeight: 48
                        color: Theme.panel2
                        border.color: Theme.border
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            Rectangle {
                                width: 34; height: 34; color: Theme.panel3; border.color: Theme.accent; radius: Theme.radius
                                Text { anchors.centerIn: parent; text: Theme.platformCode(cockpit.activePlatformId); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text { text: cockpit.activePlatformCategory; color: Theme.muted; font.pixelSize: 6; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: cockpit.activePlatformName; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: cockpit.activePlatformPropulsion; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                        }
                    }

                    ComboBox {
                        id: scenarioBox
                        model: cockpit.scenarios
                        Layout.preferredWidth: 142
                        contentItem: Text { text: scenarioBox.displayText; color: Theme.platinum; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 8; font.family: "Consolas" }
                        background: Rectangle { color: Theme.panel2; radius: Theme.radius; border.color: Theme.border }
                        onActivated: cockpit.setScenario(currentText)
                    }

                    ColumnLayout {
                        spacing: 0
                        Text { text: "TICK " + cockpit.tick; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                        Text { text: "BUILD 3.2.0 / UI-M1"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                    }

                    Rectangle {
                        Layout.preferredWidth: 170
                        Layout.preferredHeight: 44
                        color: Theme.panel2
                        border.color: cockpit.activeAlertCount === 0 ? Theme.border : Theme.amber
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            Rectangle { width: 8; height: 8; radius: 4; color: cockpit.activeAlertCount === 0 ? Theme.green : Theme.amber }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text { text: cockpit.activeAlertCount === 0 ? "NOMINAL" : "ATTENTION"; color: cockpit.activeAlertCount === 0 ? Theme.platinum : Theme.amber; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                Text { text: "ALERTS " + cockpit.activeAlertCount + "  /  DX " + cockpit.diagnosticFindingCount; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                            }
                        }
                    }

                    MinisterialButton { text: cockpit.text("language"); implicitWidth: 72; onClicked: cockpit.setLanguage(cockpit.rtl ? "en" : "ar") }
                }

                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 1; color: Theme.accent; opacity: 0.75 }
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: root.selectedPage
                ExecutiveDashboard {}
                SystemHealthPage {}
                SensorsPage {}
                EventsPage {}
                ReplayPage {}
                TrendsPage {}
                DigitalTwinPage {}
                AircraftPlatformLibrary {}
                FaultLabPage {}
                DiagnosticCenter {}
                VerificationCenter {}
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 25
                color: Theme.shell
                border.color: Theme.borderSoft
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8
                    Text { text: "NEXVARY AVIONICS LAB  /  COMMAND ENGINEERING INTERFACE"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                    Item { Layout.fillWidth: true }
                    Text { text: cockpit.text("simulation_only"); color: Theme.silver; font.pixelSize: 6 }
                    Item { Layout.fillWidth: true }
                    Text { text: cockpit.activePlatformName.toUpperCase() + "  •  OFFLINE  •  SYNTHETIC DATA  •  NO LIVE CONTROL"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 6 }
                }
            }
        }
    }
}
