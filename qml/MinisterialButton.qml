import QtQuick
import QtQuick.Controls
import "Theme.js" as Theme

Button {
    id: control
    property color accent: Theme.gold
    implicitHeight: 36
    implicitWidth: 118
    font.pixelSize: 11
    font.bold: true
    contentItem: Text {
        text: control.text
        color: control.enabled ? (control.checked ? control.accent : Theme.text) : "#526069"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.letterSpacing: 0.4
    }
    background: Rectangle {
        radius: Theme.radius
        color: control.down ? "#12212a" : (control.hovered ? "#0c1a22" : Theme.panel)
        border.width: 1
        border.color: control.checked ? control.accent : Theme.border
        Rectangle { visible: control.checked; height: 2; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; color: control.accent }
    }
}
