import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function rowById(rows, id) { for (var i=0;i<rows.length;++i) if (rows[i].id===id) return rows[i]; return ({"value":0,"unit":"","valid":false,"state":"UNKNOWN","health":0}) }
    function sensor(id) { return rowById(cockpit.sensorRows,id) }
    function t(key) { const dep=cockpit.language; return cockpit.text(key) }
    function fmt(id,d) { var s=sensor(id); return Number(s.value).toFixed(d)+" "+s.unit }
    function telemetryQuality() { if (cockpit.sensorRows.length===0) return 0; var ok=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid) ++ok; return Math.round(ok*100/cockpit.sensorRows.length) }
    function readiness() { return Math.max(0, Math.round((cockpit.twinNominalCount*100/5) - cockpit.activeAlertCount*5)) }

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 14; spacing: 12
        GridLayout {
            Layout.fillWidth: true; Layout.preferredHeight:116; Layout.minimumHeight:116; Layout.maximumHeight:116
            columns: 6; columnSpacing:10; rowSpacing:0
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:page.t("system_readiness"); value:page.readiness()+"%"; subtitle:cockpit.activeAlertCount===0?page.t("systems_nominal"):page.t("attention_required"); iconText:"✓"; accent:cockpit.activeAlertCount===0?Theme.green:Theme.amber }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:page.t("active_alerts"); value:String(cockpit.activeAlertCount); subtitle:cockpit.activeAlertCount===0?page.t("no_active_alerts"):page.t("attention_required"); iconText:"!"; accent:cockpit.activeAlertCount===0?Theme.green:Theme.amber }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:page.t("verification_status"); value:(cockpit.twinFaultCount===0&&cockpit.activeAlertCount===0)?"READY":"ATTENTION"; subtitle:page.t("runtime_verification"); iconText:"V"; accent:(cockpit.twinFaultCount===0&&cockpit.activeAlertCount===0)?Theme.green:Theme.amber }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:page.t("recorded_frames"); value:String(cockpit.recordedFrames); subtitle:page.t("session_data"); iconText:"▣"; accent:Theme.cyan }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:page.t("telemetry_health"); value:page.telemetryQuality()+"%"; subtitle:page.t("data_quality"); iconText:"◉"; accent:page.telemetryQuality()===100?Theme.green:Theme.amber }
            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:page.t("digital_twin"); value:cockpit.twinFaultCount===0?"SYNC":"DEGRADED"; subtitle:cockpit.twinNominalCount+"/5 "+page.t("nominal"); iconText:"◇"; accent:cockpit.twinFaultCount===0?Theme.green:Theme.amber }
        }

        RowLayout {
            Layout.fillWidth:true; Layout.preferredHeight:410; Layout.minimumHeight:400; Layout.maximumHeight:420; spacing:12
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; radius:10; color:Theme.panel; border.color:Theme.gold
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:14; spacing:8
                    RowLayout { Layout.fillWidth:true
                        Text { text:page.t("digital_twin_aircraft"); color:Theme.gold; font.pixelSize:18; font.bold:true; Layout.fillWidth:true }
                        Text { text:cockpit.twinFaultCount===0?"SYNCHRONIZED":"DEGRADED"; color:cockpit.twinFaultCount===0?Theme.green:Theme.amber; font.bold:true }
                    }
                    Item {
                        Layout.fillWidth:true; Layout.fillHeight:true
                        AircraftSchematic { anchors.centerIn:parent; width:parent.width*.48; height:parent.height*.84 }
                        Repeater {
                            model:cockpit.twinRows
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width:190; height:78; radius:8; color:"#081820"; border.width:1; border.color:Theme.stateColor(modelData.state)
                                x:index%2===0?8:parent.width-width-8
                                y:18+Math.floor(index/2)*92
                                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:2
                                    RowLayout { Layout.fillWidth:true
                                        Text { text:"●"; color:Theme.stateColor(modelData.state) }
                                        Text { text:modelData.label; color:Theme.silver; font.bold:true; font.pixelSize:11; Layout.fillWidth:true; elide:Text.ElideRight }
                                    }
                                    Text { text:modelData.state; color:Theme.stateColor(modelData.state); font.bold:true; font.pixelSize:13 }
                                    Text { text:page.t("health")+": "+Number(modelData.health).toFixed(0)+"%"; color:Theme.muted; font.pixelSize:10 }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:610; Layout.fillHeight:true; radius:10; color:Theme.panel; border.color:Theme.gold
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:14; spacing:8
                    RowLayout { Layout.fillWidth:true
                        Text { text:page.t("primary_flight_display"); color:Theme.gold; font.pixelSize:18; font.bold:true; Layout.fillWidth:true }
                        Text { text:"MODE: ATT  •  LIVE SYNTHETIC"; color:Theme.cyan; font.pixelSize:10 }
                    }
                    RowLayout {
                        Layout.fillWidth:true; Layout.fillHeight:true; spacing:9
                        ColumnLayout {
                            Layout.preferredWidth:132; Layout.fillHeight:true; spacing:8
                            MfdTape { Layout.fillWidth:true; Layout.fillHeight:true; title:page.t("altitude_m"); currentValue:page.sensor("altitude_m").value; majorStep:100; decimals:0; unit:"m"; accent:Theme.cyan }
                            MfdTape { Layout.fillWidth:true; Layout.fillHeight:true; title:page.t("airspeed_kph"); currentValue:page.sensor("airspeed_kph").value; majorStep:10; decimals:0; unit:"km/h"; accent:Theme.cyan }
                        }
                        AttitudeIndicator { Layout.fillWidth:true; Layout.fillHeight:true; pitch:page.sensor("imu_pitch_deg").value; roll:page.sensor("imu_roll_deg").value }
                        ColumnLayout { Layout.preferredWidth:145; Layout.fillHeight:true; spacing:7
                            MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:page.t("bus_voltage_v"); value:page.fmt("bus_voltage_v",1); accent:page.sensor("bus_voltage_v").valid?Theme.green:Theme.red }
                            MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:page.t("cpu_temp_c"); value:page.fmt("cpu_temp_c",1); accent:Theme.green }
                            MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:page.t("hydraulic_pressure_pct"); value:page.fmt("hydraulic_pressure_pct",0); accent:Theme.green }
                            MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:page.t("fuel_level_pct"); value:page.fmt("fuel_level_pct",0); accent:Theme.green }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth:true; Layout.fillHeight:true; Layout.preferredHeight:200; Layout.minimumHeight:180; spacing:12
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; radius:10; color:Theme.panel; border.color:Theme.border
                ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:6
                    RowLayout { Layout.fillWidth:true
                        Text { text:page.t("recent_events"); color:Theme.gold; font.bold:true; font.pixelSize:15; Layout.fillWidth:true }
                        Text { text:cockpit.eventCount+" "+page.t("events"); color:Theme.muted; font.pixelSize:10 }
                    }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:2
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            width:ListView.view.width; height:31; color:index%2?"#07141b":"#091820"
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); Layout.preferredWidth:65; font.bold:true; font.pixelSize:9 }
                                Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:82; font.pixelSize:9 }
                                Text { text:modelData.message; color:Theme.text; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:9 }
                            }
                        }
                    }
                }
            }
            Rectangle {
                Layout.preferredWidth:350; Layout.fillHeight:true; radius:10; color:Theme.panel; border.color:Theme.gold
                ColumnLayout { anchors.fill:parent; anchors.margins:13; spacing:7
                    Text { text:page.t("training_scenario"); color:Theme.gold; font.bold:true; font.pixelSize:15 }
                    Text { text:cockpit.scenario; color:Theme.green; font.bold:true; font.pixelSize:25 }
                    Text { text:page.t("scenario_description"); color:Theme.muted; wrapMode:Text.Wrap; Layout.fillWidth:true }
                    Item { Layout.fillHeight:true }
                    MinisterialButton { Layout.fillWidth:true; text:page.t("reset"); onClicked:cockpit.resetLab() }
                }
            }
            PerformancePanel { Layout.preferredWidth:430; Layout.fillHeight:true }
        }
    }
}
