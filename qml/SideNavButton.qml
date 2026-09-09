import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Button {
    id: control
    property string iconKind: "dashboard"
    implicitHeight: 62
    implicitWidth: 176
    checkable: true
    contentItem: RowLayout {
        spacing: 12
        NavIcon { kind: control.iconKind; iconColor: control.checked ? Theme.gold : "#9eb8c7"; Layout.preferredWidth: 28; Layout.preferredHeight: 28 }
        Text { text: control.text; color: control.checked ? Theme.gold : Theme.text; font.pixelSize: 12; font.bold: control.checked; Layout.fillWidth: true; wrapMode: Text.Wrap }
    }
    background: Rectangle {
        color: control.checked ? "#152119" : (control.hovered ? "#0a171e" : "transparent")
        border.width: control.checked ? 1 : 0
        border.color: control.checked ? Theme.gold : "transparent"
        radius: 8
        Rectangle { visible: control.checked; width: 4; anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; color: Theme.gold; radius: 2 }
    }
}
