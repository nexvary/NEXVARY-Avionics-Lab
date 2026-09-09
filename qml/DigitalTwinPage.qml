import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:8
        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:58; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.text("digital_twin_aircraft"); color:Theme.gold; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"ترابط الأنظمة والحالة المتزامنة":"SYSTEM INTERCONNECT / SYNCHRONIZED STATE"; color:Theme.muted; font.pixelSize:9 }
                }
                Text { text:"NOM "+cockpit.twinNominalCount+"  DEG "+cockpit.twinDegradedCount+"  FLT "+cockpit.twinFaultCount; color:cockpit.twinFaultCount?Theme.red:(cockpit.twinDegradedCount?Theme.amber:Theme.green); font.family:"Consolas"; font.pixelSize:12; font.bold:true }
            }
        }
        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
            Rectangle {
                Layout.preferredWidth:390; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:5
                    Text { text:cockpit.rtl?"مجموعة الأنظمة A":"SYSTEM GROUP A"; color:Theme.muted; font.pixelSize:9; font.bold:true }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property int index; required property var modelData; visible:index%2===0; Layout.fillWidth:true; Layout.fillHeight:visible; color:"#07141b"; border.color:Theme.stateColor(modelData.state); radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:9
                                Rectangle { width:4; height:32; color:Theme.stateColor(modelData.state) }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label.toUpperCase(); color:Theme.silver; font.pixelSize:10; font.bold:true; elide:Text.ElideRight; Layout.fillWidth:true }
                                    Text { text:"CH "+modelData.valid+"/"+modelData.expected+"  ISSUES "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                                }
                                Text { text:modelData.state+"\n"+Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); horizontalAlignment:Text.AlignRight; font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                            }
                        }
                    }
                    Item { Layout.fillHeight:true }
                }
            }
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:"#030a0f"; border.color:Theme.gold; radius:Theme.radius
                Canvas { anchors.fill:parent; onPaint:{var c=getContext("2d");c.reset();c.strokeStyle=Theme.grid;c.lineWidth=1;for(var x=35;x<width;x+=35){c.beginPath();c.moveTo(x,0);c.lineTo(x,height);c.stroke();}for(var y=35;y<height;y+=35){c.beginPath();c.moveTo(0,y);c.lineTo(width,y);c.stroke();}} }
                AircraftSchematic { anchors.centerIn:parent; width:parent.width*.72; height:parent.height*.82 }
                Text { anchors.left:parent.left; anchors.leftMargin:12; anchors.top:parent.top; anchors.topMargin:10; text:"DIGITAL TWIN / DATA FUSION"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:9 }
                Text { anchors.right:parent.right; anchors.rightMargin:12; anchors.bottom:parent.bottom; anchors.bottomMargin:10; text:cockpit.twinFaultCount===0?"STATE: SYNCHRONIZED":"STATE: DEGRADED"; color:cockpit.twinFaultCount===0?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
            }
            Rectangle {
                Layout.preferredWidth:390; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:5
                    Text { text:cockpit.rtl?"مجموعة الأنظمة B":"SYSTEM GROUP B"; color:Theme.muted; font.pixelSize:9; font.bold:true }
                    Repeater { model:cockpit.twinRows
                        delegate: Rectangle { required property int index; required property var modelData; visible:index%2===1; Layout.fillWidth:true; Layout.fillHeight:visible; color:"#07141b"; border.color:Theme.stateColor(modelData.state); radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:9
                                Rectangle { width:4; height:32; color:Theme.stateColor(modelData.state) }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label.toUpperCase(); color:Theme.silver; font.pixelSize:10; font.bold:true; elide:Text.ElideRight; Layout.fillWidth:true }
                                    Text { text:"CH "+modelData.valid+"/"+modelData.expected+"  ISSUES "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                                }
                                Text { text:modelData.state+"\n"+Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); horizontalAlignment:Text.AlignRight; font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                            }
                        }
                    }
                    Item { Layout.fillHeight:true }
                }
            }
        }
    }
}
