import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function colorFor(i){ return ["#6A88A0","#8FA5B5","#A7B3BC","#738A9A"][i%4] }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:82; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:1
                    Text { text:cockpit.rtl?"منضدة التحليل الهندسي":"ENGINEERING WORKBENCH"; color:Theme.platinum; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"تحليل القياسات / الاتجاهات متعددة القنوات":"TELEMETRY ANALYSIS / MULTI-CHANNEL TRENDS"; color:Theme.muted; font.pixelSize:8 }
                }
            }
            Rectangle { Layout.preferredWidth:170; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:0
                    Text { text:"TIME WINDOW"; color:Theme.muted; font.pixelSize:7 }
                    ComboBox {
                        id: w
                        model: [20,60,120,0]
                        currentIndex: 1
                        Layout.fillWidth: true
                        onActivated: cockpit.setTrendWindow(Number(currentText))
                        contentItem: Text {
                            text: w.displayText
                            color: Theme.platinum
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "Consolas"
                        }
                        background: Rectangle {
                            color: Theme.panel2
                            radius: Theme.radius
                            border.color: Theme.border
                        }
                    }
                }
            }
            StatusCard { Layout.preferredWidth:170; Layout.fillHeight:true; title:"FRAMES"; value:String(cockpit.recordedFrames); subtitle:"SYNCHRONIZED"; iconText:"REC"; accent:Theme.accent }
            StatusCard { Layout.preferredWidth:210; Layout.fillHeight:true; title:"SCENARIO"; value:cockpit.scenario.toUpperCase(); subtitle:"TRAINING RUN"; iconText:"SCN"; accent:Theme.accent }
            StatusCard { Layout.preferredWidth:180; Layout.fillHeight:true; title:"SYSTEM HEALTH"; value:cockpit.activeAlertCount===0?"100%":"CHECK"; subtitle:"LIVE STATUS"; iconText:"SYS"; accent:Theme.accent }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:"MULTI-CHANNEL TREND"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:"NORMALIZED / LIVE"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:cockpit.performanceSeries }
                    RowLayout { Layout.fillWidth:true
                        Text { text:"T-"+cockpit.trendWindow; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                        Item { Layout.fillWidth:true }
                        Repeater { model:cockpit.performanceSeries
                            delegate: RowLayout { required property int index; required property var modelData; spacing:3
                                Rectangle { width:12; height:2; color:page.colorFor(index) }
                                Text { text:modelData.label; color:Theme.silver; font.pixelSize:7 }
                            }
                        }
                        Item { Layout.fillWidth:true }
                        Text { text:"T0"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:480; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"مصفوفة القنوات":"CHANNEL MATRIX"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:cockpit.trendRows.length+" CHANNELS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    RowLayout { Layout.fillWidth:true; Layout.preferredHeight:24
                        Text { text:"CHANNEL"; color:Theme.muted; font.pixelSize:7; Layout.fillWidth:true }
                        Text { text:"LATEST"; color:Theme.muted; font.pixelSize:7; Layout.preferredWidth:72; horizontalAlignment:Text.AlignRight }
                        Text { text:"QUALITY"; color:Theme.muted; font.pixelSize:7; Layout.preferredWidth:64; horizontalAlignment:Text.AlignRight }
                    }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.trendRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:56; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:7; spacing:7
                                Rectangle { width:3; height:30; color:modelData.quality>=99?Theme.accent:(modelData.quality>=90?Theme.amber:Theme.red) }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:"MIN "+Number(modelData.minimum).toFixed(2)+"   MEAN "+Number(modelData.mean).toFixed(2)+"   MAX "+Number(modelData.maximum).toFixed(2); color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                Text { text:Number(modelData.latest).toFixed(2); color:Theme.platinum; font.family:"Consolas"; font.pixelSize:11; font.bold:true; Layout.preferredWidth:72; horizontalAlignment:Text.AlignRight }
                                Text { text:Number(modelData.quality).toFixed(1)+"%"; color:modelData.quality>=99?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:8; Layout.preferredWidth:64; horizontalAlignment:Text.AlignRight }
                            }
                        }
                    }
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:190; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    Text { text:"CHANNEL STATISTICS"; color:Theme.platinum; font.pixelSize:9; font.bold:true }
                    GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:4; columnSpacing:5; rowSpacing:5
                        Repeater { model:cockpit.trendRows.length>0?[cockpit.trendRows[0]]:[]
                            delegate: Item { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true
                                GridLayout { anchors.fill:parent; columns:4; columnSpacing:5; rowSpacing:5
                                    MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"MIN";value:Number(modelData.minimum).toFixed(2);accent:Theme.accent}
                                    MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"MAX";value:Number(modelData.maximum).toFixed(2);accent:Theme.accent}
                                    MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"MEAN";value:Number(modelData.mean).toFixed(2);accent:Theme.accent}
                                    MetricBox{Layout.fillWidth:true;Layout.fillHeight:true;label:"QUALITY";value:Number(modelData.quality).toFixed(1)+"%";accent:Theme.accent}
                                }
                            }
                        }
                    }
                }
            }
            Rectangle { Layout.preferredWidth:360; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    Text { text:"RUN CONTEXT"; color:Theme.platinum; font.pixelSize:9; font.bold:true }
                    Text { text:"SCENARIO   "+cockpit.scenario.toUpperCase(); color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                    Text { text:"TICK       "+cockpit.tick; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                    Text { text:"FRAMES     "+cockpit.recordedFrames; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                    Text { text:"WINDOW     "+cockpit.trendWindow; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                    Item { Layout.fillHeight:true }
                    Text { text:cockpit.rtl?"بيانات تدريب ومحاكاة فقط":"TRAINING / SIMULATION DATA ONLY"; color:Theme.muted; font.pixelSize:7 }
                }
            }
        }
    }
}
