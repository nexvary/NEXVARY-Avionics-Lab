import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function nominalPct(){ return Math.round(cockpit.twinNominalCount*100/Math.max(1,cockpit.twinRows.length)) }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:82; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:1
                    Text { text:cockpit.rtl?"المخطط التشغيلي للأنظمة":"SYSTEMS OPERATIONAL SYNOPTIC"; color:Theme.platinum; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"مراقبة صحة الأنظمة، الأدلة، وترابط التوأم الرقمي":"SUBSYSTEM HEALTH / EVIDENCE / DIGITAL-TWIN CORRELATION"; color:Theme.muted; font.pixelSize:8 }
                }
            }
            StatusCard { Layout.preferredWidth:210; Layout.fillHeight:true; title:"SYSTEM HEALTH"; value:page.nominalPct()+"%"; subtitle:"NOMINAL COVERAGE"; iconText:"SYS"; accent:Theme.accent }
            StatusCard { Layout.preferredWidth:190; Layout.fillHeight:true; title:"ACTIVE ALERTS"; value:String(cockpit.activeAlertCount); subtitle:"CORRELATED"; iconText:"ALT"; accent:cockpit.activeAlertCount?Theme.amber:Theme.accent }
            StatusCard { Layout.preferredWidth:220; Layout.fillHeight:true; title:"DIGITAL TWIN"; value:cockpit.twinFaultCount===0?"SYNCHRONIZED":"REVIEW"; subtitle:"STATE AGREEMENT"; iconText:"TWN"; accent:cockpit.twinFaultCount===0?Theme.accent:Theme.amber }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"ترابط الأنظمة":"SYSTEM INTERCONNECT"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"NOM "+cockpit.twinNominalCount+"   DEG "+cockpit.twinDegradedCount+"   FLT "+cockpit.twinFaultCount; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Item { Layout.fillWidth:true; Layout.fillHeight:true
                        AircraftSchematic { anchors.centerIn:parent; width:parent.width*.62; height:parent.height*.90; subsystemRows:cockpit.twinRows }
                        Repeater { model:cockpit.twinRows
                            delegate: Rectangle { required property int index; required property var modelData; width:188; height:64; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                                x:index%2===0?12:parent.width-width-12
                                y:18+Math.floor(index/2)*78
                                RowLayout { anchors.fill:parent; anchors.margins:7
                                    Rectangle { width:4; height:34; color:Theme.stateColor(modelData.state) }
                                    ColumnLayout { Layout.fillWidth:true; spacing:1
                                        Text { text:modelData.label.toUpperCase(); color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:"CH "+modelData.valid+"/"+modelData.expected+"   ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                    ColumnLayout { spacing:0
                                        Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:12; font.bold:true }
                                        Text { text:modelData.state; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:500; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مصفوفة صحة الأنظمة":"SUBSYSTEM HEALTH MATRIX"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:cockpit.twinRows.length+" SUBSYSTEMS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    RowLayout { Layout.fillWidth:true; Layout.preferredHeight:24
                        Text { text:"SUBSYSTEM"; color:Theme.muted; font.pixelSize:7; Layout.fillWidth:true }
                        Text { text:"CHANNELS"; color:Theme.muted; font.pixelSize:7; Layout.preferredWidth:80 }
                        Text { text:"HEALTH"; color:Theme.muted; font.pixelSize:7; Layout.preferredWidth:64; horizontalAlignment:Text.AlignRight }
                        Text { text:"STATE"; color:Theme.muted; font.pixelSize:7; Layout.preferredWidth:80; horizontalAlignment:Text.AlignRight }
                    }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?Theme.panel2:Theme.panel; border.color:Theme.borderSoft; radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:7
                                Rectangle { width:3; height:26; color:Theme.stateColor(modelData.state) }
                                Text { text:modelData.label; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                Text { text:modelData.valid+" / "+modelData.expected; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8; Layout.preferredWidth:80 }
                                Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.platinum; font.family:"Consolas"; font.pixelSize:10; font.bold:true; Layout.preferredWidth:64; horizontalAlignment:Text.AlignRight }
                                Text { text:modelData.state; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:8; font.bold:true; Layout.preferredWidth:80; horizontalAlignment:Text.AlignRight }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:82; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:8; spacing:6
                            MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"NOMINAL"; value:String(cockpit.twinNominalCount); accent:Theme.accent }
                            MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"DEGRADED"; value:String(cockpit.twinDegradedCount); accent:cockpit.twinDegradedCount?Theme.amber:Theme.silver }
                            MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"FAULT"; value:String(cockpit.twinFaultCount); accent:cockpit.twinFaultCount?Theme.red:Theme.silver }
                        }
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:46; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:8
                Text { text:"HEALTH EVIDENCE"; color:Theme.silver; font.pixelSize:8; font.bold:true }
                Text { text:"CHANNELS "+cockpit.sensorCount; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                Text { text:"EVENTS "+cockpit.eventCount; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                Text { text:"FRAMES "+cockpit.recordedFrames; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                Item { Layout.fillWidth:true }
                Text { text:cockpit.rtl?"تدريب ومحاكاة فقط":"TRAINING / SIMULATION ONLY"; color:Theme.muted; font.pixelSize:7 }
            }
        }
    }
}
