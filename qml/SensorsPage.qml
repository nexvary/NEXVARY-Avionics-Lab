import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme
Item {
    ColumnLayout { anchors.fill:parent; anchors.margins:18; spacing:10
        Text { text:cockpit.text("sensors"); color:Theme.gold; font.pixelSize:24; font.bold:true }
        ListView { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8; clip:true; model:cockpit.sensorRows
            delegate: Rectangle { required property var modelData; width:ListView.view.width; height:68; radius:8; color:Theme.panel; border.color:modelData.valid?Theme.green:Theme.red
                RowLayout { anchors.fill:parent; anchors.margins:14
                    Text { text:modelData.label; color:Theme.gold; font.bold:true; Layout.fillWidth:true }
                    Text { text:Number(modelData.value).toFixed(2)+" "+modelData.unit; color:modelData.valid?Theme.green:Theme.red; font.pixelSize:20; font.bold:true }
                }
            }
        }
    }
}
