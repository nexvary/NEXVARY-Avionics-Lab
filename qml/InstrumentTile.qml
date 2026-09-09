import QtQuick

Rectangle {
    id: tile
    required property string tileLabel
    required property string tileValue
    required property string tileState

    implicitHeight: 138
    radius: 8
    color: "#071014"
    border.width: 2
    border.color: tileState === "NOMINAL" ? "#39ff9b" : "#ffb000"

    Column {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        Text {
            width: parent.width
            text: tile.tileLabel
            color: "#94aeb8"
            font.pixelSize: 15
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: parent.width
            text: tile.tileValue
            color: tile.tileState === "NOMINAL" ? "#39ff9b" : "#ffb000"
            font.pixelSize: 27
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: parent.width
            text: tile.tileState
            color: "#d3dde1"
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
