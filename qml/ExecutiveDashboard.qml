import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function rowById(rows,id){ for(var i=0;i<rows.length;++i) if(rows[i].id===id) return rows[i]; return ({"value":0,"unit":"","valid":false}) }
    function sensor(id){ return rowById(cockpit.sensorRows,id) }
    function fmt(id,d){ var s=sensor(id); return Number(s.value).toFixed(d)+" "+s.unit }
    function telemetryQuality(){ if(cockpit.sensorRows.length===0)return 0; var ok=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid)++ok; return Math.round(ok*100/cockpit.sensorRows.length) }
    function readiness(){ return Math.max(0,Math.round((cockpit.twinNominalCount*100/Math.max(1,cockpit.twinRows.length))-cockpit.activeAlertCount*4)) }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 78
            color: Theme.panel
            border.color: Theme.border
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 9
                spacing: 7
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    Text { text: cockpit.rtl ? "مركز القيادة الهندسي" : "ENGINEERING COMMAND OVERVIEW"; color: Theme.platinum; font.pixelSize: 16; font.bold: true }
                    Text { text: cockpit.activePlatformName.toUpperCase()+"  /  "+cockpit.activePlatformCategory+"  /  "+cockpit.scenario.toUpperCase(); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                    Text { text: cockpit.rtl ? "ملخص تشغيلي للإدارة العليا — بيانات صناعية ومحاكاة فقط" : "EXECUTIVE SYSTEM SYNOPSIS — SYNTHETIC / OFFLINE / TRAINING ONLY"; color: Theme.muted; font.pixelSize: 7 }
                }
                Repeater {
                    model: [
                        {"k":"READINESS","v":page.readiness()+"%","s":cockpit.activeAlertCount===0?"NOMINAL":"ATTENTION","c":cockpit.activeAlertCount===0?Theme.green:Theme.amber},
                        {"k":"DATA QUALITY","v":page.telemetryQuality()+"%","s":cockpit.sensorCount+" CHANNELS","c":Theme.accent},
                        {"k":"DIAGNOSTICS","v":String(cockpit.diagnosticFindingCount),"s":"HEALTH "+cockpit.diagnosticHealthScore,"c":cockpit.diagnosticFaultCount?Theme.red:Theme.accent},
                        {"k":"EVIDENCE","v":String(cockpit.recordedFrames),"s":"FRAMES / "+cockpit.eventCount+" EVENTS","c":Theme.silver}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.preferredWidth: 150
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: Theme.border
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 7; spacing: 0
                            Text { text:modelData.k; color:Theme.muted; font.pixelSize:6; font.bold:true }
                            Text { text:modelData.v; color:modelData.c; font.family:"Consolas"; font.pixelSize:16; font.bold:true }
                            Text { text:modelData.s; color:Theme.silver; font.family:"Consolas"; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 470
            spacing: 7

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
                        Text { text: cockpit.rtl ? "المخطط المنظومي للمنصة" : "PLATFORM SYSTEM SYNOPTIC"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text { text: Theme.platformCode(cockpit.activePlatformId)+" / DIGITAL TWIN / BUS A-B"; color: Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        AircraftSchematic {
                            anchors.centerIn: parent
                            width: Math.min(parent.width*.70, 600)
                            height: parent.height*.94
                            platformId: cockpit.activePlatformId
                            subsystemRows: cockpit.twinRows
                        }
                        Repeater {
                            model: cockpit.twinRows
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: 174; height: 58
                                color: Theme.panel2
                                border.color: Theme.border
                                radius: Theme.radius
                                x: index%2===0 ? 7 : parent.width-width-7
                                y: 12 + Math.floor(index/2)*70
                                RowLayout {
                                    anchors.fill:parent; anchors.margins:6
                                    Rectangle { width:3; height:32; color:Theme.stateColor(modelData.state) }
                                    ColumnLayout {
                                        Layout.fillWidth:true; spacing:0
                                        Text { text:modelData.label.toUpperCase(); color:Theme.platinum; font.pixelSize:7; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:"CH "+modelData.valid+"/"+modelData.expected+"  ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }
                                    }
                                    Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth:true; Layout.preferredHeight:31
                        color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        RowLayout {
                            anchors.fill:parent; anchors.margins:6
                            Text { text:"PROFILE  "+cockpit.activePlatformId.toUpperCase(); color:Theme.silver; font.family:"Consolas"; font.pixelSize:6 }
                            Text { text:"PROPULSION  "+cockpit.activePlatformPropulsion; color:Theme.silver; font.family:"Consolas"; font.pixelSize:6 }
                            Item { Layout.fillWidth:true }
                            Text { text:"TWIN NODES "+cockpit.twinRows.length+"  •  SYNC"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:6 }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 360
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout {
                        Layout.fillWidth:true
                        Text { text:"PRIMARY FLIGHT DISPLAY"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:"SIM / PFD"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    RowLayout {
                        Layout.fillWidth:true; Layout.fillHeight:true; spacing:4
                        MfdTape { Layout.preferredWidth:68; Layout.fillHeight:true; title:"ALT"; currentValue:page.sensor("altitude_m").value; unit:"m"; majorStep:100; decimals:0; accent:Theme.accent }
                        AttitudeIndicator { Layout.fillWidth:true; Layout.fillHeight:true; pitch:page.sensor("imu_pitch_deg").value; roll:page.sensor("imu_roll_deg").value }
                        MfdTape { Layout.preferredWidth:68; Layout.fillHeight:true; title:"SPD"; currentValue:page.sensor("airspeed_kph").value; unit:"km/h"; majorStep:20; decimals:0; accent:Theme.accent }
                    }
                    GridLayout {
                        Layout.fillWidth:true; Layout.preferredHeight:82; columns:2; columnSpacing:4; rowSpacing:4
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"PITCH"; value:Number(page.sensor("imu_pitch_deg").value).toFixed(1)+"°"; accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"ROLL"; value:Number(page.sensor("imu_roll_deg").value).toFixed(1)+"°"; accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"ALT"; value:page.fmt("altitude_m",0); accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"SPD"; value:page.fmt("airspeed_kph",0); accent:Theme.accent }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 270
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout {
                        Layout.fillWidth:true
                        Text { text:cockpit.rtl?"صحة الأنظمة":"SYSTEM HEALTH"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:cockpit.twinFaultCount+" F"; color:cockpit.twinFaultCount?Theme.red:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    Repeater {
                        model:cockpit.twinRows
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:42
                            color:index%2?Theme.panel2:Theme.panel; border.color:Theme.borderSoft; radius:Theme.radius
                            RowLayout {
                                anchors.fill:parent; anchors.margins:5
                                Rectangle { width:3; height:22; color:Theme.stateColor(modelData.state) }
                                ColumnLayout {
                                    Layout.fillWidth:true; spacing:0
                                    Text { text:modelData.label; color:Theme.platinum; font.pixelSize:7; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:modelData.state+" / "+modelData.valid+" OF "+modelData.expected; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }
                                }
                                Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    GridLayout {
                        Layout.fillWidth:true; Layout.preferredHeight:112; columns:2; columnSpacing:4; rowSpacing:4
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"BUS"; value:page.fmt("bus_voltage_v",1); accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"CPU"; value:page.fmt("cpu_temp_c",1); accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"HYD"; value:page.fmt("hydraulic_pressure_pct",0); accent:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"FUEL"; value:page.fmt("fuel_level_pct",0); accent:Theme.accent }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth:true
            Layout.preferredHeight:210
            spacing:7

            Rectangle {
                Layout.preferredWidth:365; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:7; spacing:3
                    RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl?"سجل الأحداث":"EVENT STREAM"; color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true }; Text { text:String(cockpit.eventCount); color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 } }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    ListView {
                        Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle {
                            required property int index; required property var modelData
                            width:ListView.view.width; height:30; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:4; Text { text:modelData.time; color:Theme.muted; Layout.preferredWidth:58; font.family:"Consolas"; font.pixelSize:6 }; Rectangle { width:3; height:17; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.accent) }; Text { text:modelData.source; color:Theme.accent; Layout.preferredWidth:48; font.family:"Consolas"; font.pixelSize:6 }; Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:6 } }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:7; spacing:3
                    RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl?"اتجاهات القياسات":"ENGINEERING TREND"; color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true }; Text { text:"LIVE / "+cockpit.recordedFrames+" FR"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:6 } }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:cockpit.performanceSeries; cursorVisible:false }
                }
            }

            Rectangle {
                Layout.preferredWidth:300; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:7; spacing:3
                    Text { text:cockpit.rtl?"سياق المهمة":"RUN CONTEXT"; color:Theme.platinum; font.pixelSize:8; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    Text { text:"PROFILE   "+cockpit.activePlatformId.toUpperCase(); color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                    Text { text:"SCENARIO  "+cockpit.scenario.toUpperCase(); color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                    Text { text:"TICK      "+cockpit.tick; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                    Text { text:"FRAMES    "+cockpit.recordedFrames; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                    Text { text:"DX SCORE  "+cockpit.diagnosticHealthScore+" / 100"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                    Item { Layout.fillHeight:true }
                    Text { text:"TRAINING / SIMULATION ONLY"; color:Theme.muted; font.pixelSize:6 }
                    Text { text:"NO LIVE AIRCRAFT CONTROL PATH"; color:Theme.muted; font.pixelSize:6 }
                }
            }
        }
    }
}
