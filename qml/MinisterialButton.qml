import QtQuick
import QtQuick.Controls
import "Theme.js" as Theme

Button {
    id: control
    property color accent: Theme.gold
    implicitHeight: 42
    implicitWidth: 128
    font.pixelSize: 13
    font.bold: true
    contentItem: Text {
        text: control.text
        color: control.enabled ? Theme.text : "#5e6a70"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        radius: 7
        color: control.down ? "#12242d" : (control.hovered ? "#0d1e26" : Theme.panel)
        border.width: control.checked ? 2 : 1
        border.color: control.checked ? control.accent : Theme.border
        Rectangle {
            visible: control.checked
            width: 4; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
            color: control.accent; radius: 2
        }
    }
}
