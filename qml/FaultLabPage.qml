import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function observed(){ return cockpit.activeAlertCount>0 || cockpit.twinFaultCount>0 || cockpit.twinDegradedCount>0 }
    function recovered(){ return cockpit.activeTrainingFaultCount===0 && cockpit.eventCount>1 }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:66; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:9; spacing:10
                NavIcon { kind:"fault"; iconColor:Theme.platinum; Layout.preferredWidth:30; Layout.preferredHeight:30 }
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"منصة اختبار الأعطال والاستجابة":"FAULT INJECTION & RESPONSE WORKBENCH"; color:Theme.platinum; font.pixelSize:17; font.bold:true }
                    Text { text:cockpit.rtl?"تدريب محاكاة موثق — تجهيز، حقن، ملاحظة، استعادة، تحقق":"AUDITABLE TRAINING PROTOCOL — ARM / INJECT / OBSERVE / RECOVER / VERIFY"; color:Theme.muted; font.pixelSize:8 }
                }
                Text { text:"ACTIVE  "+cockpit.activeTrainingFaultCount; color:cockpit.activeTrainingFaultCount?Theme.amber:Theme.accent; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                MinisterialButton { text:cockpit.text("clear_faults"); enabled:cockpit.activeTrainingFaultCount>0; accent:Theme.amber; onClicked:cockpit.clearTrainingFaults() }
            }
        }

        GridLayout { Layout.fillWidth:true; Layout.preferredHeight:74; columns:5; columnSpacing:5
            Repeater { model:[
                {"n":"01","t":"ARM","ok":true},
                {"n":"02","t":"INJECT","ok":cockpit.activeTrainingFaultCount>0},
                {"n":"03","t":"OBSERVE","ok":page.observed()},
                {"n":"04","t":"RECOVER","ok":page.recovered()},
                {"n":"05","t":"VERIFY","ok":page.recovered() && cockpit.activeAlertCount===0 && cockpit.twinFaultCount===0}
            ]; delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel2; border.color:modelData.ok?Theme.accent:Theme.border; radius:Theme.radius
                RowLayout { anchors.fill:parent; anchors.margins:8
                    Rectangle { width:30; height:30; color:Theme.panel3; border.color:modelData.ok?Theme.accent:Theme.border; radius:Theme.radius
                        Text { anchors.centerIn:parent; text:modelData.n; color:modelData.ok?Theme.platinum:Theme.muted; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
                    }
                    ColumnLayout { Layout.fillWidth:true; spacing:0
                        Text { text:modelData.t; color:modelData.ok?Theme.platinum:Theme.silver; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                        Text { text:modelData.ok?"COMPLETE":"WAITING"; color:modelData.ok?Theme.accent:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                    }
                    Text { text:modelData.ok?"✓":"—"; color:modelData.ok?Theme.accent:Theme.muted; font.pixelSize:13 }
                }
            } }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.preferredWidth:410; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مكتبة حالات الاختبار":"TEST CONDITION LIBRARY"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:String(cockpit.presentationFaultPresets.length)+" PRESETS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.presentationFaultPresets
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.preferredHeight:112; color:index%2?Theme.panel2:Theme.panel; border.color:modelData.active?Theme.amber:Theme.border; radius:Theme.radius
                            ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                                RowLayout { Layout.fillWidth:true
                                    Rectangle { width:4; height:30; color:modelData.active?Theme.amber:Theme.accent }
                                    ColumnLayout { Layout.fillWidth:true; spacing:1
                                        Text { text:modelData.label.toUpperCase(); color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:modelData.sensor+"  /  "+modelData.mode; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                    Text { text:modelData.active?"INJECTED":"READY"; color:modelData.active?Theme.amber:Theme.silver; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                }
                                Text { text:modelData.detail; color:Theme.muted; font.pixelSize:8; wrapMode:Text.Wrap; Layout.fillWidth:true; Layout.fillHeight:true }
                                MinisterialButton { Layout.fillWidth:true; implicitHeight:28; text:modelData.active?cockpit.text("active"):cockpit.text("apply_fault"); checked:modelData.active; accent:Theme.accent; enabled:!modelData.active; onClicked:cockpit.applyTrainingFault(modelData.id) }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                            Text { text:cockpit.rtl?"معايير الاستعادة":"RECOVERY CRITERIA"; color:Theme.platinum; font.pixelSize:9; font.bold:true }
                            Repeater { model:[
                                {"t":"0 ACTIVE TRAINING FAULTS","ok":cockpit.activeTrainingFaultCount===0},
                                {"t":"0 TWIN FAULTS","ok":cockpit.twinFaultCount===0},
                                {"t":"0 ACTIVE ALERTS","ok":cockpit.activeAlertCount===0},
                                {"t":"SESSION EVIDENCE PRESENT","ok":cockpit.recordedFrames>0}
                            ]; delegate: RowLayout { required property var modelData; Layout.fillWidth:true
                                Rectangle { width:8; height:8; radius:4; color:modelData.ok?Theme.green:Theme.muted }
                                Text { text:modelData.t; color:modelData.ok?Theme.silver:Theme.muted; font.family:"Consolas"; font.pixelSize:8; Layout.fillWidth:true }
                            } }
                            Item { Layout.fillHeight:true }
                            Text { text:cockpit.rtl?"المنصة تدريب ومحاكاة فقط، ولا ترسل أوامر إلى عتاد أو طائرة حقيقية.":"TRAINING / SIMULATION ONLY — NO LIVE AIRCRAFT OR HARDWARE COMMAND PATH."; color:Theme.muted; font.pixelSize:7; wrapMode:Text.Wrap; Layout.fillWidth:true }
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مركز المحاكاة والأدلة الحية":"SIMULATION & LIVE EVIDENCE CENTER"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"EVENTS  "+cockpit.eventCount; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    GridLayout { Layout.fillWidth:true; Layout.preferredHeight:64; columns:3; columnSpacing:5
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"ACTIVE ALERTS"; value:String(cockpit.activeAlertCount); accent:cockpit.activeAlertCount?Theme.amber:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"TWIN FAULTS"; value:String(cockpit.twinFaultCount); accent:cockpit.twinFaultCount?Theme.red:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"DEGRADED"; value:String(cockpit.twinDegradedCount); accent:cockpit.twinDegradedCount?Theme.amber:Theme.accent }
                    }
                    Text { text:cockpit.rtl?"الجدول الزمني للأحداث":"EVENT TIMELINE"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                    ListView { Layout.fillWidth:true; Layout.preferredHeight:130; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:31; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:modelData.time; color:Theme.muted; Layout.preferredWidth:82; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.silver); Layout.preferredWidth:52; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                Text { text:modelData.source; color:Theme.accent; Layout.preferredWidth:70; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:8 }
                            }
                        }
                    }
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"قنوات الاستجابة المباشرة":"LIVE RESPONSE CHANNELS"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:cockpit.sensorCount+" CHANNELS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:5; rowSpacing:5
                        Repeater { model:cockpit.sensorRows
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:48; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:6
                                    Rectangle { width:4; height:25; color:modelData.valid?Theme.accent:Theme.red }
                                    ColumnLayout { Layout.fillWidth:true; spacing:0
                                        Text { text:modelData.id; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.platinum:Theme.red; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                                    }
                                    Text { text:modelData.valid?"VALID":"FAULT"; color:modelData.valid?Theme.silver:Theme.red; font.family:"Consolas"; font.pixelSize:7 }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:360; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    Text { text:cockpit.rtl?"مصفوفة استجابة الأنظمة":"SYSTEM RESPONSE MATRIX"; color:Theme.platinum; font.pixelSize:10; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.preferredHeight:62; color:index%2?Theme.panel2:Theme.panel; border.color:Theme.border; radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:7
                                Rectangle { width:4; height:30; color:Theme.stateColor(modelData.state) }
                                ColumnLayout { Layout.fillWidth:true; spacing:0
                                    Text { text:modelData.label; color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:"CH "+modelData.valid+"/"+modelData.expected+"   ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                Text { text:modelData.state+"\n"+Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); horizontalAlignment:Text.AlignRight; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                            }
                        }
                    }
                    Item { Layout.fillHeight:true }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:88; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:4
                            Text { text:"RECOVERY STATUS"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                            Text { text:page.recovered()?"VERIFIED / RECOVERED":"PROTOCOL IN PROGRESS"; color:page.recovered()?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                            Rectangle { Layout.fillWidth:true; height:4; color:Theme.borderSoft
                                Rectangle { width:page.recovered()?parent.width:parent.width*.2; height:parent.height; color:page.recovered()?Theme.accent:Theme.amber }
                            }
                        }
                    }
                }
            }
        }
    }
}
