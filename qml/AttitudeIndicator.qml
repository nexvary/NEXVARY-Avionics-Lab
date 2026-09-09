import QtQuick
import "Theme.js" as Theme

Item {
    id: root
    property real pitch: 0
    property real roll: 0
    width: 280; height: 280
    Rectangle {
        anchors.centerIn: parent; width: Math.min(parent.width, parent.height); height: width; radius: width/2
        clip: true; color: "#050b10"; border.color: Theme.border; border.width: 2
        Item {
            anchors.centerIn: parent; width: parent.width*1.3; height: parent.height*1.3
            rotation: -root.roll
            y: root.pitch * 2
            Rectangle { anchors.top: parent.top; width: parent.width; height: parent.height/2; color: "#1159ad" }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: parent.height/2; color: "#6b4322" }
            Rectangle { anchors.centerIn: parent; width: parent.width; height: 3; color: "white" }
            Repeater {
                model: [-20,-10,10,20]
                delegate: Rectangle {
                    required property int modelData
                    width: 72; height: 2; color: "white"; x: (parent.width-width)/2; y: parent.height/2 - modelData*2
                }
            }
        }
        Canvas {
            anchors.fill: parent
            onPaint: {
                var c = getContext("2d"); c.reset(); c.strokeStyle = "#f3d15c"; c.lineWidth = 4;
                c.beginPath(); c.moveTo(width*0.27,height*0.50); c.lineTo(width*0.43,height*0.50); c.lineTo(width*0.50,height*0.55); c.lineTo(width*0.57,height*0.50); c.lineTo(width*0.73,height*0.50); c.stroke();
                c.beginPath(); c.moveTo(width*0.50,height*0.16); c.lineTo(width*0.47,height*0.23); c.lineTo(width*0.53,height*0.23); c.closePath(); c.fillStyle="#f3d15c"; c.fill();
            }
        }
    }
}
