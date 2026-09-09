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
    function sevColor(s){ return s==="FAULT"?Theme.red:(s==="WARN"?Theme.amber:Theme.green) }

    ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:8
        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:58; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"محطة الأحداث والارتباط الزمني":"EVENT CORRELATION CONSOLE"; color:Theme.gold; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"زمن الحدث، المصدر، الشدة، البحث والترشيح":"TIMESTAMP / SOURCE / SEVERITY / SEARCH / FILTER"; color:Theme.muted; font.pixelSize:9 }
                }
                Text { text:"TOTAL "+cockpit.eventCount; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:11; font.bold:true }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.preferredHeight:46; spacing:6
            Repeater { model:[{"t":"ALL","n":cockpit.eventCount,"c":Theme.cyan},{"t":"INFO","n":page.countSeverity("INFO"),"c":Theme.green},{"t":"WARN","n":page.countSeverity("WARN"),"c":Theme.amber},{"t":"FAULT","n":page.countSeverity("FAULT"),"c":Theme.red}]
                delegate: MinisterialButton { required property var modelData; text:modelData.t+"  "+modelData.n; checkable:true; checked:page.severityFilter===modelData.t; accent:modelData.c; implicitWidth:118; onClicked:page.severityFilter=modelData.t }
            }
            Item { Layout.fillWidth:true }
            TextField { Layout.preferredWidth:320; placeholderText:cockpit.rtl?"ابحث في المصدر أو الرسالة":"Search source or message"; color:Theme.text; font.family:"Consolas"; font.pixelSize:9; onTextChanged:page.query=text
                background:Rectangle{color:Theme.panel; border.color:activeFocus?Theme.cyan:Theme.border; radius:Theme.radius}
            }
        }

        Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:1
                Rectangle { Layout.fillWidth:true; Layout.preferredHeight:30; color:"#0a1920"
                    RowLayout { anchors.fill:parent; anchors.margins:6
                        Text { text:"TIME"; color:Theme.muted; Layout.preferredWidth:105; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                        Text { text:"SEVERITY"; color:Theme.muted; Layout.preferredWidth:72; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                        Text { text:"SOURCE"; color:Theme.muted; Layout.preferredWidth:150; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                        Text { text:"MESSAGE / EVIDENCE"; color:Theme.muted; Layout.fillWidth:true; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                    }
                }
                ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:1
                    delegate: Rectangle { required property int index; required property var modelData; property bool acceptedRow:page.accepted(modelData); width:ListView.view.width; height:acceptedRow?36:0; visible:acceptedRow; color:index%2?"#061219":"#08161d"
                        RowLayout { anchors.fill:parent; anchors.margins:6
                            Text { text:modelData.time; color:Theme.silver; Layout.preferredWidth:105; font.family:"Consolas"; font.pixelSize:8 }
                            Text { text:modelData.severity; color:page.sevColor(modelData.severity); Layout.preferredWidth:72; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                            Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:150; font.family:"Consolas"; font.pixelSize:8; elide:Text.ElideRight }
                            Text { text:modelData.message; color:Theme.text; Layout.fillWidth:true; font.pixelSize:9; elide:Text.ElideRight }
                        }
                    }
                }
            }
        }
    }
}
