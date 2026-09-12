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
    property var navigationHistory: []
    property real uiScale: Math.max(0.92, Math.min(1.35, width / 1720.0))
    property var languageOptions: [
        {"code":"ar", "name":"العربية"},
        {"code":"en", "name":"English"},
        {"code":"tr", "name":"Türkçe"},
        {"code":"es", "name":"Español"},
        {"code":"de", "name":"Deutsch"},
        {"code":"it", "name":"Italiano"},
        {"code":"fr", "name":"Français"},
        {"code":"ur", "name":"اردو"},
        {"code":"fa", "name":"فارسی"},
        {"code":"ru", "name":"Русский"}
    ]

    function languageIndex(code) {
        for (let i = 0; i < languageOptions.length; ++i)
            if (languageOptions[i].code === code) return i
        return 1
    }

    function navigateTo(index) {
        if (index === selectedPage) return
        let next = navigationHistory.slice(0)
        next.push(selectedPage)
        if (next.length > 24) next.shift()
        navigationHistory = next
        selectedPage = index
    }

    function goBack() {
        if (navigationHistory.length === 0) {
            selectedPage = 0
            return
        }
        let next = navigationHistory.slice(0)
        selectedPage = next.pop()
        navigationHistory = next
    }

    onSelectedPageChanged: {
        if (selectedPage === 0) workMode = "EXECUTIVE"
        else if (selectedPage === 5) workMode = "ENGINEERING"
        else if (selectedPage === 9) workMode = "DIAGNOSTIC"
        else if (selectedPage === 11) workMode = "BRIEF"
    }

    function setWorkMode(mode) {
        workMode = mode
        if (mode === "EXECUTIVE") navigateTo(0)
        else if (mode === "ENGINEERING") navigateTo(5)
        else if (mode === "DIAGNOSTIC") navigateTo(9)
        else navigateTo(11)
    }

    Timer { interval: 250; running: true; repeat: true; onTriggered: cockpit.step() }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: Math.round(206 * root.uiScale)
            Layout.fillHeight: true
            color: Theme.shell
            border.color: Theme.border
            border.width: Theme.frameWidth
            LayoutMirroring.enabled: false

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.round(12 * root.uiScale)
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.round(64 * root.uiScale)
                    spacing: 9
                    NexvaryMark { Layout.preferredWidth: 42; Layout.preferredHeight: 42 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text { text: "NEXVARY"; color: Theme.platinum; font.pixelSize: Math.round(17 * root.uiScale); font.bold: true; font.letterSpacing: 2.4 }
                        Text { text: "AVIONICS LAB"; color: Theme.silver; font.pixelSize: Math.round(8 * root.uiScale); font.letterSpacing: 1.5 }
                        Text { text: "COMMAND INTERFACE"; color: Theme.accent; font.pixelSize: Math.round(6 * root.uiScale); font.letterSpacing: 1.0 }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                Text { text: "MISSION WORKSPACES"; color: Theme.muted; font.pixelSize: 7; font.bold: true; font.letterSpacing: 1.1; leftPadding: 4; topPadding: 4; bottomPadding: 2 }

                Repeater {
                    model: [
                        {"text": cockpit.text("mfd"), "icon": "dashboard"},
                        {"text": cockpit.text("systems"), "icon": "health"},
                        {"text": cockpit.text("sensors"), "icon": "sensors"},
                        {"text": cockpit.text("events"), "icon": "events"},
                        {"text": cockpit.text("replay"), "icon": "replay"},
                        {"text": cockpit.text("trends"), "icon": "trends"},
                        {"text": cockpit.text("digital_twin"), "icon": "twin"},
                        {"text": cockpit.text("platform_library"), "icon": "platform"},
                        {"text": cockpit.text("fault_lab"), "icon": "fault"},
                        {"text": cockpit.text("diagnostic_center"), "icon": "diagnostic"},
                        {"text": cockpit.text("verification_center"), "icon": "verify"},
                        {"text": cockpit.text("about_system"), "icon": "about"},
                        {"text": cockpit.text("about_us"), "icon": "about"}
                    ]
                    delegate: SideNavButton {
                        required property int index
                        required property var modelData
                        text: modelData.text
                        iconKind: modelData.icon
                        checked: root.selectedPage === index
                        Layout.fillWidth: true
                        onClicked: root.navigateTo(index)
                    }
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.round(102 * root.uiScale)
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 2
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
                        Text { text: "v3.2.0  •  UI RELEASE GATE"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
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
                Layout.preferredHeight: Math.round(80 * root.uiScale)
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    anchors.topMargin: 9
                    anchors.bottomMargin: 9
                    spacing: 8

                    MinisterialButton {
                        text: cockpit.rtl ? "◀  " + cockpit.text("back") : "◀  " + cockpit.text("back")
                        implicitWidth: 88
                        visible: root.selectedPage !== 0 || root.navigationHistory.length > 0
                        enabled: visible
                        accent: Theme.gold
                        onClicked: root.goBack()
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text {
                            text: cockpit.text("app_title")
                            color: Theme.platinum
                            font.pixelSize: Math.round(20 * root.uiScale)
                            font.bold: true
                            font.letterSpacing: 0.35
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            Layout.fillWidth: true
                            elide: Text.ElideRight
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
                        visible: root.width >= 1540
                        spacing: 4
                        MinisterialButton { text: "EXEC"; checkable: true; checked: root.workMode === "EXECUTIVE"; implicitWidth: 58; accent: Theme.accent; onClicked: root.setWorkMode("EXECUTIVE") }
                        MinisterialButton { text: "ENG"; checkable: true; checked: root.workMode === "ENGINEERING"; implicitWidth: 58; accent: Theme.accent; onClicked: root.setWorkMode("ENGINEERING") }
                        MinisterialButton { text: "DIAG"; checkable: true; checked: root.workMode === "DIAGNOSTIC"; implicitWidth: 58; accent: Theme.accent; onClicked: root.setWorkMode("DIAGNOSTIC") }
                        MinisterialButton { text: "BRIEF"; checkable: true; checked: root.workMode === "BRIEF"; implicitWidth: 62; accent: Theme.platinum; onClicked: root.setWorkMode("BRIEF") }
                    }

                    Rectangle { width: 1; Layout.fillHeight: true; color: Theme.borderSoft; visible: root.width >= 1540 }

                    Rectangle {
                        Layout.preferredWidth: root.width >= 1800 ? 188 : 166
                        Layout.preferredHeight: 48
                        color: Theme.panel2
                        border.color: Theme.border
                        border.width: Theme.frameWidth
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            Rectangle {
                                width: 34
                                height: 34
                                color: Theme.panel3
                                border.color: Theme.accent
                                border.width: Theme.frameWidth
                                radius: Theme.radius
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
                        Layout.preferredWidth: root.width >= 1700 ? 132 : 112
                        contentItem: Text { text: scenarioBox.displayText; color: Theme.platinum; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 8; font.family: "Consolas"; elide: Text.ElideRight }
                        background: Rectangle { color: Theme.panel2; radius: Theme.radius; border.color: Theme.border; border.width: Theme.frameWidth }
                        onActivated: cockpit.setScenario(currentText)
                    }

                    ColumnLayout {
                        visible: root.width >= 1460
                        spacing: 0
                        Text { text: "TICK " + cockpit.tick; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                        Text { text: "BUILD 3.2.0 / UI-M3"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                    }

                    Rectangle {
                        Layout.preferredWidth: root.width >= 1640 ? 150 : 122
                        Layout.preferredHeight: 44
                        color: Theme.panel2
                        border.color: cockpit.activeAlertCount === 0 ? Theme.border : Theme.amber
                        border.width: Theme.frameWidth
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            Rectangle { width: 8; height: 8; radius: 4; color: cockpit.activeAlertCount === 0 ? Theme.green : Theme.amber }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text { text: cockpit.activeAlertCount === 0 ? "NOMINAL" : "ATTENTION"; color: cockpit.activeAlertCount === 0 ? Theme.platinum : Theme.amber; font.family: "Consolas"; font.pixelSize: 9; font.bold: true; elide: Text.ElideRight }
                                Text { text: "ALERTS " + cockpit.activeAlertCount + " / DX " + cockpit.diagnosticFindingCount; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; elide: Text.ElideRight }
                            }
                        }
                    }

                    ComboBox {
                        id: languageBox
                        model: root.languageOptions
                        textRole: "name"
                        Layout.preferredWidth: 118
                        currentIndex: root.languageIndex(cockpit.language)
                        contentItem: Text {
                            text: languageBox.displayText
                            color: Theme.platinum
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 9
                            font.bold: true
                            elide: Text.ElideRight
                        }
                        background: Rectangle { color: Theme.panel2; radius: Theme.radius; border.color: Theme.gold; border.width: 1 }
                        onActivated: cockpit.setLanguage(root.languageOptions[currentIndex].code)
                    }
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
                Item {
                    AboutSystem { anchors.fill: parent; anchors.bottomMargin: 86 }
                    TechnologyStackBanner {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        height: 74
                    }
                }
                AboutNexvary {}
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 25
                color: Theme.shell
                border.color: Theme.border
                border.width: Theme.frameWidth
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8
                    Text { text: "NEXVARY AVIONICS LAB  /  COMMAND ENGINEERING INTERFACE"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                    Item { Layout.fillWidth: true }
                    Text { text: cockpit.text("simulation_only"); color: Theme.silver; font.pixelSize: 6; elide: Text.ElideRight; Layout.maximumWidth: parent.width * 0.42 }
                    Item { Layout.fillWidth: true }
                    Text { text: cockpit.activePlatformName.toUpperCase() + "  •  OFFLINE  •  SYNTHETIC DATA  •  NO LIVE CONTROL"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 6; elide: Text.ElideRight }
                }
            }
        }
    }
}
