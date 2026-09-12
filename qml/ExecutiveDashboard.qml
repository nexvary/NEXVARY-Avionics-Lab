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
            Layout.preferredHeight: 62
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 9
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
                              ? "صورة تنفيذية كثيفة للمجال الجوي والجاهزية والصيانة والصحة الهندسية — بدون مساحات مهدرة"
                              : "DENSE EXECUTIVE AIR PICTURE • AIRSPACE • READINESS • MAINTENANCE • ENGINEERING HEALTH"
                        color: Theme.accent
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 310
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
            Layout.preferredHeight: 72
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
                        spacing: 6
                        Rectangle { width: 3; Layout.fillHeight: true; color: modelData.c; radius: 1 }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: modelData.t; color: Theme.silver; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                            Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 16; font.bold: true }
                            Text { text: modelData.s; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                        Text { text: modelData.i; color: modelData.c; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            ColumnLayout {
                Layout.preferredWidth: Math.max(620, page.width * 0.60)
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(350, Math.min(445, page.height * 0.47))
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

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 6

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
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

                            Rectangle {
                                Layout.preferredWidth: 190
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 5
                                    Text { text: cockpit.rtl ? "سياق الصورة الجوية" : "AIR PICTURE CONTEXT"; color: Theme.platinum; font.pixelSize: 8; font.bold: true }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                    Repeater {
                                        model: [
                                            {"k": cockpit.rtl ? "المصدر" : "SOURCE", "v": cockpit.airOperationsSource, "c": Theme.accent},
                                            {"k": cockpit.rtl ? "المسارات" : "TRACKS", "v": String(cockpit.airOperationsTrackCount), "c": Theme.platinum},
                                            {"k": cockpit.rtl ? "مرتفع فأعلى" : "HIGH+", "v": String(cockpit.airOperationsHighCount), "c": cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green},
                                            {"k": cockpit.rtl ? "المشاهدات" : "OBSERVATIONS", "v": String(cockpit.airOperationsObservationCount), "c": Theme.gold},
                                            {"k": cockpit.rtl ? "النمط" : "MODE", "v": page.upper(cockpit.airOperationsMode), "c": Theme.green}
                                        ]
                                        delegate: Rectangle {
                                            required property var modelData
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            color: Theme.panel3
                                            border.color: Theme.borderSoft
                                            border.width: 1
                                            radius: Theme.radius
                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.margins: 5
                                                spacing: 5
                                                Text { text: modelData.k; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                                Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.maximumWidth: 105; elide: Text.ElideRight }
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
                            Text { text: cockpit.rtl ? "مصفوفة جاهزية المنصات" : "PLATFORM READINESS MATRIX"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.readinessReadyCount + " / " + cockpit.readinessAssets.length + " READY"; color: page.readinessColor(cockpit.readinessFleetPercent); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                        GridView {
                            id: readinessGrid
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: cockpit.readinessAssets
                            cellWidth: Math.max(260, width / 2)
                            cellHeight: Math.max(92, height / Math.max(1, Math.ceil(count / 2)))
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: readinessGrid.cellWidth - 4
                                height: readinessGrid.cellHeight - 4
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: modelData.active ? Theme.accent : page.stateColor(modelData.state)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 7
                                    Rectangle { width: 4; Layout.fillHeight: true; color: page.stateColor(modelData.state); radius: 1 }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        Text { text: modelData.tail + " / " + modelData.name; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.category; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        RowLayout {
                                            Layout.fillWidth: true
                                            Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.silver; font.pixelSize: 6 }
                                            Text { text: modelData.readiness + "%"; color: page.readinessColor(modelData.readiness); font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true }
                                            Text { text: (cockpit.rtl ? "طاقم " : "CREW ") + modelData.crewReady + "/" + modelData.crewRequired; color: modelData.crewReady === modelData.crewRequired ? Theme.green : Theme.amber; font.family: "Consolas"; font.pixelSize: 6 }
                                        }
                                        Rectangle {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 6
                                            color: Theme.panel
                                            radius: 3
                                            Rectangle { width: parent.width * Math.max(0, Math.min(100, modelData.readiness)) / 100; height: parent.height; radius: 3; color: page.readinessColor(modelData.readiness) }
                                        }
                                        RowLayout {
                                            Layout.fillWidth: true
                                            Text { text: modelData.trainingSlot; color: Theme.accent; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                            Text { text: modelData.state; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                        }
                                    }
                                }
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
                    Layout.preferredHeight: 168
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
                            Text { text: cockpit.rtl ? "المسارات المرصودة" : "TRACK SUMMARY"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.airOperationsTrackCount); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            id: trackList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 3
                            model: cockpit.airOperationsTracks
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: Math.max(44, Math.min(52, (trackList.height - Math.max(0, trackList.count - 1) * trackList.spacing) / Math.max(1, trackList.count)))
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: page.threatColor(modelData.threatLevel)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 6
                                    Rectangle { width: 4; Layout.fillHeight: true; color: page.threatColor(modelData.threatLevel) }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.trackId + " / " + modelData.classification; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: Math.round(modelData.altitudeMeters) + " m  •  " + Math.round(modelData.speedMetersPerSecond) + " m/s  •  " + page.upper(modelData.threatLevel); color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                                    }
                                    Text { text: modelData.insideProtectedZone ? (cockpit.rtl ? "منطقة محمية" : "PROTECTED") : (cockpit.rtl ? "واضح" : "CLEAR"); color: modelData.insideProtectedZone ? Theme.amber : Theme.green; font.pixelSize: 6; font.bold: true }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 98
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        Text { text: cockpit.rtl ? "الصحة الهندسية" : "ENGINEERING HEALTH"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 4
                            columnSpacing: 4
                            Repeater {
                                model: [
                                    {"k": cockpit.rtl ? "توأم اسمي" : "TWIN", "v": String(cockpit.twinNominalCount), "c": Theme.green},
                                    {"k": cockpit.rtl ? "متدهور" : "DEGRADED", "v": String(cockpit.twinDegradedCount), "c": cockpit.twinDegradedCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "تشخيص" : "DX", "v": String(cockpit.diagnosticFindingCount), "c": cockpit.diagnosticFindingCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "تنبيه" : "ALERTS", "v": String(cockpit.activeAlertCount), "c": cockpit.activeAlertCount > 0 ? Theme.amber : Theme.green}
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
                                        anchors.margins: 5
                                        spacing: 0
                                        Text { text: modelData.k; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 14; font.bold: true }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 124
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "الحوادث والمراجعة" : "INCIDENT REVIEW"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.airOperationsIncidentCount); color: Theme.amber; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        ListView {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 55
                            clip: true
                            spacing: 3
                            model: cockpit.airOperationsIncidents
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 52
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: page.threatColor(modelData.peakThreatLevel)
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 0
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: modelData.incidentId + " / " + modelData.trackId; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: page.upper(modelData.status); color: Theme.silver; font.pixelSize: 6 }
                                    }
                                    Text { text: modelData.summary; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 4
                            Repeater {
                                model: [
                                    {"k": cockpit.rtl ? "مرتفع+" : "HIGH+", "v": String(cockpit.airOperationsHighCount), "c": cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "مشاهدات" : "OBS", "v": String(cockpit.airOperationsObservationCount), "c": Theme.accent},
                                    {"k": cockpit.rtl ? "المصدر" : "SOURCE", "v": "AEGIS", "c": Theme.platinum}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: Theme.panel2
                                    border.color: Theme.borderSoft
                                    border.width: 1
                                    radius: Theme.radius
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 4
                                        Text { text: modelData.k; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 218
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "متابعة الصيانة" : "MAINTENANCE FOLLOW-UP"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.readinessMaintenanceOpenCount); color: Theme.gold; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            id: maintenanceList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 3
                            model: cockpit.readinessMaintenanceRows
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: Math.max(36, Math.min(52, (maintenanceList.height - Math.max(0, maintenanceList.count - 1) * maintenanceList.spacing) / Math.max(1, maintenanceList.count)))
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: modelData.priority === "P2" ? Theme.amber : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 0
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
                        anchors.margins: 7
                        spacing: 3
                        Text { text: cockpit.rtl ? "السجل الزمني الأخير" : "RECENT LAB TIMELINE"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
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
                                height: 29
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    spacing: 5
                                    Text { text: modelData.time; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.preferredWidth: 52 }
                                    Rectangle { width: 3; height: 15; color: modelData.severity === "FAULT" ? Theme.red : (modelData.severity === "WARN" ? Theme.amber : Theme.accent) }
                                    Text { text: modelData.source; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 6; Layout.preferredWidth: 50 }
                                    Text { text: modelData.message; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
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
