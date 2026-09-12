import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function upper(value) { return String(value || "").toUpperCase() }
    function threatColor(level) {
        var t = upper(level)
        if (t === "CRITICAL" || t === "HIGH") return Theme.red
        if (t === "MEDIUM") return Theme.amber
        if (t === "LOW") return Theme.gold
        return Theme.accent
    }
    function stateColor(state) {
        var s = upper(state)
        if (s === "READY" || s === "NOMINAL") return Theme.green
        if (s === "LIMITED" || s === "DEGRADED") return Theme.amber
        if (s === "FAULT" || s === "CRITICAL") return Theme.red
        return Theme.accent
    }
    function readinessColor(value) {
        if (value >= 90) return Theme.green
        if (value >= 80) return Theme.gold
        return Theme.amber
    }
    function overallState() {
        if (cockpit.airOperationsHighCount > 0 || cockpit.twinFaultCount > 0)
            return cockpit.rtl ? "يتطلب مراجعة" : "REVIEW REQUIRED"
        if (cockpit.readinessFleetPercent < 85 || cockpit.activeAlertCount > 0)
            return cockpit.rtl ? "جاهزية محدودة" : "LIMITED READINESS"
        return cockpit.rtl ? "مستقر للتدريب" : "TRAINING NOMINAL"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 66
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: cockpit.rtl ? "مركز القيادة الجوية الموحد" : "UNIFIED AIR COMMAND CENTER"
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl
                              ? "صورة تنفيذية موحدة للوعي الجوي والجاهزية والصيانة وصحة الأنظمة"
                              : "AIRSPACE AWARENESS • FLEET READINESS • MAINTENANCE • ENGINEERING HEALTH"
                        color: Theme.accent
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 320
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green
                    border.width: 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8
                        Rectangle {
                            width: 34
                            height: 34
                            radius: 17
                            color: Theme.panel3
                            border.color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green
                            border.width: 2
                            Text {
                                anchors.centerIn: parent
                                text: cockpit.airOperationsHighCount > 0 ? "!" : "✓"
                                color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green
                                font.pixelSize: 16
                                font.bold: true
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: cockpit.rtl ? "الحالة التنفيذية" : "EXECUTIVE STATE"; color: Theme.silver; font.pixelSize: 7; font.bold: true }
                            Text { text: page.overallState(); color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: "OFFLINE • SYNTHETIC • REPLAY"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                        }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 76
            columns: 6
            columnSpacing: 6

            Repeater {
                model: [
                    {"t": cockpit.rtl ? "المسارات الجوية" : "AIR TRACKS", "v": String(cockpit.airOperationsTrackCount), "s": cockpit.rtl ? "صورة الوعي الحالية" : "CURRENT AWARENESS", "c": Theme.accent, "i":"AIR"},
                    {"t": cockpit.rtl ? "الحوادث" : "INCIDENTS", "v": String(cockpit.airOperationsIncidentCount), "s": cockpit.rtl ? "للمراجعة والتحليل" : "REVIEW CONTEXT", "c": cockpit.airOperationsIncidentCount > 0 ? Theme.amber : Theme.green, "i":"INC"},
                    {"t": cockpit.rtl ? "جاهزية الأسطول" : "FLEET READINESS", "v": cockpit.readinessFleetPercent + "%", "s": cockpit.readinessReadyCount + " / " + cockpit.readinessAssets.length + (cockpit.rtl ? " جاهزة" : " READY"), "c": page.readinessColor(cockpit.readinessFleetPercent), "i":"RDY"},
                    {"t": cockpit.rtl ? "الصيانة" : "MAINTENANCE", "v": String(cockpit.readinessMaintenanceOpenCount), "s": cockpit.rtl ? "بنود متابعة" : "FOLLOW-UP ITEMS", "c": Theme.gold, "i":"MNT"},
                    {"t": cockpit.rtl ? "صحة التشخيص" : "DIAGNOSTIC HEALTH", "v": cockpit.diagnosticHealthScore + "%", "s": cockpit.diagnosticFindingCount + (cockpit.rtl ? " نتائج" : " FINDINGS"), "c": cockpit.diagnosticHealthScore >= 90 ? Theme.green : Theme.amber, "i":"DX"},
                    {"t": cockpit.rtl ? "التوأم الرقمي" : "DIGITAL TWIN", "v": String(cockpit.twinNominalCount), "s": cockpit.twinFaultCount + (cockpit.rtl ? " أعطال" : " FAULTS"), "c": cockpit.twinFaultCount > 0 ? Theme.amber : Theme.green, "i":"DT"}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: modelData.c
                    border.width: 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 7
                        Rectangle { width: 3; Layout.fillHeight: true; color: modelData.c; radius: 1 }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: modelData.t; color: Theme.silver; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                            Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 17; font.bold: true }
                            Text { text: modelData.s; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                        Text { text: modelData.i; color: modelData.c; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            Rectangle {
                Layout.preferredWidth: 650
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "الصورة الجوية الموحدة" : "UNIFIED AIR PICTURE"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text { text: cockpit.airOperationsSource + " • " + cockpit.airOperationsMode; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 6; elide: Text.ElideRight }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 360
                        color: Theme.panel2
                        border.color: Theme.borderSoft
                        border.width: 1
                        radius: Theme.radius

                        Canvas {
                            anchors.fill: parent
                            anchors.margins: 12
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                var cx = width / 2
                                var cy = height / 2
                                var r = Math.min(width, height) * 0.43
                                ctx.strokeStyle = Theme.borderSoft
                                ctx.lineWidth = 1
                                for (var ring = 1; ring <= 5; ++ring) {
                                    ctx.beginPath(); ctx.arc(cx, cy, r * ring / 5, 0, Math.PI * 2); ctx.stroke()
                                }
                                ctx.strokeStyle = Theme.accent
                                ctx.globalAlpha = 0.35
                                for (var a = 0; a < 360; a += 30) {
                                    var rad = a * Math.PI / 180
                                    ctx.beginPath(); ctx.moveTo(cx,cy); ctx.lineTo(cx + Math.cos(rad)*r, cy + Math.sin(rad)*r); ctx.stroke()
                                }
                                ctx.globalAlpha = 1.0
                            }
                        }

                        Repeater {
                            model: cockpit.airOperationsTracks
                            delegate: Item {
                                required property int index
                                required property var modelData
                                width: 120
                                height: 42
                                x: Math.max(8, Math.min(parent.width - width - 8, parent.width * (0.18 + ((index * 0.31) % 0.68)) - width / 2))
                                y: Math.max(8, Math.min(parent.height - height - 8, parent.height * (0.18 + ((index * 0.27) % 0.66)) - height / 2))
                                Rectangle { x: 0; y: 13; width: 14; height: 14; radius: 7; color: page.threatColor(modelData.threatLevel); border.color: Theme.platinum; border.width: 1 }
                                Rectangle {
                                    x: 18; y: 0; width: 100; height: 40
                                    color: Theme.panel3
                                    border.color: page.threatColor(modelData.threatLevel)
                                    border.width: 1
                                    radius: Theme.radius
                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 4
                                        spacing: 0
                                        Text { text: modelData.trackId + "  " + page.upper(modelData.threatLevel); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                        Text { text: Math.round(modelData.altitudeMeters) + "m • " + Math.round(modelData.speedMetersPerSecond) + "m/s"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                                        Text { text: modelData.classification; color: Theme.muted; font.pixelSize: 6; width: parent.width; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 8
                            width: 250
                            height: 24
                            color: Theme.panel3
                            border.color: Theme.green
                            border.width: 1
                            radius: Theme.radius
                            Text { anchors.centerIn: parent; text: cockpit.rtl ? "وعي موقفي تدريبي — لا تحكم حي" : "TRAINING AWARENESS • NO LIVE CONTROL"; color: Theme.green; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                        }
                    }

                    Text { text: cockpit.rtl ? "المسارات المرصودة" : "TRACK SUMMARY"; color: Theme.platinum; font.pixelSize: 8; font.bold: true }
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 3
                        model: cockpit.airOperationsTracks
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            width: ListView.view.width
                            height: 50
                            color: index % 2 ? Theme.panel2 : Theme.panel3
                            border.color: page.threatColor(modelData.threatLevel)
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 6
                                Rectangle { width: 4; height: 30; color: page.threatColor(modelData.threatLevel) }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Text { text: modelData.trackId + " / " + modelData.classification; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: Math.round(modelData.altitudeMeters) + " m  •  " + Math.round(modelData.speedMetersPerSecond) + " m/s  •  " + page.upper(modelData.threatLevel); color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                                }
                                Text { text: modelData.insideProtectedZone ? (cockpit.rtl ? "منطقة محمية" : "PROTECTED ZONE") : (cockpit.rtl ? "مسار واضح" : "CLEAR"); color: modelData.insideProtectedZone ? Theme.amber : Theme.green; font.pixelSize: 6; font.bold: true }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 305
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "مصفوفة جاهزية المنصات" : "PLATFORM READINESS MATRIX"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.readinessReadyCount + " / " + cockpit.readinessAssets.length + " READY"; color: page.readinessColor(cockpit.readinessFleetPercent); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 3
                            model: cockpit.readinessAssets
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 58
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: modelData.active ? Theme.accent : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 7
                                    Rectangle { width: 4; height: 34; color: page.stateColor(modelData.state) }
                                    ColumnLayout {
                                        Layout.preferredWidth: 170
                                        spacing: 0
                                        Text { text: modelData.tail + " / " + modelData.name; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.category; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        RowLayout {
                                            Layout.fillWidth: true
                                            Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true }
                                            Text { text: modelData.readiness + "%"; color: page.readinessColor(modelData.readiness); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                        }
                                        Rectangle {
                                            Layout.fillWidth: true
                                            height: 6
                                            color: Theme.panel
                                            radius: 3
                                            Rectangle { width: parent.width * Math.max(0, Math.min(100, modelData.readiness)) / 100; height: parent.height; radius: 3; color: page.readinessColor(modelData.readiness) }
                                        }
                                    }
                                    ColumnLayout {
                                        Layout.preferredWidth: 72
                                        spacing: 0
                                        Text { text: cockpit.rtl ? "الطاقم" : "CREW"; color: Theme.muted; font.pixelSize: 6 }
                                        Text { text: modelData.crewReady + "/" + modelData.crewRequired; color: modelData.crewReady === modelData.crewRequired ? Theme.green : Theme.amber; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                    }
                                    Rectangle {
                                        Layout.preferredWidth: 70
                                        Layout.preferredHeight: 23
                                        color: Theme.panel
                                        border.color: page.stateColor(modelData.state)
                                        border.width: 1
                                        radius: Theme.radius
                                        Text { anchors.centerIn: parent; text: modelData.state; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                    }
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
                    border.width: Theme.frameWidth
                    radius: Theme.radius

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: cockpit.rtl ? "الصحة الهندسية والتنفيذية" : "ENGINEERING & EXECUTIVE HEALTH"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 115
                            columns: 4
                            columnSpacing: 5
                            rowSpacing: 5
                            Repeater {
                                model: [
                                    {"k": cockpit.rtl ? "عقد التوأم" : "TWIN NOMINAL", "v": String(cockpit.twinNominalCount), "c": Theme.green},
                                    {"k": cockpit.rtl ? "عقد متدهورة" : "TWIN DEGRADED", "v": String(cockpit.twinDegradedCount), "c": cockpit.twinDegradedCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "نتائج التشخيص" : "DX FINDINGS", "v": String(cockpit.diagnosticFindingCount), "c": cockpit.diagnosticFindingCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "تنبيهات نشطة" : "ACTIVE ALERTS", "v": String(cockpit.activeAlertCount), "c": cockpit.activeAlertCount > 0 ? Theme.amber : Theme.green}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: Theme.panel2
                                    border.color: modelData.c
                                    border.width: 1
                                    radius: Theme.radius
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        spacing: 1
                                        Text { text: modelData.k; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 15; font.bold: true }
                                    }
                                }
                            }
                        }
                        Text { text: cockpit.rtl ? "آخر أحداث المختبر" : "RECENT LAB EVENTS"; color: Theme.silver; font.pixelSize: 7; font.bold: true }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 2
                            model: cockpit.eventRows
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 30
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    spacing: 5
                                    Text { text: modelData.time; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.preferredWidth: 58 }
                                    Rectangle { width: 3; height: 16; color: modelData.severity === "FAULT" ? Theme.red : (modelData.severity === "WARN" ? Theme.amber : Theme.accent) }
                                    Text { text: modelData.source; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 6; Layout.preferredWidth: 54 }
                                    Text { text: modelData.message; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 360
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 240
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "الحوادث والمراجعة" : "INCIDENT REVIEW"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.airOperationsIncidentCount); color: Theme.amber; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 4
                            model: cockpit.airOperationsIncidents
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 66
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: page.threatColor(modelData.peakThreatLevel)
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 1
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: modelData.incidentId + " / " + modelData.trackId; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: page.upper(modelData.status); color: Theme.silver; font.pixelSize: 6 }
                                    }
                                    Text { text: modelData.summary; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight }
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
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "متابعة الصيانة" : "MAINTENANCE FOLLOW-UP"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.readinessMaintenanceOpenCount); color: Theme.gold; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 3
                            model: cockpit.readinessMaintenanceRows
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 58
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: modelData.priority === "P2" ? Theme.amber : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 1
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: modelData.priority + " / " + modelData.platform + " / " + modelData.system; color: modelData.priority === "P2" ? Theme.amber : Theme.accent; font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.due; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 6 }
                                    }
                                    Text { text: modelData.action; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 34
            color: Theme.panel2
            border.color: Theme.green
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 7
                Text { text: "AEGIS C-UAS"; color: Theme.accent; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 8 }
                Text { text: "AIR OPS EXCHANGE"; color: Theme.platinum; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 8 }
                Text { text: "AVIONICS LAB"; color: Theme.platinum; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 8 }
                Text { text: "READINESS OPS"; color: Theme.gold; font.pixelSize: 6; font.bold: true }
                Item { Layout.fillWidth: true }
                Text { text: cockpit.rtl ? "تدريب • محاكاة • تحليل • لا توجيه أسلحة أو تحكم حي" : "TRAINING • SIMULATION • ANALYSIS • NO WEAPONS / NO LIVE CONTROL"; color: Theme.green; font.pixelSize: 6; font.bold: true; elide: Text.ElideRight }
            }
        }
    }
}
