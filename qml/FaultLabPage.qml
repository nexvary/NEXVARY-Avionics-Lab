import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:8
        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:62; color:Theme.panel; border.color:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                NavIcon { kind:"fault"; iconColor:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.silver; Layout.preferredWidth:24; Layout.preferredHeight:24 }
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"مختبر حقن الأعطال التدريبية":"SYNTHETIC FAULT TEST CONSOLE"; color:Theme.gold; font.pixelSize:16; font.bold:true }
                    Text { text:cockpit.rtl?"حقن محدود وقابل للتدقيق — بيانات تدريبية فقط":"BOUNDED / AUDITABLE / TRAINING DATA ONLY"; color:Theme.muted; font.pixelSize:8; font.letterSpacing:.5 }
                }
                Text { text:"ACTIVE "+cockpit.activeTrainingFaultCount; color:cockpit.activeTrainingFaultCount?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:12; font.bold:true }
                MinisterialButton { text:cockpit.text("clear_faults"); enabled:cockpit.activeTrainingFaultCount>0; accent:Theme.amber; onClicked:cockpit.clearTrainingFaults() }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
            Rectangle {
                Layout.preferredWidth:470; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:4
                    Text { text:cockpit.rtl?"كتالوج الاختبارات":"FAULT PRESET CATALOG"; color:Theme.silver; font.pixelSize:10; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.presentationFaultPresets
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?"#071219":"#09171e"; border.color:modelData.active?Theme.amber:"#142832"; border.width:modelData.active?2:1; radius:Theme.radius
                            ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:2
                                RowLayout { Layout.fillWidth:true
                                    Rectangle { width:4; height:28; color:modelData.active?Theme.amber:Theme.cyan }
                                    ColumnLayout { Layout.fillWidth:true; spacing:0
                                        Text { text:modelData.label.toUpperCase(); color:Theme.text; font.pixelSize:10; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:modelData.sensor+" / "+modelData.mode; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                                    }
                                    Text { text:modelData.active?"INJECTED":"ARMED"; color:modelData.active?Theme.amber:Theme.muted; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                                }
                                Text { text:modelData.detail; color:Theme.muted; font.pixelSize:8; wrapMode:Text.Wrap; Layout.fillWidth:true; Layout.fillHeight:true }
                                MinisterialButton { Layout.fillWidth:true; implicitHeight:30; text:modelData.active?cockpit.text("active"):cockpit.text("apply_fault"); checked:modelData.active; accent:Theme.amber; enabled:!modelData.active; onClicked:cockpit.applyTrainingFault(modelData.id) }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"سجل الأدلة والاستجابة":"INJECTION / RESPONSE EVIDENCE"; color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"EVENTS "+cockpit.eventCount; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:35; color:index%2?"#071219":"#09171e"
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); Layout.preferredWidth:55; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                                Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:75; font.family:"Consolas"; font.pixelSize:8 }
                                Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:8 }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:300; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:6
                    Text { text:cockpit.rtl?"حالة الاختبار":"TEST STATE"; color:Theme.gold; font.pixelSize:12; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Text { text:"SCENARIO"; color:Theme.muted; font.pixelSize:8 }
                    Text { text:cockpit.scenario; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:15; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                    Text { text:"ACTIVE INJECTIONS"; color:Theme.muted; font.pixelSize:8 }
                    Text { text:String(cockpit.activeTrainingFaultCount); color:cockpit.activeTrainingFaultCount?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:25; font.bold:true }
                    Text { text:"SYSTEM ALERTS"; color:Theme.muted; font.pixelSize:8 }
                    Text { text:String(cockpit.activeAlertCount); color:cockpit.activeAlertCount?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:25; font.bold:true }
                    Text { text:"TWIN FAULTS"; color:Theme.muted; font.pixelSize:8 }
                    Text { text:String(cockpit.twinFaultCount); color:cockpit.twinFaultCount?Theme.red:Theme.green; font.family:"Consolas"; font.pixelSize:25; font.bold:true }
                    Item { Layout.fillHeight:true }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:72; color:"#07141a"; border.color:Theme.border; radius:Theme.radius
                        Text { anchors.fill:parent; anchors.margins:8; text:cockpit.rtl?"لا يتم إرسال أي أوامر إلى طائرة أو عتاد حقيقي. الاختبارات اصطناعية داخل المحاكاة.":"NO LIVE AIRCRAFT OR HARDWARE COMMANDS. SYNTHETIC SIMULATION ONLY."; color:Theme.muted; wrapMode:Text.Wrap; font.pixelSize:8 }
                    }
                }
            }
        }
    }
}
