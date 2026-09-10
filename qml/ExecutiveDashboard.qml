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
        GridLayout {
            Layout.fillWidth:true; Layout.preferredHeight:82; Layout.minimumHeight:82; Layout.maximumHeight:82
            columns:6; columnSpacing:6; rowSpacing:0
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"جاهزية النظام":"SYSTEM READINESS";value:page.readiness()+"%";subtitle:cockpit.activeAlertCount===0?"NOMINAL":"ATTENTION";iconText:"R";accent:cockpit.activeAlertCount===0?Theme.green:Theme.amber}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"التنبيهات":"ACTIVE ALERTS";value:String(cockpit.activeAlertCount);subtitle:"EVENT CORRELATION";iconText:"A";accent:cockpit.activeAlertCount===0?Theme.green:Theme.amber}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"التحقق التشغيلي":"RUNTIME ASSURANCE";value:(cockpit.twinFaultCount===0&&cockpit.activeAlertCount===0)?"READY":"CHECK";subtitle:"LIVE EVIDENCE";iconText:"V";accent:(cockpit.twinFaultCount===0&&cockpit.activeAlertCount===0)?Theme.green:Theme.amber}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"الإطارات المسجلة":"RECORDED FRAMES";value:String(cockpit.recordedFrames);subtitle:"SESSION BUFFER";iconText:"F";accent:Theme.cyan}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"سلامة القياسات":"TELEMETRY HEALTH";value:page.telemetryQuality()+"%";subtitle:"DATA QUALITY";iconText:"T";accent:page.telemetryQuality()===100?Theme.green:Theme.amber}
            StatusCard{Layout.fillWidth:true;Layout.fillHeight:true;title:cockpit.rtl?"التوأم الرقمي":"DIGITAL TWIN";value:cockpit.twinFaultCount===0?"SYNC":"DEG";subtitle:cockpit.twinNominalCount+" / "+cockpit.twinRows.length+" NOMINAL";iconText:"D";accent:cockpit.twinFaultCount===0?Theme.green:Theme.amber}
        }

        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:438; Layout.minimumHeight:360; spacing:7
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:"#030a0f"; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true; Layout.preferredHeight:22
                        Text { text:cockpit.rtl?"خريطة المنصة / ترابط الأنظمة":"PLATFORM SYSTEM MAP / DIGITAL TWIN"; color:Theme.silver; font.pixelSize:11; font.bold:true; Layout.fillWidth:true; font.letterSpacing:.5 }
                        Text { text:cockpit.twinFaultCount===0?"SYNCHRONIZED":"DEGRADED"; color:cockpit.twinFaultCount===0?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Item { Layout.fillWidth:true; Layout.fillHeight:true
                        Canvas { anchors.fill:parent; onPaint:{var c=getContext("2d");c.reset();c.strokeStyle=Theme.grid;c.lineWidth=1;for(var x=32;x<width;x+=32){c.beginPath();c.moveTo(x,0);c.lineTo(x,height);c.stroke();}for(var y=32;y<height;y+=32){c.beginPath();c.moveTo(0,y);c.lineTo(width,y);c.stroke();}} }
                        AircraftSchematic { anchors.centerIn:parent; width:parent.width*.58; height:parent.height*.91; subsystemRows:cockpit.twinRows }
                        Repeater { model:cockpit.twinRows
                            delegate: Rectangle { required property int index; required property var modelData; width:164; height:55; color:"#07151c"; border.color:Theme.stateColor(modelData.state); radius:Theme.radius
                                x:index%2===0?7:parent.width-width-7; y:7+Math.floor(index/2)*68
                                ColumnLayout { anchors.fill:parent; anchors.margins:6; spacing:0
                                    RowLayout { Layout.fillWidth:true
                                        Rectangle { width:4; height:25; color:Theme.stateColor(modelData.state) }
                                        Text { text:modelData.label.toUpperCase(); color:Theme.silver; font.pixelSize:8; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                                    }
                                    Text { text:modelData.state+"   CH "+modelData.valid+"/"+modelData.expected+"   ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                            }
                        }
                        Rectangle { anchors.left:parent.left; anchors.right:parent.right; anchors.bottom:parent.bottom; height:29; color:"#06141a"; border.color:Theme.border; radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:"SUBSYS "+cockpit.twinRows.length; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                                Text { text:"CHANNELS "+cockpit.sensorCount; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                                Text { text:"EVENTS "+cockpit.eventCount; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                                Text { text:"FRAMES "+cockpit.recordedFrames; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                                Item { Layout.fillWidth:true }
                                Text { text:"SYNTHETIC DATA BUS"; color:Theme.green; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:610; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"شاشة الطيران الرئيسية":"PRIMARY FLIGHT DISPLAY / MFD"; color:Theme.silver; font.pixelSize:11; font.bold:true; Layout.fillWidth:true }
                        Text { text:"ATT / SYNTHETIC"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:5
                        MfdTape { Layout.preferredWidth:92; Layout.fillHeight:true; title:cockpit.rtl?"الارتفاع":"ALT"; currentValue:page.sensor("altitude_m").value; unit:page.sensor("altitude_m").unit; majorStep:100; decimals:0; accent:Theme.cyan }
                        AttitudeIndicator { Layout.fillWidth:true; Layout.fillHeight:true; pitch:page.sensor("imu_pitch_deg").value; roll:page.sensor("imu_roll_deg").value }
                        MfdTape { Layout.preferredWidth:92; Layout.fillHeight:true; title:cockpit.rtl?"السرعة":"SPD"; currentValue:page.sensor("airspeed_kph").value; unit:page.sensor("airspeed_kph").unit; majorStep:20; decimals:0; accent:Theme.cyan }
                        ColumnLayout { Layout.preferredWidth:126; Layout.fillHeight:true; spacing:4
                            MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"PWR BUS";value:page.fmt("bus_voltage_v",1);accent:page.sensor("bus_voltage_v").valid?Theme.green:Theme.red}
                            MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"CPU TEMP";value:page.fmt("cpu_temp_c",1);accent:Theme.green}
                            MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"HYD";value:page.fmt("hydraulic_pressure_pct",0);accent:Theme.green}
                            MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"FUEL";value:page.fmt("fuel_level_pct",0);accent:Theme.green}
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:28; color:"#07151c"; border.color:Theme.border; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:5
                            Text { text:"PITCH "+Number(page.sensor("imu_pitch_deg").value).toFixed(1)+"°"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                            Text { text:"ROLL "+Number(page.sensor("imu_roll_deg").value).toFixed(1)+"°"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                            Item { Layout.fillWidth:true }
                            Text { text:"ALERT "+cockpit.activeAlertCount; color:cockpit.activeAlertCount?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                        }
                    }
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:188; spacing:7
            Rectangle { Layout.preferredWidth:330; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:3
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"الأحداث المرتبطة":"CORRELATED EVENTS"; color:Theme.silver; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:String(cockpit.eventCount); color:Theme.cyan; font.family:"Consolas"; font.pixelSize:9 }
                    }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:27; color:index%2?"#061219":"#08161d"
                            RowLayout { anchors.fill:parent; anchors.margins:5
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); Layout.preferredWidth:46; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                                Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:55; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:7 }
                            }
                        }
                    }
                }
            }
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:3
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"القنوات الحية":"LIVE CHANNEL MATRIX"; color:Theme.silver; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:page.telemetryQuality()+"% QUALITY"; color:page.telemetryQuality()===100?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:4; rowSpacing:4
                        Repeater { model:cockpit.sensorRows
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:"#07151c"; border.color:modelData.valid?"#1c4b3a":Theme.red; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:5
                                    Rectangle { width:3; height:20; color:modelData.valid?Theme.green:Theme.red }
                                    Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.cyan:Theme.red; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                Layout.preferredWidth:270; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                    Text { text:cockpit.rtl?"حالة السيناريو":"SCENARIO CONTROL"; color:Theme.silver; font.pixelSize:9; font.bold:true }
                    Text { text:cockpit.scenario.toUpperCase(); color:Theme.green; font.family:"Consolas"; font.pixelSize:19; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                    GridLayout { Layout.fillWidth:true; columns:2; columnSpacing:4; rowSpacing:4
                        MetricBox { Layout.fillWidth:true; Layout.preferredHeight:46; label:"TICK"; value:String(cockpit.tick); accent:Theme.cyan }
                        MetricBox { Layout.fillWidth:true; Layout.preferredHeight:46; label:"FRAMES"; value:String(cockpit.recordedFrames); accent:Theme.green }
                    }
                    Item { Layout.fillHeight:true }
                    MinisterialButton { Layout.fillWidth:true; text:cockpit.text("reset"); onClicked:cockpit.resetLab() }
                }
            }
            PerformancePanel { Layout.preferredWidth:365; Layout.fillHeight:true }
        }
    }
}
