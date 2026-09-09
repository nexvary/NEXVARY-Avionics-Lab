import QtQuick
import "Theme.js" as Theme

Item {
    id: root
    property real pitch: 0
    property real roll: 0
    width: 300
    height: 300

    Behavior on pitch { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
    Behavior on roll { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

    Rectangle {
        id: bezel
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height)
        height: width
        radius: width / 2
        color: "#03080c"
        border.color: "#52646d"
        border.width: 3
        clip: true

        Item {
            id: horizon
            anchors.centerIn: parent
            width: parent.width * 1.45
            height: parent.height * 1.45
            rotation: -root.roll
            y: root.pitch * 2.2

            Rectangle { anchors.top: parent.top; width: parent.width; height: parent.height/2; color: "#0d5ab5" }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: parent.height/2; color: "#6a431f" }
            Rectangle { anchors.centerIn: parent; width: parent.width; height: 3; color: "#f7f7f7" }

            Repeater {
                model: [-30,-20,-10,10,20,30]
                delegate: Item {
                    required property int modelData
                    width: horizon.width
                    height: 18
                    y: horizon.height/2 - modelData*2.2 - height/2
                    Rectangle {
                        anchors.centerIn: parent
                        width: Math.abs(modelData) % 20 === 0 ? 92 : 62
                        height: 2
                        color: "white"
                        opacity: 0.95
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.horizontalCenterOffset: -64
                        text: Math.abs(modelData)
                        color: "white"
                        font.pixelSize: 9
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.horizontalCenterOffset: 64
                        text: Math.abs(modelData)
                        color: "white"
                        font.pixelSize: 9
                    }
                }
            }
        }

        Canvas {
            anchors.fill: parent
            onPaint: {
                var c = getContext("2d")
                c.clearRect(0,0,width,height)
                var cx = width/2
                var cy = height/2
                var radius = Math.min(width,height)*0.44

                c.strokeStyle = "#dce8ed"
                c.lineWidth = 2
                var marks = [-60,-45,-30,-20,-10,0,10,20,30,45,60]
                for (var i=0;i<marks.length;++i) {
                    var a = (marks[i]-90) * Math.PI/180
                    var len = (marks[i] % 30 === 0) ? 12 : 7
                    c.beginPath()
                    c.moveTo(cx + Math.cos(a)*(radius-len), cy + Math.sin(a)*(radius-len))
                    c.lineTo(cx + Math.cos(a)*radius, cy + Math.sin(a)*radius)
                    c.stroke()
                }

                c.strokeStyle = Theme.gold
                c.lineWidth = 4
                c.beginPath()
                c.moveTo(width*0.25,cy)
                c.lineTo(width*0.43,cy)
                c.lineTo(cx,cy+14)
                c.lineTo(width*0.57,cy)
                c.lineTo(width*0.75,cy)
                c.stroke()

                c.fillStyle = Theme.gold
                c.beginPath()
                c.moveTo(cx,height*0.10)
                c.lineTo(cx-8,height*0.15)
                c.lineTo(cx+8,height*0.15)
                c.closePath()
                c.fill()
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 14
            anchors.horizontalCenter: parent.horizontalCenter
            width: 122
            height: 25
            radius: 4
            color: "#071218cc"
            border.color: Theme.border
            Text {
                anchors.centerIn: parent
                text: "P " + Number(root.pitch).toFixed(1) + "°   R " + Number(root.roll).toFixed(1) + "°"
                color: Theme.silver
                font.pixelSize: 10
                font.bold: true
            }
        }
    }
}
