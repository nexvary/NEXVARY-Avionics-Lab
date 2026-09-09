import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function nominalPct(){ return Math.round(cockpit.twinNominalCount*100/Math.max(1,cockpit.twinRows.length)) }

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 12; spacing: 8
        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:58; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                Text { text:cockpit.rtl?"مخطط الأنظمة المتزامن":"SYSTEMS SYNOPTIC"; color:Theme.gold; font.pixelSize:18; font.bold:true; Layout.fillWidth:true }
                Text { text:"NOMINAL  "+cockpit.twinNominalCount+"   DEGRADED  "+cockpit.twinDegradedCount+"   FAULT  "+cockpit.twinFaultCount; color:cockpit.twinFaultCount>0?Theme.red:(cockpit.twinDegradedCount>0?Theme.amber:Theme.green); font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                Text { text:page.nominalPct()+"%"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:18; font.bold:true }
            }
        }

        RowLayout {
            Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:"#030b10"; border.color:Theme.border; radius:Theme.radius
                Canvas {
                    anchors.fill:parent
                    onPaint:{ var c=getContext("2d"); c.reset(); c.strokeStyle=Theme.grid; c.lineWidth=1; for(var x=40;x<width;x+=40){c.beginPath();c.moveTo(x,0);c.lineTo(x,height);c.stroke();} for(var y=40;y<height;y+=40){c.beginPath();c.moveTo(0,y);c.lineTo(width,y);c.stroke();} c.strokeStyle="#335565"; c.lineWidth=1.5; var cx=width/2, cy=height/2; var pts=[[.18,.22],[.82,.22],[.14,.72],[.86,.72],[.5,.84]]; for(var i=0;i<pts.length;i++){c.beginPath();c.moveTo(cx,cy);c.lineTo(width*pts[i][0],height*pts[i][1]);c.stroke();} }
                }
                Rectangle { width:170; height:74; anchors.centerIn:parent; color:"#071821"; border.color:Theme.cyan; radius:Theme.radius
                    Column { anchors.centerIn:parent; spacing:4
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"AVIONICS DATA CORE"; color:Theme.cyan; font.bold:true; font.pixelSize:12 }
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"SYNCHRONIZED"; color:Theme.green; font.family:"Consolas"; font.pixelSize:11 }
                    }
                }
                Repeater {
                    model:cockpit.twinRows
                    delegate: Rectangle {
                        required property int index; required property var modelData
                        width:190; height:92; color:"#07131a"; border.width:1; border.color:Theme.stateColor(modelData.state); radius:Theme.radius
                        x:index===0?24:(index===1?parent.width-width-24:(index===2?18:(index===3?parent.width-width-18:(parent.width-width)/2)))
                        y:index<2?50:(index<4?parent.height-height-80:parent.height-height-22)
                        ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:2
                            Text { text:modelData.label.toUpperCase(); color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                            RowLayout { Layout.fillWidth:true
                                Text { text:modelData.state; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:15; font.bold:true; Layout.fillWidth:true }
                                Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.text; font.family:"Consolas"; font.pixelSize:15 }
                            }
                            Text { text:"CH "+modelData.valid+"/"+modelData.expected+"   ISSUES "+modelData.issues; color:modelData.issues>0?Theme.amber:Theme.muted; font.family:"Consolas"; font.pixelSize:9 }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:390; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"حالة القنوات":"CHANNEL EVIDENCE"; color:Theme.gold; font.bold:true; font.pixelSize:14; Layout.fillWidth:true }
                        Text { text:cockpit.sensorCount+" CH"; color:Theme.cyan; font.family:"Consolas" }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?"#071219":"#09171e"; border.color:"#142933"; radius:0
                            RowLayout { anchors.fill:parent; anchors.margins:8
                                Rectangle { width:5; height:22; color:Theme.stateColor(modelData.state) }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label; color:Theme.text; font.pixelSize:10; font.bold:true; elide:Text.ElideRight; Layout.fillWidth:true }
                                    Text { text:"VALID "+modelData.valid+" / "+modelData.expected+"   ISSUES "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                                }
                                Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:13; font.bold:true }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:56; color:"#07141a"; border.color:Theme.border
                        RowLayout { anchors.fill:parent; anchors.margins:8
                            Text { text:cockpit.rtl?"التنبيهات النشطة":"ACTIVE ALERTS"; color:Theme.muted; Layout.fillWidth:true; font.pixelSize:9 }
                            Text { text:String(cockpit.activeAlertCount); color:cockpit.activeAlertCount?Theme.amber:Theme.green; font.family:"Consolas"; font.pixelSize:22; font.bold:true }
                        }
                    }
                }
            }
        }
    }
}
