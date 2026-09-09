import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    color: Theme.panel
    border.color: Theme.border
    radius: Theme.radius
    function colorFor(i){ return [Theme.cyan,Theme.gold,Theme.green,"#b98cff"][i%4] }
    ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:3
        RowLayout { Layout.fillWidth:true
            Text { text:cockpit.text("system_performance").toUpperCase(); color:Theme.silver; font.bold:true; font.pixelSize:9; Layout.fillWidth:true; font.letterSpacing:.6 }
            Text { text:"LIVE"; color:Theme.green; font.family:"Consolas"; font.pixelSize:8 }
        }
        Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
        Repeater {
            model:cockpit.performanceSeries
            delegate: RowLayout { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; spacing:6
                ColumnLayout { Layout.preferredWidth:104; spacing:0
                    Text { text:modelData.label; color:Theme.muted; font.pixelSize:8; elide:Text.ElideRight; Layout.fillWidth:true }
                    Text { text:Number(modelData.latest).toFixed(1)+" "+modelData.unit; color:root.colorFor(index); font.bold:true; font.family:"Consolas"; font.pixelSize:10 }
                }
                Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:"#030a0f"; border.color:Theme.grid
                    TelemetrySparkline { anchors.fill:parent; anchors.margins:2; values:modelData.values; minValue:modelData.minimum; maxValue:modelData.maximum; lineColor:root.colorFor(index) }
                }
            }
        }
    }
}
