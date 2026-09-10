import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function validSensors(){ var n=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid) ++n; return n }
    function checks(){ return [
        {"name":cockpit.rtl?"سلامة القياسات":"TELEMETRY VALIDITY","pass":page.validSensors()===cockpit.sensorCount&&cockpit.sensorCount>0,"evidence":page.validSensors()+" / "+cockpit.sensorCount+" VALID","code":"TEL"},
        {"name":cockpit.rtl?"اتساق التوأم الرقمي":"DIGITAL TWIN CONSISTENCY","pass":cockpit.twinFaultCount===0,"evidence":"FAULTS "+cockpit.twinFaultCount+"  DEG "+cockpit.twinDegradedCount,"code":"TWN"},
        {"name":cockpit.rtl?"حالة التنبيهات":"ALERT STATE","pass":cockpit.activeAlertCount===0,"evidence":"ACTIVE "+cockpit.activeAlertCount,"code":"ALT"},
        {"name":cockpit.rtl?"مسجل الجلسة":"SESSION RECORDER","pass":cockpit.recordedFrames>10,"evidence":"FRAMES "+cockpit.recordedFrames,"code":"REC"},
        {"name":cockpit.rtl?"تشغيل السيناريو":"SCENARIO PIPELINE","pass":cockpit.tick>0,"evidence":"TICK "+cockpit.tick+"  "+cockpit.scenario,"code":"SCN"},
        {"name":cockpit.rtl?"حالة مختبر الأعطال":"FAULT LAB STATE","pass":cockpit.activeTrainingFaultCount===0,"evidence":"ACTIVE "+cockpit.activeTrainingFaultCount,"code":"FLT"}
    ] }
    function passCount(){ var a=page.checks(),n=0; for(var i=0;i<a.length;++i) if(a[i].pass) ++n; return n }
    function ratio(){ return Math.round(page.passCount()*100/6) }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:82; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:1
                    Text { text:cockpit.rtl?"مركز التحقق":"VERIFICATION CENTER"; color:Theme.platinum; font.pixelSize:20; font.bold:true; font.letterSpacing:.5 }
                    Text { text:cockpit.rtl?"أدلة ضمان تشغيل للمحاكاة والتدريب — ليست شهادة اعتماد":"RUNTIME ASSURANCE / TRAINING & SIMULATION EVIDENCE / NOT CERTIFICATION"; color:Theme.muted; font.pixelSize:8 }
                }
            }
            Rectangle { Layout.preferredWidth:270; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                RowLayout { anchors.fill:parent; anchors.margins:10
                    ColumnLayout { Layout.fillWidth:true; spacing:0
                        Text { text:"GATES PASSED"; color:Theme.muted; font.pixelSize:8 }
                        Text { text:page.passCount()+" / 6"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:24; font.bold:true }
                        Text { text:"ALL ASSURANCE GATES"; color:Theme.silver; font.pixelSize:7 }
                    }
                    Text { text:page.ratio()+"%"; color:page.ratio()===100?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:20; font.bold:true }
                }
            }
            Rectangle { Layout.preferredWidth:250; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:1
                    Text { text:"ASSURANCE LEVEL"; color:Theme.muted; font.pixelSize:8 }
                    Text { text:page.passCount()===6?"ASSURED":"ATTENTION"; color:page.passCount()===6?Theme.accent:Theme.amber; font.pixelSize:18; font.bold:true }
                    Text { text:page.passCount()===6?"RUNTIME EVIDENCE COMPLETE":"REVIEW REQUIRED"; color:Theme.silver; font.pixelSize:7 }
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:75; spacing:6
            Repeater { model:[
                {"k":"SCENARIO","v":cockpit.scenario,"c":Theme.accent},
                {"k":"TICK","v":String(cockpit.tick),"c":Theme.platinum},
                {"k":"RECORDED FRAMES","v":String(cockpit.recordedFrames),"c":Theme.platinum},
                {"k":"EVENTS","v":String(cockpit.eventCount),"c":Theme.platinum},
                {"k":"ALERTS","v":String(cockpit.activeAlertCount),"c":cockpit.activeAlertCount?Theme.amber:Theme.silver},
                {"k":"FAULT LAB STATE","v":cockpit.activeTrainingFaultCount===0?"NOMINAL":String(cockpit.activeTrainingFaultCount),"c":cockpit.activeTrainingFaultCount?Theme.amber:Theme.silver}
            ]; delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:0
                    Text { text:modelData.k; color:Theme.muted; font.pixelSize:7; font.bold:true }
                    Text { text:modelData.v; color:modelData.c; font.family:"Consolas"; font.pixelSize:15; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                }
            } }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"شبكة فحوص ضمان التشغيل":"RUNTIME ASSURANCE CHECK GRID"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"6 GATES / LIVE VERIFICATION"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:6; rowSpacing:6
                        Repeater { model:page.checks()
                            delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?Theme.panel2:Theme.panel; border.color:Theme.border; radius:Theme.radius
                                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:5
                                    RowLayout { Layout.fillWidth:true
                                        Rectangle { width:40; height:40; color:Theme.panel3; border.color:modelData.pass?Theme.accent:Theme.amber; radius:Theme.radius
                                            Text { anchors.centerIn:parent; text:modelData.code; color:modelData.pass?Theme.platinum:Theme.amber; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
                                        }
                                        ColumnLayout { Layout.fillWidth:true; spacing:0
                                            Text { text:modelData.name; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                            Text { text:modelData.evidence; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                                        }
                                        Text { text:modelData.pass?"PASS":"CHECK"; color:modelData.pass?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
                                    }
                                    Rectangle { Layout.fillWidth:true; height:4; color:Theme.borderSoft
                                        Rectangle { width:modelData.pass?parent.width:parent.width*.35; height:parent.height; color:modelData.pass?Theme.accent:Theme.amber }
                                    }
                                    Text { text:modelData.pass?"EVIDENCE WITHIN EXPECTED TRAINING LIMITS":"EVIDENCE REQUIRES REVIEW"; color:Theme.muted; font.pixelSize:7 }
                                }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:82; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:8; spacing:6
                            Repeater { model:[
                                {"k":"VALID CH","v":page.validSensors()+"/"+cockpit.sensorCount},
                                {"k":"TWIN","v":cockpit.twinFaultCount===0?"SYNC":"FAULT"},
                                {"k":"ALERTS","v":String(cockpit.activeAlertCount)},
                                {"k":"FRAMES","v":String(cockpit.recordedFrames)}
                            ]; delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:0
                                    Text { text:modelData.k; color:Theme.muted; font.pixelSize:7 }
                                    Item { Layout.fillHeight:true }
                                    Text { text:modelData.v; color:Theme.accent; font.family:"Consolas"; font.pixelSize:15; font.bold:true }
                                }
                            } }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:570; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مصفوفة الأدلة":"EVIDENCE MATRIX"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"TRACEABLE SNAPSHOT"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:46; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:7
                            Text { text:"EVIDENCE CHAIN"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                            Item { Layout.fillWidth:true }
                            Text { text:"SCENARIO  →  TELEMETRY  →  HEALTH  →  REPORT"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                        }
                    }
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"أدلة القنوات":"CHANNEL EVIDENCE"; color:Theme.silver; font.pixelSize:8; font.bold:true; Layout.fillWidth:true }
                        Text { text:page.validSensors()+" / "+cockpit.sensorCount+" VALID"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:5; rowSpacing:5
                        Repeater { model:cockpit.sensorRows
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:47; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:6
                                    Rectangle { width:3; height:24; color:modelData.valid?Theme.accent:Theme.red }
                                    ColumnLayout { Layout.fillWidth:true; spacing:0
                                        Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.platinum:Theme.red; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                                    }
                                    Text { text:modelData.valid?"PASS":"FAIL"; color:modelData.valid?Theme.silver:Theme.red; font.family:"Consolas"; font.pixelSize:7 }
                                }
                            }
                        }
                    }
                    Text { text:cockpit.rtl?"أحداث الأدلة الأخيرة":"RECENT EVIDENCE EVENTS"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                    ListView { Layout.fillWidth:true; Layout.preferredHeight:104; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:30; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:modelData.time; color:Theme.muted; Layout.preferredWidth:76; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.source; color:Theme.accent; Layout.preferredWidth:62; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:7 }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:38; color:Theme.panel2; border.color:page.passCount()===6?Theme.accent:Theme.amber; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:7
                            Text { text:page.passCount()===6?"ALL SIX RUNTIME GATES SATISFIED":"RUNTIME EVIDENCE REQUIRES ATTENTION"; color:page.passCount()===6?Theme.platinum:Theme.amber; font.family:"Consolas"; font.pixelSize:8; font.bold:true; Layout.fillWidth:true }
                            Text { text:"TRAINING ONLY"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                        }
                    }
                }
            }
        }
    }
}
