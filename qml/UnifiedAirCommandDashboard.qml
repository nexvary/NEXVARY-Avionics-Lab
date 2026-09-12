import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "UnifiedCommandLocale.js" as UnifiedLocale

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
        if (cockpit.airOperationsHighCount > 0 || cockpit.twinFaultCount > 0) return cockpit.rtl ? "يتطلب مراجعة" : "REVIEW REQUIRED"
        if (cockpit.readinessFleetPercent < 85 || cockpit.activeAlertCount > 0) return cockpit.rtl ? "جاهزية محدودة" : "LIMITED READINESS"
        return cockpit.rtl ? "مستقر للتدريب" : "TRAINING NOMINAL"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 9
        spacing: 6

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 76
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 11
                spacing: 10

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: UnifiedLocale.label(cockpit.language)
                        color: Theme.platinum
                        font.pixelSize: 21
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl
                              ? "صورة تنفيذية موحدة للمجال الجوي والجاهزية والصيانة وصحة الأنظمة — بيانات تدريبية قابلة للمراجعة"
                              : "UNIFIED EXECUTIVE AIR PICTURE • AIRSPACE • READINESS • MAINTENANCE • SYSTEM HEALTH"
                        color: Theme.accent
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 330
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green
                    border.width: 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 9
                        Rectangle {
                            width: 38; height: 38; radius: 19
                            color: "transparent"
                            border.color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green
                            border.width: 2
                            Text { anchors.centerIn: parent; text: cockpit.airOperationsHighCount > 0 ? "!" : "✓"; color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green; font.pixelSize: 18; font.bold: true }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: cockpit.rtl ? "الحالة التنفيذية الموحدة" : "UNIFIED EXECUTIVE STATE"; color: Theme.silver; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: page.overallState(); color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: cockpit.rtl ? "OFFLINE • SYNTHETIC • REPLAY" : "OFFLINE • SYNTHETIC • REPLAY"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                        }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            columns: 6
            columnSpacing: 6
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "المسارات الجوية" : "AIR TRACKS"; value: String(cockpit.airOperationsTrackCount); subtitle: cockpit.rtl ? "صورة الوعي الحالية" : "CURRENT AWARENESS PICTURE"; iconText: "AIR"; accent: Theme.accent }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "الحوادث" : "INCIDENTS"; value: String(cockpit.airOperationsIncidentCount); subtitle: cockpit.rtl ? "سياق قابل للمراجعة" : "REVIEWABLE CONTEXT"; iconText: "INC"; accent: cockpit.airOperationsIncidentCount > 0 ? Theme.amber : Theme.green }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "جاهزية الأسطول" : "FLEET READINESS"; value: cockpit.readinessFleetPercent + "%"; subtitle: cockpit.readinessReadyCount + " / " + cockpit.readinessAssets.length + (cockpit.rtl ? " جاهزة" : " READY"); iconText: "RDY"; accent: page.readinessColor(cockpit.readinessFleetPercent) }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "الصيانة" : "MAINTENANCE"; value: String(cockpit.readinessMaintenanceOpenCount); subtitle: cockpit.rtl ? "بنود متابعة هندسية" : "ENGINEERING FOLLOW-UP"; iconText: "MNT"; accent: Theme.gold }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "صحة التشخيص" : "DIAGNOSTIC HEALTH"; value: cockpit.diagnosticHealthScore + "%"; subtitle: cockpit.diagnosticFindingCount + (cockpit.rtl ? " نتائج" : " FINDINGS"); iconText: "DX"; accent: cockpit.diagnosticHealthScore >= 90 ? Theme.green : Theme.amber }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "التوأم الرقمي" : "DIGITAL TWIN"; value: String(cockpit.twinNominalCount); subtitle: cockpit.twinFaultCount + (cockpit.rtl ? " أعطال" : " FAULTS"); iconText: "DT"; accent: cockpit.twinFaultCount > 0 ? Theme.amber : Theme.green }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6

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
                            Text { text: cockpit.rtl ? "الصورة الجوية الموحدة" : "UNIFIED AIR PICTURE"; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.airOperationsSource + "  •  " + cockpit.airOperationsMode; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7; elide: Text.ElideRight }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 6

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumWidth: 470
                                color: Theme.panel2
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius

                                Canvas {
                                    id: scope
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.reset()
                                        var cx = width / 2
                                        var cy = height / 2
                                        var r = Math.min(width, height) * 0.43
                                        ctx.strokeStyle = Theme.borderSoft
                                        ctx.lineWidth = 1
                                        for (var i = 1; i <= 4; ++i) {
                                            ctx.beginPath(); ctx.arc(cx, cy, r * i / 4, 0, Math.PI * 2); ctx.stroke()
                                        }
                                        ctx.beginPath(); ctx.moveTo(cx-r,cy); ctx.lineTo(cx+r,cy); ctx.stroke()
                                        ctx.beginPath(); ctx.moveTo(cx,cy-r); ctx.lineTo(cx,cy+r); ctx.stroke()
                                        ctx.strokeStyle = Theme.accent
                                        ctx.globalAlpha = 0.45
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
                                        width: 116; height: 42
                                        x: Math.max(8, Math.min(parent.width - width - 8, parent.width * (0.18 + ((index * 0.31) % 0.68)) - width/2))
                                        y: Math.max(8, Math.min(parent.height - height - 8, parent.height * (0.20 + ((index * 0.27) % 0.64)) - height/2))
                                        Rectangle {
                                            x: 0; y: 12; width: 14; height: 14; radius: 7
                                            color: page.threatColor(modelData.threatLevel)
                                            border.color: Theme.platinum; border.width: 1
                                        }
                                        Rectangle {
                                            x: 18; y: 0; width: 96; height: 38
                                            color: Theme.panel3
                                            border.color: page.threatColor(modelData.threatLevel)
                                            border.width: 1
                                            radius: Theme.radius
                                            Column {
                                                anchors.fill: parent; anchors.margins: 4; spacing: 0
                                                Text { text: modelData.trackId + "  " + page.upper(modelData.threatLevel); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                                Text { text: Math.round(modelData.altitudeMeters) + "m  •  " + Math.round(modelData.speedMetersPerSecond) + "m/s"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                                                Text { text: modelData.classification; color: Theme.muted; font.pixelSize: 6; elide: Text.ElideRight; width: parent.width }
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 8
                                    width: 250; height: 25
                                    color: Theme.panel3
                                    border.color: Theme.green
                                    border.width: 1
                                    radius: Theme.radius
                                    Text { anchors.centerIn: parent; text: cockpit.rtl ? "وعي موقفي تدريبي — لا تحكم حي" : "TRAINING AWARENESS • NO LIVE CONTROL"; color: Theme.green; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 360
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 4
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: cockpit.rtl ? "المسارات المرصودة" : "TRACK TABLE"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                                        Text { text: String(cockpit.airOperationsTrackCount); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                    }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
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
                                            height: 58
                                            color: index % 2 ? Theme.panel3 : Theme.panel
                                            border.color: page.threatColor(modelData.threatLevel)
                                            border.width: 1
                                            radius: Theme.radius
                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.margins: 6
                                                spacing: 6
                                                Rectangle { width: 4; height: 36; color: page.threatColor(modelData.threatLevel) }
                                                ColumnLayout {
                                                    Layout.fillWidth: true
                                                    spacing: 0
                                                    Text { text: modelData.trackId + "  /  " + modelData.classification; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                                    Text { text: Math.round(modelData.altitudeMeters) + " m   •   " + Math.round(modelData.speedMetersPerSecond) + " m/s"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                                                    Text { text: modelData.insideProtectedZone ? (cockpit.rtl ? "داخل منطقة محمية" : "PROTECTED ZONE CONTEXT") : (cockpit.rtl ? "خارج المناطق المحمية" : "CLEAR OF PROTECTED ZONES"); color: modelData.insideProtectedZone ? Theme.amber : Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                                }
                                                Text { text: page.upper(modelData.threatLevel); color: page.threatColor(modelData.threatLevel); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 215
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
                            orientation: ListView.Horizontal
                            clip: true
                            spacing: 5
                            model: cockpit.readinessAssets
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: 220
                                height: ListView.view.height
                                color: Theme.panel2
                                border.color: modelData.active ? Theme.accent : page.stateColor(modelData.state)
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 3
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Rectangle { width: 4; height: 30; color: page.stateColor(modelData.state) }
                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 0
                                            Text { text: modelData.tail; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                            Text { text: modelData.name; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                        }
                                        Text { text: modelData.state; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true }
                                        Text { text: modelData.readiness + "%"; color: page.readinessColor(modelData.readiness); font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                    }
                                    Rectangle {
                                        Layout.fillWidth: true; Layout.preferredHeight: 7
                                        color: Theme.panel3; radius: 3
                                        Rectangle { width: parent.width * modelData.readiness / 100; height: parent.height; radius: 3; color: page.readinessColor(modelData.readiness) }
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: cockpit.rtl ? "الطاقم" : "CREW"; color: Theme.muted; font.pixelSize: 6 }
                                        Text { text: modelData.crewReady + "/" + modelData.crewRequired; color: modelData.crewReady === modelData.crewRequired ? Theme.green : Theme.amber; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                        Item { Layout.fillWidth: true }
                                        Text { text: cockpit.rtl ? "الفحص" : "INSPECT"; color: Theme.muted; font.pixelSize: 6 }
                                        Text { text: modelData.hoursToInspection + "h"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                    }
                                    Text { text: modelData.trainingSlot; color: Theme.accent; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 410
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 178
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: cockpit.rtl ? "الصحة الهندسية" : "ENGINEERING HEALTH"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 2
                            columnSpacing: 5
                            rowSpacing: 5
                            Repeater {
                                model: [
                                    {"k": cockpit.rtl ? "التوأم الاسمي" : "TWIN NOMINAL", "v": cockpit.twinNominalCount, "c": Theme.green},
                                    {"k": cockpit.rtl ? "المتدهور" : "DEGRADED", "v": cockpit.twinDegradedCount, "c": cockpit.twinDegradedCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "نتائج التشخيص" : "DX FINDINGS", "v": cockpit.diagnosticFindingCount, "c": cockpit.diagnosticFindingCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "التنبيهات" : "ACTIVE ALERTS", "v": cockpit.activeAlertCount, "c": cockpit.activeAlertCount > 0 ? Theme.amber : Theme.green}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: Theme.panel2
                                    border.color: modelData.c
                                    border.width: 1
                                    radius: Theme.radius
                                    RowLayout {
                                        anchors.fill: parent; anchors.margins: 7
                                        Rectangle { width: 4; Layout.fillHeight: true; color: modelData.c }
                                        ColumnLayout {
                                            Layout.fillWidth: true; spacing: 0
                                            Text { text: modelData.k; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                            Text { text: String(modelData.v); color: modelData.c; font.family: "Consolas"; font.pixelSize: 15; font.bold: true }
                                        }
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
                                height: 64
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: page.threatColor(modelData.peakThreatLevel)
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 6; spacing: 1
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
                    Layout.preferredHeight: 230
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
                                height: 54
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: modelData.priority === "P2" ? Theme.amber : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 6; spacing: 1
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
            Layout.preferredHeight: 38
            color: Theme.panel2
            border.color: Theme.green
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 7
                spacing: 7
                Text { text: "AEGIS C-UAS"; color: Theme.accent; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 9 }
                Text { text: "AIR OPS EXCHANGE"; color: Theme.platinum; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 9 }
                Text { text: "AVIONICS LAB"; color: Theme.platinum; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 9 }
                Text { text: "READINESS OPS"; color: Theme.gold; font.pixelSize: 6; font.bold: true }
                Item { Layout.fillWidth: true }
                Text { text: cockpit.rtl ? "تدريب • محاكاة • تحليل • لا توجيه أسلحة أو تحكم حي" : "TRAINING • SIMULATION • ANALYSIS • NO WEAPONS / NO LIVE CONTROL"; color: Theme.green; font.pixelSize: 6; font.bold: true; elide: Text.ElideRight }
            }
        }
    }
}
