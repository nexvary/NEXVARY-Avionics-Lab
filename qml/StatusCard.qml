import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: card
    property string title: ""
    property string value: ""
    property string subtitle: ""
    property string iconText: "•"
    property color accent: Theme.accent
    radius: Theme.radius
    color: Theme.panel
    border.width: 1
    border.color: Theme.border
    implicitHeight: 88

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 3
        color: card.accent
        opacity: 0.9
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 11
        anchors.topMargin: 9
        anchors.bottomMargin: 8
        spacing: 3
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: card.iconText
                color: Theme.silver
                font.pixelSize: 11
                font.bold: true
                font.family: "Consolas"
            }
            Text {
                text: card.title.toUpperCase()
                color: Theme.silver
                font.pixelSize: 8
                font.bold: true
                font.letterSpacing: 0.9
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
        Text {
            text: card.value
            color: card.accent
            font.pixelSize: 20
            font.bold: true
            font.family: "Consolas"
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
        Text {
            text: card.subtitle
            color: Theme.muted
            font.pixelSize: 8
            Layout.fillWidth: true
            elide: Text.ElideRight
        }
    }
}
