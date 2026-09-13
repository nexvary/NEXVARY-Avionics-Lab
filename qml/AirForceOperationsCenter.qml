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
        color: "#071017"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0A1620" }
            GradientStop { position: 0.55; color: "#071119" }
            GradientStop { position: 1.0; color: "#050C12" }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 9
        spacing: 7

        // Hero command header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 76
            radius: 7
            border.color: "#315367"
            border.width: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#162631" }
                GradientStop { position: 1.0; color: "#0E1921" }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 11
                spacing: 12

                Rectangle { width: 5; Layout.fillHeight: true; radius: 3; color: "#56B8D8" }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: cockpit.rtl ? "مركز عمليات وإدارة القوة الجوية" : "AIR FORCE OPERATIONS & MANAGEMENT CENTER"
                        color: "#F3F6F7"
                        font.pixelSize: 22
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "صورة جوية مشتركة • جاهزية • قواعد • أسراب • صيانة • تدريب • تدقيق" : "COMMON AIR PICTURE • FORCE READINESS • BASES • SQUADRONS • SUSTAINMENT • TRAINING • AUDIT"
                        color: "#67C9E7"
                        font.pixelSize: 8
                        font.bold: true
                        font.letterSpacing: 0.6
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "وعي موقفي وإدارة وتدريب — دون تحكم حي بالطائرات أو وظائف اشتباك" : "SITUATIONAL AWARENESS / MANAGEMENT / TRAINING — NO LIVE AIRCRAFT CONTROL OR ENGAGEMENT"
                        color: "#7F919A"
                        font.family: "Consolas"
                        font.pixelSize: 6
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                RowLayout {
                    spacing: 6
                    Repeater {
                        model: [
                            {k: cockpit.rtl ? "القوة" : "FORCE", v: cockpit.forceFleetReadinessPercent + "%", c: page.readinessColor(cockpit.forceFleetReadinessPercent)},
                            {k: cockpit.rtl ? "الأطقم" : "CREW", v: cockpit.forceCrewReadinessPercent + "%", c: page.readinessColor(cockpit.forceCrewReadinessPercent)},
                            {k: cockpit.rtl ? "القواعد" : "BASES", v: cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length, c: "#63E2A6"},
                            {k: cockpit.rtl ? "الصيانة" : "MNT", v: String(cockpit.forceOpenMaintenanceCount), c: cockpit.forceOpenMaintenanceCount > 0 ? "#F5B44C" : "#63E2A6"}
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            width: 94; height: 48; radius: 6
                            color: "#111E27"
                            border.color: modelData.c
                            border.width: 1
                            Column {
                                anchors.centerIn: parent
                                spacing: 1
                                Text { text: modelData.k; color: "#85969E"; font.pixelSize: 6; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                                Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 13; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                            }
                        }
                    }
                }
            }
        }

        // Primary operational surface
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 480
            spacing: 7

            // Map + airfield band
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 850
                spacing: 7

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
                    Layout.preferredHeight: 112
                    radius: 7
                    color: "#0F1A22"
                    border.color: "#2A4858"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "القواعد والمطارات" : "BASES & AIRFIELDS"; color: "#F1F4F5"; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.forceWeatherConstraintCount + (cockpit.rtl ? " قيود طقس" : " WEATHER CONSTRAINTS"); color: cockpit.forceWeatherConstraintCount > 0 ? "#F5B44C" : "#63E2A6"; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 6
                            Repeater {
                                model: cockpit.forceBases
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    radius: 6
                                    color: "#13232B"
                                    border.color: Number(modelData.supportPercent) >= 90 ? "#3A9B76" : "#9A7738"
                                    border.width: 1
                                    RowLayout {
                                        anchors.fill: parent; anchors.margins: 7; spacing: 7
                                        Rectangle {
                                            width: 34; height: 34; radius: 17
                                            color: Number(modelData.supportPercent) >= 90 ? "#153B2D" : "#3A2C18"
                                            border.color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"
                                            border.width: 2
                                            Text { anchors.centerIn: parent; text: "✦"; color: parent.border.color; font.pixelSize: 13; font.bold: true }
                                        }
                                        ColumnLayout {
                                            Layout.fillWidth: true; spacing: 1
                                            Text { text: modelData.name; color: "#EAF0F2"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                            Text { text: modelData.runway + "  •  " + modelData.weather; color: "#8FA0A7"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                            Rectangle {
                                                Layout.fillWidth: true; height: 5; radius: 3; color: "#26343B"
                                                Rectangle { width: parent.width * Number(modelData.supportPercent) / 100; height: parent.height; radius: 3; color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C" }
                                            }
                                        }
                                        Text { text: modelData.supportPercent + "%"; color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Command rail
            ColumnLayout {
                Layout.preferredWidth: Math.min(470, Math.max(390, page.width * 0.29))
                Layout.minimumWidth: 380
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 134
                    radius: 7
                    color: "#0F1B23"
                    border.color: "#355261"
                    border.width: 1
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 8; spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "موقف القوة" : "FORCE POSTURE"; color: "#F3F5F6"; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Rectangle { width: 8; height: 8; radius: 4; color: cockpit.forceFleetReadinessPercent >= 85 ? "#63E2A6" : "#F5B44C" }
                            Text { text: cockpit.forceFleetReadinessPercent >= 85 ? "NOMINAL" : "REVIEW"; color: cockpit.forceFleetReadinessPercent >= 85 ? "#63E2A6" : "#F5B44C"; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: "#273A44" }
                        GridLayout {
                            Layout.fillWidth: true; columns: 4; rowSpacing: 4; columnSpacing: 8
                            Text { text: cockpit.rtl ? "جاهز" : "READY"; color: "#7F919A"; font.pixelSize: 6 }
                            Text { text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount; color: page.readinessColor(cockpit.forceFleetReadinessPercent); font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: cockpit.rtl ? "الحوادث" : "INCIDENTS"; color: "#7F919A"; font.pixelSize: 6 }
                            Text { text: String(cockpit.airOperationsIncidentCount); color: cockpit.airOperationsIncidentCount > 0 ? "#FF8A67" : "#63E2A6"; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: cockpit.rtl ? "المسارات" : "TRACKS"; color: "#7F919A"; font.pixelSize: 6 }
                            Text { text: String(cockpit.airOperationsTrackCount + cockpit.publicFlightTrackCount); color: "#56B8D8"; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: cockpit.rtl ? "الطقس" : "WX"; color: "#7F919A"; font.pixelSize: 6 }
                            Text { text: String(cockpit.forceWeatherConstraintCount); color: cockpit.forceWeatherConstraintCount > 0 ? "#F5B44C" : "#63E2A6"; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                        }
                        Item { Layout.fillHeight: true }
                        Rectangle {
                            Layout.fillWidth: true; height: 6; radius: 3; color: "#24323A"
                            Rectangle { width: parent.width * cockpit.forceFleetReadinessPercent / 100; height: parent.height; radius: 3; color: page.readinessColor(cockpit.forceFleetReadinessPercent) }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 7
                    color: "#0F1B23"
                    border.color: "#7C6334"
                    border.width: 1
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 8; spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "جاهزية الأسراب" : "SQUADRON READINESS"; color: "#F3F5F6"; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount; color: page.readinessColor(cockpit.forceFleetReadinessPercent); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: "#2A3941" }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 5
                            model: cockpit.forceSquadrons
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 68
                                radius: 6
                                color: index % 2 ? "#12212A" : "#101D25"
                                border.color: page.stateColor(modelData.state)
                                border.width: 1
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 7; spacing: 8
                                    Rectangle {
                                        width: 42; height: 42; radius: 5
                                        color: "#0B151C"; border.color: "#314954"; border.width: 1
                                        Text { anchors.centerIn: parent; text: modelData.platform.indexOf("UAV") >= 0 ? "UAV" : (modelData.platform.indexOf("Hel") >= 0 ? "HEL" : "JET"); color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true; spacing: 2
                                        RowLayout {
                                            Layout.fillWidth: true
                                            Text { text: modelData.name; color: "#EAF0F2"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                            Text { text: modelData.ready + "/" + modelData.assigned; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                        }
                                        Text { text: modelData.platform + "  •  CREW " + modelData.crewReady + "/" + modelData.crewRequired; color: "#7F919A"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Rectangle {
                                            Layout.fillWidth: true; height: 6; radius: 3; color: "#26343B"
                                            Rectangle { width: parent.width * Number(modelData.ready) / Math.max(1, Number(modelData.assigned)); height: parent.height; radius: 3; color: page.stateColor(modelData.state) }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 176
                    radius: 7
                    color: "#0F1B23"
                    border.color: "#40515A"
                    border.width: 1
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 8; spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "الصيانة والتدريب" : "SUSTAINMENT & TRAINING"; color: "#F3F5F6"; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.forceOpenMaintenanceCount + " MNT"; color: "#F5B44C"; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: "#2A3941" }
                        ListView {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 62
                            clip: true
                            spacing: 1
                            model: cockpit.forceMaintenancePlanRows
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width; height: 20; spacing: 5
                                Text { text: modelData.priority; color: modelData.priority === "P2" ? "#FF8A67" : "#F5B44C"; font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.preferredWidth: 26 }
                                Text { text: modelData.platform + " / " + modelData.item; color: "#C8D0D3"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.due; color: "#708088"; font.family: "Consolas"; font.pixelSize: 6 }
                            }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: "#26363E" }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 1
                            model: cockpit.forceTrainingRows
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width; height: 20; spacing: 5
                                Text { text: modelData.time; color: "#56B8D8"; font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.preferredWidth: 40 }
                                Text { text: modelData.group; color: "#E8ECEE"; font.pixelSize: 6; font.bold: true; Layout.preferredWidth: 78; elide: Text.ElideRight }
                                Text { text: modelData.item; color: "#AAB6BB"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                            }
                        }
                    }
                }
            }
        }

        // Visual intelligence deck
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 190
            spacing: 7

            AircraftCommandCard {
                Layout.preferredWidth: page.width * 0.32
                Layout.fillHeight: true
                rtl: cockpit.rtl
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 7
                color: "#0F1A22"
                border.color: "#315A6C"
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 8; spacing: 5
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "تكامل البيانات والمصادر" : "DATA & INTEGRATION LAYER"; color: "#F0F4F5"; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                        Text { text: "COMMON DATA FOUNDATION"; color: "#56B8D8"; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: "#2B3B43" }
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 4
                        columnSpacing: 6
                        rowSpacing: 6
                        Repeater {
                            model: [
                                {n:"PUBLIC ADS-B",s:cockpit.publicFlightStatus,c:"#56B8D8"},
                                {n:"AEGIS C-UAS",s:cockpit.airOperationsMode,c:"#D2B36C"},
                                {n:"DIGITAL TWIN",s:cockpit.twinFaultCount > 0 ? "REVIEW" : "NOMINAL",c:cockpit.twinFaultCount > 0 ? "#FF8A67" : "#63E2A6"},
                                {n:"DIAGNOSTICS",s:cockpit.diagnosticHealthScore + "%",c:cockpit.diagnosticHealthScore >= 90 ? "#63E2A6" : "#F5B44C"},
                                {n:"AIRSPACE",s:"DATASET READY",c:"#9B83D5"},
                                {n:"BASE MGMT",s:cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length,c:"#63E2A6"},
                                {n:"SUSTAINMENT",s:cockpit.forceOpenMaintenanceCount + " OPEN",c:"#F5B44C"},
                                {n:"AUDIT",s:"ENABLED",c:"#7FA7C5"}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true; Layout.fillHeight: true
                                radius: 5; color: "#12222B"; border.color: modelData.c; border.width: 1
                                Column {
                                    anchors.centerIn: parent; spacing: 2
                                    Text { text: modelData.n; color: "#93A3AA"; font.pixelSize: 6; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: modelData.s; color: modelData.c; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: page.width * 0.26
                Layout.fillHeight: true
                radius: 7
                color: "#0F1A22"
                border.color: "#6E5430"
                border.width: 1
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 8; spacing: 5
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "مراجعة الحوادث" : "INCIDENT REVIEW"; color: "#F0F4F5"; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                        Text { text: String(cockpit.airOperationsIncidentCount); color: cockpit.airOperationsIncidentCount > 0 ? "#FF8A67" : "#63E2A6"; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: "#2B3B43" }
                    ListView {
                        Layout.fillWidth: true; Layout.fillHeight: true; clip: true; spacing: 4
                        model: cockpit.airOperationsIncidents
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width; height: 54; radius: 5
                            color: "#131F26"; border.color: "#8A5C40"; border.width: 1
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 6; spacing: 1
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: modelData.trackId || modelData.incidentId || "INCIDENT"; color: "#E9EEF0"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: String(modelData.peakThreatLevel || "REVIEW").toUpperCase(); color: "#FF8A67"; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                }
                                Text { text: modelData.summary || modelData.status || "Review record"; color: "#8FA0A7"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true; height: 24; radius: 4; color: "#111A20"; border.color: "#2E444F"; border.width: 1
                        Text { anchors.centerIn: parent; text: cockpit.rtl ? "وعي وتوثيق فقط — لا توجد وظائف اشتباك" : "AWARENESS / DOCUMENTATION ONLY — NO ENGAGEMENT FUNCTIONS"; color: "#74858D"; font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
                    }
                }
            }
        }
    }
}
