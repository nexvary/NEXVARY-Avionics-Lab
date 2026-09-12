import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "UnifiedCommandLocale.js" as UnifiedLocale

Item {
    id: page
    clip: true

    function stateColor(state) {
        if (state === "READY" || state === "NOMINAL") return Theme.green
        if (state === "LIMITED" || state === "MEDIUM") return Theme.amber
        if (state === "HIGH" || state === "CRITICAL" || state === "FAULT") return Theme.red
        return Theme.accent
    }

    function readinessColor(value) {
        if (value >= 90) return Theme.green
        if (value >= 80) return Theme.gold
        return Theme.amber
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 88
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
                        text: UnifiedLocale.label(cockpit.language)
                        color: Theme.platinum
                        font.pixelSize: 22
                        font.bold: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Text {
                        text: UnifiedLocale.subtitle(cockpit.language)
                        color: Theme.accent
                        font.pixelSize: 9
                        font.bold: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
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
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 2
                        Text { text: cockpit.rtl ? "الصورة التنفيذية الموحدة" : "UNIFIED EXECUTIVE PICTURE"; color: Theme.silver; font.pixelSize: 8; font.bold: true }
                        Text { text: cockpit.airOperationsHighCount > 0 ? (cockpit.rtl ? "تحتاج مراجعة" : "REVIEW REQUIRED") : (cockpit.rtl ? "مستقرة للتدريب" : "TRAINING NOMINAL"); color: cockpit.airOperationsHighCount > 0 ? Theme.amber : Theme.green; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                        Text { text: cockpit.rtl ? "مصادر صناعية / Replay / لا تحكم حي" : "SYNTHETIC / REPLAY / NO LIVE CONTROL"; color: Theme.muted; font.pixelSize: 7 }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            columns: 6
            columnSpacing: 7
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: UnifiedLocale.airspace(cockpit.language); value: String(cockpit.airOperationsTrackCount); subtitle: cockpit.rtl ? "مسارات رصد حالية" : "CURRENT AWARENESS TRACKS"; iconText: "AIR"; accent: Theme.accent }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "الحوادث" : "INCIDENTS"; value: String(cockpit.airOperationsIncidentCount); subtitle: cockpit.rtl ? "سجل سياقي للمراجعة" : "REVIEWABLE CONTEXT"; iconText: "INC"; accent: cockpit.airOperationsIncidentCount > 0 ? Theme.amber : Theme.green }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: UnifiedLocale.readiness(cockpit.language); value: cockpit.readinessFleetPercent + "%"; subtitle: cockpit.rtl ? "متوسط الجاهزية" : "SYNTHETIC FLEET AVERAGE"; iconText: "RDY"; accent: readinessColor(cockpit.readinessFleetPercent) }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "الصيانة" : "MAINTENANCE"; value: String(cockpit.readinessMaintenanceOpenCount); subtitle: cockpit.rtl ? "بنود متابعة مفتوحة" : "OPEN FOLLOW-UP ITEMS"; iconText: "MNT"; accent: Theme.gold }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "صحة التشخيص" : "DIAGNOSTIC HEALTH"; value: cockpit.diagnosticHealthScore + "%"; subtitle: cockpit.rtl ? "مؤشر هندسي" : "ENGINEERING INDEX"; iconText: "DX"; accent: cockpit.diagnosticHealthScore >= 90 ? Theme.green : Theme.amber }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "التوأم الرقمي" : "DIGITAL TWIN"; value: String(cockpit.twinNominalCount); subtitle: cockpit.rtl ? "عقد سليمة / حالة اسمية" : "NOMINAL NODES"; iconText: "DT"; accent: cockpit.twinFaultCount > 0 ? Theme.amber : Theme.green }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
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
                            Text { text: UnifiedLocale.airspace(cockpit.language); color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.airOperationsSource + "  /  " + cockpit.airOperationsMode; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7; elide: Text.ElideRight }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 4
                            model: cockpit.airOperationsTracks
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 52
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: modelData.threatLevel === "HIGH" || modelData.threatLevel === "CRITICAL" ? Theme.amber : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 8
                                    Rectangle { width: 4; height: 32; color: stateColor(modelData.threatLevel) }
                                    ColumnLayout {
                                        Layout.preferredWidth: 150
                                        spacing: 0
                                        Text { text: modelData.trackId; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.classification; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    ColumnLayout {
                                        Layout.preferredWidth: 110
                                        spacing: 0
                                        Text { text: cockpit.rtl ? "الارتفاع" : "ALTITUDE"; color: Theme.muted; font.pixelSize: 6 }
                                        Text { text: Math.round(modelData.altitudeMeters) + " m"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                    }
                                    ColumnLayout {
                                        Layout.preferredWidth: 110
                                        spacing: 0
                                        Text { text: cockpit.rtl ? "السرعة" : "SPEED"; color: Theme.muted; font.pixelSize: 6 }
                                        Text { text: Math.round(modelData.speedMetersPerSecond) + " m/s"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: cockpit.rtl ? "مصادر الرصد" : "SENSOR SOURCES"; color: Theme.muted; font.pixelSize: 6 }
                                        Text { text: modelData.sensors && modelData.sensors.length ? modelData.sensors.join(" • ") : "—"; color: Theme.accent; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    Rectangle {
                                        Layout.preferredWidth: 72
                                        Layout.preferredHeight: 24
                                        color: Theme.panel
                                        border.color: stateColor(modelData.threatLevel)
                                        border.width: 1
                                        radius: Theme.radius
                                        Text { anchors.centerIn: parent; text: modelData.threatLevel; color: stateColor(modelData.threatLevel); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
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
                        anchors.margins: 9
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: UnifiedLocale.readiness(cockpit.language); color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.readinessReadyCount + " / " + cockpit.readinessAssets.length + " READY"; color: readinessColor(cockpit.readinessFleetPercent); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 4
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
                                    anchors.margins: 7
                                    spacing: 8
                                    Rectangle { width: 4; height: 36; color: stateColor(modelData.state) }
                                    ColumnLayout {
                                        Layout.preferredWidth: 200
                                        spacing: 0
                                        Text { text: modelData.tail + "  /  " + modelData.name; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.category; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    ColumnLayout {
                                        Layout.preferredWidth: 190
                                        spacing: 2
                                        RowLayout {
                                            Layout.fillWidth: true
                                            Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true }
                                            Text { text: modelData.readiness + "%"; color: readinessColor(modelData.readiness); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                        }
                                        Rectangle {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 6
                                            color: Theme.panel
                                            radius: 3
                                            Rectangle { width: parent.width * modelData.readiness / 100; height: parent.height; radius: 3; color: readinessColor(modelData.readiness) }
                                        }
                                    }
                                    ColumnLayout {
                                        Layout.preferredWidth: 100
                                        spacing: 0
                                        Text { text: cockpit.rtl ? "الطاقم" : "CREW"; color: Theme.muted; font.pixelSize: 6 }
                                        Text { text: modelData.crewReady + "/" + modelData.crewRequired; color: modelData.crewReady === modelData.crewRequired ? Theme.green : Theme.amber; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: cockpit.rtl ? "نافذة التدريب" : "TRAINING WINDOW"; color: Theme.muted; font.pixelSize: 6 }
                                        Text { text: modelData.trainingSlot; color: Theme.accent; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    Rectangle {
                                        Layout.preferredWidth: 70
                                        Layout.preferredHeight: 24
                                        color: Theme.panel
                                        border.color: stateColor(modelData.state)
                                        border.width: 1
                                        radius: Theme.radius
                                        Text { anchors.centerIn: parent; text: modelData.state; color: stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 430
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 205
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: UnifiedLocale.engineering(cockpit.language); color: Theme.platinum; font.pixelSize: 11; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 2
                            columnSpacing: 6
                            rowSpacing: 6
                            Repeater {
                                model: [
                                    {"k": cockpit.rtl ? "عقد التوأم الاسمية" : "TWIN NOMINAL", "v": String(cockpit.twinNominalCount), "c": Theme.green},
                                    {"k": cockpit.rtl ? "عقد متدهورة" : "TWIN DEGRADED", "v": String(cockpit.twinDegradedCount), "c": cockpit.twinDegradedCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "نتائج التشخيص" : "DIAGNOSTIC FINDINGS", "v": String(cockpit.diagnosticFindingCount), "c": cockpit.diagnosticFindingCount > 0 ? Theme.amber : Theme.green},
                                    {"k": cockpit.rtl ? "التنبيهات النشطة" : "ACTIVE ALERTS", "v": String(cockpit.activeAlertCount), "c": cockpit.activeAlertCount > 0 ? Theme.amber : Theme.green}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: Theme.panel2
                                    border.color: Theme.borderSoft
                                    border.width: 1
                                    radius: Theme.radius
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 7
                                        spacing: 1
                                        Text { text: modelData.k; color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 16; font.bold: true }
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
                        anchors.margins: 9
                        spacing: 5
                        Text { text: UnifiedLocale.attention(cockpit.language); color: Theme.platinum; font.pixelSize: 11; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: cockpit.rtl ? "الحوادث الجوية / Awareness" : "AIRSPACE INCIDENT CONTEXT"; color: Theme.accent; font.pixelSize: 7; font.bold: true }
                        ListView {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 150
                            clip: true
                            spacing: 4
                            model: cockpit.airOperationsIncidents
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 58
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: modelData.peakThreatLevel === "HIGH" || modelData.peakThreatLevel === "CRITICAL" ? Theme.amber : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 1
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: modelData.incidentId + "  /  " + modelData.trackId; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.status; color: Theme.silver; font.pixelSize: 7 }
                                    }
                                    Text { text: modelData.summary; color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                        Text { text: cockpit.rtl ? "الصيانة / Engineering" : "MAINTENANCE FOLLOW-UP"; color: Theme.gold; font.pixelSize: 7; font.bold: true }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 4
                            model: cockpit.readinessMaintenanceRows
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 64
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
                                        Text { text: modelData.priority + "  /  " + modelData.platform + "  /  " + modelData.system; color: modelData.priority === "P2" ? Theme.amber : Theme.accent; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.due; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7 }
                                    }
                                    Text { text: modelData.action; color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            color: Theme.panel2
            border.color: Theme.green
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8
                Text { text: "AEGIS C-UAS"; color: Theme.accent; font.pixelSize: 7; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 10 }
                Text { text: "AIR OPS EXCHANGE"; color: Theme.platinum; font.pixelSize: 7; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 10 }
                Text { text: "AVIONICS LAB"; color: Theme.platinum; font.pixelSize: 7; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 10 }
                Text { text: "READINESS OPS"; color: Theme.gold; font.pixelSize: 7; font.bold: true }
                Item { Layout.fillWidth: true }
                Text { text: UnifiedLocale.boundary(cockpit.language); color: Theme.green; font.pixelSize: 7; font.bold: true; Layout.maximumWidth: parent.width * 0.55; elide: Text.ElideRight }
            }
        }
    }
}
