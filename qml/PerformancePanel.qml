import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme
Rectangle {
    id: root
    radius:10; color:Theme.panel; border.color:Theme.border
    function colorFor(i){ return [Theme.cyan,Theme.gold,Theme.green,"#b98cff"][i%4] }
    ColumnLayout { anchors.fill:parent; anchors.margins:12; spacing:5
        Text { text:cockpit.text("system_performance"); color:Theme.gold; font.bold:true; font.pixelSize:15 }
        Repeater {
            model:cockpit.performanceSeries
            delegate: RowLayout { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; spacing:7
                ColumnLayout { Layout.preferredWidth:120; spacing:1
                    Text { text:modelData.label; color:Theme.silver; font.pixelSize:9; elide:Text.ElideRight; Layout.fillWidth:true }
                    Text { text:Number(modelData.latest).toFixed(1)+" "+modelData.unit; color:root.colorFor(index); font.bold:true; font.pixelSize:11 }
                }
                TelemetrySparkline { Layout.fillWidth:true; Layout.fillHeight:true; values:modelData.values; minValue:modelData.minimum; maxValue:modelData.maximum; lineColor:root.colorFor(index) }
            }
        }
    }
}
