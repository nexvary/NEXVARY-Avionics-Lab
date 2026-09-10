import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function rowById(rows,id){ for(var i=0;i<rows.length;++i) if(rows[i].id===id) return rows[i]; return ({"value":0,"unit":"","valid":false}) }
    function sensor(id){ return rowById(cockpit.sensorRows,id) }
    function fmt(id,d){ var s=sensor(id); return Number(s.value).toFixed(d)+" "+s.unit }
    function telemetryQuality(){ if(cockpit.sensorRows.length===0)return 0; var ok=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid)++ok; return Math.round(ok*100/cockpit.sensorRows.length) }
    function readiness(){ return Math.max(0,Math.round((cockpit.twinNominalCount*100/Math.max(1,cockpit.twinRows.length))-cockpit.activeAlertCount*5)) }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        GridLayout { Layout.fillWidth:true; Layout.preferredHeight:88; columns:6; columnSpacing:6
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"جاهزية النظام":"SYSTEM READINESS";value:page.readiness()+"%";subtitle:cockpit.activeAlertCount===0?"NOMINAL":"ATTENTION";iconText:"SYS";accent:Theme.accent}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"التنبيهات":"ACTIVE ALERTS";value:String(cockpit.activeAlertCount);subtitle:"EVENT CORRELATION";iconText:"ALT";accent:cockpit.activeAlertCount===0?Theme.accent:Theme.amber}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"ضمان التشغيل":"RUNTIME ASSURANCE";value:(cockpit.twinFaultCount===0&&cockpit.activeAlertCount===0)?"READY":"CHECK";subtitle:"LIVE EVIDENCE";iconText:"VER";accent:Theme.accent}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"الإطارات المسجلة":"RECORDED FRAMES";value:String(cockpit.recordedFrames);subtitle:"SESSION BUFFER";iconText:"REC";accent:Theme.accent}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"سلامة القياسات":"TELEMETRY HEALTH";value:page.telemetryQuality()+"%";subtitle:"DATA QUALITY";iconText:"TEL";accent:Theme.accent}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"التوأم الرقمي":"DIGITAL TWIN";value:cockpit.twinFaultCount===0?"SYNC":"DEG";subtitle:cockpit.twinNominalCount+" / "+cockpit.twinRows.length+" NOMINAL";iconText:"TWN";accent:Theme.accent}
        }

        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:455; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true; Layout.preferredHeight:24
                        Text { text:cockpit.rtl?"نظرة عامة على أنظمة المنصة / التوأم الرقمي":"PLATFORM SYSTEMS OVERVIEW / DIGITAL TWIN"; color:Theme.platinum; font.pixelSize:11; font.bold:true; Layout.fillWidth:true; font.letterSpacing:.5 }
                        Text { text:cockpit.twinFaultCount===0?"5 SUBSYSTEMS  /  LIVE SYNC":"DEGRADED"; color:cockpit.twinFaultCount===0?Theme.accent:Theme.amber; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Item { Layout.fillWidth:true; Layout.fillHeight:true
                        AircraftSchematic { anchors.centerIn:parent; width:parent.width*.62; height:parent.height*.92; subsystemRows:cockpit.twinRows }
                        Repeater { model:cockpit.twinRows
                            delegate: Rectangle { required property int index; required property var modelData; width:176; height:58; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                                x:index%2===0?8:parent.width-width-8; y:10+Math.floor(index/2)*72
                                RowLayout { anchors.fill:parent; anchors.margins:7
                                    Rectangle { width:4; height:32; color:Theme.stateColor(modelData.state) }
                                    ColumnLayout { Layout.fillWidth:true; spacing:1
                                        Text { text:modelData.label.toUpperCase(); color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:"CH "+modelData.valid+"/"+modelData.expected+"   ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                    ColumnLayout { spacing:0
                                        Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                                        Text { text:modelData.state; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                }
                            }
                        }
                        Rectangle { anchors.left:parent.left; anchors.right:parent.right; anchors.bottom:parent.bottom; height:29; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:"PLATFORM  NEXVARY 1700 (SIM)"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                                Item { Layout.fillWidth:true }
                                Text { text:"CHANNELS "+cockpit.sensorCount+"   •   EVENTS "+cockpit.eventCount+"   •   FRAMES "+cockpit.recordedFrames; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:620; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"شاشة العرض الرئيسية":"PRIMARY FLIGHT DISPLAY / MFD"; color:Theme.platinum; font.pixelSize:11; font.bold:true; Layout.fillWidth:true }
                        Text { text:"ATTITUDE / SYNTHETIC"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:5
                        MfdTape { Layout.preferredWidth:88; Layout.fillHeight:true; title:"ALT"; currentValue:page.sensor("altitude_m").value; unit:page.sensor("altitude_m").unit; majorStep:100; decimals:0; accent:Theme.accent }
                        AttitudeIndicator { Layout.fillWidth:true; Layout.fillHeight:true; pitch:page.sensor("imu_pitch_deg").value; roll:page.sensor("imu_roll_deg").value }
                        MfdTape { Layout.preferredWidth:88; Layout.fillHeight:true; title:"SPD"; currentValue:page.sensor("airspeed_kph").value; unit:page.sensor("airspeed_kph").unit; majorStep:20; decimals:0; accent:Theme.accent }
                        ColumnLayout { Layout.preferredWidth:132; Layout.fillHeight:true; spacing:4
                            MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"PWR BUS";value:page.fmt("bus_voltage_v",1);accent:Theme.accent}
                            MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"CPU TEMP";value:page.fmt("cpu_temp_c",1);accent:Theme.accent}
                            MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"HYD PRESS";value:page.fmt("hydraulic_pressure_pct",0);accent:Theme.accent}
                            MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"FUEL LEVEL";value:page.fmt("fuel_level_pct",0);accent:Theme.accent}
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:30; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:5
                            Text { text:"PITCH  "+Number(page.sensor("imu_pitch_deg").value).toFixed(1)+"°"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                            Text { text:"ROLL  "+Number(page.sensor("imu_roll_deg").value).toFixed(1)+"°"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                            Item { Layout.fillWidth:true }
                            Text { text:"ALERTS  "+cockpit.activeAlertCount; color:cockpit.activeAlertCount?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                        }
                    }
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:205; spacing:7
            Rectangle { Layout.preferredWidth:390; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:3
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"الأحداث الأخيرة / المترابطة":"RECENT / CORRELATED EVENTS"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:String(cockpit.eventCount); color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:30; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:modelData.time; color:Theme.muted; Layout.preferredWidth:66; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.silver); Layout.preferredWidth:48; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                Text { text:modelData.source; color:Theme.accent; Layout.preferredWidth:55; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:7 }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:3
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مصفوفة القنوات الحية":"LIVE CHANNEL MATRIX"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:page.telemetryQuality()+"% CHANNEL HEALTH"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:4; rowSpacing:4
                        Repeater { model:cockpit.sensorRows
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:5
                                    Rectangle { width:3; height:22; color:modelData.valid?Theme.accent:Theme.red }
                                    Text { text:modelData.id; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.platinum:Theme.red; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:270; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    Text { text:cockpit.rtl?"التحكم في السيناريو":"SCENARIO CONTROL"; color:Theme.platinum; font.pixelSize:9; font.bold:true }
                    Text { text:cockpit.scenario.toUpperCase(); color:Theme.accent; font.family:"Consolas"; font.pixelSize:18; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                    GridLayout { Layout.fillWidth:true; columns:2; columnSpacing:5
                        MetricBox { Layout.fillWidth:true; Layout.preferredHeight:50; label:"TICK"; value:String(cockpit.tick); accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.preferredHeight:50; label:"FRAMES"; value:String(cockpit.recordedFrames); accent:Theme.accent }
                    }
                    Item { Layout.fillHeight:true }
                    MinisterialButton { Layout.fillWidth:true; text:cockpit.text("reset"); onClicked:cockpit.resetLab() }
                }
            }
            PerformancePanel { Layout.preferredWidth:360; Layout.fillHeight:true }
        }
    }
}
