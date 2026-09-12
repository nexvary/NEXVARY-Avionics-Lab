import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirOperationsLocale.js" as AirOpsLocale

Item {
    id: page
    clip: true

    function threatColor(level) {
        if (level === "Critical") return Theme.red
        if (level === "High") return Theme.amber
        if (level === "Medium") return Theme.gold
        if (level === "Low") return Theme.accent
        return Theme.green
    }

    function shortMode() {
        return cockpit.airOperationsMode === "simulation-replay" ? "SIMULATION / REPLAY" : "AWARENESS ONLY"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 82
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: AirOpsLocale.label(cockpit.language)
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        Layout.fillWidth: true
                    }
                    Text {
                        text: cockpit.rtl
                              ? "طبقة تكامل للرصد والوعي بالمجال الجوي تربط بيانات Aegis مع بيئة NEXVARY الهندسية"
                              : "AIRSPACE AWARENESS INTEGRATION — AEGIS C-UAS REPLAY + NEXVARY ENGINEERING CONTEXT"
                        color: Theme.accent
                        font.pixelSize: 9
                        font.bold: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 280
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: Theme.gold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 1
                        Text { text: cockpit.airOperationsSource; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: page.shortMode(); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        Text { text: cockpit.airOperationsStatus; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            columns: 4
            columnSpacing: 7
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "المسارات المرصودة" : "AIR TRACKS"; value: String(cockpit.airOperationsTrackCount); subtitle: "NORMALIZED AEGIS FEED"; iconText: "TRK"; accent: Theme.accent }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "الحوادث" : "INCIDENTS"; value: String(cockpit.airOperationsIncidentCount); subtitle: "REPLAY / EVIDENCE CONTEXT"; iconText: "INC"; accent: Theme.gold }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "مرتفع فأعلى" : "HIGH OR ABOVE"; value: String(cockpit.airOperationsHighCount); subtitle: "OPERATOR ATTENTION"; iconText: "THR"; accent: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "المشاهدات" : "OBSERVATIONS"; value: String(cockpit.airOperationsObservationCount); subtitle: "SOURCE OBSERVATIONS"; iconText: "OBS"; accent: Theme.accent }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7

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
                    anchors.margins: 9
                    spacing: 5

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "الصورة الجوية الموحدة" : "UNIFIED AIR PICTURE"; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                        Text { text: "AEGIS → NORMALIZED EXCHANGE → AVIONICS LAB"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 260
                        color: Theme.panel2
                        border.color: Theme.borderSoft
                        border.width: 1
                        radius: Theme.radius

                        Canvas {
                            id: scope
                            anchors.fill: parent
                            anchors.margins: 10
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                var cx = width / 2
                                var cy = height / 2
                                var radius = Math.min(width, height) * 0.42
                                ctx.strokeStyle = Theme.borderSoft
                                ctx.lineWidth = 1
                                for (var ring = 1; ring <= 4; ++ring) {
                                    ctx.beginPath()
                                    ctx.arc(cx, cy, radius * ring / 4, 0, Math.PI * 2)
                                    ctx.stroke()
                                }
                                ctx.beginPath(); ctx.moveTo(cx-radius,cy); ctx.lineTo(cx+radius,cy); ctx.stroke()
                                ctx.beginPath(); ctx.moveTo(cx,cy-radius); ctx.lineTo(cx,cy+radius); ctx.stroke()
                            }
                        }

                        Repeater {
                            model: cockpit.airOperationsTracks
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: 16
                                height: 16
                                radius: 8
                                color: page.threatColor(modelData.threatLevel)
                                border.color: Theme.platinum
                                border.width: 1
                                x: parent.width * (0.24 + ((index * 0.23) % 0.58)) - width / 2
                                y: parent.height * (0.28 + ((index * 0.19) % 0.48)) - height / 2
                                ToolTip.visible: dotArea.containsMouse
                                ToolTip.text: modelData.trackId + " • " + modelData.classification + " • " + modelData.threatLevel
                                MouseArea { id: dotArea; anchors.fill: parent; hoverEnabled: true }
                            }
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 8
                            text: cockpit.rtl ? "نطاق تدريب/إعادة تشغيل — ليس شاشة اشتباك" : "TRAINING / REPLAY SCOPE — NOT AN ENGAGEMENT DISPLAY"
                            color: Theme.muted
                            font.family: "Consolas"
                            font.pixelSize: 7
                        }
                    }

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
                            height: 48
                            color: index % 2 ? Theme.panel2 : Theme.panel
                            border.color: Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 8
                                Rectangle { width: 4; height: 28; color: page.threatColor(modelData.threatLevel) }
                                ColumnLayout {
                                    Layout.preferredWidth: 150
                                    spacing: 0
                                    Text { text: modelData.trackId; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                    Text { text: modelData.classification; color: Theme.silver; font.pixelSize: 7 }
                                }
                                Text { text: Number(modelData.altitudeMeters).toFixed(0) + " m"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8; Layout.preferredWidth: 82 }
                                Text { text: Number(modelData.speedMetersPerSecond).toFixed(1) + " m/s"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8; Layout.preferredWidth: 86 }
                                Text { text: "CONF " + Math.round(Number(modelData.confidence) * 100) + "%"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; Layout.preferredWidth: 78 }
                                Text { text: modelData.insideProtectedZone ? (modelData.zoneName || "ZONE") : "CLEAR"; color: modelData.insideProtectedZone ? Theme.amber : Theme.muted; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                Rectangle {
                                    Layout.preferredWidth: 92
                                    Layout.preferredHeight: 25
                                    color: Theme.panel3
                                    border.color: page.threatColor(modelData.threatLevel)
                                    border.width: 1
                                    radius: Theme.radius
                                    Text { anchors.centerIn: parent; text: modelData.threatLevel + " / " + modelData.threatScore; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 390
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 6

                    Text { text: cockpit.rtl ? "الحوادث والسياق" : "INCIDENT & CONTEXT"; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    ListView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 165
                        model: cockpit.airOperationsIncidents
                        clip: true
                        spacing: 4
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: 78
                            color: Theme.panel2
                            border.color: page.threatColor(modelData.peakThreatLevel)
                            border.width: 1
                            radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 2
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: modelData.incidentId; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true }
                                    Text { text: modelData.peakThreatLevel + " / " + modelData.peakScore; color: page.threatColor(modelData.peakThreatLevel); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                }
                                Text { text: modelData.trackId + " • " + modelData.status; color: Theme.accent; font.pixelSize: 7 }
                                Text { text: modelData.summary; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true; wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                    Text { text: cockpit.rtl ? "معمارية التكامل" : "INTEGRATION ARCHITECTURE"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }

                    Repeater {
                        model: [
                            {"code":"01", "title":"AEGIS C-UAS COMMAND", "detail": cockpit.rtl ? "كشف، تتبع، دمج حساسات، حوادث وأدلة" : "Detection, tracking, sensor fusion, incidents and evidence"},
                            {"code":"02", "title":"AIR OPS EXCHANGE v1", "detail": cockpit.rtl ? "مخطط JSON موحد للوعي فقط مع رفض حقول التحكم النشط" : "Normalized JSON awareness schema with active-control rejection"},
                            {"code":"03", "title":"NEXVARY AVIONICS LAB", "detail": cockpit.rtl ? "التوأم الرقمي، القياسات، التشخيص والتحقق" : "Digital twin, telemetry, diagnostics and verification"},
                            {"code":"04", "title":"FUTURE MODULE SLOT", "detail": cockpit.rtl ? "جاهز لربط مشروع ثالث عبر نفس العقد" : "Ready for a third project through the same contract"}
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 66
                            color: Theme.panel2
                            border.color: Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 8
                                Rectangle {
                                    width: 34; height: 34; radius: 17; color: Theme.panel3; border.color: Theme.accent; border.width: 1
                                    Text { anchors.centerIn: parent; text: modelData.code; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: modelData.title; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.detail; color: Theme.silver; font.pixelSize: 7; wrapMode: Text.WordWrap; Layout.fillWidth: true; maximumLineCount: 2; elide: Text.ElideRight }
                                }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 58
                        color: Theme.panel3
                        border.color: Theme.green
                        border.width: 1
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            spacing: 1
                            Text { text: cockpit.rtl ? "حدود الأمان" : "SAFETY BOUNDARY"; color: Theme.green; font.pixelSize: 8; font.bold: true }
                            Text { text: cockpit.rtl ? "وعي موقفي، تدريب، إعادة تشغيل وتحليل فقط — لا أوامر اشتباك أو تشويش أو استحواذ أو تحكم حي." : "Awareness, training, replay and analysis only — no engagement, jamming, takeover or live-control commands."; color: Theme.silver; font.pixelSize: 7; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                        }
                    }
                }
            }
        }
    }
}
