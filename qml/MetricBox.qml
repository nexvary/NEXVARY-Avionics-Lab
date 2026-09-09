import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme
Rectangle {
    id: root
    property string label: ""
    property string value: ""
    property color accent: Theme.green
    radius:7; color:"#081820"; border.color:Theme.border
    ColumnLayout { anchors.fill:parent; anchors.margins:8; spacing:3
        Text { text:root.label; color:Theme.muted; font.pixelSize:9; Layout.fillWidth:true; elide:Text.ElideRight }
        Text { text:root.value; color:root.accent; font.pixelSize:16; font.bold:true; Layout.fillWidth:true; horizontalAlignment:Text.AlignRight }
    }
}
