import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function observed(){ return cockpit.activeAlertCount>0 || cockpit.twinFaultCount>0 || cockpit.twinDegradedCount>0 }
    function recovered(){ return cockpit.activeTrainingFaultCount===0 && cockpit.eventCount>1 }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumHeight: 62
            Layout.preferredHeight: 62
            Layout.maximumHeight: 62
            color: Theme.panel
            border.color: Theme.border
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 9
                spacing: 10
                NavIcon { kind: "fault"; iconColor: Theme.platinum; Layout.preferredWidth: 28; Layout.preferredHeight: 28 }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text { text: cockpit.rtl ? "منصة اختبار الأعطال والاستجابة" : "FAULT INJECTION & RESPONSE WORKBENCH"; color: Theme.platinum; font.pixelSize: 16; font.bold: true }
                    Text { text: cockpit.rtl ? "بروتوكول تدريب موثق: تجهيز / حقن / ملاحظة / استعادة / تحقق" : "AUDITABLE TRAINING PROTOCOL — ARM / INJECT / OBSERVE / RECOVER / VERIFY"; color: Theme.muted; font.pixelSize: 8 }
                }
                Text { text: "ACTIVE  " + cockpit.activeTrainingFaultCount; color: cockpit.activeTrainingFaultCount?Theme.amber:Theme.accent; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                MinisterialButton { text: cockpit.text("clear_faults"); enabled: cockpit.activeTrainingFaultCount>0; accent: Theme.amber; onClicked: cockpit.clearTrainingFaults() }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.minimumHeight: 64
            Layout.preferredHeight: 64
            Layout.maximumHeight: 64
            columns: 5
            columnSpacing: 5
            Repeater {
                model: [
                    {"n":"01","t":"ARM","ok":true},
                    {"n":"02","t":"INJECT","ok":cockpit.activeTrainingFaultCount>0},
                    {"n":"03","t":"OBSERVE","ok":page.observed()},
                    {"n":"04","t":"RECOVER","ok":page.recovered()},
                    {"n":"05","t":"VERIFY","ok":page.recovered() && cockpit.activeAlertCount===0 && cockpit.twinFaultCount===0}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: modelData.ok?Theme.accent:Theme.border
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        Rectangle {
                            width: 28
                            height: 28
                            color: Theme.panel3
                            border.color: modelData.ok?Theme.accent:Theme.border
                            radius: Theme.radius
                            Text { anchors.centerIn: parent; text: modelData.n; color: modelData.ok?Theme.platinum:Theme.muted; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: modelData.t; color: modelData.ok?Theme.platinum:Theme.silver; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                            Text { text: modelData.ok?"COMPLETE":"WAITING"; color: modelData.ok?Theme.accent:Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                        }
                        Text { text: modelData.ok?"✓":"—"; color: modelData.ok?Theme.accent:Theme.muted; font.pixelSize: 12 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7

            Rectangle {
                Layout.preferredWidth: 355
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 5
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl?"مكتبة حالات الاختبار":"TEST CONDITION LIBRARY"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text { text: String(cockpit.presentationFaultPresets.length)+" PRESETS"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8 }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
                    Repeater {
                        model: cockpit.presentationFaultPresets
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.minimumHeight: 88
                            Layout.preferredHeight: 88
                            Layout.maximumHeight: 88
                            color: index%2?Theme.panel2:Theme.panel
                            border.color: modelData.active?Theme.amber:Theme.border
                            radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 2
                                RowLayout {
                                    Layout.fillWidth: true
                                    Rectangle { width: 3; height: 26; color: modelData.active?Theme.amber:Theme.accent }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.label.toUpperCase(); color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.sensor+" / "+modelData.mode; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                                    }
                                    Text { text: modelData.active?"INJECTED":"READY"; color: modelData.active?Theme.amber:Theme.silver; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                }
                                Text { text: modelData.detail; color: Theme.muted; font.pixelSize: 7; elide: Text.ElideRight; Layout.fillWidth: true }
                                MinisterialButton { Layout.fillWidth: true; implicitHeight: 25; text: modelData.active?cockpit.text("active"):cockpit.text("apply_fault"); checked: modelData.active; accent: Theme.accent; enabled: !modelData.active; onClicked: cockpit.applyTrainingFault(modelData.id) }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: Theme.border
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 5
                            Text { text: cockpit.rtl?"معايير الاستعادة":"RECOVERY CRITERIA"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                            Repeater {
                                model: [
                                    {"t":"0 ACTIVE TRAINING FAULTS","ok":cockpit.activeTrainingFaultCount===0},
                                    {"t":"0 TWIN FAULTS","ok":cockpit.twinFaultCount===0},
                                    {"t":"0 ACTIVE ALERTS","ok":cockpit.activeAlertCount===0},
                                    {"t":"SESSION EVIDENCE PRESENT","ok":cockpit.recordedFrames>0}
                                ]
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Rectangle { width: 7; height: 7; radius: 3; color: modelData.ok?Theme.green:Theme.muted }
                                    Text { text: modelData.t; color: modelData.ok?Theme.silver:Theme.muted; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true }
                                }
                            }
                            Item { Layout.fillHeight: true }
                            Text { text: cockpit.rtl?"تدريب ومحاكاة فقط — لا توجد أوامر لعتاد أو طائرة حقيقية":"TRAINING / SIMULATION ONLY — NO LIVE AIRCRAFT OR HARDWARE COMMAND PATH"; color: Theme.muted; font.pixelSize: 7; wrapMode: Text.Wrap; Layout.fillWidth: true }
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
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl?"مركز المحاكاة والأدلة الحية":"SIMULATION & LIVE EVIDENCE"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text { text: "EVENTS  "+cockpit.eventCount; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8 }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 58
                        Layout.preferredHeight: 58
                        Layout.maximumHeight: 58
                        columns: 3
                        columnSpacing: 5
                        MetricBox { Layout.fillWidth: true; Layout.fillHeight: true; label: "ACTIVE ALERTS"; value: String(cockpit.activeAlertCount); accent: cockpit.activeAlertCount?Theme.amber:Theme.accent }
                        MetricBox { Layout.fillWidth: true; Layout.fillHeight: true; label: "TWIN FAULTS"; value: String(cockpit.twinFaultCount); accent: cockpit.twinFaultCount?Theme.red:Theme.accent }
                        MetricBox { Layout.fillWidth: true; Layout.fillHeight: true; label: "DEGRADED"; value: String(cockpit.twinDegradedCount); accent: cockpit.twinDegradedCount?Theme.amber:Theme.accent }
                    }
                    Text { text: cockpit.rtl?"الجدول الزمني للأحداث":"EVENT TIMELINE"; color: Theme.silver; font.pixelSize: 8; font.bold: true }
                    ListView {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 108
                        Layout.preferredHeight: 108
                        Layout.maximumHeight: 108
                        model: cockpit.eventRows
                        clip: true
                        spacing: 1
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            width: ListView.view.width
                            height: 27
                            color: index%2?Theme.panel2:Theme.panel
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                Text { text: modelData.time; color: Theme.muted; Layout.preferredWidth: 72; font.family: "Consolas"; font.pixelSize: 7 }
                                Text { text: modelData.severity; color: modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.silver); Layout.preferredWidth: 48; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                Text { text: modelData.source; color: Theme.accent; Layout.preferredWidth: 60; font.family: "Consolas"; font.pixelSize: 7 }
                                Text { text: modelData.message; color: Theme.silver; Layout.fillWidth: true; elide: Text.ElideRight; font.pixelSize: 7 }
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl?"قنوات الاستجابة المباشرة":"LIVE RESPONSE CHANNELS"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                        Text { text: cockpit.sensorCount+" CHANNELS"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8 }
                    }
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 2
                        columnSpacing: 5
                        rowSpacing: 5
                        Repeater {
                            model: cockpit.sensorRows
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumHeight: 42
                                color: Theme.panel2
                                border.color: Theme.border
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    Rectangle { width: 3; height: 23; color: modelData.valid?Theme.accent:Theme.red }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.id; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: Number(modelData.value).toFixed(1)+" "+modelData.unit; color: modelData.valid?Theme.platinum:Theme.red; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                    }
                                    Text { text: modelData.valid?"VALID":"FAULT"; color: modelData.valid?Theme.silver:Theme.red; font.family: "Consolas"; font.pixelSize: 7 }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4
                    Text { text: cockpit.rtl?"مصفوفة استجابة الأنظمة":"SYSTEM RESPONSE MATRIX"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.border }
                    Repeater {
                        model: cockpit.twinRows
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.minimumHeight: 50
                            Layout.preferredHeight: 50
                            Layout.maximumHeight: 50
                            color: index%2?Theme.panel2:Theme.panel
                            border.color: Theme.border
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                Rectangle { width: 3; height: 25; color: Theme.stateColor(modelData.state) }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Text { text: modelData.label; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: "CH "+modelData.valid+"/"+modelData.expected+"  ISS "+modelData.issues; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                                }
                                Text { text: modelData.state+"\n"+Number(modelData.health).toFixed(0)+"%"; color: Theme.stateColor(modelData.state); horizontalAlignment: Text.AlignRight; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            }
                        }
                    }
                    Item { Layout.fillHeight: true }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.minimumHeight: 74
                        Layout.preferredHeight: 74
                        Layout.maximumHeight: 74
                        color: Theme.panel2
                        border.color: Theme.border
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            spacing: 3
                            Text { text: "RECOVERY STATUS"; color: Theme.silver; font.pixelSize: 8; font.bold: true }
                            Text { text: page.recovered()?"VERIFIED / RECOVERED":"PROTOCOL IN PROGRESS"; color: page.recovered()?Theme.green:Theme.amber; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 3
                                color: Theme.borderSoft
                                Rectangle { width: page.recovered()?parent.width:parent.width*.2; height: parent.height; color: page.recovered()?Theme.accent:Theme.amber }
                            }
                        }
                    }
                }
            }
        }
    }
}
