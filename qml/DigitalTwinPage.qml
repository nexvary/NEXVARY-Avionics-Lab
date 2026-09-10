import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:82; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:1
                    Text { text:cockpit.rtl?"منظومة التوأم الرقمي":"DIGITAL TWIN SYSTEMS VIEW"; color:Theme.platinum; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"ترابط الأنظمة، دمج البيانات، ومراقبة حالة النموذج":"SYSTEM INTERCONNECT / DATA FUSION / MODEL STATE"; color:Theme.muted; font.pixelSize:8 }
                }
            }
            StatusCard { Layout.preferredWidth:210; Layout.fillHeight:true; title:"NOMINAL"; value:String(cockpit.twinNominalCount); subtitle:"SUBSYSTEMS"; iconText:"NOM"; accent:Theme.accent }
            StatusCard { Layout.preferredWidth:210; Layout.fillHeight:true; title:"DEGRADED"; value:String(cockpit.twinDegradedCount); subtitle:"REQUIRES REVIEW"; iconText:"DEG"; accent:cockpit.twinDegradedCount?Theme.amber:Theme.silver }
            StatusCard { Layout.preferredWidth:190; Layout.fillHeight:true; title:"FAULT"; value:String(cockpit.twinFaultCount); subtitle:"MODEL FAULTS"; iconText:"FLT"; accent:cockpit.twinFaultCount?Theme.red:Theme.silver }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.preferredWidth:390; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    Text { text:cockpit.rtl?"مجموعة الأنظمة أ":"SYSTEM GROUP A"; color:Theme.platinum; font.pixelSize:10; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property int index; required property var modelData; visible:index%2===0; Layout.fillWidth:true; Layout.fillHeight:visible; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:8
                                Rectangle { width:4; height:32; color:Theme.stateColor(modelData.state) }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label.toUpperCase(); color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:"CH "+modelData.valid+"/"+modelData.expected+"   ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                ColumnLayout { spacing:0
                                    Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                                    Text { text:modelData.state; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                                }
                            }
                        }
                    }
                    Item { Layout.fillHeight:true }
                }
            }

            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:"PLATFORM DIGITAL TWIN"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:cockpit.twinFaultCount===0?"SYNCHRONIZED":"DEGRADED"; color:cockpit.twinFaultCount===0?Theme.accent:Theme.amber; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Item { Layout.fillWidth:true; Layout.fillHeight:true
                        AircraftSchematic { anchors.centerIn:parent; width:parent.width*.78; height:parent.height*.90; subsystemRows:cockpit.twinRows }
                        Rectangle { anchors.left:parent.left; anchors.right:parent.right; anchors.bottom:parent.bottom; height:34; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Text { text:"DATA FUSION"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                                Text { text:cockpit.sensorCount+" CHANNELS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                                Text { text:cockpit.twinRows.length+" SUBSYSTEMS"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                                Item { Layout.fillWidth:true }
                                Text { text:"STATE AGREEMENT / SYNTHETIC"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:390; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    Text { text:cockpit.rtl?"مجموعة الأنظمة ب":"SYSTEM GROUP B"; color:Theme.platinum; font.pixelSize:10; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property int index; required property var modelData; visible:index%2===1; Layout.fillWidth:true; Layout.fillHeight:visible; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:8
                                Rectangle { width:4; height:32; color:Theme.stateColor(modelData.state) }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label.toUpperCase(); color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:"CH "+modelData.valid+"/"+modelData.expected+"   ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                ColumnLayout { spacing:0
                                    Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                                    Text { text:modelData.state; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                                }
                            }
                        }
                    }
                    Item { Layout.fillHeight:true }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:92; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                            Text { text:"MODEL STATUS"; color:Theme.muted; font.pixelSize:7 }
                            Text { text:cockpit.twinFaultCount===0?"SYNCHRONIZED":"REVIEW REQUIRED"; color:cockpit.twinFaultCount===0?Theme.accent:Theme.amber; font.pixelSize:15; font.bold:true }
                            Text { text:"NOM "+cockpit.twinNominalCount+"  •  DEG "+cockpit.twinDegradedCount+"  •  FLT "+cockpit.twinFaultCount; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                        }
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:42; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:7
                Text { text:"DIGITAL TWIN EVIDENCE"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                Text { text:"FRAMES "+cockpit.recordedFrames; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                Text { text:"EVENTS "+cockpit.eventCount; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                Item { Layout.fillWidth:true }
                Text { text:cockpit.rtl?"بيانات محاكاة تدريبية فقط":"SYNTHETIC TRAINING DATA ONLY"; color:Theme.muted; font.pixelSize:7 }
            }
        }
    }
}
