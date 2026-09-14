import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function readinessColor(v) {
        if (v >= 90) return "#63E2A6"
        if (v >= 80) return "#F5B44C"
        return "#FF6B57"
    }
    function stateColor(v) {
        var s = String(v || "").toUpperCase()
        if (s === "READY" || s === "AVAILABLE" || s === "NOMINAL" || s === "CURRENT" || s === "ON TIME") return "#63E2A6"
        if (s === "LIMITED" || s === "REVIEW" || s === "PENDING" || s === "CAUTION") return "#F5B44C"
        return "#FF6B57"
    }
    function sourceColor(v) {
        var s = String(v || "").toUpperCase()
        if (s === "NOMINAL") return Theme.radarGreen
        if (s === "LIMITED") return Theme.royalGold
        return Theme.warmOrange
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#080808" }
            GradientStop { position: 0.52; color: "#050505" }
            GradientStop { position: 1.0; color: "#000000" }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            radius: 8
            border.color: Theme.border
            border.width: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.panel2 }
                GradientStop { position: 1.0; color: Theme.panel }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 13
                spacing: 14

                Rectangle { width: 6; Layout.fillHeight: true; radius: 3; color: Theme.royalGold }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3
                    Text {
                        text: cockpit.rtl ? "مركز عمليات وإدارة القوة الجوية" : "AIR FORCE OPERATIONS & MANAGEMENT CENTER"
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.titlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "الصورة الجوية المشتركة • القواعد والمطارات • جاهزية الأسراب • الأطقم • الصيانة • التدريب" : "COMMON AIR PICTURE • BASES & AIRFIELDS • SQUADRON READINESS • CREWS • SUSTAINMENT • TRAINING"
                        color: Theme.royalGold
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.smallPx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "وعي موقفي وإدارة وتدريب — لا تحكم حي بالطائرات ولا وظائف اشتباك" : "SITUATIONAL AWARENESS / MANAGEMENT / TRAINING — NO LIVE AIRCRAFT CONTROL OR ENGAGEMENT"
                        color: Theme.silver
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.smallPx
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                RowLayout {
                    spacing: 7
                    Repeater {
                        model: [
                            {k: cockpit.rtl ? "جاهزية القوة" : "FORCE", v: cockpit.forceFleetReadinessPercent + "%", c: page.readinessColor(cockpit.forceFleetReadinessPercent)},
                            {k: cockpit.rtl ? "جاهزية الأطقم" : "CREW", v: cockpit.forceCrewReadinessPercent + "%", c: page.readinessColor(cockpit.forceCrewReadinessPercent)},
                            {k: cockpit.rtl ? "القواعد" : "BASES", v: cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length, c: "#63E2A6"},
                            {k: cockpit.rtl ? "الصيانة" : "MAINT", v: String(cockpit.forceOpenMaintenanceCount), c: cockpit.forceOpenMaintenanceCount > 0 ? "#F5B44C" : "#63E2A6"}
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            width: 116
                            height: 58
                            radius: 7
                            color: Theme.panel2
                            border.color: Theme.border
                            border.width: 1
                            Column {
                                anchors.centerIn: parent
                                spacing: 2
                                Text {
                                    text: modelData.k
                                    color: Theme.silver
                                    font.family: Theme.uiFont(cockpit.rtl)
                                    font.pixelSize: Theme.smallPx
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Text {
                                    text: modelData.v
                                    color: modelData.c
                                    font.family: Theme.mono
                                    font.pixelSize: 17
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 500
            spacing: 8

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 860
                spacing: 8

                StrategicAirMap {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    publicTracks: cockpit.publicFlightTracks
                    aegisTracks: cockpit.airOperationsTracks
                    bases: cockpit.forceBases
                    rtl: cockpit.rtl
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 128
                    radius: 8
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "القواعد والمطارات" : "BASES & AIRFIELDS"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.sectionPx
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: cockpit.forceWeatherConstraintCount + (cockpit.rtl ? " قيود طقس" : " WEATHER CONSTRAINTS")
                                color: cockpit.forceWeatherConstraintCount > 0 ? "#F5B44C" : "#63E2A6"
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 7
                            Repeater {
                                model: cockpit.forceBases
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    radius: 7
                                    color: Theme.panel2
                                    border.color: Theme.border
                                    border.width: 1

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 9

                                        Rectangle {
                                            width: 42; height: 42; radius: 21
                                            color: Number(modelData.supportPercent) >= 90 ? "#1A1A1A" : "#1A1A1A"
                                            border.color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"
                                            border.width: 2
                                            Text { anchors.centerIn: parent; text: "✦"; color: parent.border.color; font.pixelSize: 16; font.bold: true }
                                        }

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 2
                                            Text {
                                                text: modelData.name
                                                color: Theme.platinum
                                                font.family: Theme.uiFont(cockpit.rtl)
                                                font.pixelSize: Theme.smallPx
                                                font.bold: true
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }
                                            Text {
                                                text: modelData.runway + "  •  " + modelData.weather
                                                color: Theme.silver
                                                font.family: Theme.uiFont(cockpit.rtl)
                                                font.pixelSize: Theme.smallPx
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }
                                            Rectangle {
                                                Layout.fillWidth: true; height: 7; radius: 3; color: Theme.panel3
                                                Rectangle { width: parent.width * Number(modelData.supportPercent) / 100; height: parent.height; radius: 3; color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C" }
                                            }
                                        }

                                        Text {
                                            text: modelData.supportPercent + "%"
                                            color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"
                                            font.family: Theme.mono
                                            font.pixelSize: 14
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: Math.min(520, Math.max(450, page.width * 0.31))
                Layout.minimumWidth: 440
                Layout.fillHeight: true
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 168
                    radius: 8
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 7

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "جاهزية القوة" : "FORCE READINESS"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.sectionPx
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Rectangle { width: 10; height: 10; radius: 5; color: cockpit.forceFleetReadinessPercent >= 85 ? "#63E2A6" : "#F5B44C" }
                            Text {
                                text: cockpit.forceFleetReadinessPercent >= 85 ? (cockpit.rtl ? "اسمي" : "NOMINAL") : (cockpit.rtl ? "مراجعة" : "REVIEW")
                                color: cockpit.forceFleetReadinessPercent >= 85 ? "#63E2A6" : "#F5B44C"
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.panel3 }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 4
                            rowSpacing: 8
                            columnSpacing: 10

                            Text { text: cockpit.rtl ? "المنصات الجاهزة" : "READY"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                            Text { text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount; color: page.readinessColor(cockpit.forceFleetReadinessPercent); font.family: Theme.mono; font.pixelSize: 13; font.bold: true }
                            Text { text: cockpit.rtl ? "الحوادث" : "INCIDENTS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                            Text { text: String(cockpit.airOperationsIncidentCount); color: cockpit.airOperationsIncidentCount > 0 ? "#FF8A67" : "#63E2A6"; font.family: Theme.mono; font.pixelSize: 13; font.bold: true }
                            Text { text: cockpit.rtl ? "المسارات" : "TRACKS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                            Text { text: String(cockpit.airOperationsTrackCount + cockpit.publicFlightTrackCount); color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: 13; font.bold: true }
                            Text { text: cockpit.rtl ? "قيود الطقس" : "WEATHER"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                            Text { text: String(cockpit.forceWeatherConstraintCount); color: cockpit.forceWeatherConstraintCount > 0 ? "#F5B44C" : "#63E2A6"; font.family: Theme.mono; font.pixelSize: 13; font.bold: true }
                        }

                        Rectangle {
                            Layout.fillWidth: true; height: 8; radius: 4; color: Theme.panel3
                            Rectangle { width: parent.width * cockpit.forceFleetReadinessPercent / 100; height: parent.height; radius: 4; color: page.readinessColor(cockpit.forceFleetReadinessPercent) }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 8
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 7

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "جاهزية الأسراب" : "SQUADRON READINESS"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.sectionPx
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount
                                color: page.readinessColor(cockpit.forceFleetReadinessPercent)
                                font.family: Theme.mono
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.panel3 }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 7
                            model: cockpit.forceSquadrons
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 82
                                radius: 7
                                color: index % 2 ? "#151515" : "#111111"
                                border.color: Theme.border
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 9
                                    spacing: 10

                                    Rectangle {
                                        width: 50; height: 50; radius: 7
                                        color: Theme.shell
                                        border.color: Theme.border
                                        border.width: 1
                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.platform.indexOf("UAV") >= 0 ? "UAV" : (modelData.platform.indexOf("Hel") >= 0 ? "HEL" : "JET")
                                            color: page.stateColor(modelData.state)
                                            font.family: Theme.mono
                                            font.pixelSize: Theme.smallPx
                                            font.bold: true
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 4
                                        RowLayout {
                                            Layout.fillWidth: true
                                            Text {
                                                text: modelData.name
                                                color: Theme.platinum
                                                font.family: Theme.uiFont(cockpit.rtl)
                                                font.pixelSize: Theme.smallPx
                                                font.bold: true
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }
                                            Text {
                                                text: modelData.ready + "/" + modelData.assigned
                                                color: page.stateColor(modelData.state)
                                                font.family: Theme.mono
                                                font.pixelSize: Theme.smallPx
                                                font.bold: true
                                            }
                                        }
                                        Text {
                                            text: modelData.platform + "  •  CREW " + modelData.crewReady + "/" + modelData.crewRequired
                                            color: Theme.silver
                                            font.family: Theme.uiFont(cockpit.rtl)
                                            font.pixelSize: Theme.smallPx
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                        Rectangle {
                                            Layout.fillWidth: true; height: 8; radius: 4; color: Theme.panel3
                                            Rectangle { width: parent.width * Number(modelData.ready) / Math.max(1, Number(modelData.assigned)); height: parent.height; radius: 4; color: page.stateColor(modelData.state) }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 210
                    radius: 8
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "الصيانة والتدريب" : "SUSTAINMENT & TRAINING"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.sectionPx
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text { text: cockpit.forceOpenMaintenanceCount + " MNT"; color: Theme.amber; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.panel3 }

                        ListView {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 78
                            clip: true
                            spacing: 2
                            model: cockpit.forceMaintenancePlanRows
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width
                                height: 25
                                spacing: 7
                                Text { text: modelData.priority; color: modelData.priority === "P2" ? "#FF8A67" : "#F5B44C"; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.preferredWidth: 30 }
                                Text { text: modelData.platform + " / " + modelData.item; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.due; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 2
                            model: cockpit.forceTrainingRows
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width
                                height: 25
                                spacing: 7
                                Text { text: modelData.time; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.preferredWidth: 50 }
                                Text { text: modelData.group; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.preferredWidth: 98; elide: Text.ElideRight }
                                Text { text: modelData.item; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 104
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 9
                spacing: 8
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                ColumnLayout {
                    Layout.preferredWidth: 225
                    spacing: 2
                    Text { text: cockpit.rtl ? "التنبيهات والحوادث" : "ALERTS & INCIDENTS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                    Text { text: cockpit.rtl ? "ملخص تنفيذي — التفاصيل في مساحة الحوادث" : "EXECUTIVE SUMMARY — DETAILS IN INCIDENT WORKSPACE"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                }

                Repeater {
                    model: [
                        {label: cockpit.rtl ? "الحوادث" : "INCIDENTS", value: cockpit.airOperationsIncidentCount, note: cockpit.rtl ? "سجل الأدلة متاح" : "EVIDENCE LOG READY", color: cockpit.airOperationsIncidentCount ? Theme.warmOrange : Theme.radarGreen},
                        {label: cockpit.rtl ? "الصيانة المفتوحة" : "OPEN MAINTENANCE", value: cockpit.forceOpenMaintenanceCount, note: cockpit.rtl ? "حسب الأولوية والمنصة" : "BY PRIORITY / PLATFORM", color: cockpit.forceOpenMaintenanceCount ? Theme.amber : Theme.radarGreen},
                        {label: cockpit.rtl ? "جاهزية التدريب" : "TRAINING READY", value: cockpit.forceCrewReadinessPercent + "%", note: cockpit.rtl ? "الأطقم والجداول" : "CREWS / SCHEDULE", color: page.readinessColor(cockpit.forceCrewReadinessPercent)},
                        {label: cockpit.rtl ? "مصادر البيانات" : "DATA SOURCES", value: cockpit.dataSourceRows.length, note: cockpit.publicFlightFeedStatus, color: Theme.signalCyan}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: modelData.color
                        border.width: 1
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8
                            Rectangle { width: 9; height: 9; radius: 5; color: modelData.color }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1
                                Text { text: modelData.label; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: String(modelData.value); color: modelData.color; font.family: Theme.mono; font.pixelSize: 18; font.bold: true }
                                Text { text: modelData.note; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            visible: false
            Layout.fillWidth: true
            Layout.preferredHeight: 0
            Layout.minimumHeight: 0
            Layout.maximumHeight: 0
            spacing: 8

            AircraftCommandCard {
                Layout.preferredWidth: page.width * 0.31
                Layout.fillHeight: true
                rtl: cockpit.rtl
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 8
                color: Theme.panel
                border.color: Theme.border
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 7

                    Text {
                        text: cockpit.rtl ? "تكامل البيانات والمصادر" : "DATA & INTEGRATION"
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.sectionPx
                        font.bold: true
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.panel3 }

                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 4
                        columnSpacing: 8
                        rowSpacing: 8

                        Repeater {
                            model: cockpit.dataSourceRows
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 7
                                color: Theme.panel2
                                border.color: Theme.border
                                border.width: 1
                                Column {
                                    anchors.centerIn: parent
                                    spacing: 4
                                    Text { text: modelData.name; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter; width: Math.max(80, parent.parent.width - 12); horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                                    Text { text: modelData.freshness; color: page.sourceColor(modelData.health); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: page.width * 0.25
                Layout.fillHeight: true
                radius: 8
                color: Theme.panel
                border.color: Theme.border
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 7

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: cockpit.rtl ? "مراجعة الحوادث" : "INCIDENT REVIEW"
                            color: Theme.platinum
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: Theme.sectionPx
                            font.bold: true
                            Layout.fillWidth: true
                        }
                        Text { text: String(cockpit.airOperationsIncidentCount); color: cockpit.airOperationsIncidentCount > 0 ? "#FF8A67" : "#63E2A6"; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.panel3 }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 6
                        model: cockpit.airOperationsIncidents
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: 72
                            radius: 7
                            color: Theme.panel2
                            border.color: Theme.border
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 3
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: modelData.trackId || modelData.incidentId || "INCIDENT"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: String(modelData.peakThreatLevel || "REVIEW").toUpperCase(); color: Theme.warmOrange; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                }
                                Text { text: modelData.summary || modelData.status || "Review record"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 34
                        radius: 5
                        color: Theme.panel2
                        border.color: Theme.borderSoft
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: cockpit.rtl ? "وعي وتوثيق فقط — لا توجد وظائف اشتباك" : "AWARENESS / DOCUMENTATION ONLY — NO ENGAGEMENT FUNCTIONS"
                            color: Theme.silver
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: Theme.smallPx
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
