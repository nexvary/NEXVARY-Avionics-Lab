import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    property int selectedIndex: 0
    function sensorAt(i){ return cockpit.sensorRows.length>0 ? cockpit.sensorRows[Math.max(0,Math.min(i,cockpit.sensorRows.length-1))] : ({"id":"","label":"NO CHANNEL","value":0,"unit":"","valid":false}) }
    function selectedSensor(){ return sensorAt(selectedIndex) }
    function trendFor(id){ for(var i=0;i<cockpit.trendRows.length;++i) if(cockpit.trendRows[i].id===id) return cockpit.trendRows[i]; return ({"quality":0,"minimum":0,"maximum":0,"mean":0,"delta":0,"slope":0,"valid":0,"invalid":0,"missing":0}) }
    function seriesFor(id){ for(var i=0;i<cockpit.performanceSeries.length;++i) if(cockpit.performanceSeries[i].id===id) return cockpit.performanceSeries[i]; return ({"values":[]}) }
    function validCount(){ var n=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid)++n; return n }
    function qColor(q){ return q>=99?Theme.green:(q>=90?Theme.amber:Theme.red) }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:82; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:1
                    Text { text:cockpit.rtl?"وحدة هندسة الحساسات":"SENSOR ENGINEERING CONSOLE"; color:Theme.platinum; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"جودة القنوات، النطاق، الاتجاه، وأدلة القياس":"CHANNEL QUALITY / RANGE / TREND / EVIDENCE"; color:Theme.muted; font.pixelSize:8 }
                }
            }
            StatusCard { Layout.preferredWidth:190; Layout.fillHeight:true; title:"VALID CHANNELS"; value:page.validCount()+" / "+cockpit.sensorCount; subtitle:"DATA QUALITY"; iconText:"CH"; accent:Theme.accent }
            StatusCard { Layout.preferredWidth:180; Layout.fillHeight:true; title:"TREND WINDOW"; value:String(cockpit.trendWindow); subtitle:"ROLLING FRAMES"; iconText:"WIN"; accent:Theme.accent }
            StatusCard { Layout.preferredWidth:190; Layout.fillHeight:true; title:"RECORDED"; value:String(cockpit.recordedFrames); subtitle:"SESSION FRAMES"; iconText:"REC"; accent:Theme.accent }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.preferredWidth:400; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"فهرس القنوات":"CHANNEL INDEX"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:String(cockpit.sensorCount); color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.sensorRows; clip:true; spacing:1; currentIndex:page.selectedIndex
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:58; color:index===page.selectedIndex?Theme.panel3:(index%2?Theme.panel2:Theme.panel); border.color:index===page.selectedIndex?Theme.accent:Theme.borderSoft; radius:Theme.radius
                            MouseArea { anchors.fill:parent; onClicked:page.selectedIndex=index }
                            RowLayout { anchors.fill:parent; anchors.margins:7
                                Rectangle { width:3; height:30; color:modelData.valid?Theme.accent:Theme.red }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                ColumnLayout { Layout.preferredWidth:110; spacing:0
                                    Text { text:Number(modelData.value).toFixed(2)+" "+modelData.unit; color:modelData.valid?Theme.platinum:Theme.red; font.family:"Consolas"; font.pixelSize:10; font.bold:true; Layout.alignment:Qt.AlignRight }
                                    Text { text:modelData.valid?"VALID":"INVALID"; color:modelData.valid?Theme.silver:Theme.red; font.family:"Consolas"; font.pixelSize:7; Layout.alignment:Qt.AlignRight }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
                Rectangle { Layout.fillWidth:true; Layout.preferredHeight:92; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                    RowLayout { anchors.fill:parent; anchors.margins:10
                        ColumnLayout { Layout.fillWidth:true; spacing:1
                            Text { text:page.selectedSensor().label; color:Theme.platinum; font.pixelSize:12; font.bold:true }
                            Text { text:page.selectedSensor().id.toUpperCase(); color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                        }
                        Text { text:Number(page.selectedSensor().value).toFixed(3)+" "+page.selectedSensor().unit; color:page.selectedSensor().valid?Theme.accent:Theme.red; font.family:"Consolas"; font.pixelSize:27; font.bold:true }
                        ColumnLayout { Layout.preferredWidth:120; spacing:1
                            Text { text:"QUALITY"; color:Theme.muted; font.pixelSize:7 }
                            Text { text:Number(page.trendFor(page.selectedSensor().id).quality).toFixed(1)+"%"; color:page.qColor(page.trendFor(page.selectedSensor().id).quality); font.family:"Consolas"; font.pixelSize:17; font.bold:true }
                        }
                    }
                }
                Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                    ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                        RowLayout { Layout.fillWidth:true
                            Text { text:cockpit.rtl?"النطاق المسجل للقناة":"RECORDED CHANNEL SCOPE"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }
                            Text { text:"SAMPLES "+page.trendFor(page.selectedSensor().id).valid; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                        }
                        TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:[page.seriesFor(page.selectedSensor().id)] }
                    }
                }
                GridLayout { Layout.fillWidth:true; Layout.preferredHeight:128; columns:3; columnSpacing:5; rowSpacing:5
                    Repeater { model:[
                        {"k":"MIN","v":Number(page.trendFor(page.selectedSensor().id).minimum).toFixed(3)},
                        {"k":"MEAN","v":Number(page.trendFor(page.selectedSensor().id).mean).toFixed(3)},
                        {"k":"MAX","v":Number(page.trendFor(page.selectedSensor().id).maximum).toFixed(3)},
                        {"k":"DELTA","v":Number(page.trendFor(page.selectedSensor().id).delta).toFixed(3)},
                        {"k":"SLOPE / s","v":Number(page.trendFor(page.selectedSensor().id).slope).toFixed(4)},
                        {"k":"INVALID / MISS","v":page.trendFor(page.selectedSensor().id).invalid+" / "+page.trendFor(page.selectedSensor().id).missing}
                    ]; delegate: MetricBox { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; label:modelData.k; value:modelData.v; accent:Theme.accent } }
                }
            }

            Rectangle { Layout.preferredWidth:350; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    Text { text:cockpit.rtl?"مصفوفة جودة البيانات":"DATA QUALITY MATRIX"; color:Theme.platinum; font.pixelSize:10; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    RowLayout { Layout.fillWidth:true; Layout.preferredHeight:22
                        Text { text:"CHANNEL"; color:Theme.muted; font.pixelSize:7; Layout.fillWidth:true }
                        Text { text:"QUALITY"; color:Theme.muted; font.pixelSize:7; Layout.preferredWidth:65; horizontalAlignment:Text.AlignRight }
                    }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.trendRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:46; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Rectangle { width:3; height:25; color:page.qColor(modelData.quality) }
                                Text { text:modelData.label; color:Theme.platinum; font.pixelSize:8; Layout.fillWidth:true; elide:Text.ElideRight }
                                Text { text:Number(modelData.quality).toFixed(1)+"%"; color:page.qColor(modelData.quality); font.family:"Consolas"; font.pixelSize:9; font.bold:true; Layout.preferredWidth:65; horizontalAlignment:Text.AlignRight }
                            }
                        }
                    }
                }
            }
        }
    }
}
