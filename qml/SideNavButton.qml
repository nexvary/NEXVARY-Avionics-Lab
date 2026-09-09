import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Button {
    id: control
    property string iconKind: "dashboard"
    implicitHeight: 49
    implicitWidth: 184
    checkable: true
    contentItem: RowLayout {
        spacing: 10
        NavIcon { kind: control.iconKind; iconColor: control.checked ? Theme.gold : "#8fa8b3"; Layout.preferredWidth: 22; Layout.preferredHeight: 22 }
        Text { text: control.text; color: control.checked ? Theme.gold : Theme.text; font.pixelSize: 11; font.bold: control.checked; Layout.fillWidth: true; elide: Text.ElideRight }
    }
    background: Rectangle {
        color: control.checked ? "#0d181a" : (control.hovered ? "#0a151b" : "transparent")
        border.width: control.checked ? 1 : 0
        border.color: control.checked ? "#5b4b25" : "transparent"
        radius: Theme.radius
        Rectangle { visible: control.checked; width: 2; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; color: Theme.gold }
    }
}
