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

    ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:8
        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:58; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"وحدة هندسة الحساسات":"SENSOR ENGINEERING CONSOLE"; color:Theme.gold; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"جودة القنوات، الاتجاهات، القيم غير الصالحة وأدلة القياس":"CHANNEL QUALITY / TREND / VALIDITY / EVIDENCE"; color:Theme.muted; font.pixelSize:9 }
                }
                Text { text:"VALID "+page.validCount()+" / "+cockpit.sensorCount; color:page.validCount()===cockpit.sensorCount?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:12; font.bold:true }
                Text { text:"WINDOW "+cockpit.trendWindow; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:10 }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
            Rectangle { Layout.preferredWidth:410; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"فهرس القنوات":"CHANNEL INDEX"; color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:String(cockpit.sensorCount); color:Theme.cyan; font.family:"Consolas" }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.sensorRows; clip:true; spacing:1; currentIndex:page.selectedIndex
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:56; color:index===page.selectedIndex?"#0a2029":(index%2?"#061219":"#08161d"); border.color:index===page.selectedIndex?Theme.cyan:"transparent"
                            MouseArea { anchors.fill:parent; onClicked:page.selectedIndex=index }
                            RowLayout { anchors.fill:parent; anchors.margins:7
                                Rectangle { width:4; height:28; color:modelData.valid?Theme.green:Theme.red }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label; color:Theme.text; font.pixelSize:9; font.bold:true; elide:Text.ElideRight; Layout.fillWidth:true }
                                    Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                ColumnLayout { Layout.preferredWidth:112; spacing:0
                                    Text { text:Number(modelData.value).toFixed(2)+" "+modelData.unit; color:modelData.valid?Theme.cyan:Theme.red; font.family:"Consolas"; font.pixelSize:11; font.bold:true; Layout.alignment:Qt.AlignRight }
                                    Text { text:modelData.valid?"VALID":"INVALID"; color:modelData.valid?Theme.green:Theme.red; font.family:"Consolas"; font.pixelSize:7; Layout.alignment:Qt.AlignRight }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
                Rectangle { Layout.fillWidth:true; Layout.preferredHeight:98; color:"#06141b"; border.color:page.selectedSensor().valid?Theme.green:Theme.red; radius:Theme.radius
                    RowLayout { anchors.fill:parent; anchors.margins:12
                        ColumnLayout { Layout.fillWidth:true; spacing:2
                            Text { text:page.selectedSensor().label; color:Theme.silver; font.pixelSize:12; font.bold:true }
                            Text { text:page.selectedSensor().id.toUpperCase(); color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                        }
                        Text { text:Number(page.selectedSensor().value).toFixed(3)+" "+page.selectedSensor().unit; color:page.selectedSensor().valid?Theme.cyan:Theme.red; font.family:"Consolas"; font.pixelSize:30; font.bold:true }
                        ColumnLayout { Layout.preferredWidth:115; spacing:1
                            Text { text:"QUALITY"; color:Theme.muted; font.pixelSize:8 }
                            Text { text:Number(page.trendFor(page.selectedSensor().id).quality).toFixed(1)+"%"; color:page.qColor(page.trendFor(page.selectedSensor().id).quality); font.family:"Consolas"; font.pixelSize:18; font.bold:true }
                        }
                    }
                }
                Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                    ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:4
                        RowLayout { Layout.fillWidth:true
                            Text { text:cockpit.rtl?"نطاق القناة المسجل":"RECORDED CHANNEL SCOPE"; color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                            Text { text:"SAMPLES "+page.trendFor(page.selectedSensor().id).valid; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:8 }
                        }
                        TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:[page.seriesFor(page.selectedSensor().id)] }
                    }
                }
                GridLayout { Layout.fillWidth:true; Layout.preferredHeight:132; columns:3; columnSpacing:5; rowSpacing:5
                    Repeater { model:[
                        {"k":"MIN","v":Number(page.trendFor(page.selectedSensor().id).minimum).toFixed(3)},
                        {"k":"MEAN","v":Number(page.trendFor(page.selectedSensor().id).mean).toFixed(3)},
                        {"k":"MAX","v":Number(page.trendFor(page.selectedSensor().id).maximum).toFixed(3)},
                        {"k":"DELTA","v":Number(page.trendFor(page.selectedSensor().id).delta).toFixed(3)},
                        {"k":"SLOPE / s","v":Number(page.trendFor(page.selectedSensor().id).slope).toFixed(4)},
                        {"k":"INVALID / MISS","v":page.trendFor(page.selectedSensor().id).invalid+" / "+page.trendFor(page.selectedSensor().id).missing}
                    ]; delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:"#07141a"; border.color:Theme.border
                        Column { anchors.centerIn:parent; spacing:4
                            Text { anchors.horizontalCenter:parent.horizontalCenter; text:modelData.k; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                            Text { anchors.horizontalCenter:parent.horizontalCenter; text:modelData.v; color:Theme.silver; font.family:"Consolas"; font.pixelSize:12; font.bold:true }
                        }
                    } }
                }
            }

            Rectangle { Layout.preferredWidth:360; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                    Text { text:cockpit.rtl?"مصفوفة جودة البيانات":"DATA QUALITY MATRIX"; color:Theme.gold; font.pixelSize:11; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.trendRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:44; color:index%2?"#061219":"#08161d"
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Rectangle { width:4; height:24; color:page.qColor(modelData.quality) }
                                Text { text:modelData.label; color:Theme.text; font.pixelSize:8; Layout.fillWidth:true; elide:Text.ElideRight }
                                Text { text:Number(modelData.quality).toFixed(1)+"%"; color:page.qColor(modelData.quality); font.family:"Consolas"; font.pixelSize:9; font.bold:true }
                            }
                        }
                    }
                }
            }
        }
    }
}
