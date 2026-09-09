import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme
Item {
    ColumnLayout { anchors.fill:parent; anchors.margins:18; spacing:10
        RowLayout { Layout.fillWidth:true
            Text { text:cockpit.text("events"); color:Theme.gold; font.pixelSize:24; font.bold:true; Layout.fillWidth:true }
            Text { text:cockpit.eventCount+" "+cockpit.text("events"); color:Theme.muted }
        }
        ListView { Layout.fillWidth:true; Layout.fillHeight:true; spacing:6; clip:true; model:cockpit.eventRows
            delegate: Rectangle { required property var modelData; width:ListView.view.width; height:64; radius:7; color:Theme.panel; border.color:Theme.border
                RowLayout { anchors.fill:parent; anchors.margins:12
                    Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.green); font.bold:true; Layout.preferredWidth:90 }
                    Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:150 }
                    Text { text:modelData.message; color:Theme.text; Layout.fillWidth:true; wrapMode:Text.Wrap }
                }
            }
        }
    }
}
