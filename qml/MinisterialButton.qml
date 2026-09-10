import QtQuick
import QtQuick.Controls
import "Theme.js" as Theme

Button {
    id: control
    property color accent: Theme.accent
    implicitHeight: 38
    implicitWidth: 118
    font.pixelSize: 10
    font.bold: true

    contentItem: Text {
        text: control.text
        color: control.enabled ? (control.checked ? Theme.platinum : Theme.silver) : "#58636B"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.letterSpacing: 0.65
    }

    background: Rectangle {
        radius: Theme.radius
        color: control.down ? Theme.elevated : (control.hovered ? Theme.panel3 : Theme.panel)
        border.width: control.checked ? 1 : 1
        border.color: control.checked ? control.accent : Theme.border
        Rectangle {
            visible: control.checked
            height: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: control.accent
        }
    }
}
