import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: card
    property string title: ""
    property string value: ""
    property string subtitle: ""
    property string iconText: "•"
    property color accent: Theme.green
    radius: Theme.radius
    color: Theme.panel
    border.width: 1
    border.color: Theme.border
    implicitHeight: 116
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 14; spacing: 6
        RowLayout {
            Layout.fillWidth: true
            Text { text: card.iconText; color: card.accent; font.pixelSize: 22; font.bold: true }
            Text { text: card.title; color: Theme.silver; font.pixelSize: 13; font.bold: true; Layout.fillWidth: true; wrapMode: Text.Wrap }
        }
        Text { text: card.value; color: card.accent; font.pixelSize: 27; font.bold: true; Layout.fillWidth: true }
        Text { text: card.subtitle; color: Theme.muted; font.pixelSize: 11; Layout.fillWidth: true; wrapMode: Text.Wrap }
    }
}
