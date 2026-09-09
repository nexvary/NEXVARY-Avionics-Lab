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

    Text {
        anchors.top: parent.top
        anchors.topMargin: 7
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 14
        text: root.title
        color: Theme.muted
        font.pixelSize: 9
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
    }

    Canvas {
        id: tape
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 27
        anchors.bottom: valueBox.top
        anchors.bottomMargin: 5

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Connections {
            target: root
            function onCurrentValueChanged() { tape.requestPaint() }
            function onMajorStepChanged() { tape.requestPaint() }
            function onDecimalsChanged() { tape.requestPaint() }
            function onAccentChanged() { tape.requestPaint() }
        }

        onPaint: {
            var c = getContext("2d")
            c.clearRect(0,0,width,height)
            if (height <= 5 || width <= 20) return
            c.font = "9px sans-serif"
            c.textBaseline = "middle"
            for (var i=0; i<7; ++i) {
                var y = 7 + i * (height - 14) / 6
                var value = root.currentValue + (3-i) * root.majorStep
                var selected = (i === 3)
                c.fillStyle = selected ? root.accent : Theme.silver
                c.fillText(Number(value).toFixed(root.decimals), 8, y)
                c.strokeStyle = selected ? root.accent : "#52646d"
                c.lineWidth = selected ? 2 : 1
                c.beginPath()
                c.moveTo(width - (selected ? 38 : 23), y)
                c.lineTo(width - 8, y)
                c.stroke()
            }
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: tape.verticalCenter
        width: 7
        height: 24
        color: root.accent
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
