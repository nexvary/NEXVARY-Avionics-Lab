import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function validSensors(){ var n=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid) ++n; return n }
    function checks(){ return [
        {"name":cockpit.rtl?"سلامة القياسات":"TELEMETRY VALIDITY", "pass":page.validSensors()===cockpit.sensorCount && cockpit.sensorCount>0, "evidence":page.validSensors()+" / "+cockpit.sensorCount+" VALID", "code":"TEL"},
        {"name":cockpit.rtl?"اتساق التوأم الرقمي":"DIGITAL TWIN CONSISTENCY", "pass":cockpit.twinFaultCount===0, "evidence":"FAULTS "+cockpit.twinFaultCount+"  DEG "+cockpit.twinDegradedCount, "code":"TWN"},
        {"name":cockpit.rtl?"حالة التنبيهات":"ALERT STATE", "pass":cockpit.activeAlertCount===0, "evidence":"ACTIVE "+cockpit.activeAlertCount, "code":"ALT"},
        {"name":cockpit.rtl?"مسجل الجلسة":"SESSION RECORDER", "pass":cockpit.recordedFrames>10, "evidence":"FRAMES "+cockpit.recordedFrames, "code":"REC"},
        {"name":cockpit.rtl?"تشغيل السيناريو":"SCENARIO PIPELINE", "pass":cockpit.tick>0, "evidence":"TICK "+cockpit.tick+"  "+cockpit.scenario, "code":"SCN"},
        {"name":cockpit.rtl?"حالة مختبر الأعطال":"FAULT LAB STATE", "pass":cockpit.activeTrainingFaultCount===0, "evidence":"ACTIVE "+cockpit.activeTrainingFaultCount, "code":"FLT"}
    ] }
    function passCount(){ var a=page.checks(), n=0; for(var i=0;i<a.length;++i) if(a[i].pass) ++n; return n }
    function ratio(){ return Math.round(page.passCount()*100/6) }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:68; Layout.minimumHeight:68; Layout.maximumHeight:68; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:9
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"مركز التحقق التشغيلي":"RUNTIME VERIFICATION CENTER"; color:Theme.gold; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"أدلة تشغيل للمحاكاة والتدريب — ليست شهادة اعتماد":"TRAINING / SIMULATION ASSURANCE EVIDENCE — NOT CERTIFICATION"; color:Theme.muted; font.pixelSize:9; font.letterSpacing:.4 }
                }
                Text { text:page.passCount()+" / 6"; color:page.passCount()===6?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:24; font.bold:true }
                Rectangle { width:150; height:34; color:page.passCount()===6?"#082117":"#241b08"; border.color:page.passCount()===6?Theme.green:Theme.amber; radius:Theme.radius
                    Text { anchors.centerIn:parent; text:page.passCount()===6?"ASSURED / "+page.ratio()+"%":"ATTENTION / "+page.ratio()+"%"; color:page.passCount()===6?Theme.green:Theme.amber; font.family:"Consolas"; font.bold:true; font.pixelSize:10 }
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"شبكة فحوص الضمان الحية":"LIVE ASSURANCE CHECK GRID"; color:Theme.silver; font.pixelSize:11; font.bold:true; Layout.fillWidth:true }
                        Text { text:"6 GATES / LIVE"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    GridLayout { Layout.fillWidth:true; Layout.preferredHeight:320; Layout.minimumHeight:280; columns:2; columnSpacing:6; rowSpacing:6
                        Repeater { model:page.checks()
                            delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?"#071219":"#09171e"; border.color:modelData.pass?"#215740":Theme.amber; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:9
                                    Rectangle { width:42; height:42; color:modelData.pass?"#08281c":"#2a1d09"; border.color:modelData.pass?Theme.green:Theme.amber; radius:Theme.radius
                                        Column { anchors.centerIn:parent; spacing:0
                                            Text { anchors.horizontalCenter:parent.horizontalCenter; text:modelData.code; color:modelData.pass?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                                            Text { anchors.horizontalCenter:parent.horizontalCenter; text:modelData.pass?"✓":"!"; color:modelData.pass?Theme.green:Theme.amber; font.pixelSize:14; font.bold:true }
                                        }
                                    }
                                    ColumnLayout { Layout.fillWidth:true; spacing:2
                                        Text { text:modelData.name; color:Theme.text; font.pixelSize:10; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:modelData.evidence; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                                        Rectangle { Layout.fillWidth:true; height:4; color:"#102029"; radius:2
                                            Rectangle { width:parent.width; height:parent.height; color:modelData.pass?Theme.green:Theme.amber; radius:2; opacity:.75 }
                                        }
                                    }
                                    Text { text:modelData.pass?"PASS":"CHECK"; color:modelData.pass?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                                }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:120; color:"#06131a"; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                            RowLayout { Layout.fillWidth:true
                                Text { text:cockpit.rtl?"تكوين الثقة اللحظي":"ASSURANCE COMPOSITION"; color:Theme.gold; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                                Text { text:page.ratio()+"%"; color:page.ratio()===100?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:14; font.bold:true }
                            }
                            GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:4; columnSpacing:5
                                MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"VALID CH"; value:page.validSensors()+"/"+cockpit.sensorCount; accent:Theme.cyan }
                                MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"TWIN"; value:cockpit.twinFaultCount===0?"SYNC":"FAULT"; accent:cockpit.twinFaultCount===0?Theme.green:Theme.red }
                                MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"ALERTS"; value:String(cockpit.activeAlertCount); accent:cockpit.activeAlertCount?Theme.amber:Theme.green }
                                MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"FRAMES"; value:String(cockpit.recordedFrames); accent:Theme.cyan }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:520; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مصفوفة الأدلة":"EVIDENCE MATRIX"; color:Theme.gold; font.pixelSize:13; font.bold:true; Layout.fillWidth:true }
                        Text { text:"TRACEABLE SNAPSHOT"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    GridLayout { Layout.fillWidth:true; columns:2; columnSpacing:5; rowSpacing:5
                        Repeater { model:[
                            {"k":"SCENARIO","v":cockpit.scenario,"c":Theme.cyan},
                            {"k":"TICK","v":String(cockpit.tick),"c":Theme.text},
                            {"k":"RECORDED","v":String(cockpit.recordedFrames),"c":Theme.text},
                            {"k":"EVENTS","v":String(cockpit.eventCount),"c":Theme.text},
                            {"k":"ALERTS","v":String(cockpit.activeAlertCount),"c":cockpit.activeAlertCount?Theme.amber:Theme.green},
                            {"k":"FAULT LAB","v":String(cockpit.activeTrainingFaultCount),"c":cockpit.activeTrainingFaultCount?Theme.amber:Theme.green}
                        ]
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.preferredHeight:58; color:"#07141b"; border.color:Theme.border; radius:Theme.radius
                                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:1
                                    Text { text:modelData.k; color:Theme.muted; font.pixelSize:8; font.bold:true; font.letterSpacing:.5 }
                                    Text { text:modelData.v; color:modelData.c; font.family:"Consolas"; font.pixelSize:15; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:42; color:"#07141b"; border.color:Theme.border; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:6
                            Text { text:"EVIDENCE CHAIN"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                            Text { text:"SCENARIO → TELEMETRY → HEALTH → REPORT"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8; Layout.fillWidth:true; horizontalAlignment:Text.AlignRight }
                        }
                    }
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"أدلة القنوات":"CHANNEL EVIDENCE"; color:Theme.gold; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:page.validSensors()+"/"+cockpit.sensorCount+" VALID"; color:page.validSensors()===cockpit.sensorCount?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:5; rowSpacing:5
                        Repeater { model:cockpit.sensorRows
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:44; color:"#07151c"; border.color:modelData.valid?"#1c4b3a":Theme.red; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:6
                                    Rectangle { width:4; height:24; color:modelData.valid?Theme.green:Theme.red }
                                    ColumnLayout { Layout.fillWidth:true; spacing:0
                                        Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7; elide:Text.ElideRight; Layout.fillWidth:true }
                                        Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.cyan:Theme.red; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                                    }
                                    Text { text:modelData.valid?"PASS":"FAIL"; color:modelData.valid?Theme.green:Theme.red; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                }
                            }
                        }
                    }
                    Text { text:cockpit.rtl?"آخر أحداث الأدلة":"RECENT EVIDENCE EVENTS"; color:Theme.silver; font.pixelSize:9; font.bold:true }
                    ListView { Layout.fillWidth:true; Layout.preferredHeight:90; Layout.minimumHeight:60; Layout.maximumHeight:110; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:30; color:index%2?"#071219":"#09171e"
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); font.family:"Consolas"; font.pixelSize:7; Layout.preferredWidth:52 }
                                Text { text:modelData.source; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:7; Layout.preferredWidth:65 }
                                Text { text:modelData.message; color:Theme.silver; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:34; color:page.passCount()===6?"#071c16":"#241b08"; border.color:page.passCount()===6?Theme.green:Theme.amber; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:6
                            Text { text:page.passCount()===6?"ALL SIX RUNTIME GATES SATISFIED":"RUNTIME EVIDENCE REQUIRES ATTENTION"; color:page.passCount()===6?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:8; font.bold:true; Layout.fillWidth:true }
                            Text { text:"TRAINING ONLY"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                        }
                    }
                }
            }
        }
    }
}
