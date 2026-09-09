import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

ApplicationWindow {
    id: root
    width: 1600
    height: 980
    minimumWidth: 1280
    minimumHeight: 760
    visible: true
    title: cockpit.text("app_title")
    color: Theme.bg
    property int selectedPage: 0

    function t(key) { const dep = cockpit.language; return cockpit.text(key) }
    function rowById(rows, id) {
        for (var i=0; i<rows.length; ++i) if (rows[i].id === id) return rows[i]
        return ({"label": id, "value":0, "unit":"", "valid":false, "state":"UNKNOWN", "health":0, "issues":0})
    }
    function sensor(id) { return rowById(cockpit.sensorRows, id) }
    function twin(id) { return rowById(cockpit.twinRows, id) }
    function stateColor(s) { return Theme.stateColor(s) }
    function fmtSensor(id, digits) {
        var s = sensor(id); return Number(s.value).toFixed(digits === undefined ? 1 : digits) + (s.unit ? " " + s.unit : "")
    }
    function glyphFor(index) { return ["⌂","✦","◉","▣","▶","▥","◇","⚠"][index] }

    LayoutMirroring.enabled: cockpit.rtl
    LayoutMirroring.childrenInherit: true

    Timer { interval: 250; running: true; repeat: true; onTriggered: cockpit.step() }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 196
            Layout.fillHeight: true
            color: "#051018"
            border.color: "#172b35"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Item { Layout.fillWidth: true; Layout.preferredHeight: 104
                    Column {
                        anchors.centerIn: parent; spacing: 2
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "NEXVARY"; color: Theme.gold; font.pixelSize: 24; font.bold: true; font.letterSpacing: 3 }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "AVIONICS LAB"; color: Theme.silver; font.pixelSize: 10; font.letterSpacing: 4 }
                        Rectangle { width: 62; height: 2; color: Theme.gold; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }

                Repeater {
                    model: [
                        root.t("mfd"), root.t("systems"), root.t("sensors"), root.t("events"),
                        root.t("replay"), root.t("trends"), root.t("digital_twin"), root.t("fault_lab")
                    ]
                    delegate: SideNavButton {
                        required property int index
                        required property string modelData
                        text: modelData
                        glyph: root.glyphFor(index)
                        checked: root.selectedPage === index
                        Layout.fillWidth: true
                        onClicked: root.selectedPage = index
                    }
                }
                Item { Layout.fillHeight: true }
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 88; color: "#07141c"; radius: 8; border.color: Theme.border
                    Column { anchors.centerIn: parent; spacing: 4
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "SIMULATION"; color: Theme.cyan; font.bold: true }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "TRAINING PLATFORM"; color: Theme.muted; font.pixelSize: 10 }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "SECURE • OFFLINE"; color: Theme.green; font.pixelSize: 10 }
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.margins: 0
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 96
                color: "#061119"
                border.color: "#223944"
                border.width: 1
                RowLayout {
                    anchors.fill: parent; anchors.margins: 18; spacing: 20
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 2
                        Text { text: root.t("app_title"); color: Theme.gold; font.pixelSize: 25; font.bold: true }
                        Text { text: root.t("training") + "  |  " + cockpit.scenario; color: Theme.green; font.pixelSize: 13; font.bold: true }
                    }
                    ColumnLayout {
                        Text { text: root.t("scenario"); color: Theme.muted; font.pixelSize: 10 }
                        ComboBox {
                            id: scenarioCombo; model: cockpit.scenarios; Layout.preferredWidth: 190
                            contentItem: Text { text: scenarioCombo.displayText; color: Theme.text; verticalAlignment: Text.AlignVCenter; leftPadding: 10 }
                            background: Rectangle { color: Theme.panel; radius: 6; border.color: Theme.border }
                            onActivated: cockpit.setScenario(currentText)
                        }
                    }
                    ColumnLayout {
                        Text { text: root.t("tick") + ": " + cockpit.tick; color: Theme.silver; font.pixelSize: 14; font.bold: true }
                        Text { text: "BUILD 1.4 • STAGE 900"; color: Theme.muted; font.pixelSize: 10 }
                    }
                    Rectangle {
                        Layout.preferredWidth: 220; Layout.preferredHeight: 52; radius: 8; color: "#071a16"; border.color: Theme.green
                        RowLayout { anchors.fill: parent; anchors.margins: 12
                            Text { text: "●"; color: Theme.green; font.pixelSize: 22 }
                            ColumnLayout { Layout.fillWidth: true
                                Text { text: cockpit.activeAlertCount === 0 ? root.t("systems_nominal") : cockpit.activeAlertCount + " " + root.t("active_alerts"); color: cockpit.activeAlertCount === 0 ? Theme.green : Theme.amber; font.bold: true; font.pixelSize: 12; elide: Text.ElideRight; Layout.fillWidth: true }
                                Text { text: cockpit.activeAlertCount === 0 ? "ALL SYSTEMS NOMINAL" : "ATTENTION REQUIRED"; color: Theme.muted; font.pixelSize: 9 }
                            }
                        }
                    }
                    MinisterialButton { text: root.t("language"); implicitWidth: 100; onClicked: cockpit.setLanguage(cockpit.rtl ? "en" : "ar") }
                }
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: root.selectedPage

                // Executive Dashboard / MFD
                ScrollView {
                    clip: true
                    contentWidth: availableWidth
                    ColumnLayout {
                        width: parent.width
                        spacing: 12
                        padding: 14

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 6
                            columnSpacing: 10
                            StatusCard { Layout.fillWidth: true; title: root.t("system_readiness"); value: cockpit.activeAlertCount === 0 ? "100%" : Math.max(0,100-cockpit.activeAlertCount*12) + "%"; subtitle: cockpit.activeAlertCount === 0 ? root.t("systems_nominal") : root.t("active_alerts"); iconText:"✦"; accent: cockpit.activeAlertCount === 0 ? Theme.green : Theme.amber }
                            StatusCard { Layout.fillWidth: true; title: root.t("active_alerts"); value: String(cockpit.activeAlertCount); subtitle: cockpit.activeAlertCount === 0 ? root.t("no_active_alerts") : root.t("attention_required"); iconText:"!"; accent: cockpit.activeAlertCount === 0 ? Theme.green : Theme.amber }
                            StatusCard { Layout.fillWidth: true; title: root.t("verification_status"); value: "NOMINAL"; subtitle: root.t("verification_passed"); iconText:"✓"; accent:Theme.green }
                            StatusCard { Layout.fillWidth: true; title: root.t("recorded_frames"); value: String(cockpit.recordedFrames); subtitle: root.t("session_data"); iconText:"▣"; accent:Theme.cyan }
                            StatusCard { Layout.fillWidth: true; title: root.t("telemetry_health"); value: cockpit.sensorCount > 0 ? "100%" : "0%"; subtitle: root.t("data_quality"); iconText:"◉"; accent:Theme.green }
                            StatusCard { Layout.fillWidth: true; title: root.t("digital_twin"); value: cockpit.twinFaultCount === 0 ? "SYNC" : "DEGRADED"; subtitle: cockpit.twinNominalCount + "/5 " + root.t("nominal"); iconText:"◇"; accent:cockpit.twinFaultCount===0 ? Theme.green : Theme.amber }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 470
                            spacing: 12

                            Rectangle {
                                Layout.fillWidth: true; Layout.fillHeight: true; radius: Theme.radius; color: Theme.panel; border.color: Theme.gold
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout { Layout.fillWidth: true
                                        Text { text: root.t("digital_twin"); color: Theme.gold; font.pixelSize: 18; font.bold: true; Layout.fillWidth: true }
                                        Text { text: cockpit.twinFaultCount===0 ? "SYNCHRONIZED" : "DEGRADED"; color: cockpit.twinFaultCount===0 ? Theme.green : Theme.amber; font.bold: true }
                                    }
                                    Item {
                                        Layout.fillWidth: true; Layout.fillHeight: true
                                        Canvas {
                                            id: aircraftCanvas
                                            anchors.centerIn: parent; width: parent.width*0.48; height: parent.height*0.80
                                            onPaint: {
                                                var c=getContext("2d"); c.reset();
                                                c.strokeStyle="#5fc9ff"; c.lineWidth=2; c.shadowColor="#2e9bd1"; c.shadowBlur=14;
                                                c.beginPath();
                                                c.moveTo(width*0.50,height*0.04); c.lineTo(width*0.56,height*0.34); c.lineTo(width*0.94,height*0.55); c.lineTo(width*0.60,height*0.59); c.lineTo(width*0.58,height*0.90); c.lineTo(width*0.69,height*0.96); c.lineTo(width*0.52,height*0.93); c.lineTo(width*0.50,height*0.99); c.lineTo(width*0.48,height*0.93); c.lineTo(width*0.31,height*0.96); c.lineTo(width*0.42,height*0.90); c.lineTo(width*0.40,height*0.59); c.lineTo(width*0.06,height*0.55); c.lineTo(width*0.44,height*0.34); c.closePath(); c.stroke();
                                                c.strokeStyle="#24495c"; c.lineWidth=1; c.beginPath(); c.moveTo(width*.5,height*.06); c.lineTo(width*.5,height*.94); c.stroke();
                                            }
                                        }
                                        Repeater {
                                            model: cockpit.twinRows
                                            delegate: Rectangle {
                                                required property int index; required property var modelData
                                                width: 190; height: 88; radius: 8; color: "#081820"; border.width: 1; border.color: root.stateColor(modelData.state)
                                                x: index % 2 === 0 ? 8 : parent.width-width-8
                                                y: 28 + Math.floor(index/2)*108
                                                Column { anchors.fill: parent; anchors.margins: 10; spacing: 3
                                                    Row { spacing:8
                                                        Text { text:"●"; color:root.stateColor(modelData.state) }
                                                        Text { text:modelData.label; color:Theme.silver; font.bold:true; font.pixelSize:12 }
                                                    }
                                                    Text { text:modelData.state; color:root.stateColor(modelData.state); font.bold:true; font.pixelSize:13 }
                                                    Text { text:root.t("health")+": "+Number(modelData.health).toFixed(0)+"%"; color:Theme.muted; font.pixelSize:10 }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 590; Layout.fillHeight: true; radius:Theme.radius; color:Theme.panel; border.color:Theme.gold
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 14; spacing: 8
                                    RowLayout { Layout.fillWidth: true
                                        Text { text:root.t("primary_flight_display"); color:Theme.gold; font.pixelSize:18; font.bold:true; Layout.fillWidth:true }
                                        Text { text:"MODE: ATT"; color:Theme.cyan; font.pixelSize:11 }
                                    }
                                    RowLayout {
                                        Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
                                        ColumnLayout { Layout.preferredWidth:140; Layout.fillHeight:true
                                            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:root.t("altitude_m"); value:root.fmtSensor("altitude_m",0); subtitle:"ALT"; accent:Theme.cyan }
                                            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:root.t("airspeed_kph"); value:root.fmtSensor("airspeed_kph",0); subtitle:"IAS"; accent:Theme.cyan }
                                        }
                                        AttitudeIndicator { Layout.fillWidth:true; Layout.fillHeight:true; pitch:root.sensor("imu_pitch_deg").value; roll:root.sensor("imu_roll_deg").value }
                                        ColumnLayout { Layout.preferredWidth:150; Layout.fillHeight:true
                                            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:root.t("bus_voltage_v"); value:root.fmtSensor("bus_voltage_v",1); subtitle:"POWER"; accent:root.sensor("bus_voltage_v").valid?Theme.green:Theme.red }
                                            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:root.t("cpu_temp_c"); value:root.fmtSensor("cpu_temp_c",1); subtitle:"COMPUTE"; accent:Theme.green }
                                            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:root.t("hydraulic_pressure_pct"); value:root.fmtSensor("hydraulic_pressure_pct",0); subtitle:"HYD"; accent:Theme.green }
                                            StatusCard { Layout.fillWidth:true; Layout.fillHeight:true; title:root.t("fuel_level_pct"); value:root.fmtSensor("fuel_level_pct",0); subtitle:"FUEL"; accent:Theme.green }
                                        }
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth:true; Layout.preferredHeight:220; spacing:12
                            Rectangle {
                                Layout.fillWidth:true; Layout.fillHeight:true; radius:Theme.radius; color:Theme.panel; border.color:Theme.border
                                ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:7
                                    RowLayout { Layout.fillWidth:true
                                        Text { text:root.t("recent_events"); color:Theme.gold; font.bold:true; font.pixelSize:16; Layout.fillWidth:true }
                                        Text { text:cockpit.eventCount+" "+root.t("events"); color:Theme.muted }
                                    }
                                    ListView {
                                        Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:3
                                        delegate: Rectangle { required property var modelData; width:ListView.view.width; height:34; color:index%2?"#07141b":"#091820"
                                            RowLayout { anchors.fill:parent; anchors.margins:7
                                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); Layout.preferredWidth:70; font.bold:true; font.pixelSize:10 }
                                                Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:90; font.pixelSize:10 }
                                                Text { text:modelData.message; color:Theme.text; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:10 }
                                            }
                                        }
                                    }
                                }
                            }
                            Rectangle {
                                Layout.preferredWidth:390; Layout.fillHeight:true; radius:Theme.radius; color:Theme.panel; border.color:Theme.gold
                                ColumnLayout { anchors.fill:parent; anchors.margins:14; spacing:8
                                    Text { text:root.t("training_scenario"); color:Theme.gold; font.bold:true; font.pixelSize:16 }
                                    Text { text:cockpit.scenario; color:Theme.green; font.bold:true; font.pixelSize:28 }
                                    Text { text:root.t("scenario_description"); color:Theme.muted; wrapMode:Text.Wrap; Layout.fillWidth:true }
                                    Item { Layout.fillHeight:true }
                                    MinisterialButton { Layout.fillWidth:true; text:root.t("reset"); onClicked:cockpit.resetLab() }
                                }
                            }
                            Rectangle {
                                Layout.preferredWidth:440; Layout.fillHeight:true; radius:Theme.radius; color:Theme.panel; border.color:Theme.border
                                ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:8
                                    Text { text:root.t("system_performance"); color:Theme.gold; font.bold:true; font.pixelSize:16 }
                                    Repeater {
                                        model:["cpu_temp_c","bus_voltage_v","hydraulic_pressure_pct","fuel_level_pct"]
                                        delegate: RowLayout { required property string modelData; Layout.fillWidth:true
                                            Text { text:root.t(modelData); color:Theme.silver; Layout.preferredWidth:135; font.pixelSize:10 }
                                            Rectangle { Layout.fillWidth:true; height:8; radius:4; color:"#0e2028"
                                                Rectangle { height:parent.height; radius:4; color:index===0?Theme.cyan:(index===1?Theme.gold:(index===2?Theme.green:"#b98cff")); width:Math.max(8,parent.width*Math.min(1,Math.abs(root.sensor(modelData).value)/100)) }
                                            }
                                            Text { text:Number(root.sensor(modelData).value).toFixed(1); color:Theme.text; Layout.preferredWidth:52; horizontalAlignment:Text.AlignRight }
                                        }
                                    }
                                    TelemetrySparkline { Layout.fillWidth:true; Layout.fillHeight:true; values:[20,25,24,28,31,27,29,32,30,33,31,34,32,35]; lineColor:Theme.cyan; minValue:15; maxValue:40 }
                                }
                            }
                        }
                    }
                }

                // System Health
                Item {
                    GridLayout { anchors.fill:parent; anchors.margins:18; columns:2; spacing:12
                        Repeater { model:cockpit.twinRows
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; radius:Theme.radius; color:Theme.panel; border.width:2; border.color:root.stateColor(modelData.state)
                                ColumnLayout { anchors.fill:parent; anchors.margins:20
                                    Text { text:modelData.label; color:Theme.gold; font.pixelSize:22; font.bold:true }
                                    Text { text:modelData.state; color:root.stateColor(modelData.state); font.pixelSize:30; font.bold:true }
                                    ProgressBar { Layout.fillWidth:true; from:0; to:100; value:modelData.health }
                                    Text { text:root.t("health")+": "+Number(modelData.health).toFixed(0)+"%   •   "+root.t("issues")+": "+modelData.issues; color:Theme.text }
                                }
                            }
                        }
                    }
                }

                // Sensors
                Item {
                    ListView { anchors.fill:parent; anchors.margins:18; spacing:8; clip:true; model:cockpit.sensorRows
                        delegate: Rectangle { required property var modelData; width:ListView.view.width; height:68; radius:8; color:Theme.panel; border.color:modelData.valid?Theme.green:Theme.red
                            RowLayout { anchors.fill:parent; anchors.margins:14
                                Text { text:modelData.label; color:Theme.gold; font.bold:true; Layout.fillWidth:true }
                                Text { text:Number(modelData.value).toFixed(2)+" "+modelData.unit; color:modelData.valid?Theme.green:Theme.red; font.pixelSize:20; font.bold:true }
                            }
                        }
                    }
                }

                // Event Log
                Item {
                    ListView { anchors.fill:parent; anchors.margins:18; spacing:6; clip:true; model:cockpit.eventRows
                        delegate: Rectangle { required property var modelData; width:ListView.view.width; height:64; radius:7; color:Theme.panel; border.color:Theme.border
                            RowLayout { anchors.fill:parent; anchors.margins:12
                                Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); font.bold:true; Layout.preferredWidth:90 }
                                Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:150 }
                                Text { text:modelData.message; color:Theme.text; Layout.fillWidth:true; wrapMode:Text.Wrap }
                            }
                        }
                    }
                }

                // Replay
                Item {
                    ColumnLayout { anchors.fill:parent; anchors.margins:18; spacing:14
                        RowLayout { Layout.fillWidth:true
                            Text { text:root.t("replay"); color:Theme.gold; font.pixelSize:24; font.bold:true; Layout.fillWidth:true }
                            MinisterialButton { text:cockpit.replayMode?root.t("exit_replay"):root.t("enter_replay"); onClicked:cockpit.setReplayMode(!cockpit.replayMode) }
                        }
                        Slider { Layout.fillWidth:true; from:0; to:Math.max(1,cockpit.replayMaximum); value:cockpit.replayIndex; enabled:cockpit.replayMode; onMoved:cockpit.seekReplay(Math.round(value)) }
                        GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:4; spacing:10
                            Repeater { model:cockpit.tiles; delegate:InstrumentTile { Layout.fillWidth:true; Layout.fillHeight:true; tileLabel:modelData.label; tileValue:modelData.value; tileState:modelData.state } }
                        }
                    }
                }

                // Trends
                Item {
                    ColumnLayout { anchors.fill:parent; anchors.margins:18; spacing:10
                        RowLayout { Layout.fillWidth:true
                            Text { text:root.t("trends"); color:Theme.gold; font.pixelSize:24; font.bold:true; Layout.fillWidth:true }
                            ComboBox { model:[20,60,120,0]; currentIndex:1; onActivated:cockpit.setTrendWindow(currentText) }
                        }
                        ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.trendRows; clip:true; spacing:6
                            delegate: Rectangle { required property var modelData; width:ListView.view.width; height:62; radius:7; color:Theme.panel; border.color:modelData.quality>=99?Theme.green:(modelData.quality>=90?Theme.amber:Theme.red)
                                RowLayout { anchors.fill:parent; anchors.margins:10
                                    Text { text:modelData.label; color:Theme.gold; Layout.fillWidth:true; font.bold:true }
                                    Text { text:"LATEST "+Number(modelData.latest).toFixed(2); color:Theme.cyan; Layout.preferredWidth:130 }
                                    Text { text:"MEAN "+Number(modelData.mean).toFixed(2); color:Theme.text; Layout.preferredWidth:130 }
                                    Text { text:"MIN "+Number(modelData.minimum).toFixed(2); color:Theme.text; Layout.preferredWidth:120 }
                                    Text { text:"MAX "+Number(modelData.maximum).toFixed(2); color:Theme.text; Layout.preferredWidth:120 }
                                    Text { text:Number(modelData.quality).toFixed(1)+"%"; color:modelData.quality>=99?Theme.green:Theme.amber; Layout.preferredWidth:80; font.bold:true }
                                }
                            }
                        }
                    }
                }

                // Digital Twin
                Item {
                    GridLayout { anchors.fill:parent; anchors.margins:18; columns:2; spacing:14
                        Repeater { model:cockpit.twinRows
                            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; radius:12; color:Theme.panel; border.width:2; border.color:root.stateColor(modelData.state)
                                ColumnLayout { anchors.fill:parent; anchors.margins:20; spacing:12
                                    Text { text:modelData.label; color:Theme.gold; font.pixelSize:24; font.bold:true }
                                    Text { text:modelData.state; color:root.stateColor(modelData.state); font.pixelSize:30; font.bold:true }
                                    ProgressBar { Layout.fillWidth:true; from:0; to:100; value:modelData.health }
                                    Text { text:root.t("channels")+": "+modelData.valid+"/"+modelData.expected; color:Theme.text }
                                    Text { text:root.t("issues")+": "+modelData.issues; color:modelData.issues>0?Theme.amber:Theme.muted }
                                }
                            }
                        }
                    }
                }

                // Fault Lab
                Item {
                    ColumnLayout { anchors.fill:parent; anchors.margins:18; spacing:14
                        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:76; radius:Theme.radius; color:"#0a151a"; border.color:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.green
                            RowLayout { anchors.fill:parent; anchors.margins:16
                                Text { text:"⚠"; color:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.green; font.pixelSize:28 }
                                ColumnLayout { Layout.fillWidth:true
                                    Text { text:root.t("fault_lab"); color:Theme.gold; font.pixelSize:20; font.bold:true }
                                    Text { text:root.t("fault_lab_notice"); color:Theme.text; wrapMode:Text.Wrap; Layout.fillWidth:true }
                                }
                                Text { text:cockpit.activeTrainingFaultCount+" "+root.t("active_training_faults"); color:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.green; font.bold:true }
                                MinisterialButton { text:root.t("clear_faults"); enabled:cockpit.activeTrainingFaultCount>0; onClicked:cockpit.clearTrainingFaults() }
                            }
                        }
                        GridLayout { Layout.fillWidth:true; Layout.preferredHeight:250; columns:3; spacing:12
                            Repeater { model:cockpit.trainingFaultPresets
                                delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; radius:Theme.radius; color:Theme.panel; border.color:modelData.active?Theme.amber:Theme.border; border.width:modelData.active?2:1
                                    ColumnLayout { anchors.fill:parent; anchors.margins:16; spacing:9
                                        Text { text:modelData.label; color:Theme.gold; font.pixelSize:18; font.bold:true; wrapMode:Text.Wrap; Layout.fillWidth:true }
                                        Text { text:modelData.description; color:Theme.text; wrapMode:Text.Wrap; Layout.fillWidth:true; Layout.fillHeight:true }
                                        Text { text:modelData.mode; color:Theme.cyan; font.pixelSize:11 }
                                        MinisterialButton { Layout.fillWidth:true; text:modelData.active?root.t("active"):root.t("apply_fault"); checked:modelData.active; onClicked:cockpit.applyTrainingFault(modelData.id) }
                                    }
                                }
                            }
                        }
                        Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; radius:Theme.radius; color:Theme.panel; border.color:Theme.border
                            ColumnLayout { anchors.fill:parent; anchors.margins:14
                                Text { text:root.t("recent_events"); color:Theme.gold; font.bold:true; font.pixelSize:16 }
                                ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:4
                                    delegate: Rectangle { required property var modelData; width:ListView.view.width; height:38; color:index%2?"#07141b":"#091820"
                                        RowLayout { anchors.fill:parent; anchors.margins:7
                                            Text { text:modelData.severity; color:Theme.amber; Layout.preferredWidth:70 }
                                            Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:110 }
                                            Text { text:modelData.message; color:Theme.text; Layout.fillWidth:true; elide:Text.ElideRight }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth:true; Layout.preferredHeight:34; color:"#041018"; border.color:"#142832"
                RowLayout { anchors.fill:parent; anchors.margins:8
                    Text { text:"NEXVARY AVIONICS LAB"; color:Theme.muted; font.pixelSize:9 }
                    Item { Layout.fillWidth:true }
                    Text { text:root.t("simulation_only"); color:Theme.muted; font.pixelSize:9 }
                    Item { Layout.fillWidth:true }
                    Text { text:"SECURE  |  OFFLINE MODE  ●"; color:Theme.green; font.pixelSize:9 }
                }
            }
        }
    }
}
