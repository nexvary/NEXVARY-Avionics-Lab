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
    implicitHeight: 86

    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 2; color: card.accent }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 11
        anchors.rightMargin: 9
        anchors.topMargin: 8
        anchors.bottomMargin: 7
        spacing: 2
        RowLayout {
            Layout.fillWidth: true
            Text { text: card.iconText; color: card.accent; font.pixelSize: 12; font.bold: true; font.family: "Consolas" }
            Text { text: card.title.toUpperCase(); color: Theme.muted; font.pixelSize: 9; font.bold: true; font.letterSpacing: 0.7; Layout.fillWidth: true; elide: Text.ElideRight }
        }
        Text { text: card.value; color: card.accent; font.pixelSize: 20; font.bold: true; font.family: "Consolas"; Layout.fillWidth: true; elide: Text.ElideRight }
        Text { text: card.subtitle; color: Theme.silver; font.pixelSize: 9; Layout.fillWidth: true; elide: Text.ElideRight }
    }
}
