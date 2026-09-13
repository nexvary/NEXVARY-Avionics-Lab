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

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#081620" }
            GradientStop { position: 0.52; color: "#071119" }
            GradientStop { position: 1.0; color: "#050C12" }
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
            border.color: "#365B70"
            border.width: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#182B36" }
                GradientStop { position: 1.0; color: "#0F1A22" }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 13
                spacing: 14

                Rectangle { width: 6; Layout.fillHeight: true; radius: 3; color: "#56B8D8" }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3
                    Text {
                        text: cockpit.rtl ? "مركز عمليات وإدارة القوة الجوية" : "AIR FORCE OPERATIONS & MANAGEMENT CENTER"
                        color: "#F5F7F8"
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.titlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "الصورة الجوية المشتركة • القواعد والمطارات • جاهزية الأسراب • الأطقم • الصيانة • التدريب" : "COMMON AIR PICTURE • BASES & AIRFIELDS • SQUADRON READINESS • CREWS • SUSTAINMENT • TRAINING"
                        color: "#72CCE8"
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: 11
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "وعي موقفي وإدارة وتدريب — لا تحكم حي بالطائرات ولا وظائف اشتباك" : "SITUATIONAL AWARENESS / MANAGEMENT / TRAINING — NO LIVE AIRCRAFT CONTROL OR ENGAGEMENT"
                        color: "#93A3AA"
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: 9
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
                            color: "#12212A"
                            border.color: modelData.c
                            border.width: 1
                            Column {
                                anchors.centerIn: parent
                                spacing: 2
                                Text {
                                    text: modelData.k
                                    color: "#A0ADB3"
                                    font.family: Theme.uiFont(cockpit.rtl)
                                    font.pixelSize: 9
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
                    color: "#0F1A22"
                    border.color: "#315365"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "القواعد والمطارات" : "BASES & AIRFIELDS"
                                color: "#F2F5F6"
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: 13
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: cockpit.forceWeatherConstraintCount + (cockpit.rtl ? " قيود طقس" : " WEATHER CONSTRAINTS")
                                color: cockpit.forceWeatherConstraintCount > 0 ? "#F5B44C" : "#63E2A6"
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: 10
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
                                    color: "#14242D"
                                    border.color: Number(modelData.supportPercent) >= 90 ? "#3F9E7B" : "#9C7A3D"
                                    border.width: 1

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 9

                                        Rectangle {
                                            width: 42; height: 42; radius: 21
                                            color: Number(modelData.supportPercent) >= 90 ? "#153B2D" : "#3A2C18"
                                            border.color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"
                                            border.width: 2
                                            Text { anchors.centerIn: parent; text: "✦"; color: parent.border.color; font.pixelSize: 16; font.bold: true }
                                        }

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 2
                                            Text {
                                                text: modelData.name
                                                color: "#EFF3F4"
                                                font.family: Theme.uiFont(cockpit.rtl)
                                                font.pixelSize: 11
                                                font.bold: true
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }
                                            Text {
                                                text: modelData.runway + "  •  " + modelData.weather
                                                color: "#A2AFB5"
                                                font.family: Theme.uiFont(cockpit.rtl)
                                                font.pixelSize: 9
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }
                                            Rectangle {
                                                Layout.fillWidth: true; height: 7; radius: 3; color: "#283840"
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
                    color: "#0F1B23"
                    border.color: "#3A5D6C"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 7

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "الموقف العام للقوة" : "FORCE SITUATION"
                                color: "#F4F6F7"
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: 13
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Rectangle { width: 10; height: 10; radius: 5; color: cockpit.forceFleetReadinessPercent >= 85 ? "#63E2A6" : "#F5B44C" }
                            Text {
                                text: cockpit.forceFleetReadinessPercent >= 85 ? (cockpit.rtl ? "اسمي" : "NOMINAL") : (cockpit.rtl ? "مراجعة" : "REVIEW")
                                color: cockpit.forceFleetReadinessPercent >= 85 ? "#63E2A6" : "#F5B44C"
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#2E414A" }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 4
                            rowSpacing: 8
                            columnSpacing: 10

                            Text { text: cockpit.rtl ? "المنصات الجاهزة" : "READY"; color: "#91A0A7"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9 }
                            Text { text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount; color: page.readinessColor(cockpit.forceFleetReadinessPercent); font.family: Theme.mono; font.pixelSize: 13; font.bold: true }
                            Text { text: cockpit.rtl ? "الحوادث" : "INCIDENTS"; color: "#91A0A7"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9 }
                            Text { text: String(cockpit.airOperationsIncidentCount); color: cockpit.airOperationsIncidentCount > 0 ? "#FF8A67" : "#63E2A6"; font.family: Theme.mono; font.pixelSize: 13; font.bold: true }
                            Text { text: cockpit.rtl ? "المسارات" : "TRACKS"; color: "#91A0A7"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9 }
                            Text { text: String(cockpit.airOperationsTrackCount + cockpit.publicFlightTrackCount); color: "#56B8D8"; font.family: Theme.mono; font.pixelSize: 13; font.bold: true }
                            Text { text: cockpit.rtl ? "قيود الطقس" : "WEATHER"; color: "#91A0A7"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9 }
                            Text { text: String(cockpit.forceWeatherConstraintCount); color: cockpit.forceWeatherConstraintCount > 0 ? "#F5B44C" : "#63E2A6"; font.family: Theme.mono; font.pixelSize: 13; font.bold: true }
                        }

                        Rectangle {
                            Layout.fillWidth: true; height: 8; radius: 4; color: "#26353D"
                            Rectangle { width: parent.width * cockpit.forceFleetReadinessPercent / 100; height: parent.height; radius: 4; color: page.readinessColor(cockpit.forceFleetReadinessPercent) }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 8
                    color: "#0F1B23"
                    border.color: "#856A36"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 7

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "جاهزية الأسراب" : "SQUADRON READINESS"
                                color: "#F4F6F7"
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: 13
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount
                                color: page.readinessColor(cockpit.forceFleetReadinessPercent)
                                font.family: Theme.mono
                                font.pixelSize: 11
                                font.bold: true
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#31424A" }

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
                                color: index % 2 ? "#13232C" : "#101E27"
                                border.color: page.stateColor(modelData.state)
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 9
                                    spacing: 10

                                    Rectangle {
                                        width: 50; height: 50; radius: 7
                                        color: "#0B151C"
                                        border.color: "#38515D"
                                        border.width: 1
                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.platform.indexOf("UAV") >= 0 ? "UAV" : (modelData.platform.indexOf("Hel") >= 0 ? "HEL" : "JET")
                                            color: page.stateColor(modelData.state)
                                            font.family: Theme.mono
                                            font.pixelSize: 10
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
                                                color: "#EEF2F3"
                                                font.family: Theme.uiFont(cockpit.rtl)
                                                font.pixelSize: 11
                                                font.bold: true
                                                Layout.fillWidth: true
                                                elide: Text.ElideRight
                                            }
                                            Text {
                                                text: modelData.ready + "/" + modelData.assigned
                                                color: page.stateColor(modelData.state)
                                                font.family: Theme.mono
                                                font.pixelSize: 11
                                                font.bold: true
                                            }
                                        }
                                        Text {
                                            text: modelData.platform + "  •  CREW " + modelData.crewReady + "/" + modelData.crewRequired
                                            color: "#9BA9AF"
                                            font.family: Theme.uiFont(cockpit.rtl)
                                            font.pixelSize: 9
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                        Rectangle {
                                            Layout.fillWidth: true; height: 8; radius: 4; color: "#293840"
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
                    color: "#0F1B23"
                    border.color: "#465A64"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "الصيانة والتدريب" : "SUSTAINMENT & TRAINING"
                                color: "#F4F6F7"
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: 13
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text { text: cockpit.forceOpenMaintenanceCount + " MNT"; color: "#F5B44C"; font.family: Theme.mono; font.pixelSize: 10; font.bold: true }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#2F4149" }

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
                                Text { text: modelData.priority; color: modelData.priority === "P2" ? "#FF8A67" : "#F5B44C"; font.family: Theme.mono; font.pixelSize: 9; font.bold: true; Layout.preferredWidth: 30 }
                                Text { text: modelData.platform + " / " + modelData.item; color: "#D0D7DA"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.due; color: "#84939A"; font.family: Theme.mono; font.pixelSize: 9 }
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#2A3C45" }

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
                                Text { text: modelData.time; color: "#56B8D8"; font.family: Theme.mono; font.pixelSize: 9; font.bold: true; Layout.preferredWidth: 46 }
                                Text { text: modelData.group; color: "#EDF1F2"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9; font.bold: true; Layout.preferredWidth: 92; elide: Text.ElideRight }
                                Text { text: modelData.item; color: "#AAB6BB"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: Theme.mono; font.pixelSize: 9; font.bold: true }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 224
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
                color: "#0F1A22"
                border.color: "#315A6C"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 7

                    Text {
                        text: cockpit.rtl ? "تكامل البيانات والمصادر" : "DATA & INTEGRATION"
                        color: "#F2F5F6"
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: 13
                        font.bold: true
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: "#2E414A" }

                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 4
                        columnSpacing: 8
                        rowSpacing: 8

                        Repeater {
                            model: [
                                {n:"PUBLIC ADS-B",s:cockpit.publicFlightStatus,c:"#56B8D8"},
                                {n:"AEGIS C-UAS",s:cockpit.airOperationsMode,c:"#D2B36C"},
                                {n:"DIGITAL TWIN",s:cockpit.twinFaultCount > 0 ? "REVIEW" : "NOMINAL",c:cockpit.twinFaultCount > 0 ? "#FF8A67" : "#63E2A6"},
                                {n:"DIAGNOSTICS",s:cockpit.diagnosticHealthScore + "%",c:cockpit.diagnosticHealthScore >= 90 ? "#63E2A6" : "#F5B44C"},
                                {n:"AIRSPACE",s:"READY",c:"#9B83D5"},
                                {n:"BASE MGMT",s:cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length,c:"#63E2A6"},
                                {n:"SUSTAINMENT",s:cockpit.forceOpenMaintenanceCount + " OPEN",c:"#F5B44C"},
                                {n:"AUDIT",s:"ENABLED",c:"#7FA7C5"}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 7
                                color: "#14242D"
                                border.color: modelData.c
                                border.width: 1
                                Column {
                                    anchors.centerIn: parent
                                    spacing: 4
                                    Text { text: modelData.n; color: "#A6B2B7"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: modelData.s; color: modelData.c; font.family: Theme.mono; font.pixelSize: 11; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
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
                color: "#0F1A22"
                border.color: "#785A33"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 7

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: cockpit.rtl ? "مراجعة الحوادث" : "INCIDENT REVIEW"
                            color: "#F2F5F6"
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: 13
                            font.bold: true
                            Layout.fillWidth: true
                        }
                        Text { text: String(cockpit.airOperationsIncidentCount); color: cockpit.airOperationsIncidentCount > 0 ? "#FF8A67" : "#63E2A6"; font.family: Theme.mono; font.pixelSize: 11; font.bold: true }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#2E414A" }

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
                            color: "#142129"
                            border.color: "#936143"
                            border.width: 1

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 3
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: modelData.trackId || modelData.incidentId || "INCIDENT"; color: "#EEF2F3"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 10; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: String(modelData.peakThreatLevel || "REVIEW").toUpperCase(); color: "#FF8A67"; font.family: Theme.mono; font.pixelSize: 9; font.bold: true }
                                }
                                Text { text: modelData.summary || modelData.status || "Review record"; color: "#A0ADB3"; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 9; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 34
                        radius: 5
                        color: "#111A20"
                        border.color: "#2E444F"
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: cockpit.rtl ? "وعي وتوثيق فقط — لا توجد وظائف اشتباك" : "AWARENESS / DOCUMENTATION ONLY — NO ENGAGEMENT FUNCTIONS"
                            color: "#87969D"
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: 8
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
