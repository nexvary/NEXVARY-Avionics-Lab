import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true
    function rowById(rows,id){ for(var i=0;i<rows.length;++i) if(rows[i].id===id) return rows[i]; return ({"value":0,"unit":"","valid":false}) }
    function sensor(id){ return rowById(cockpit.sensorRows,id) }
    function fmt(id,d){ var s=sensor(id); return Number(s.value).toFixed(d)+" "+s.unit }
    function telemetryQuality(){ if(cockpit.sensorRows.length===0)return 0; var ok=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid)++ok; return Math.round(ok*100/cockpit.sensorRows.length) }
    function readiness(){ return Math.max(0,Math.round((cockpit.twinNominalCount*100/Math.max(1,cockpit.twinRows.length))-cockpit.activeAlertCount*5)) }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        // Simulator status ribbon: compact, factual, non-decorative.
        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 82
            columns: 6
            columnSpacing: 6
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:cockpit.rtl?"حالة المحاكاة":"SIMULATION"; value:"RUNNING"; subtitle:"SYNTHETIC / OFFLINE"; iconText:"SIM"; accent:Theme.accent }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:cockpit.rtl?"السيناريو":"SCENARIO"; value:cockpit.scenario.toUpperCase(); subtitle:"DETERMINISTIC RUN"; iconText:"SCN"; accent:Theme.accent }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:cockpit.rtl?"الارتفاع":"ALTITUDE"; value:Number(page.sensor("altitude_m").value).toFixed(0)+" m"; subtitle:"SYNTHETIC SENSOR"; iconText:"ALT"; accent:Theme.accent }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:cockpit.rtl?"السرعة الجوية":"AIRSPEED"; value:Number(page.sensor("airspeed_kph").value).toFixed(0)+" km/h"; subtitle:"SYNTHETIC SENSOR"; iconText:"SPD"; accent:Theme.accent }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:cockpit.rtl?"جودة البيانات":"DATA QUALITY"; value:page.telemetryQuality()+"%"; subtitle:cockpit.sensorCount+" CHANNELS"; iconText:"DAT"; accent:Theme.accent }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:cockpit.rtl?"جاهزية الأنظمة":"SYSTEM HEALTH"; value:page.readiness()+"%"; subtitle:cockpit.activeAlertCount===0?"NOMINAL":"ATTENTION"; iconText:"SYS"; accent:cockpit.activeAlertCount===0?Theme.accent:Theme.amber }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 485
            spacing: 7

            // Platform/system synoptic — primary engineering view.
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 28
                        Text { text:cockpit.rtl?"المخطط المنظومي للمنصة":"AIRFRAME / AVIONICS SYSTEM SYNOPTIC"; color:Theme.platinum; font.pixelSize:11; font.bold:true; Layout.fillWidth:true; font.letterSpacing:.6 }
                        Text { text:"DATA BUS  A/B   •   TWIN SYNC"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        AircraftSchematic {
                            anchors.centerIn: parent
                            width: Math.min(parent.width*0.68, 620)
                            height: parent.height*0.94
                            subsystemRows: cockpit.twinRows
                        }

                        Repeater {
                            model: cockpit.twinRows
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: 182
                                height: 62
                                color: Theme.panel2
                                border.color: Theme.border
                                radius: Theme.radius
                                x: index%2===0 ? 8 : parent.width-width-8
                                y: 12 + Math.floor(index/2)*76

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    Rectangle { width:3; height:36; color:Theme.stateColor(modelData.state) }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 1
                                        Text { text:modelData.label.toUpperCase(); color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:"CH "+modelData.valid+" / "+modelData.expected; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                                        Text { text:"ISSUES "+modelData.issues; color:modelData.issues?Theme.amber:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                    ColumnLayout {
                                        spacing: 0
                                        Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                                        Text { text:modelData.state; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 30
                            color: Theme.panel2
                            border.color: Theme.border
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                Text { text:"PLATFORM  NXV-SIM-01"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:"BUS STATUS  SYNCHRONIZED"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                                Item { Layout.fillWidth:true }
                                Text { text:"SUBSYSTEMS "+cockpit.twinRows.length+"  •  FRAMES "+cockpit.recordedFrames; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                            }
                        }
                    }
                }
            }

            // PFD / primary flight simulation instrument.
            Rectangle {
                Layout.preferredWidth: 430
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text:"PRIMARY FLIGHT DISPLAY"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"PFD / SIM"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 4
                        MfdTape { Layout.preferredWidth:74; Layout.fillHeight:true; title:"ALT"; currentValue:page.sensor("altitude_m").value; unit:"m"; majorStep:100; decimals:0; accent:Theme.accent }
                        AttitudeIndicator { Layout.fillWidth:true; Layout.fillHeight:true; pitch:page.sensor("imu_pitch_deg").value; roll:page.sensor("imu_roll_deg").value }
                        MfdTape { Layout.preferredWidth:74; Layout.fillHeight:true; title:"SPD"; currentValue:page.sensor("airspeed_kph").value; unit:"km/h"; majorStep:20; decimals:0; accent:Theme.accent }
                    }
                    Rectangle {
                        Layout.fillWidth:true
                        Layout.preferredHeight:42
                        color:Theme.panel2
                        border.color:Theme.border
                        radius:Theme.radius
                        RowLayout {
                            anchors.fill:parent
                            anchors.margins:6
                            Text { text:"PITCH  "+Number(page.sensor("imu_pitch_deg").value).toFixed(1)+"°"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                            Text { text:"ROLL  "+Number(page.sensor("imu_roll_deg").value).toFixed(1)+"°"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                            Item { Layout.fillWidth:true }
                            Text { text:"T+ "+cockpit.tick; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                        }
                    }
                }
            }

            // EICAS-like synthetic systems monitor.
            Rectangle {
                Layout.preferredWidth: 310
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مراقبة الأنظمة":"SYSTEMS MONITOR"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"EICAS / SYN"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }

                    Repeater {
                        model: cockpit.twinRows
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            Layout.fillWidth:true
                            Layout.fillHeight:true
                            color:index%2?Theme.panel2:Theme.panel
                            border.color:Theme.borderSoft
                            radius:Theme.radius
                            clip: true
                            RowLayout {
                                anchors.fill:parent
                                anchors.margins:6
                                Rectangle { width:4; height:26; color:Theme.stateColor(modelData.state) }
                                ColumnLayout {
                                    Layout.fillWidth:true
                                    Layout.minimumWidth:0
                                    spacing:0
                                    Text { text:modelData.label; color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true; Layout.minimumWidth:0; elide:Text.ElideRight }
                                    Text { text:modelData.state; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                Rectangle {
                                    Layout.preferredWidth:82
                                    height:7
                                    color:Theme.borderSoft
                                    radius:1
                                    Rectangle { height:parent.height; width:parent.width*Math.max(0,Math.min(1,Number(modelData.health)/100)); color:Theme.stateColor(modelData.state); radius:1 }
                                }
                                Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.platinum; font.family:"Consolas"; font.pixelSize:8; font.bold:true; Layout.preferredWidth:34; horizontalAlignment:Text.AlignRight }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    GridLayout {
                        Layout.fillWidth:true
                        Layout.preferredHeight:150
                        columns:2
                        columnSpacing:4
                        rowSpacing:4
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"PWR BUS"; value:page.fmt("bus_voltage_v",1); accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"CPU TEMP"; value:page.fmt("cpu_temp_c",1); accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"HYD"; value:page.fmt("hydraulic_pressure_pct",0); accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"FUEL"; value:page.fmt("fuel_level_pct",0); accent:Theme.accent }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth:true
            Layout.preferredHeight:235
            spacing:7

            Rectangle {
                Layout.preferredWidth:390
                Layout.fillHeight:true
                color:Theme.panel
                border.color:Theme.border
                radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent
                    anchors.margins:7
                    spacing:3
                    RowLayout {
                        Layout.fillWidth:true
                        Text { text:cockpit.rtl?"سجل الأحداث المباشر":"LIVE EVENT LOG"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:String(cockpit.eventCount); color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView {
                        Layout.fillWidth:true
                        Layout.fillHeight:true
                        model:cockpit.eventRows
                        clip:true
                        spacing:1
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            width:ListView.view.width
                            height:32
                            color:index%2?Theme.panel2:Theme.panel
                            RowLayout {
                                anchors.fill:parent
                                anchors.margins:5
                                Text { text:modelData.time; color:Theme.muted; Layout.preferredWidth:62; font.family:"Consolas"; font.pixelSize:7 }
                                Rectangle { width:3; height:18; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.accent) }
                                Text { text:modelData.source; color:Theme.accent; Layout.preferredWidth:54; font.family:"Consolas"; font.pixelSize:7 }
                                Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:7 }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth:true
                Layout.fillHeight:true
                color:Theme.panel
                border.color:Theme.border
                radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent
                    anchors.margins:7
                    spacing:3
                    RowLayout {
                        Layout.fillWidth:true
                        Text { text:cockpit.rtl?"اتجاهات القياسات":"ENGINEERING TELEMETRY"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:"LIVE / "+cockpit.recordedFrames+" FRAMES"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:cockpit.performanceSeries; cursorVisible:false }
                }
            }

            Rectangle {
                Layout.preferredWidth:330
                Layout.fillHeight:true
                color:Theme.panel
                border.color:Theme.border
                radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent
                    anchors.margins:7
                    spacing:3
                    RowLayout {
                        Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مصفوفة القنوات":"CHANNEL MATRIX"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:page.telemetryQuality()+"%"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    GridLayout {
                        Layout.fillWidth:true
                        Layout.fillHeight:true
                        columns:2
                        columnSpacing:3
                        rowSpacing:3
                        Repeater {
                            model:cockpit.sensorRows
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth:true
                                Layout.fillHeight:true
                                color:Theme.panel2
                                border.color:Theme.borderSoft
                                radius:Theme.radius
                                ColumnLayout {
                                    anchors.fill:parent
                                    anchors.margins:5
                                    spacing:1
                                    Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.platinum:Theme.red; font.family:"Consolas"; font.pixelSize:8; font.bold:true; Layout.fillWidth:true }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
