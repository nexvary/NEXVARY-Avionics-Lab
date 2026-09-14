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
        color: control.enabled ? (control.checked ? Theme.platinum : Theme.silver) : "#8E8E8E"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.letterSpacing: 0.65
    }

    background: Rectangle {
        radius: Theme.radius
        color: control.down ? Theme.elevated : (control.hovered ? Theme.panel3 : Theme.panel)
        border.width: control.checked ? Theme.activeFrameWidth : Theme.frameWidth
        border.color: control.checked ? control.accent : Theme.border
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: parent.radius + 2
            color: "transparent"
            border.color: Theme.goldGlow
            border.width: 1
            visible: control.checked
        }
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
