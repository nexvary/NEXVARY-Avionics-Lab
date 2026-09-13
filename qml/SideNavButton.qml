import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Button {
    id: control
    property string iconKind: "dashboard"
    implicitHeight: 52
    implicitWidth: 200
    checkable: true

    contentItem: RowLayout {
        spacing: 10
        NavIcon {
            kind: control.iconKind
            iconColor: control.checked ? Theme.platinum : Theme.silver
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
        }
        Text {
            text: control.text
            color: control.checked ? Theme.platinum : Theme.silver
            font.family: /[\u0600-\u06FF]/.test(control.text) ? Theme.arabicKufi : Theme.latinUi
            font.pixelSize: 12
            font.bold: control.checked
            font.letterSpacing: 0.1
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
        Rectangle {
            visible: control.checked
            width: 6; height: 6; radius: 3
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
