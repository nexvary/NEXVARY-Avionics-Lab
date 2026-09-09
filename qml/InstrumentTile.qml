import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    property string tileLabel: ""
    property string tileValue: ""
    property string tileState: "NOMINAL"
    radius: 10
    color: Theme.panel
    border.width: 1
    border.color: Theme.stateColor(tileState)
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 14; spacing: 8
        Text { text: root.tileLabel; color: Theme.silver; font.pixelSize: 13; font.bold: true; Layout.fillWidth: true; wrapMode: Text.Wrap }
        Item { Layout.fillHeight: true }
        Text { text: root.tileValue; color: Theme.text; font.pixelSize: 25; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 28; radius: 5; color: "#0b1b22"; border.color: Theme.stateColor(root.tileState)
            Text { anchors.centerIn: parent; text: root.tileState; color: Theme.stateColor(root.tileState); font.pixelSize: 10; font.bold: true }
        }
    }
}
