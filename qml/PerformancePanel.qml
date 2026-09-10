import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    color: Theme.panel
    border.color: Theme.border
    radius: Theme.radius
    function colorFor(i){ return ["#6A88A0","#8299A8","#A0ACB4","#738A9A","#8B9CA7","#667C89"][i%6] }

    ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
        RowLayout { Layout.fillWidth:true
            Text { text:cockpit.text("system_performance").toUpperCase(); color:Theme.platinum; font.bold:true; font.pixelSize:9; Layout.fillWidth:true; font.letterSpacing:.5 }
            Text { text:"LIVE"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 }
        }
        Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
        Repeater {
            model:cockpit.performanceSeries
            delegate: RowLayout { required property int index; required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; spacing:6
                ColumnLayout { Layout.preferredWidth:108; spacing:0
                    Text { text:modelData.label; color:Theme.muted; font.pixelSize:7; elide:Text.ElideRight; Layout.fillWidth:true }
                    Text { text:Number(modelData.latest).toFixed(1)+" "+modelData.unit; color:Theme.platinum; font.bold:true; font.family:"Consolas"; font.pixelSize:9 }
                }
                Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel2; border.color:Theme.borderSoft; radius:Theme.radius
                    TelemetrySparkline { anchors.fill:parent; anchors.margins:2; values:modelData.values; minValue:modelData.minimum; maxValue:modelData.maximum; lineColor:root.colorFor(index) }
                }
            }
        }
    }
}
