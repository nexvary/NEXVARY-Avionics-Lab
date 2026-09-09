import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function progress(){ return cockpit.replayMaximum>0 ? cockpit.replayIndex/cockpit.replayMaximum : 0 }

    ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:8
        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:62; color:Theme.panel; border.color:cockpit.replayMode?Theme.cyan:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"مختبر الإعادة والتحليل الزمني":"REPLAY & TIME-CORRELATION LAB"; color:Theme.gold; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"إعادة تشغيل القياسات مع الرسوم والقيم بنفس الإطار":"FRAME-SYNCHRONIZED TELEMETRY / VALUES / EVIDENCE"; color:Theme.muted; font.pixelSize:9 }
                }
                Text { text:cockpit.replayTime; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:14; font.bold:true }
                Text { text:"FRAME "+cockpit.replayIndex+" / "+cockpit.replayMaximum; color:Theme.silver; font.family:"Consolas"; font.pixelSize:10 }
                MinisterialButton { text:cockpit.replayMode?(cockpit.replayPaused?(cockpit.rtl?"تشغيل":"PLAY"):(cockpit.rtl?"إيقاف مؤقت":"PAUSE")):(cockpit.rtl?"دخول الإعادة":"ENTER REPLAY"); accent:Theme.cyan; onClicked:{ if(!cockpit.replayMode)cockpit.setReplayMode(true); else cockpit.setReplayPaused(!cockpit.replayPaused) } }
                MinisterialButton { text:cockpit.rtl?"خروج":"EXIT"; enabled:cockpit.replayMode; onClicked:cockpit.setReplayMode(false) }
            }
        }

        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:74; color:"#06131a"; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:9; spacing:8
                MinisterialButton { text:"-10"; implicitWidth:58; enabled:cockpit.replayMode && cockpit.replayIndex>0; onClicked:cockpit.seekReplay(Math.max(0,cockpit.replayIndex-10)) }
                Slider { Layout.fillWidth:true; from:0; to:Math.max(1,cockpit.replayMaximum); value:cockpit.replayIndex; enabled:cockpit.replayMode; onMoved:cockpit.seekReplay(Math.round(value)) }
                MinisterialButton { text:"+10"; implicitWidth:58; enabled:cockpit.replayMode && cockpit.replayIndex<cockpit.replayMaximum; onClicked:cockpit.seekReplay(Math.min(cockpit.replayMaximum,cockpit.replayIndex+10)) }
                Rectangle { Layout.preferredWidth:180; Layout.preferredHeight:32; color:"#071b21"; border.color:cockpit.replayMode?Theme.cyan:Theme.border
                    Text { anchors.centerIn:parent; text:cockpit.replayMode?(cockpit.replayPaused?"PAUSED / SCRUB":"PLAYING"):("LIVE BUFFER "+cockpit.recordedFrames); color:cockpit.replayMode?Theme.cyan:Theme.green; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"القياسات المتزامنة مع الإطار":"FRAME-SYNCHRONIZED TELEMETRY"; color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:Math.round(page.progress()*100)+"%"; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:10 }
                    }
                    TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:cockpit.performanceSeries; cursorRatio:1.0; cursorVisible:cockpit.replayMode }
                    RowLayout { Layout.fillWidth:true
                        Text { text:"BUFFER START"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                        Item { Layout.fillWidth:true }
                        Text { text:cockpit.replayTime; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                        Item { Layout.fillWidth:true }
                        Text { text:"BUFFER END"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:430; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                    Text { text:cockpit.rtl?"قيم الإطار الحالي":"CURRENT FRAME VALUES"; color:Theme.gold; font.pixelSize:11; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.tiles; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:48; color:index%2?"#061219":"#08161d"
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Rectangle { width:4; height:25; color:modelData.state==="NOMINAL"?Theme.green:Theme.red }
                                ColumnLayout { Layout.fillWidth:true; spacing:0
                                    Text { text:modelData.label; color:Theme.text; font.pixelSize:8; font.bold:true; elide:Text.ElideRight; Layout.fillWidth:true }
                                    Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                Text { text:modelData.value; color:modelData.state==="NOMINAL"?Theme.cyan:Theme.red; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                            }
                        }
                    }
                }
            }
        }
    }
}
