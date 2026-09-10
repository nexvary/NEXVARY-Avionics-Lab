import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    property string label: ""
    property string value: ""
    property color accent: Theme.accent

    radius: Theme.radius
    color: Theme.panel2
    border.color: Theme.border
    border.width: 1

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        color: root.accent
        opacity: .85
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 9
        anchors.rightMargin: 8
        anchors.topMargin: 7
        anchors.bottomMargin: 7
        spacing: 2
        Text {
            text: root.label.toUpperCase()
            color: Theme.muted
            font.pixelSize: 8
            font.bold: true
            font.letterSpacing: .5
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
        Item { Layout.fillHeight: true }
        Text {
            text: root.value
            color: root.accent
            font.family: "Consolas"
            font.pixelSize: 15
            font.bold: true
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideRight
        }
    }
}
