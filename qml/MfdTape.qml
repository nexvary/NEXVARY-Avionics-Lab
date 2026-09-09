import QtQuick
import "Theme.js" as Theme

Rectangle {
    id: root
    property string title: ""
    property string unit: ""
    property real currentValue: 0
    property real majorStep: 10
    property int decimals: 0
    property color accent: Theme.cyan

    implicitWidth: 132
    implicitHeight: 150
    radius: 7
    color: "#061117"
    border.width: 1
    border.color: Theme.border
    clip: true

    Text {
        anchors.top: parent.top
        anchors.topMargin: 7
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.title
        color: Theme.muted
        font.pixelSize: 9
        font.bold: true
        elide: Text.ElideRight
        width: parent.width - 12
        horizontalAlignment: Text.AlignHCenter
    }

    Item {
        id: scale
        anchors.top: parent.top
        anchors.topMargin: 25
        anchors.bottom: valueBox.top
        anchors.bottomMargin: 4
        anchors.left: parent.left
        anchors.right: parent.right

        Repeater {
            model: 7
            delegate: Item {
                required property int index
                width: scale.width
                height: 18
                y: index * (scale.height - height) / 6
                property real tickValue: root.currentValue + (3 - index) * root.majorStep

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    width: index === 3 ? 34 : 18
                    height: index === 3 ? 2 : 1
                    color: index === 3 ? root.accent : "#52646d"
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    text: Number(parent.tickValue).toFixed(root.decimals)
                    color: index === 3 ? root.accent : Theme.silver
                    font.pixelSize: index === 3 ? 11 : 9
                    font.bold: index === 3
                }
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: 7
            height: 22
            color: root.accent
            opacity: 0.9
        }
    }

    Rectangle {
        id: valueBox
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 7
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 14
        height: 31
        radius: 4
        color: "#0b1c24"
        border.color: root.accent
        border.width: 1
        Text {
            anchors.centerIn: parent
            text: Number(root.currentValue).toFixed(root.decimals) + (root.unit.length ? " " + root.unit : "")
            color: root.accent
            font.pixelSize: 14
            font.bold: true
        }
    }
}
