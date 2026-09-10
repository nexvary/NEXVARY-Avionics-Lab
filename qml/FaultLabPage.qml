import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function observed(){ return cockpit.activeAlertCount>0 || cockpit.twinFaultCount>0 || cockpit.twinDegradedCount>0 }
    function recovered(){ return cockpit.activeTrainingFaultCount===0 && cockpit.eventCount>1 }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:62; Layout.minimumHeight:62; Layout.maximumHeight:62; color:Theme.panel; border.color:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:9
                NavIcon { kind:"fault"; iconColor:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.silver; Layout.preferredWidth:24; Layout.preferredHeight:24 }
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"منضدة اختبار الأعطال والاستجابة":"FAULT INJECTION & RESPONSE WORKBENCH"; color:Theme.gold; font.pixelSize:16; font.bold:true }
                    Text { text:cockpit.rtl?"تجهيز ← حقن ← ملاحظة ← استعادة ← تحقق":"ARM → INJECT → OBSERVE → RECOVER → VERIFY"; color:Theme.muted; font.pixelSize:8; font.letterSpacing:.5 }
                }
                Text { text:"ACTIVE "+cockpit.activeTrainingFaultCount; color:cockpit.activeTrainingFaultCount?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:12; font.bold:true }
                MinisterialButton { text:cockpit.text("clear_faults"); enabled:cockpit.activeTrainingFaultCount>0; accent:Theme.amber; onClicked:cockpit.clearTrainingFaults() }
            }
        }

        GridLayout { Layout.fillWidth:true; Layout.preferredHeight:70; Layout.minimumHeight:70; Layout.maximumHeight:70; columns:5; columnSpacing:5; rowSpacing:0
            Repeater { model:[
                {"n":"01","t":"ARM","ok":true},
                {"n":"02","t":"INJECT","ok":cockpit.activeTrainingFaultCount>0},
                {"n":"03","t":"OBSERVE","ok":page.observed()},
                {"n":"04","t":"RECOVER","ok":page.recovered()},
                {"n":"05","t":"VERIFY","ok":page.recovered() && cockpit.activeAlertCount===0 && cockpit.twinFaultCount===0}
            ]; delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:modelData.ok?"#071b17":"#0b1216"; border.color:modelData.ok?Theme.green:Theme.border; radius:Theme.radius
                RowLayout { anchors.fill:parent; anchors.margins:8
                    Rectangle { width:28; height:28; radius:14; color:modelData.ok?"#0a3022":"#111c22"; border.color:modelData.ok?Theme.green:Theme.border
                        Text { anchors.centerIn:parent; text:modelData.n; color:modelData.ok?Theme.green:Theme.muted; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                    }
                    ColumnLayout { Layout.fillWidth:true; spacing:0
                        Text { text:modelData.t; color:modelData.ok?Theme.text:Theme.muted; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                        Text { text:modelData.ok?"GATE COMPLETE":"WAITING"; color:modelData.ok?Theme.green:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                    }
                    Text { text:modelData.ok?"✓":"—"; color:modelData.ok?Theme.green:Theme.muted; font.pixelSize:14 }
                }
            } }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.preferredWidth:350; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:4
                    Text { text:cockpit.rtl?"مصفوفة استجابة الأنظمة":"SYSTEM RESPONSE MATRIX"; color:Theme.gold; font.pixelSize:11; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.preferredHeight:57; color:index%2?"#061219":"#08161d"; border.color:Theme.stateColor(modelData.state); radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Rectangle { width:4; height:30; color:Theme.stateColor(modelData.state) }
                                ColumnLayout { Layout.fillWidth:true; spacing:0
                                    Text { text:modelData.label; color:Theme.text; font.pixelSize:8; font.bold:true; elide:Text.ElideRight; Layout.fillWidth:true }
                                    Text { text:"CH "+modelData.valid+"/"+modelData.expected+"  ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                ColumnLayout { spacing:0
                                    Text { text:modelData.state; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                                    Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                                }
                            }
                        }
                    }
                    Item { Layout.fillHeight:true }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:92; color:"#07141a"; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:3
                            Text { text:"RECOVERY CRITERIA"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                            Text { text:"0 ACTIVE FAULTS  •  0 TWIN FAULTS  •  0 ALERTS"; color:page.recovered()?Theme.green:Theme.muted; font.family:"Consolas"; font.pixelSize:8; wrapMode:Text.Wrap; Layout.fillWidth:true }
                            Rectangle { Layout.fillWidth:true; height:4; color:"#102029"; radius:2
                                Rectangle { width:page.recovered()?parent.width:parent.width*.2; height:parent.height; color:page.recovered()?Theme.green:Theme.amber; radius:2 }
                            }
                            Text { text:cockpit.rtl?"اختبار محاكاة فقط — لا مسار أوامر حي":"SIMULATION TEST ONLY — NO LIVE COMMAND PATH"; color:Theme.muted; font.pixelSize:7 }
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"دليل الاستجابة الزمني":"TIME-CORRELATED RESPONSE EVIDENCE"; color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"EVENTS "+cockpit.eventCount; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    GridLayout { Layout.fillWidth:true; Layout.preferredHeight:58; Layout.minimumHeight:58; Layout.maximumHeight:58; columns:3; columnSpacing:5
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"ALERTS"; value:String(cockpit.activeAlertCount); accent:cockpit.activeAlertCount?Theme.amber:Theme.green }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"TWIN FAULT"; value:String(cockpit.twinFaultCount); accent:cockpit.twinFaultCount?Theme.red:Theme.green }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"DEGRADED"; value:String(cockpit.twinDegradedCount); accent:cockpit.twinDegradedCount?Theme.amber:Theme.green }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Text { text:cockpit.rtl?"أحداث الاختبار":"TEST EVENTS"; color:Theme.gold; font.pixelSize:8; font.bold:true }
                    ListView { Layout.fillWidth:true; Layout.preferredHeight:126; Layout.minimumHeight:80; Layout.maximumHeight:150; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:32; color:index%2?"#061219":"#08161d"
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:modelData.time; color:Theme.silver; Layout.preferredWidth:86; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); Layout.preferredWidth:52; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:70; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:8 }
                            }
                        }
                    }
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"تليمترية الاستجابة الحية":"LIVE RESPONSE TELEMETRY"; color:Theme.gold; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:cockpit.sensorCount+" CHANNELS"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:5; rowSpacing:5
                        Repeater { model:cockpit.sensorRows
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:45; color:"#07151c"; border.color:modelData.valid?"#1c4b3a":Theme.red; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:6
                                    Rectangle { width:4; height:24; color:modelData.valid?Theme.green:Theme.red }
                                    ColumnLayout { Layout.fillWidth:true; spacing:0
                                        Text { text:modelData.id; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7; elide:Text.ElideRight; Layout.fillWidth:true }
                                        Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.cyan:Theme.red; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                                    }
                                    Text { text:modelData.valid?"VALID":"FAULT"; color:modelData.valid?Theme.green:Theme.red; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:38; color:"#06141a"; border.color:Theme.border; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:6
                            Text { text:cockpit.rtl?"مؤشر الاستعادة":"RECOVERY STATUS"; color:Theme.muted; font.pixelSize:8; Layout.fillWidth:true }
                            Text { text:page.recovered()?"RECOVERED":"IN PROGRESS"; color:page.recovered()?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:390; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"كتالوج حالات الاختبار":"TEST CONDITION CATALOG"; color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:String(cockpit.presentationFaultPresets.length)+" PRESETS"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.presentationFaultPresets
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.preferredHeight:105; color:index%2?"#061219":"#08161d"; border.color:modelData.active?Theme.amber:"#142832"; border.width:modelData.active?2:1; radius:Theme.radius
                            ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:3
                                RowLayout { Layout.fillWidth:true
                                    Rectangle { width:4; height:28; color:modelData.active?Theme.amber:Theme.cyan }
                                    ColumnLayout { Layout.fillWidth:true; spacing:0
                                        Text { text:modelData.label.toUpperCase(); color:Theme.text; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:modelData.sensor+" / "+modelData.mode; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                    Text { text:modelData.active?"INJECTED":"READY"; color:modelData.active?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                }
                                Text { text:modelData.detail; color:Theme.muted; font.pixelSize:8; wrapMode:Text.Wrap; Layout.fillWidth:true; Layout.fillHeight:true }
                                MinisterialButton { Layout.fillWidth:true; implicitHeight:26; text:modelData.active?cockpit.text("active"):cockpit.text("apply_fault"); checked:modelData.active; accent:Theme.amber; enabled:!modelData.active; onClicked:cockpit.applyTrainingFault(modelData.id) }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:150; color:"#07141a"; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:5
                            RowLayout { Layout.fillWidth:true
                                Text { text:cockpit.rtl?"غلاف الأمان":"SAFETY ENVELOPE"; color:Theme.gold; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                                Text { text:"SYNTHETIC ONLY"; color:Theme.green; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                            }
                            Repeater { model:[
                                {"k":"ACTIVE FAULTS","v":String(cockpit.activeTrainingFaultCount),"c":cockpit.activeTrainingFaultCount?Theme.amber:Theme.green},
                                {"k":"ACTIVE ALERTS","v":String(cockpit.activeAlertCount),"c":cockpit.activeAlertCount?Theme.amber:Theme.green},
                                {"k":"TWIN FAULTS","v":String(cockpit.twinFaultCount),"c":cockpit.twinFaultCount?Theme.red:Theme.green},
                                {"k":"RECORDED FRAMES","v":String(cockpit.recordedFrames),"c":Theme.cyan},
                                {"k":"TELEMETRY CH","v":String(cockpit.sensorCount),"c":Theme.cyan}
                            ]; delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:"#061219"; border.color:Theme.border; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:6
                                    Text { text:modelData.k; color:Theme.muted; font.pixelSize:8; Layout.fillWidth:true }
                                    Text { text:modelData.v; color:modelData.c; font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                                }
                            } }
                            Text { text:cockpit.rtl?"المنصة لا ترسل أوامر إلى طائرة أو عتاد حقيقي.":"THE LAB DOES NOT ISSUE COMMANDS TO LIVE AIRCRAFT OR HARDWARE."; color:Theme.muted; wrapMode:Text.Wrap; font.pixelSize:7; Layout.fillWidth:true }
                        }
                    }
                }
            }
        }
    }
}
