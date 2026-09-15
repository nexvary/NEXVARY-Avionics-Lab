import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "NavigationLocale.js" as NavLocale

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
    property string selectedRoute: "overview"
    property string activeGroup: "command"
    property string workMode: "COMMAND"
    property bool presentationMode: false
    property var navigationHistory: []
    property real uiScale: Math.max(0.94, Math.min(1.30, width / 1920.0))
    property bool rtlLayoutVerified: cockpit.rtl && shellLayout.layoutDirection === Qt.RightToLeft && navigationRail.x > width / 2
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

    function tr(key) { return NavLocale.t(cockpit.language, key) }

    function navigationGroups() {
        return [
            {
                id: "command", label: tr("command"), accent: Theme.royalGold, open: true,
                entries: [
                    {route:"overview", label:tr("overview"), icon:"dashboard", page:0, workspace:0},
                    {route:"common-picture", label:tr("commonPicture"), icon:"map", page:11, workspace:1}
                ]
            },
            {
                id: "air-operations", label: tr("airOps"), accent: Theme.signalCyan, open: true,
                entries: [
                    {route:"airspace", label:tr("airspace"), icon:"airspace", page:11, workspace:0},
                    {route:"flight-tracking", label:tr("flightTracking"), icon:"radar", page:11, workspace:5},
                    {route:"route-lab", label:tr("routeLab"), icon:"route", page:11, workspace:3},
                    {route:"aeronautical-data", label:tr("aeroData"), icon:"data", page:11, workspace:2},
                    {route:"space-domain", label:tr("spaceDomain"), icon:"orbit", page:11, workspace:7}
                ]
            },
            {
                id: "force-management", label: tr("force"), accent: Theme.radarGreen, open: true,
                entries: [
                    {route:"fleet", label:tr("fleet"), icon:"fleet", page:12, workspace:0},
                    {route:"squadrons", label:tr("squadrons"), icon:"fleet", page:12, workspace:1},
                    {route:"bases", label:tr("bases"), icon:"base", page:12, workspace:2},
                    {route:"crews", label:tr("crews"), icon:"crew", page:12, workspace:3},
                    {route:"training", label:tr("training"), icon:"training", page:12, workspace:4},
                    {route:"maintenance", label:tr("maintenance"), icon:"maintenance", page:12, workspace:5}
                ]
            },
            {
                id: "engineering", label: tr("engineering"), accent: Theme.skyBlue, open: false,
                entries: [
                    {route:"system-health", label:tr("health"), icon:"health", page:1, workspace:0},
                    {route:"sensors", label:tr("sensors"), icon:"sensors", page:2, workspace:0},
                    {route:"digital-twin", label:tr("twin"), icon:"twin", page:6, workspace:0},
                    {route:"diagnostics", label:tr("diagnostics"), icon:"diagnostic", page:9, workspace:0},
                    {route:"fault-lab", label:tr("faultLab"), icon:"fault", page:8, workspace:0},
                    {route:"verification", label:tr("verification"), icon:"verify", page:10, workspace:0},
                    {route:"replay", label:tr("replay"), icon:"replay", page:4, workspace:0},
                    {route:"trends", label:tr("trends"), icon:"trends", page:5, workspace:0},
                    {route:"aircraft-visuals", label:tr("aircraft"), icon:"platform", page:11, workspace:4}
                ]
            },
            {
                id: "cuas", label: tr("cuas"), accent: Theme.warmOrange, open: false,
                entries: [
                    {route:"cuas-detection", label:tr("detection"), icon:"radar", page:11, workspace:60},
                    {route:"cuas-classification", label:tr("classification"), icon:"classify", page:11, workspace:61},
                    {route:"cuas-incidents", label:tr("incidents"), icon:"incident", page:11, workspace:62},
                    {route:"cuas-coordination", label:tr("coordination"), icon:"response", page:11, workspace:63}
                ]
            },
            {
                id: "system", label: tr("system"), accent: Theme.metallicSilver, open: false,
                entries: [
                    {route:"data-sources", label:tr("sources"), icon:"source", page:15, workspace:0},
                    {route:"audit", label:tr("audit"), icon:"verify", page:16, workspace:0},
                    {route:"reports", label:tr("reports"), icon:"report", page:16, workspace:1},
                    {route:"settings", label:tr("settings"), icon:"settings", page:16, workspace:2},
                    {route:"platform-library", label:tr("platformLibrary"), icon:"platform", page:7, workspace:0},
                    {route:"about-system", label:tr("aboutSystem"), icon:"about", page:13, workspace:0},
                    {route:"about-nexvary", label:tr("aboutNexvary"), icon:"about", page:14, workspace:0}
                ]
            }
        ]
    }

    function languageIndex(code) {
        for (let i = 0; i < languageOptions.length; ++i)
            if (languageOptions[i].code === code) return i
        return 1
    }

    function routeForPage(index) {
        const defaults = {
            0:["overview","command",0], 1:["system-health","engineering",0], 2:["sensors","engineering",0],
            3:["audit","system",0], 4:["replay","engineering",0], 5:["trends","engineering",0],
            6:["digital-twin","engineering",0], 7:["platform-library","system",0], 8:["fault-lab","engineering",0],
            9:["diagnostics","engineering",0], 10:["verification","engineering",0], 11:["airspace","air-operations",0],
            12:["fleet","force-management",0], 13:["about-system","system",0], 14:["about-nexvary","system",0],
            15:["data-sources","system",0], 16:["audit","system",0]
        }
        return defaults[index] || defaults[0]
    }

    function applyWorkspace(page, workspace) {
        if (page === 11) {
            if (workspace >= 60) {
                airOperationsPage.selectedWorkspace = 6
                airOperationsPage.cuasSection = Math.max(0, Math.min(3, workspace - 60))
            } else {
                airOperationsPage.selectedWorkspace = workspace
            }
        }
        if (page === 12) forceManagementPage.selectedWorkspace = workspace
        if (page === 16) governancePage.selectedWorkspace = workspace
    }

    function activateRoute(routeId, page, workspace, groupId, remember) {
        if (remember && (routeId !== selectedRoute || page !== selectedPage)) {
            let next = navigationHistory.slice(0)
            next.push({route:selectedRoute, page:selectedPage, workspace:currentWorkspace(), group:activeGroup})
            if (next.length > 32) next.shift()
            navigationHistory = next
        }
        selectedRoute = routeId
        activeGroup = groupId
        selectedPage = page
        applyWorkspace(page, workspace)
        if (groupId === "command") workMode = "COMMAND"
        else if (groupId === "engineering") workMode = "ENGINEERING"
        else if (groupId === "system") workMode = "SYSTEM"
        else workMode = "OPERATIONS"
    }

    function currentWorkspace() {
        if (selectedPage === 11) return airOperationsPage.selectedWorkspace === 6 ? 60 + airOperationsPage.cuasSection : airOperationsPage.selectedWorkspace
        if (selectedPage === 12) return forceManagementPage.selectedWorkspace
        if (selectedPage === 16) return governancePage.selectedWorkspace
        return 0
    }

    function navigateRoute(routeId, page, workspace, groupId) {
        activateRoute(routeId, page, workspace, groupId, true)
    }

    function navigateTo(index) {
        const target = routeForPage(index)
        activateRoute(target[0], index, target[2], target[1], true)
    }

    function initializeView(index, airWorkspace, forceWorkspace, cuasSection, systemWorkspace) {
        if (index === 11) {
            const routes = ["airspace", "common-picture", "aeronautical-data", "route-lab", "aircraft-visuals", "flight-tracking", "cuas-detection", "space-domain"]
            const groups = ["air-operations", "command", "air-operations", "air-operations", "engineering", "air-operations", "cuas", "air-operations"]
            const workspace = Math.max(0, Math.min(7, airWorkspace))
            if (workspace === 6) {
                const section = Math.max(0, Math.min(3, Number(cuasSection || 0)))
                const cuasRoutes = ["cuas-detection", "cuas-classification", "cuas-incidents", "cuas-coordination"]
                activateRoute(cuasRoutes[section], 11, 60 + section, "cuas", false)
            } else {
                activateRoute(routes[workspace], 11, workspace, groups[workspace], false)
            }
            return
        }
        if (index === 12) {
            const routes = ["fleet", "squadrons", "bases", "crews", "training", "maintenance"]
            const workspace = Math.max(0, Math.min(5, forceWorkspace))
            activateRoute(routes[workspace], 12, workspace, "force-management", false)
            return
        }
        if (index === 16) {
            const routes = ["audit", "reports", "settings"]
            const workspace = Math.max(0, Math.min(2, Number(systemWorkspace || 0)))
            activateRoute(routes[workspace], 16, workspace, "system", false)
            return
        }
        const target = routeForPage(index)
        activateRoute(target[0], index, target[2], target[1], false)
    }

    function goBack() {
        if (navigationHistory.length === 0) {
            activateRoute("overview", 0, 0, "command", false)
            return
        }
        let next = navigationHistory.slice(0)
        const previous = next.pop()
        navigationHistory = next
        activateRoute(previous.route, previous.page, previous.workspace, previous.group, false)
    }

    function setWorkMode(mode) {
        if (mode === "COMMAND") activateRoute("overview", 0, 0, "command", true)
        else if (mode === "ENGINEERING") activateRoute("system-health", 1, 0, "engineering", true)
        else if (mode === "SYSTEM") activateRoute("data-sources", 15, 0, "system", true)
        else activateRoute("common-picture", 11, 1, "air-operations", true)
    }

    function routeLabel() {
        const groups = navigationGroups()
        for (let g = 0; g < groups.length; ++g)
            for (let i = 0; i < groups[g].entries.length; ++i)
                if (groups[g].entries[i].route === selectedRoute) return groups[g].entries[i].label
        return tr("overview")
    }

    function groupLabel() {
        const groups = navigationGroups()
        for (let g = 0; g < groups.length; ++g)
            if (groups[g].id === activeGroup) return groups[g].label
        return tr("command")
    }

    function groupAccent() {
        const groups = navigationGroups()
        for (let g = 0; g < groups.length; ++g)
            if (groups[g].id === activeGroup) return groups[g].accent
        return Theme.royalGold
    }

    Timer { interval: 250; running: true; repeat: true; onTriggered: cockpit.step() }

    Shortcut {
        sequence: "F11"
        onActivated: root.presentationMode = !root.presentationMode
    }

    onPresentationModeChanged: {
        if (presentationMode) root.showFullScreen()
        else root.showMaximized()
    }

    RowLayout {
        id: shellLayout
        anchors.fill: parent
        spacing: 0
        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

        Rectangle {
            id: navigationRail
            visible: !root.presentationMode
            Layout.preferredWidth: Math.round(292 * root.uiScale)
            Layout.minimumWidth: 272
            Layout.maximumWidth: 328
            Layout.fillHeight: true
            color: Theme.shell
            border.color: Theme.border
            border.width: Theme.frameWidth

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 88
                    spacing: 11
                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                    NexvaryMark { Layout.preferredWidth: 70; Layout.preferredHeight: 70 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text {
                            text: "NEXVARY"
                            color: Theme.platinum
                            font.family: Theme.latinUi
                            font.pixelSize: 21
                            font.bold: true
                            font.letterSpacing: 2.5
                            Layout.fillWidth: true
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        }
                        Text {
                            text: "AVIONICS LAB"
                            color: Theme.signalCyan
                            font.family: Theme.latinUi
                            font.pixelSize: Theme.smallPx
                            font.bold: true
                            font.letterSpacing: 1.3
                            Layout.fillWidth: true
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        }
                        Text {
                            text: cockpit.rtl ? "منصة قيادة وهندسة الطيران" : "AIR COMMAND • ENGINEERING"
                            color: Theme.accent
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: Theme.smallPx
                            Layout.fillWidth: true
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            elide: Text.ElideRight
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                ScrollView {
                    id: navigationScroll
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentWidth: availableWidth
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    ColumnLayout {
                        width: navigationScroll.availableWidth
                        spacing: 7

                        Repeater {
                            model: root.navigationGroups()
                            delegate: WorkspaceNavGroup {
                                required property var modelData
                                Layout.fillWidth: true
                                groupId: modelData.id
                                title: modelData.label
                                accent: modelData.accent
                                entries: modelData.entries
                                selectedRoute: root.selectedRoute
                                rtl: cockpit.rtl
                                initiallyExpanded: modelData.open
                                onRouteRequested: function(routeId, page, workspace, groupId) {
                                    root.navigateRoute(routeId, page, workspace, groupId)
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 112
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                            Rectangle { width: 9; height: 9; radius: 5; color: cockpit.activeAlertCount === 0 ? Theme.radarGreen : Theme.amber }
                            Text {
                                Layout.fillWidth: true
                                text: cockpit.rtl ? "حالة المنصة" : "PLATFORM STATUS"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                            Text { text: cockpit.activeAlertCount === 0 ? "READY" : "CHECK"; color: cockpit.activeAlertCount === 0 ? Theme.radarGreen : Theme.amber; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: "OFFLINE / SYNTHETIC"; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                        Text { text: cockpit.rtl ? "لا يوجد مسار تحكم حي" : "NO LIVE AIRCRAFT CONTROL"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: cockpit.rtl ? "تدريب • تحقق • تحليل" : "TRAINING • VERIFICATION • ANALYSIS"; color: Theme.signalCyan; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                        Item { Layout.fillHeight: true }
                        Text { text: "v3.5.0  •  SPACE DOMAIN GATE 1980"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.round((root.presentationMode ? 78 : 88) * root.uiScale)
                Layout.minimumHeight: 82
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    anchors.topMargin: 9
                    anchors.bottomMargin: 9
                    spacing: 10
                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                    MinisterialButton {
                        text: (cockpit.rtl ? "▶  " : "◀  ") + cockpit.text("back")
                        implicitWidth: 94
                        visible: root.selectedPage !== 0 || root.navigationHistory.length > 0
                        enabled: visible
                        accent: Theme.royalGold
                        onClicked: root.goBack()
                    }

                    NexvaryMark {
                        visible: root.presentationMode
                        Layout.preferredWidth: 52
                        Layout.preferredHeight: 52
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: cockpit.text("app_title")
                            color: Theme.platinum
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: Math.round(Theme.pageTitlePx * root.uiScale)
                            font.bold: true
                            Layout.fillWidth: true
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            elide: Text.ElideRight
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 7
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                            Text {
                                text: root.groupLabel()
                                color: root.groupAccent()
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                            }
                            Text { text: "/"; color: Theme.metallicSilver; font.pixelSize: 12 }
                            Text {
                                Layout.fillWidth: true
                                text: root.routeLabel()
                                color: Theme.silver
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.smallPx
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                elide: Text.ElideRight
                            }
                        }
                    }

                    RowLayout {
                        visible: !root.presentationMode && (root.width >= 2100 || (root.selectedPage === 0 && root.width >= 1740))
                        spacing: 5
                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                        MinisterialButton { text: "CMD"; checkable: true; checked: root.workMode === "COMMAND"; implicitWidth: 62; accent: Theme.royalGold; onClicked: root.setWorkMode("COMMAND") }
                        MinisterialButton { text: "OPS"; checkable: true; checked: root.workMode === "OPERATIONS"; implicitWidth: 62; accent: Theme.royalGold; onClicked: root.setWorkMode("OPERATIONS") }
                        MinisterialButton { text: "ENG"; checkable: true; checked: root.workMode === "ENGINEERING"; implicitWidth: 62; accent: Theme.royalGold; onClicked: root.setWorkMode("ENGINEERING") }
                        MinisterialButton { text: "SYS"; checkable: true; checked: root.workMode === "SYSTEM"; implicitWidth: 62; accent: Theme.royalGold; onClicked: root.setWorkMode("SYSTEM") }
                    }

                    Rectangle {
                        Layout.preferredWidth: 178
                        Layout.preferredHeight: 54
                        visible: !root.presentationMode && root.width >= 1540
                        color: Theme.panel2
                        border.color: Theme.border
                        border.width: 1
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                            Rectangle {
                                width: 38; height: 38; radius: 6
                                color: Theme.panel3
                                border.color: Theme.accent
                                border.width: 1
                                Text { anchors.centerIn: parent; text: Theme.platformCode(cockpit.activePlatformId); color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text { text: cockpit.activePlatformCategory; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                Text { text: cockpit.activePlatformName; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                            }
                        }
                    }

                    ComboBox {
                        id: scenarioBox
                        visible: !root.presentationMode
                        model: cockpit.scenarios
                        Layout.preferredWidth: 132
                        contentItem: Text { text: scenarioBox.displayText; color: Theme.platinum; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.pixelSize: Theme.smallPx; font.family: Theme.mono; elide: Text.ElideRight }
                        background: Rectangle { color: Theme.panel2; radius: Theme.radius; border.color: Theme.border; border.width: 1 }
                        onActivated: cockpit.setScenario(currentText)
                    }

                    Rectangle {
                        Layout.preferredWidth: 132
                        Layout.preferredHeight: 48
                        color: Theme.panel2
                        border.color: Theme.border
                        border.width: 1
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 7
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                            Rectangle { width: 9; height: 9; radius: 5; color: cockpit.activeAlertCount === 0 ? Theme.radarGreen : Theme.amber }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text { text: cockpit.activeAlertCount === 0 ? "NOMINAL" : "ATTENTION"; color: cockpit.activeAlertCount === 0 ? Theme.radarGreen : Theme.amber; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                Text { text: "ALERTS " + cockpit.activeAlertCount + " • DX " + cockpit.diagnosticFindingCount; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                            }
                        }
                    }

                    MinisterialButton {
                        text: root.presentationMode ? (cockpit.rtl ? "خروج من العرض" : "EXIT PRESENT") : (cockpit.rtl ? "عرض وزاري" : "PRESENT")
                        implicitWidth: root.presentationMode ? 122 : 104
                        accent: Theme.royalGold
                        onClicked: root.presentationMode = !root.presentationMode
                    }

                    ComboBox {
                        id: languageBox
                        visible: !root.presentationMode
                        model: root.languageOptions
                        textRole: "name"
                        Layout.preferredWidth: 116
                        currentIndex: root.languageIndex(cockpit.language)
                        contentItem: Text {
                            text: languageBox.displayText
                            color: Theme.platinum
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: Theme.smallPx
                            font.bold: true
                            elide: Text.ElideRight
                        }
                        background: Rectangle { color: Theme.panel2; radius: Theme.radius; border.color: Theme.royalGold; border.width: 1 }
                        onActivated: cockpit.setLanguage(root.languageOptions[currentIndex].code)
                    }
                }

                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; height: 2; color: root.groupAccent(); opacity: 0.78 }
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
                AirOperationsPage { id: airOperationsPage }
                ForceManagementWorkspacePage { id: forceManagementPage }
                Item {
                    AboutSystem { anchors.fill: parent; anchors.bottomMargin: 92 }
                    TechnologyStackBanner {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        height: 78
                    }
                }
                AboutNexvary {}
                DataSourcesPage {}
                SystemGovernancePage { id: governancePage }
            }

            Rectangle {
                visible: !root.presentationMode
                Layout.fillWidth: true
                Layout.preferredHeight: root.presentationMode ? 0 : 34
                color: Theme.shell
                border.color: Theme.border
                border.width: 1
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10
                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                    Text { text: "NEXVARY AVIONICS LAB  /  v3.5.0"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                    Item { Layout.fillWidth: true }
                    Text { text: cockpit.text("simulation_only"); color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; elide: Text.ElideRight; Layout.maximumWidth: parent.width * 0.44 }
                    Item { Layout.fillWidth: true }
                    Text { text: cockpit.activePlatformName.toUpperCase() + "  •  OFFLINE  •  SYNTHETIC  •  NO LIVE CONTROL"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; elide: Text.ElideRight }
                }
            }
        }
    }
}
