import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function stateColor(active){ return active?Theme.amber:Theme.green }
    function observed(){ return cockpit.activeAlertCount>0 || cockpit.twinFaultCount>0 || cockpit.twinDegradedCount>0 }
    function recovered(){ return cockpit.activeTrainingFaultCount===0 && cockpit.eventCount>1 }

    ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:8
        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:62; color:Theme.panel; border.color:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                NavIcon { kind:"fault"; iconColor:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.silver; Layout.preferredWidth:24; Layout.preferredHeight:24 }
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"منضدة اختبار الأعطال والاستجابة":"FAULT INJECTION & RESPONSE WORKBENCH"; color:Theme.gold; font.pixelSize:16; font.bold:true }
                    Text { text:cockpit.rtl?"بروتوكول اختبار قابل للتدقيق: تجهيز ← حقن ← ملاحظة ← استعادة ← تحقق":"AUDITABLE TEST PROTOCOL: ARM → INJECT → OBSERVE → RECOVER → VERIFY"; color:Theme.muted; font.pixelSize:8; font.letterSpacing:.5 }
                }
                Text { text:"ACTIVE "+cockpit.activeTrainingFaultCount; color:cockpit.activeTrainingFaultCount?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:12; font.bold:true }
                MinisterialButton { text:cockpit.text("clear_faults"); enabled:cockpit.activeTrainingFaultCount>0; accent:Theme.amber; onClicked:cockpit.clearTrainingFaults() }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:64; spacing:4
            Repeater { model:[
                {"n":"01","t":"ARM","ok":true},
                {"n":"02","t":"INJECT","ok":cockpit.activeTrainingFaultCount>0},
                {"n":"03","t":"OBSERVE","ok":page.observed()},
                {"n":"04","t":"RECOVER","ok":page.recovered()},
                {"n":"05","t":"VERIFY","ok":page.recovered() && cockpit.activeAlertCount===0 && cockpit.twinFaultCount===0}
            ]; delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:modelData.ok?"#071b17":"#0b1216"; border.color:modelData.ok?Theme.green:Theme.border; radius:Theme.radius
                RowLayout { anchors.fill:parent; anchors.margins:8
                    Text { text:modelData.n; color:modelData.ok?Theme.green:Theme.muted; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
                    Text { text:modelData.t; color:modelData.ok?Theme.silver:Theme.muted; font.family:"Consolas"; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                    Text { text:modelData.ok?"✓":"—"; color:modelData.ok?Theme.green:Theme.muted; font.pixelSize:14 }
                }
            } }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
            Rectangle { Layout.preferredWidth:430; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                    Text { text:cockpit.rtl?"كتالوج حالات الاختبار":"TEST CONDITION CATALOG"; color:Theme.silver; font.pixelSize:10; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.presentationFaultPresets
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?"#061219":"#08161d"; border.color:modelData.active?Theme.amber:"#142832"; border.width:modelData.active?2:1; radius:Theme.radius
                            ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:2
                                RowLayout { Layout.fillWidth:true
                                    Rectangle { width:4; height:28; color:modelData.active?Theme.amber:Theme.cyan }
                                    ColumnLayout { Layout.fillWidth:true; spacing:0
                                        Text { text:modelData.label.toUpperCase(); color:Theme.text; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:modelData.sensor+" / "+modelData.mode; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                    Text { text:modelData.active?"INJECTED":"READY"; color:modelData.active?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                }
                                Text { text:modelData.detail; color:Theme.muted; font.pixelSize:8; wrapMode:Text.Wrap; Layout.fillWidth:true; Layout.fillHeight:true }
                                MinisterialButton { Layout.fillWidth:true; implicitHeight:28; text:modelData.active?cockpit.text("active"):cockpit.text("apply_fault"); checked:modelData.active; accent:Theme.amber; enabled:!modelData.active; onClicked:cockpit.applyTrainingFault(modelData.id) }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"دليل الاستجابة الزمني":"TIME-CORRELATED RESPONSE EVIDENCE"; color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"EVENTS "+cockpit.eventCount; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:34; color:index%2?"#061219":"#08161d"
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:modelData.time; color:Theme.silver; Layout.preferredWidth:86; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); Layout.preferredWidth:52; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:70; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:8 }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:355; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    Text { text:cockpit.rtl?"مصفوفة الاستجابة":"SYSTEM RESPONSE MATRIX"; color:Theme.gold; font.pixelSize:11; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?"#061219":"#08161d"; border.color:Theme.stateColor(modelData.state)
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Rectangle { width:4; height:24; color:Theme.stateColor(modelData.state) }
                                ColumnLayout { Layout.fillWidth:true; spacing:0
                                    Text { text:modelData.label; color:Theme.text; font.pixelSize:8; font.bold:true; elide:Text.ElideRight; Layout.fillWidth:true }
                                    Text { text:"CH "+modelData.valid+"/"+modelData.expected+"  ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                Text { text:modelData.state+"\n"+Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); horizontalAlignment:Text.AlignRight; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:64; color:"#07141a"; border.color:Theme.border; radius:Theme.radius
                        Text { anchors.fill:parent; anchors.margins:7; text:cockpit.rtl?"الهدف هو اختبار الاستجابة والاستعادة داخل المحاكاة فقط؛ لا توجد أوامر لعتاد أو طائرة حقيقية.":"TEST RESPONSE / RECOVERY IN SIMULATION ONLY. NO LIVE AIRCRAFT OR HARDWARE COMMAND PATH."; color:Theme.muted; wrapMode:Text.Wrap; font.pixelSize:7 }
                    }
                }
            }
        }
    }
}
