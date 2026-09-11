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
        if (root.selectedPage === 0) root.workMode = "EXECUTIVE"
        else if (root.selectedPage === 5) root.workMode = "ENGINEERING"
        else if (root.selectedPage === 9) root.workMode = "DIAGNOSTIC"
    }

    function setWorkMode(mode) {
        root.workMode = mode
        if (mode === "EXECUTIVE") root.selectedPage = 0
        else if (mode === "ENGINEERING") root.selectedPage = 5
        else root.selectedPage = 9
    }

    Timer { interval: 250; running: true; repeat: true; onTriggered: cockpit.step() }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: "#0A1117"
            border.color: Theme.border
            border.width: 1
            LayoutMirroring.enabled: false

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 5

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 78
                    spacing: 10
                    NexvaryMark { Layout.preferredWidth: 42; Layout.preferredHeight: 42 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text { text: "NEXVARY"; color: Theme.platinum; font.pixelSize: 18; font.bold: true; font.letterSpacing: 2.5 }
                        Text { text: "AVIONICS LAB"; color: Theme.silver; font.pixelSize: 8; font.letterSpacing: 1.8 }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                Text { text: "OPERATIONS"; color: Theme.muted; font.pixelSize: 8; font.bold: true; font.letterSpacing: 1.4; leftPadding: 4; topPadding: 5; bottomPadding: 3 }

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
                    Layout.preferredHeight: 92
                    color: Theme.panel
                    border.color: Theme.border
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 2
                        Text { text: "TRAINING / VERIFICATION"; color: Theme.accent; font.bold: true; font.pixelSize: 9; font.letterSpacing: 0.7; Layout.fillWidth: true }
                        Text { text: "SECURE  •  OFFLINE"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8; Layout.fillWidth: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: "NO LIVE AIRCRAFT I/O"; color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true }
                        Text { text: "SYNTHETIC DATA ONLY"; color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true }
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
                Layout.preferredHeight: 82
                color: Theme.panel
                border.color: Theme.border
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
                        Text { text: cockpit.text("app_title"); color: Theme.platinum; font.pixelSize: 21; font.bold: true; font.letterSpacing: 0.5; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; Layout.fillWidth: true }
                        Text { text: cockpit.text("training") + "  /  " + cockpit.activePlatformName + "  /  " + cockpit.scenario; color: Theme.accent; font.pixelSize: 9; font.bold: true; font.letterSpacing: 0.5; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                    RowLayout {
                        spacing: 5
                        MinisterialButton { text: "EXEC"; checkable: true; checked: root.workMode === "EXECUTIVE"; implicitWidth: 72; accent: Theme.accent; onClicked: root.setWorkMode("EXECUTIVE") }
                        MinisterialButton { text: "ENG"; checkable: true; checked: root.workMode === "ENGINEERING"; implicitWidth: 72; accent: Theme.accent; onClicked: root.setWorkMode("ENGINEERING") }
                        MinisterialButton { text: "DIAG"; checkable: true; checked: root.workMode === "DIAGNOSTIC"; implicitWidth: 72; accent: Theme.accent; onClicked: root.setWorkMode("DIAGNOSTIC") }
                    }
                    Rectangle { width: 1; Layout.fillHeight: true; color: Theme.borderSoft }
                    ColumnLayout {
                        spacing: 0
                        Text { text: "PLATFORM"; color: Theme.muted; font.pixelSize: 7; font.letterSpacing: 0.6 }
                        Text { text: cockpit.activePlatformId.toUpperCase(); color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                    }
                    ComboBox {
                        id: scenarioBox
                        model: cockpit.scenarios
                        Layout.preferredWidth: 145
                        contentItem: Text { text: scenarioBox.displayText; color: Theme.platinum; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 9; font.family: "Consolas" }
                        background: Rectangle { color: Theme.panel2; radius: Theme.radius; border.color: Theme.border }
                        onActivated: cockpit.setScenario(currentText)
                    }
                    ColumnLayout {
                        spacing: 0
                        Text { text: "TICK " + cockpit.tick; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                        Text { text: "BUILD 3.2.0  •  STAGE 1720"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                    }
                    Rectangle {
                        Layout.preferredWidth: 190
                        Layout.preferredHeight: 44
                        color: Theme.panel2
                        border.color: cockpit.activeAlertCount === 0 ? Theme.accent : Theme.amber
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            Rectangle { width: 8; height: 8; radius: 4; color: cockpit.activeAlertCount === 0 ? Theme.green : Theme.amber }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text { text: cockpit.activeAlertCount === 0 ? "SYSTEMS NOMINAL" : "ATTENTION REQUIRED"; color: cockpit.activeAlertCount === 0 ? Theme.platinum : Theme.amber; font.family: "Consolas"; font.pixelSize: 9; font.bold: true; elide: Text.ElideRight; Layout.fillWidth: true }
                                Text { text: "ALERTS " + cockpit.activeAlertCount; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                            }
                        }
                    }
                    MinisterialButton { text: cockpit.text("language"); implicitWidth: 82; onClicked: cockpit.setLanguage(cockpit.rtl ? "en" : "ar") }
                }
                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 2; color: Theme.accent; opacity: 0.55 }
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
                Layout.preferredHeight: 26
                color: "#0A1117"
                border.color: Theme.borderSoft
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8
                    Text { text: "NEXVARY AVIONICS LAB  /  AEROSPACE ENGINEERING WORKBENCH"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                    Item { Layout.fillWidth: true }
                    Text { text: cockpit.text("simulation_only"); color: Theme.silver; font.pixelSize: 7 }
                    Item { Layout.fillWidth: true }
                    Text { text: cockpit.activePlatformName.toUpperCase() + "  •  OFFLINE  •  SYNTHETIC DATA"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                }
            }
        }
    }
}
