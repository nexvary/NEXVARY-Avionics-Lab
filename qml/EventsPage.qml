import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    property string severityFilter: "ALL"
    property string query: ""
    function countSeverity(s){ var n=0; for(var i=0;i<cockpit.eventRows.length;++i) if(cockpit.eventRows[i].severity===s)++n; return n }
    function accepted(row){ var sev=severityFilter==="ALL" || row.severity===severityFilter; var q=query.trim().toLowerCase(); if(q.length===0)return sev; return sev && (String(row.message).toLowerCase().indexOf(q)>=0 || String(row.source).toLowerCase().indexOf(q)>=0) }
    function sevColor(s){ return s==="FAULT"?Theme.red:(s==="WARN"?Theme.amber:Theme.silver) }

    ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:7
        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:82; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:1
                    Text { text:cockpit.rtl?"محطة الأحداث والارتباط الزمني":"EVENT CORRELATION CONSOLE"; color:Theme.platinum; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"الوقت، المصدر، الشدة، البحث، وسلسلة الأدلة":"TIME / SOURCE / SEVERITY / SEARCH / EVIDENCE CHAIN"; color:Theme.muted; font.pixelSize:8 }
                }
            }
            StatusCard { Layout.preferredWidth:170; Layout.fillHeight:true; title:"TOTAL"; value:String(cockpit.eventCount); subtitle:"EVENTS"; iconText:"EVT"; accent:Theme.accent }
            StatusCard { Layout.preferredWidth:170; Layout.fillHeight:true; title:"WARN"; value:String(page.countSeverity("WARN")); subtitle:"ATTENTION"; iconText:"WRN"; accent:page.countSeverity("WARN")?Theme.amber:Theme.silver }
            StatusCard { Layout.preferredWidth:170; Layout.fillHeight:true; title:"FAULT"; value:String(page.countSeverity("FAULT")); subtitle:"CRITICAL"; iconText:"FLT"; accent:page.countSeverity("FAULT")?Theme.red:Theme.silver }
        }

        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:54; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:8; spacing:6
                Repeater { model:[{"t":"ALL","n":cockpit.eventCount,"c":Theme.accent},{"t":"INFO","n":page.countSeverity("INFO"),"c":Theme.silver},{"t":"WARN","n":page.countSeverity("WARN"),"c":Theme.amber},{"t":"FAULT","n":page.countSeverity("FAULT"),"c":Theme.red}]
                    delegate: MinisterialButton { required property var modelData; text:modelData.t+"  "+modelData.n; checkable:true; checked:page.severityFilter===modelData.t; accent:modelData.c; implicitWidth:118; onClicked:page.severityFilter=modelData.t }
                }
                Item { Layout.fillWidth:true }
                TextField { Layout.preferredWidth:360; placeholderText:cockpit.rtl?"ابحث في المصدر أو الرسالة":"Search source or message"; color:Theme.platinum; font.family:"Consolas"; font.pixelSize:9; onTextChanged:page.query=text
                    background:Rectangle{color:Theme.panel2; border.color:activeFocus?Theme.accent:Theme.border; radius:Theme.radius}
                }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
            Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:1
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:32; color:Theme.panel2; border.color:Theme.borderSoft
                        RowLayout { anchors.fill:parent; anchors.margins:6
                            Text { text:"TIME"; color:Theme.muted; Layout.preferredWidth:110; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                            Text { text:"SEVERITY"; color:Theme.muted; Layout.preferredWidth:76; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                            Text { text:"SOURCE"; color:Theme.muted; Layout.preferredWidth:150; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                            Text { text:"MESSAGE / EVIDENCE"; color:Theme.muted; Layout.fillWidth:true; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                        }
                    }
                    ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:1
                        delegate: Rectangle { required property int index; required property var modelData; property bool acceptedRow:page.accepted(modelData); width:ListView.view.width; height:acceptedRow?38:0; visible:acceptedRow; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:6
                                Text { text:modelData.time; color:Theme.silver; Layout.preferredWidth:110; font.family:"Consolas"; font.pixelSize:8 }
                                Text { text:modelData.severity; color:page.sevColor(modelData.severity); Layout.preferredWidth:76; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                                Text { text:modelData.source; color:Theme.accent; Layout.preferredWidth:150; font.family:"Consolas"; font.pixelSize:8; elide:Text.ElideRight }
                                Text { text:modelData.message; color:Theme.platinum; Layout.fillWidth:true; font.pixelSize:8; elide:Text.ElideRight }
                            }
                        }
                    }
                }
            }

            Rectangle { Layout.preferredWidth:390; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:5
                    Text { text:cockpit.rtl?"ملخص الأدلة":"EVIDENCE SUMMARY"; color:Theme.platinum; font.pixelSize:10; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    MetricBox { Layout.fillWidth:true; Layout.preferredHeight:72; label:"SESSION EVENTS"; value:String(cockpit.eventCount); accent:Theme.accent }
                    MetricBox { Layout.fillWidth:true; Layout.preferredHeight:72; label:"ACTIVE ALERTS"; value:String(cockpit.activeAlertCount); accent:cockpit.activeAlertCount?Theme.amber:Theme.accent }
                    MetricBox { Layout.fillWidth:true; Layout.preferredHeight:72; label:"RECORDED FRAMES"; value:String(cockpit.recordedFrames); accent:Theme.accent }
                    MetricBox { Layout.fillWidth:true; Layout.preferredHeight:72; label:"SCENARIO"; value:cockpit.scenario.toUpperCase(); accent:Theme.accent }
                    Item { Layout.fillHeight:true }
                    Rectangle { Layout.fillWidth:true; Layout.preferredHeight:88; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
                            Text { text:"TRACEABILITY"; color:Theme.muted; font.pixelSize:7 }
                            Text { text:"SCENARIO → EVENT → HEALTH → REPORT"; color:Theme.platinum; font.family:"Consolas"; font.pixelSize:8 }
                            Text { text:cockpit.rtl?"أدلة تدريب ومحاكاة فقط":"TRAINING / SIMULATION EVIDENCE ONLY"; color:Theme.muted; font.pixelSize:7 }
                        }
                    }
                }
            }
        }
    }
}
