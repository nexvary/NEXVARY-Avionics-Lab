import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function progress(){ return cockpit.replayMaximum>0 ? cockpit.replayIndex/cockpit.replayMaximum : 0 }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:82; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:1
                    Text { text:cockpit.rtl?"مختبر الإعادة والارتباط الزمني":"REPLAY & TIME-CORRELATION LAB"; color:Theme.platinum; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"إعادة تشغيل القياسات والإطارات والأدلة على محور زمني واحد":"FRAME-SYNCHRONIZED TELEMETRY / VALUES / EVIDENCE"; color:Theme.muted; font.pixelSize:8 }
                }
            }
            StatusCard { Layout.preferredWidth:190; Layout.fillHeight:true; title:"REPLAY TIME"; value:cockpit.replayTime; subtitle:"SESSION CLOCK"; iconText:"TIM"; accent:Theme.accent }
            StatusCard { Layout.preferredWidth:190; Layout.fillHeight:true; title:"FRAME"; value:cockpit.replayIndex+" / "+cockpit.replayMaximum; subtitle:"SESSION INDEX"; iconText:"FRM"; accent:Theme.accent }
        }

        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:66; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:8; spacing:7
                MinisterialButton { text:"-10"; implicitWidth:62; enabled:cockpit.replayMode&&cockpit.replayIndex>0; onClicked:cockpit.seekReplay(Math.max(0,cockpit.replayIndex-10)) }
                Slider { Layout.fillWidth:true; from:0; to:Math.max(1,cockpit.replayMaximum); value:cockpit.replayIndex; enabled:cockpit.replayMode; onMoved:cockpit.seekReplay(Math.round(value)) }
                MinisterialButton { text:"+10"; implicitWidth:62; enabled:cockpit.replayMode&&cockpit.replayIndex<cockpit.replayMaximum; onClicked:cockpit.seekReplay(Math.min(cockpit.replayMaximum,cockpit.replayIndex+10)) }
                MinisterialButton { text:cockpit.replayMode?(cockpit.replayPaused?(cockpit.rtl?"تشغيل":"PLAY"):(cockpit.rtl?"إيقاف مؤقت":"PAUSE")):(cockpit.rtl?"دخول الإعادة":"ENTER REPLAY"); accent:Theme.accent; onClicked:{ if(!cockpit.replayMode)cockpit.setReplayMode(true); else cockpit.setReplayPaused(!cockpit.replayPaused) } }
                MinisterialButton { text:cockpit.rtl?"خروج":"EXIT"; enabled:cockpit.replayMode; onClicked:cockpit.setReplayMode(false) }
                Rectangle { Layout.preferredWidth:170; Layout.preferredHeight:34; color:Theme.panel2; border.color:cockpit.replayMode?Theme.accent:Theme.border; radius:Theme.radius
                    Text { anchors.centerIn:parent; text:cockpit.replayMode?(cockpit.replayPaused?"PAUSED / SCRUB":"PLAYING"):("LIVE BUFFER "+cockpit.recordedFrames); color:cockpit.replayMode?Theme.platinum:Theme.silver; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"القياسات المتزامنة مع الإطار":"FRAME-SYNCHRONIZED TELEMETRY"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:Math.round(page.progress()*100)+"%"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:9 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:cockpit.performanceSeries; cursorRatio:page.progress(); cursorVisible:cockpit.replayMode }
                    RowLayout { Layout.fillWidth:true
                        Text { text:"BUFFER START"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                        Item { Layout.fillWidth:true }
                        Text { text:cockpit.replayTime; color:Theme.platinum; font.family:"Consolas"; font.pixelSize:8 }
                        Item { Layout.fillWidth:true }
                        Text { text:"BUFFER END"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:460; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"قيم الإطار الحالي":"CURRENT FRAME VALUES"; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true }
                        Text { text:cockpit.tiles.length+" CHANNELS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.tiles; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; width:ListView.view.width; height:50; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Rectangle { width:3; height:26; color:modelData.state==="NOMINAL"?Theme.accent:Theme.red }
                                ColumnLayout { Layout.fillWidth:true; spacing:0
                                    Text { text:modelData.label; color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                                }
                                Text { text:modelData.value; color:modelData.state==="NOMINAL"?Theme.platinum:Theme.red; font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                            }
                        }
                    }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:84; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:2
                            Text { text:"REPLAY CONTEXT"; color:Theme.muted; font.pixelSize:7 }
                            Text { text:"SCENARIO  "+cockpit.scenario.toUpperCase(); color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                            Text { text:"RECORDED  "+cockpit.recordedFrames+" FRAMES"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                            Text { text:cockpit.rtl?"محاكاة تدريبية فقط":"TRAINING / SIMULATION ONLY"; color:Theme.muted; font.pixelSize:7 }
                        }
                    }
                }
            }
        }
    }
}
