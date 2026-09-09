import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function validSensors(){ var n=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid) ++n; return n }
    function checks(){ return [
        {"name":cockpit.rtl?"سلامة القياسات":"TELEMETRY VALIDITY", "pass":page.validSensors()===cockpit.sensorCount && cockpit.sensorCount>0, "evidence":page.validSensors()+" / "+cockpit.sensorCount+" VALID"},
        {"name":cockpit.rtl?"اتساق التوأم الرقمي":"DIGITAL TWIN CONSISTENCY", "pass":cockpit.twinFaultCount===0, "evidence":"FAULTS "+cockpit.twinFaultCount+"  DEG "+cockpit.twinDegradedCount},
        {"name":cockpit.rtl?"حالة التنبيهات":"ALERT STATE", "pass":cockpit.activeAlertCount===0, "evidence":"ACTIVE "+cockpit.activeAlertCount},
        {"name":cockpit.rtl?"مسجل الجلسة":"SESSION RECORDER", "pass":cockpit.recordedFrames>10, "evidence":"FRAMES "+cockpit.recordedFrames},
        {"name":cockpit.rtl?"تشغيل السيناريو":"SCENARIO PIPELINE", "pass":cockpit.tick>0, "evidence":"TICK "+cockpit.tick+"  "+cockpit.scenario},
        {"name":cockpit.rtl?"حالة مختبر الأعطال":"FAULT LAB STATE", "pass":cockpit.activeTrainingFaultCount===0, "evidence":"ACTIVE "+cockpit.activeTrainingFaultCount}
    ] }
    function passCount(){ var a=page.checks(), n=0; for(var i=0;i<a.length;++i) if(a[i].pass) ++n; return n }

    ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:8
        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:70; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"مركز التحقق التشغيلي":"RUNTIME VERIFICATION CENTER"; color:Theme.gold; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"أدلة تشغيل للمحاكاة والتدريب — ليست شهادة اعتماد":"TRAINING / SIMULATION ASSURANCE EVIDENCE — NOT CERTIFICATION"; color:Theme.muted; font.pixelSize:9; font.letterSpacing:.4 }
                }
                Text { text:page.passCount()+" / 6"; color:page.passCount()===6?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:24; font.bold:true }
                Rectangle { width:120; height:32; color:page.passCount()===6?"#082117":"#241b08"; border.color:page.passCount()===6?Theme.green:Theme.amber; radius:Theme.radius
                    Text { anchors.centerIn:parent; text:page.passCount()===6?"ASSURED":"ATTENTION"; color:page.passCount()===6?Theme.green:Theme.amber; font.family:"Consolas"; font.bold:true; font.pixelSize:11 }
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:4
                    Text { text:cockpit.rtl?"فحوص الحالة الحية":"LIVE ASSURANCE CHECKS"; color:Theme.silver; font.pixelSize:11; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:page.checks()
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?"#071219":"#09171e"; border.color:"#142832"
                            RowLayout { anchors.fill:parent; anchors.margins:9
                                Rectangle { width:26; height:26; color:modelData.pass?"#08281c":"#2a1d09"; border.color:modelData.pass?Theme.green:Theme.amber; radius:Theme.radius
                                    Text { anchors.centerIn:parent; text:modelData.pass?"✓":"!"; color:modelData.pass?Theme.green:Theme.amber; font.bold:true }
                                }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.name; color:Theme.text; font.pixelSize:10; font.bold:true }
                                    Text { text:modelData.evidence; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                                }
                                Text { text:modelData.pass?"PASS":"CHECK"; color:modelData.pass?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:470; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:6
                    Text { text:cockpit.rtl?"مصفوفة الأدلة":"EVIDENCE MATRIX"; color:Theme.gold; font.pixelSize:13; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    GridLayout { Layout.fillWidth:true; columns:2; columnSpacing:6; rowSpacing:6
                        Repeater { model:[
                            {"k":"SCENARIO","v":cockpit.scenario,"c":Theme.cyan},
                            {"k":"TICK","v":String(cockpit.tick),"c":Theme.text},
                            {"k":"RECORDED","v":String(cockpit.recordedFrames),"c":Theme.text},
                            {"k":"EVENTS","v":String(cockpit.eventCount),"c":Theme.text},
                            {"k":"ALERTS","v":String(cockpit.activeAlertCount),"c":cockpit.activeAlertCount?Theme.amber:Theme.green},
                            {"k":"FAULT LAB","v":String(cockpit.activeTrainingFaultCount),"c":cockpit.activeTrainingFaultCount?Theme.amber:Theme.green}
                        ]
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.preferredHeight:66; color:"#07141b"; border.color:Theme.border; radius:Theme.radius
                                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:1
                                    Text { text:modelData.k; color:Theme.muted; font.pixelSize:8; font.bold:true; font.letterSpacing:.5 }
                                    Text { text:modelData.v; color:modelData.c; font.family:"Consolas"; font.pixelSize:16; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                }
                            }
                        }
                    }
                    Text { text:cockpit.rtl?"آخر الأحداث":"RECENT EVIDENCE EVENTS"; color:Theme.silver; font.pixelSize:10; font.bold:true }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:34; color:index%2?"#071219":"#09171e"
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); font.family:"Consolas"; font.pixelSize:8; Layout.preferredWidth:58 }
                                Text { text:modelData.source; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8; Layout.preferredWidth:70 }
                                Text { text:modelData.message; color:Theme.silver; font.pixelSize:8; Layout.fillWidth:true; elide:Text.ElideRight }
                            }
                        }
                    }
                }
            }
        }
    }
}
