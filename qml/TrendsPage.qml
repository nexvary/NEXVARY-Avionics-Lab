import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function qualityAvg(){ if(!cockpit.trendRows.length)return 0; var s=0; for(var i=0;i<cockpit.trendRows.length;++i)s+=Number(cockpit.trendRows[i].quality); return Math.round(s/cockpit.trendRows.length) }
    function anomalyCount(){ var n=0; for(var i=0;i<cockpit.trendRows.length;++i) if(Number(cockpit.trendRows[i].quality)<99)++n; return n }

    ColumnLayout {
        anchors.fill:parent; anchors.margins:10; spacing:7

        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:78; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout {
                anchors.fill:parent; anchors.margins:9; spacing:7
                ColumnLayout {
                    Layout.fillWidth:true; spacing:0
                    Text { text:cockpit.rtl?"منضدة التحليل الهندسي":"ENGINEERING ANALYSIS WORKBENCH"; color:Theme.platinum; font.pixelSize:16; font.bold:true }
                    Text { text:cockpit.activePlatformName.toUpperCase()+"  /  "+cockpit.scenario.toUpperCase()+"  /  MULTI-CHANNEL TELEMETRY"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                    Text { text:cockpit.rtl?"تحليل الاتجاهات وجودة القنوات والسياق الزمني":"TREND / QUALITY / TEMPORAL CONTEXT / SYNTHETIC DATA"; color:Theme.muted; font.pixelSize:7 }
                }
                Repeater {
                    model:[
                        {"k":"CHANNELS","v":String(cockpit.trendRows.length),"s":"PROFILE MAP","c":Theme.accent},
                        {"k":"QUALITY","v":page.qualityAvg()+"%","s":"VALIDITY","c":page.qualityAvg()>=99?Theme.green:Theme.amber},
                        {"k":"ANOMALIES","v":String(page.anomalyCount()),"s":"QUALITY FLAGS","c":page.anomalyCount()?Theme.amber:Theme.silver},
                        {"k":"FRAMES","v":String(cockpit.recordedFrames),"s":"RECORDED","c":Theme.silver}
                    ]
                    delegate:Rectangle {
                        required property var modelData
                        Layout.preferredWidth:135; Layout.fillHeight:true; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:0; Text { text:modelData.k; color:Theme.muted; font.pixelSize:6; font.bold:true }; Text { text:modelData.v; color:modelData.c; font.family:"Consolas"; font.pixelSize:15; font.bold:true }; Text { text:modelData.s; color:Theme.silver; font.pixelSize:6 } }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth:true; Layout.fillHeight:true; spacing:7

            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout {
                        Layout.fillWidth:true
                        Text { text:"MULTI-CHANNEL TREND / ENGINEERING ENVELOPE"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                        Text { text:"LIVE  •  T-"+cockpit.trendWindow+" → T0"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    RowLayout {
                        Layout.fillWidth:true; Layout.preferredHeight:24
                        Text { text:"AMPLITUDE"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }
                        Item { Layout.fillWidth:true }
                        Text { text:"SYNTHETIC TELEMETRY / NORMALIZED DISPLAY"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }
                    }
                    TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:cockpit.performanceSeries }
                    RowLayout {
                        Layout.fillWidth:true; Layout.preferredHeight:28; spacing:8
                        Text { text:"T-"+cockpit.trendWindow; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                        Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                        Text { text:"EVENT CORRELATION WINDOW"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:6 }
                        Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                        Text { text:"T0"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:450; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:3
                    RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl?"مصفوفة القنوات":"CHANNEL INSPECTOR"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }; Text { text:cockpit.trendRows.length+" CHANNELS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 } }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    RowLayout {
                        Layout.fillWidth:true; Layout.preferredHeight:22
                        Text { text:"CHANNEL / RANGE"; color:Theme.muted; font.pixelSize:6; Layout.fillWidth:true }
                        Text { text:"LATEST"; color:Theme.muted; font.pixelSize:6; Layout.preferredWidth:72; horizontalAlignment:Text.AlignRight }
                        Text { text:"QUALITY"; color:Theme.muted; font.pixelSize:6; Layout.preferredWidth:60; horizontalAlignment:Text.AlignRight }
                    }
                    ListView {
                        Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.trendRows; clip:true; spacing:1
                        delegate:Rectangle {
                            required property int index; required property var modelData
                            width:ListView.view.width; height:50; color:index%2?Theme.panel2:Theme.panel
                            RowLayout {
                                anchors.fill:parent; anchors.margins:6; spacing:6
                                Rectangle { width:3; height:28; color:Number(modelData.quality)>=99?Theme.accent:(Number(modelData.quality)>=90?Theme.amber:Theme.red) }
                                ColumnLayout {
                                    Layout.fillWidth:true; spacing:0
                                    Text { text:modelData.label; color:Theme.platinum; font.pixelSize:7; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:"MIN "+Number(modelData.minimum).toFixed(2)+"  μ "+Number(modelData.mean).toFixed(2)+"  MAX "+Number(modelData.maximum).toFixed(2); color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }
                                }
                                Text { text:Number(modelData.latest).toFixed(2); color:Theme.platinum; font.family:"Consolas"; font.pixelSize:9; font.bold:true; Layout.preferredWidth:72; horizontalAlignment:Text.AlignRight }
                                Text { text:Number(modelData.quality).toFixed(1)+"%"; color:Number(modelData.quality)>=99?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:7; Layout.preferredWidth:60; horizontalAlignment:Text.AlignRight }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth:true; Layout.preferredHeight:156; spacing:7
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true; Text { text:"ANALYSIS CONTROLS / PRIMARY STATISTICS"; color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true }; ComboBox { id:w; model:[20,60,120,0]; currentIndex:1; Layout.preferredWidth:105; Layout.preferredHeight:28; onActivated:cockpit.setTrendWindow(Number(currentText)); contentItem:Text { text:w.displayText; color:Theme.platinum; verticalAlignment:Text.AlignVCenter; horizontalAlignment:Text.AlignHCenter; font.family:"Consolas"; font.pixelSize:7 }; background:Rectangle { color:Theme.panel2; border.color:Theme.border; radius:Theme.radius } } }
                    GridLayout {
                        Layout.fillWidth:true; Layout.fillHeight:true; columns:4; columnSpacing:5
                        Repeater {
                            model:cockpit.trendRows.length?[cockpit.trendRows[0]]:[]
                            delegate:Item {
                                required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true
                                GridLayout { anchors.fill:parent; columns:4; columnSpacing:5; MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"MIN"; value:Number(modelData.minimum).toFixed(2); accent:Theme.accent }; MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"MAX"; value:Number(modelData.maximum).toFixed(2); accent:Theme.accent }; MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"MEAN"; value:Number(modelData.mean).toFixed(2); accent:Theme.accent }; MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"QUALITY"; value:Number(modelData.quality).toFixed(1)+"%"; accent:Theme.accent } }
                            }
                        }
                    }
                }
            }
            Rectangle {
                Layout.preferredWidth:330; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:3
                    Text { text:"RUN / REPLAY CONTEXT"; color:Theme.platinum; font.pixelSize:8; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    Text { text:"PROFILE   "+cockpit.activePlatformId.toUpperCase(); color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                    Text { text:"SCENARIO  "+cockpit.scenario.toUpperCase(); color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                    Text { text:"WINDOW    "+cockpit.trendWindow+"   FRAMES "+cockpit.recordedFrames; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                    Text { text:"ALERTS    "+cockpit.activeAlertCount+"   EVENTS "+cockpit.eventCount; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                    Item { Layout.fillHeight:true }
                    Text { text:"TRAINING / SIMULATION DATA ONLY"; color:Theme.muted; font.pixelSize:6 }
                }
            }
        }
    }
}
