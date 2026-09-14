import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "NavigationLocale.js" as NavLocale
import "AirForceManagementLocale.js" as ForceLocale

Item {
    id: page
    clip: true
    property int selectedWorkspace: 0

    function scoreColor(value) {
        if (Number(value) >= 90) return Theme.radarGreen
        if (Number(value) >= 80) return Theme.royalGold
        return Theme.warmOrange
    }

    function stateColor(value) {
        var state = String(value || "").toUpperCase()
        if (state === "READY" || state === "AVAILABLE" || state === "CONFIRMED" || state === "CURRENT") return Theme.radarGreen
        if (state === "LIMITED" || state === "REVIEW" || state === "PLANNED" || state === "DRAFT") return Theme.royalGold
        if (state === "FAULT" || state === "CRITICAL" || state === "CLOSED") return Theme.red
        return Theme.signalCyan
    }

    function routeId(index) {
        return ["fleet", "squadrons", "bases", "crews", "training", "maintenance"][Math.max(0, Math.min(5, index))]
    }

    function workspaceNote(index) {
        if (cockpit.rtl) {
            return [
                "توزيع المنصات والجاهزية وحالة الفحص الفني",
                "صورة الأسراب والتخصيص وتغطية الأطقم",
                "حالة المدارج والطقس ودعم القواعد",
                "توافر الأطقم والتغطية والتأهيل التدريبي",
                "جدول التدريب والقدرة الاستيعابية وحالة التنفيذ",
                "الأعمال المفتوحة والأولوية وأفق الاستحقاق"
            ][index]
        }
        return [
            "PLATFORM ALLOCATION, READINESS AND INSPECTION STATE",
            "SQUADRON POSTURE, ASSIGNMENT AND CREW COVERAGE",
            "RUNWAY, WEATHER AND BASE SUPPORT AVAILABILITY",
            "CREW AVAILABILITY, COVERAGE AND TRAINING QUALIFICATION",
            "TRAINING SCHEDULE, CAPACITY AND EXECUTION STATUS",
            "OPEN WORK, PRIORITY AND INSPECTION HORIZON"
        ][index]
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            Layout.minimumHeight: 86
            Layout.maximumHeight: 86
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                Rectangle {
                    Layout.preferredWidth: 5
                    Layout.fillHeight: true
                    color: page.scoreColor(cockpit.forceFleetReadinessPercent)
                    radius: 2
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: NavLocale.t(cockpit.language, page.routeId(page.selectedWorkspace))
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.pageTitlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: page.workspaceNote(page.selectedWorkspace)
                        color: Theme.signalCyan
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.secondaryPx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: ForceLocale.boundary(cockpit.language)
                        color: Theme.muted
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.smallPx
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: Theme.borderSoft
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 1
                        Text { text: cockpit.rtl ? "موقف القوة" : "FORCE POSTURE"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        Text { text: cockpit.forceReadyPlatformCount + " / " + cockpit.forceAssignedPlatformCount; color: page.scoreColor(cockpit.forceFleetReadinessPercent); font.family: Theme.mono; font.pixelSize: 19; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        Text { text: cockpit.rtl ? "منصة جاهزة • بيانات تدريبية" : "READY PLATFORMS • TRAINING DATA"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 90
            Layout.minimumHeight: 90
            Layout.maximumHeight: 90
            columns: 5
            columnSpacing: 8
            Repeater {
                model: [
                    {label: cockpit.rtl ? "جاهزية الأسطول" : "FLEET READINESS", value: cockpit.forceFleetReadinessPercent + "%", detail: cockpit.forceReadyPlatformCount + " / " + cockpit.forceAssignedPlatformCount, color: page.scoreColor(cockpit.forceFleetReadinessPercent)},
                    {label: cockpit.rtl ? "جاهزية الأطقم" : "CREW READINESS", value: cockpit.forceCrewReadinessPercent + "%", detail: cockpit.rtl ? "تغطية مطلوبة" : "REQUIRED COVERAGE", color: page.scoreColor(cockpit.forceCrewReadinessPercent)},
                    {label: cockpit.rtl ? "القواعد المتاحة" : "BASE AVAILABILITY", value: cockpit.forceAvailableBaseCount + " / " + cockpit.forceBases.length, detail: cockpit.forceWeatherConstraintCount + (cockpit.rtl ? " قيود جوية" : " WEATHER LIMIT"), color: cockpit.forceWeatherConstraintCount ? Theme.royalGold : Theme.radarGreen},
                    {label: cockpit.rtl ? "الصيانة المفتوحة" : "OPEN MAINTENANCE", value: String(cockpit.forceOpenMaintenanceCount), detail: cockpit.rtl ? "أعمال مخططة" : "PLANNED ACTIONS", color: Theme.royalGold},
                    {label: cockpit.rtl ? "مصادر البيانات" : "DATA SOURCES", value: String(cockpit.dataSourceRows.length), detail: cockpit.rtl ? "سجل مزوّدات" : "PROVIDER REGISTRY", color: Theme.signalCyan}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 1
                        Text { text: modelData.label; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                        Text { text: modelData.value; color: modelData.color; font.family: Theme.mono; font.pixelSize: 19; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        Text { text: modelData.detail; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                    }
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: page.selectedWorkspace

            // FLEET
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 7
                        Text { text: cockpit.rtl ? "مصفوفة جاهزية المنصات" : "PLATFORM READINESS MATRIX"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 2
                            columnSpacing: 8
                            rowSpacing: 8
                            Repeater {
                                model: cockpit.readinessAssets
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: Theme.panel2
                                    border.color: Theme.border
                                    border.width: 1
                                    radius: Theme.radius
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 9
                                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                        Rectangle {
                                            Layout.preferredWidth: 190
                                            Layout.fillHeight: true
                                            color: Theme.shell
                                            border.color: Theme.borderSoft
                                            radius: 4
                                            AircraftSchematic { anchors.fill: parent; anchors.margins: 6; platformId: modelData.id; subsystemRows: [] }
                                        }
                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 3
                                            Text { text: modelData.tail + "  /  " + modelData.category; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                            Text { text: modelData.name; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.bodyPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                            RowLayout {
                                                Layout.fillWidth: true
                                                Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true }
                                                Text { text: modelData.readiness + "%"; color: page.scoreColor(modelData.readiness); font.family: Theme.mono; font.pixelSize: 15; font.bold: true }
                                            }
                                            Rectangle {
                                                Layout.fillWidth: true; height: 8; color: Theme.shell; radius: 4
                                                Rectangle { width: parent.width * Number(modelData.readiness) / 100; height: parent.height; color: page.scoreColor(modelData.readiness); radius: 4 }
                                            }
                                            Text { text: (cockpit.rtl ? "الطاقم " : "CREW ") + modelData.crewReady + "/" + modelData.crewRequired + "   •   " + (cockpit.rtl ? "الفحص خلال " : "INSPECTION ") + modelData.hoursToInspection + " h"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                            Text { text: modelData.trainingSlot; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 370
                    Layout.minimumWidth: 370
                    Layout.maximumWidth: 370
                    Layout.fillHeight: true
                    spacing: 8
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 310
                        color: Theme.panel
                        border.color: Theme.border
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 7
                            Text { text: ForceLocale.squadrons(cockpit.language); color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: cockpit.forceSquadrons
                                delegate: ColumnLayout {
                                    required property var modelData
                                    Layout.fillWidth: true; spacing: 2
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: modelData.name; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.ready + "/" + modelData.assigned; color: page.stateColor(modelData.state); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                                    }
                                    Rectangle {
                                        Layout.fillWidth: true; height: 7; color: Theme.shell; radius: 3
                                        Rectangle { width: parent.width * Number(modelData.ready) / Math.max(1, Number(modelData.assigned)); height: parent.height; color: page.stateColor(modelData.state); radius: 3 }
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.panel
                        border.color: Theme.border
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 7
                            Text { text: cockpit.rtl ? "أفق الفحص الفني" : "INSPECTION HORIZON"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: cockpit.readinessAssets
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true; spacing: 7
                                    Text { text: modelData.tail; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.preferredWidth: 62 }
                                    Rectangle {
                                        Layout.fillWidth: true; height: 13; color: Theme.shell; radius: 3
                                        Rectangle { width: parent.width * Math.min(1, Number(modelData.hoursToInspection) / 40); height: parent.height; color: Number(modelData.hoursToInspection) < 16 ? Theme.warmOrange : Theme.royalGold; radius: 3 }
                                    }
                                    Text { text: modelData.hoursToInspection + " h"; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.preferredWidth: 42 }
                                }
                            }
                            Item { Layout.fillHeight: true }
                            Text { text: cockpit.rtl ? "الخط الزمني للتخطيط فقط؛ لا ينشئ أوامر تشغيلية." : "PLANNING TIMELINE ONLY; NO OPERATIONAL ORDERS ARE GENERATED."; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; wrapMode: Text.WordWrap; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        }
                    }
                }
            }

            // SQUADRONS
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 8
                        Text { text: ForceLocale.squadrons(cockpit.language); color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true; Layout.fillHeight: true; model: cockpit.forceSquadrons; spacing: 8; clip: true
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width; height: 128; color: index % 2 ? Theme.panel2 : Theme.panel3; border.color: Theme.border; border.width: 1; radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 11; spacing: 12; layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                    Rectangle { Layout.preferredWidth: 78; Layout.fillHeight: true; color: Theme.shell; border.color: Theme.borderSoft; radius: 4; Text { anchors.centerIn: parent; text: String(modelData.platform).indexOf("UAV") >= 0 ? "UAV" : String(modelData.platform).indexOf("ROTOR") >= 0 ? "HEL" : String(modelData.platform).indexOf("TURBO") >= 0 ? "TPR" : "JET"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 15; font.bold: true } }
                                    ColumnLayout {
                                        Layout.fillWidth: true; spacing: 4
                                        Text { text: modelData.name; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 15; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        Text { text: modelData.platform + "  •  " + modelData.state; color: page.stateColor(modelData.state); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        RowLayout { Layout.fillWidth: true; Text { text: cockpit.rtl ? "المنصات الجاهزة" : "READY PLATFORMS"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true } Text { text: modelData.ready + " / " + modelData.assigned; color: page.stateColor(modelData.state); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true } }
                                        Rectangle { Layout.fillWidth: true; height: 9; color: Theme.shell; radius: 4; Rectangle { width: parent.width * Number(modelData.ready) / Math.max(1, Number(modelData.assigned)); height: parent.height; color: page.stateColor(modelData.state); radius: 4 } }
                                    }
                                    ColumnLayout {
                                        Layout.preferredWidth: 145; spacing: 2
                                        Text { text: cockpit.rtl ? "تغطية الأطقم" : "CREW COVERAGE"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                        Text { text: modelData.crewReady + " / " + modelData.crewRequired; color: page.scoreColor(Number(modelData.crewReady) * 100 / Math.max(1, Number(modelData.crewRequired))); font.family: Theme.mono; font.pixelSize: 18; font.bold: true }
                                        Text { text: cockpit.rtl ? "متاح للتدريب" : "TRAINING AVAILABLE"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                    }
                                }
                            }
                        }
                    }
                }
                ColumnLayout {
                    Layout.preferredWidth: 390; Layout.minimumWidth: 390; Layout.maximumWidth: 390; Layout.fillHeight: true; spacing: 8
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 285; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 7
                            Text { text: cockpit.rtl ? "توزيع المنصات" : "PLATFORM DISTRIBUTION"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: cockpit.forceSquadrons
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true; spacing: 8
                                    Text { text: modelData.platform; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.assigned; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 18; font.bold: true }
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 7
                            Text { text: cockpit.rtl ? "ملخص التخصيص" : "ALLOCATION SUMMARY"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Text { text: cockpit.forceAssignedPlatformCount; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 34; font.bold: true }
                            Text { text: cockpit.rtl ? "منصة موزعة على أربعة أسراب تدريبية" : "PLATFORMS ALLOCATED ACROSS FOUR TRAINING SQUADRONS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.bodyPx; wrapMode: Text.WordWrap; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                            Item { Layout.fillHeight: true }
                            Text { text: "SYNTHETIC / READINESS MANAGEMENT"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                        }
                    }
                }
            }

            // BASES & AIRFIELDS
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius; clip: true
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 8; spacing: 7
                        Text { text: ForceLocale.bases(cockpit.language); color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        StrategicAirMap { Layout.fillWidth: true; Layout.fillHeight: true; rtl: cockpit.rtl; bases: cockpit.forceBases; publicTracks: []; aegisTracks: []; modeLabel: cockpit.rtl ? "شبكة القواعد والمطارات" : "BASE & AIRFIELD NETWORK" }
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 440; Layout.minimumWidth: 440; Layout.maximumWidth: 440; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 7
                        RowLayout { Layout.fillWidth: true; Text { text: cockpit.rtl ? "حالة المواقع" : "SITE STATUS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true } Text { text: cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length; color: page.scoreColor(cockpit.forceAvailableBaseCount * 100 / Math.max(1, cockpit.forceBases.length)); font.family: Theme.mono; font.pixelSize: 15; font.bold: true } }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true; Layout.fillHeight: true; model: cockpit.forceBases; spacing: 8; clip: true
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width; height: 164; color: index % 2 ? Theme.panel2 : Theme.panel3; border.color: Theme.border; border.width: 1; radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 10; spacing: 5
                                    RowLayout { Layout.fillWidth: true; layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight; Text { text: modelData.name; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 14; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight } Text { text: modelData.state; color: page.stateColor(modelData.state); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true } }
                                    Text { text: modelData.code + "  •  " + modelData.region; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                    Rectangle {
                                        Layout.fillWidth: true; height: 34; color: Theme.shell; border.color: Theme.borderSoft; radius: 3
                                        Rectangle { anchors.centerIn: parent; width: parent.width - 24; height: 9; color: "#2A2A2A"; radius: 1 }
                                        Row { anchors.centerIn: parent; spacing: 10; Repeater { model: 11; Rectangle { width: 15; height: 2; color: Theme.platinum } } }
                                    }
                                    RowLayout { Layout.fillWidth: true; Text { text: cockpit.rtl ? "المدرج" : "RUNWAY"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true } Text { text: modelData.runway; color: page.stateColor(modelData.runway); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true } }
                                    RowLayout { Layout.fillWidth: true; Text { text: cockpit.rtl ? "الطقس" : "WEATHER"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true } Text { text: modelData.weather; color: modelData.weather === "VMC" ? Theme.radarGreen : Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true } Text { text: modelData.supportPercent + "%"; color: page.scoreColor(modelData.supportPercent); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true } }
                                }
                            }
                        }
                    }
                }
            }

            // PERSONNEL / CREWS
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 8
                        Text { text: ForceLocale.crew(cockpit.language); color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true; Layout.fillHeight: true; columns: 2; columnSpacing: 8; rowSpacing: 8
                            Repeater {
                                model: cockpit.forceCrewRows
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius
                                    ColumnLayout {
                                        anchors.fill: parent; anchors.margins: 12; spacing: 7
                                        RowLayout { Layout.fillWidth: true; Text { text: modelData.role; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 15; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight } Text { text: modelData.score + "%"; color: page.scoreColor(modelData.score); font.family: Theme.mono; font.pixelSize: 22; font.bold: true } }
                                        Text { text: modelData.id + "  •  " + modelData.ready; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        Rectangle { Layout.fillWidth: true; height: 11; color: Theme.shell; radius: 5; Rectangle { width: parent.width * Number(modelData.score) / 100; height: parent.height; color: page.scoreColor(modelData.score); radius: 5 } }
                                        GridLayout {
                                            Layout.fillWidth: true; columns: 3; columnSpacing: 5
                                            Repeater { model: [cockpit.rtl ? "طيران" : "FLIGHT", cockpit.rtl ? "محاكي" : "SIM", cockpit.rtl ? "أنظمة" : "SYSTEMS"]; delegate: Rectangle { required property var modelData; Layout.fillWidth: true; height: 34; color: Theme.shell; border.color: Theme.borderSoft; radius: 3; Text { anchors.centerIn: parent; text: modelData; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true } } }
                                        }
                                        Item { Layout.fillHeight: true }
                                        Text { text: cockpit.rtl ? "متاح ضمن نافذة التدريب المخططة" : "AVAILABLE WITHIN PLANNED TRAINING WINDOW"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; wrapMode: Text.WordWrap }
                                    }
                                }
                            }
                        }
                    }
                }
                ColumnLayout {
                    Layout.preferredWidth: 420; Layout.minimumWidth: 420; Layout.maximumWidth: 420; Layout.fillHeight: true; spacing: 8
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 310; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 7
                            Text { text: cockpit.rtl ? "نافذة التدريب التالية" : "NEXT TRAINING WINDOW"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: cockpit.forceTrainingRows
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true; spacing: 8
                                    Text { text: modelData.time; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.preferredWidth: 48 }
                                    Text { text: modelData.group; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.preferredWidth: 70 }
                                    Text { text: modelData.item; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                            Text { text: cockpit.rtl ? "مؤشر التغطية" : "COVERAGE INDEX"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Text { text: cockpit.forceCrewReadinessPercent + "%"; color: page.scoreColor(cockpit.forceCrewReadinessPercent); font.family: Theme.mono; font.pixelSize: 38; font.bold: true }
                            Text { text: cockpit.rtl ? "جاهزية أطقم مجمّعة عبر الوحدات التدريبية" : "AGGREGATED CREW READINESS ACROSS TRAINING UNITS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.bodyPx; wrapMode: Text.WordWrap; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                            Item { Layout.fillHeight: true }
                            Text { text: "PERSONNEL DATA / SYNTHETIC"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                        }
                    }
                }
            }

            // TRAINING
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 8
                        Text { text: ForceLocale.training(cockpit.language); color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true; Layout.fillHeight: true; model: cockpit.forceTrainingRows; spacing: 8; clip: true
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width; height: 124; color: index % 2 ? Theme.panel2 : Theme.panel3; border.color: Theme.border; border.width: 1; radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 11; spacing: 12; layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                    ColumnLayout { Layout.preferredWidth: 96; spacing: 1; Text { text: modelData.time; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: 22; font.bold: true } Text { text: "UTC / T+" + index; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx } }
                                    Rectangle { Layout.preferredWidth: 2; Layout.fillHeight: true; color: page.stateColor(modelData.status) }
                                    ColumnLayout {
                                        Layout.fillWidth: true; spacing: 4
                                        Text { text: modelData.group; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        Text { text: modelData.item; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 14; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                        Text { text: cockpit.rtl ? "المجال: محاكاة / تحقق / تحليل" : "SCOPE: SIMULATION / VERIFICATION / ANALYSIS"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                    }
                                    Rectangle { Layout.preferredWidth: 112; Layout.preferredHeight: 40; color: Theme.shell; border.color: Theme.border; radius: 4; Text { anchors.centerIn: parent; text: modelData.status; color: page.stateColor(modelData.status); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true } }
                                }
                            }
                        }
                    }
                }
                ColumnLayout {
                    Layout.preferredWidth: 420; Layout.minimumWidth: 420; Layout.maximumWidth: 420; Layout.fillHeight: true; spacing: 8
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 310; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                            Text { text: cockpit.rtl ? "جاهزية التدريب" : "TRAINING READINESS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: cockpit.forceCrewRows
                                delegate: ColumnLayout {
                                    required property var modelData
                                    Layout.fillWidth: true; spacing: 2
                                    RowLayout { Layout.fillWidth: true; Text { text: modelData.role; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight } Text { text: modelData.score + "%"; color: page.scoreColor(modelData.score); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true } }
                                    Rectangle { Layout.fillWidth: true; height: 7; color: Theme.shell; radius: 3; Rectangle { width: parent.width * Number(modelData.score) / 100; height: parent.height; color: page.scoreColor(modelData.score); radius: 3 } }
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 7
                            Text { text: ForceLocale.reports(cockpit.language); color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: cockpit.forceExecutiveReports
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true; spacing: 7
                                    Rectangle { width: 7; height: 7; radius: 4; color: page.stateColor(modelData.status) }
                                    Text { text: modelData.title; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                }
                            }
                        }
                    }
                }
            }

            // MAINTENANCE
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 8
                        Text { text: ForceLocale.maintenance(cockpit.language); color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true; Layout.fillHeight: true; model: cockpit.readinessMaintenanceRows; spacing: 7; clip: true
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width; height: 106; color: index % 2 ? Theme.panel2 : Theme.panel3; border.color: modelData.priority === "P2" ? Theme.warmOrange : Theme.borderSoft; border.width: 1; radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 10; spacing: 12; layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                    Rectangle { Layout.preferredWidth: 52; Layout.fillHeight: true; color: Theme.shell; border.color: modelData.priority === "P2" ? Theme.warmOrange : Theme.royalGold; radius: 4; Text { anchors.centerIn: parent; text: modelData.priority; color: modelData.priority === "P2" ? Theme.warmOrange : Theme.royalGold; font.family: Theme.mono; font.pixelSize: 16; font.bold: true } }
                                    ColumnLayout {
                                        Layout.fillWidth: true; spacing: 3
                                        Text { text: modelData.platform + "  /  " + modelData.system; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        Text { text: modelData.action; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.bodyPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                        Text { text: cockpit.rtl ? "الأدلة والسجل محفوظان للمراجعة" : "EVIDENCE AND AUDIT TRAIL RETAINED FOR REVIEW"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                    }
                                    ColumnLayout { Layout.preferredWidth: 94; spacing: 2; Text { text: modelData.due; color: modelData.priority === "P2" ? Theme.warmOrange : Theme.royalGold; font.family: Theme.mono; font.pixelSize: 18; font.bold: true } Text { text: modelData.state; color: page.stateColor(modelData.state); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true } }
                                }
                            }
                        }
                    }
                }
                ColumnLayout {
                    Layout.preferredWidth: 430; Layout.minimumWidth: 430; Layout.maximumWidth: 430; Layout.fillHeight: true; spacing: 8
                    Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 330; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 8
                            Text { text: cockpit.rtl ? "خط الاستحقاق" : "DUE-HOUR TIMELINE"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: cockpit.readinessAssets
                                delegate: ColumnLayout {
                                    required property var modelData
                                    Layout.fillWidth: true; spacing: 2
                                    RowLayout { Layout.fillWidth: true; Text { text: modelData.tail; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true } Text { text: modelData.hoursToInspection + " h"; color: Number(modelData.hoursToInspection) < 16 ? Theme.warmOrange : Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true } }
                                    Rectangle { Layout.fillWidth: true; height: 10; color: Theme.shell; radius: 3; Rectangle { width: parent.width * Math.min(1, Number(modelData.hoursToInspection) / 40); height: parent.height; color: Number(modelData.hoursToInspection) < 16 ? Theme.warmOrange : Theme.royalGold; radius: 3 } }
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true; color: Theme.panel; border.color: Theme.border; radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 10; spacing: 7
                            Text { text: cockpit.rtl ? "موقف الاستدامة" : "SUSTAINMENT POSTURE"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Text { text: cockpit.forceOpenMaintenanceCount; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: 38; font.bold: true }
                            Text { text: cockpit.rtl ? "بنود تخطيط صيانة مفتوحة؛ الأولوية الأعلى معروضة بالبرتقالي." : "OPEN MAINTENANCE PLANNING ITEMS; HIGHER PRIORITY IS SHOWN IN ORANGE."; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.bodyPx; wrapMode: Text.WordWrap; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                            Item { Layout.fillHeight: true }
                            Text { text: "MAINTENANCE / ANALYSIS / NO LIVE CONTROL"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                        }
                    }
                }
            }
        }
    }
}
