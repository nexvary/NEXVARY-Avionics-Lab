import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme
Item {
    GridLayout { anchors.fill:parent; anchors.margins:18; columns:2; columnSpacing:12; rowSpacing:12
        Repeater { model:cockpit.twinRows
            delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; radius:10; color:Theme.panel; border.width:2; border.color:Theme.stateColor(modelData.state)
                ColumnLayout { anchors.fill:parent; anchors.margins:20; spacing:10
                    Text { text:modelData.label; color:Theme.gold; font.pixelSize:22; font.bold:true }
                    Text { text:modelData.state; color:Theme.stateColor(modelData.state); font.pixelSize:29; font.bold:true }
                    ProgressBar { Layout.fillWidth:true; from:0; to:100; value:modelData.health }
                    Text { text:cockpit.text("health")+": "+Number(modelData.health).toFixed(0)+"%  •  "+cockpit.text("channels")+": "+modelData.valid+"/"+modelData.expected; color:Theme.text }
                    Text { text:cockpit.text("issues")+": "+modelData.issues; color:modelData.issues>0?Theme.amber:Theme.muted }
                }
            }
        }
    }
}
