import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Button {
    id: control
    property string iconKind: "dashboard"
    implicitHeight: 46
    implicitWidth: 190
    checkable: true

    contentItem: RowLayout {
        spacing: 9
        NavIcon {
            kind: control.iconKind
            iconColor: control.checked ? Theme.platinum : Theme.silver
            Layout.preferredWidth: 19
            Layout.preferredHeight: 19
        }
        Text {
            text: control.text
            color: control.checked ? Theme.platinum : Theme.silver
            font.pixelSize: 10
            font.bold: control.checked
            font.letterSpacing: 0.2
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
        Rectangle {
            visible: control.checked
            width: 5; height: 5; radius: 2.5
            color: Theme.accent
        }
    }

    background: Rectangle {
        radius: Theme.radius
        color: control.checked ? Theme.panel3 : (control.hovered ? Theme.panel2 : "transparent")
        border.width: control.checked ? 1 : 0
        border.color: control.checked ? Theme.accent : "transparent"
        Rectangle {
            visible: control.checked
            width: 3
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: Theme.accent
        }
    }
}
