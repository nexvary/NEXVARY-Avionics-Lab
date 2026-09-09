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

    Canvas {
        id: display
        anchors.fill: parent
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Connections {
            target: root
            function onPitchChanged() { display.requestPaint() }
            function onRollChanged() { display.requestPaint() }
        }

        onPaint: {
            var c = getContext("2d")
            c.clearRect(0,0,width,height)
            var size = Math.min(width,height)
            var cx = width/2
            var cy = height/2
            var r = size*0.455

            c.save()
            c.beginPath()
            c.arc(cx,cy,r,0,Math.PI*2)
            c.clip()
            c.translate(cx,cy)
            c.rotate(-root.roll*Math.PI/180)
            c.translate(0,root.pitch*2.2)

            c.fillStyle = "#0d5ab5"
            c.fillRect(-size,-size*1.4,size*2,size*1.4)
            c.fillStyle = "#6a431f"
            c.fillRect(-size,0,size*2,size*1.4)
            c.strokeStyle = "#ffffff"
            c.lineWidth = 3
            c.beginPath(); c.moveTo(-size,0); c.lineTo(size,0); c.stroke()

            c.font = "10px sans-serif"
            c.textBaseline = "middle"
            c.fillStyle = "#ffffff"
            var ladder = [-30,-20,-10,10,20,30]
            for (var i=0;i<ladder.length;++i) {
                var deg = ladder[i]
                var y = -deg*2.2
                var longLine = Math.abs(deg)%20===0
                var half = longLine ? 48 : 32
                c.lineWidth = 2
                c.beginPath(); c.moveTo(-half,y); c.lineTo(half,y); c.stroke()
                c.fillText(String(Math.abs(deg)), -half-27, y)
                c.fillText(String(Math.abs(deg)), half+10, y)
            }
            c.restore()

            c.strokeStyle = "#52646d"
            c.lineWidth = 4
            c.beginPath(); c.arc(cx,cy,r,0,Math.PI*2); c.stroke()

            var marks = [-60,-45,-30,-20,-10,0,10,20,30,45,60]
            c.strokeStyle = "#dce8ed"
            for (var m=0;m<marks.length;++m) {
                var a = (marks[m]-90)*Math.PI/180
                var len = marks[m]%30===0 ? 13 : 8
                c.lineWidth = marks[m]===0 ? 3 : 2
                c.beginPath()
                c.moveTo(cx+Math.cos(a)*(r-len),cy+Math.sin(a)*(r-len))
                c.lineTo(cx+Math.cos(a)*r,cy+Math.sin(a)*r)
                c.stroke()
            }

            c.strokeStyle = Theme.gold
            c.lineWidth = 4
            c.beginPath()
            c.moveTo(cx-r*0.57,cy)
            c.lineTo(cx-r*0.17,cy)
            c.lineTo(cx,cy+14)
            c.lineTo(cx+r*0.17,cy)
            c.lineTo(cx+r*0.57,cy)
            c.stroke()

            c.fillStyle = Theme.gold
            c.beginPath()
            c.moveTo(cx,cy-r*0.92)
            c.lineTo(cx-8,cy-r*0.80)
            c.lineTo(cx+8,cy-r*0.80)
            c.closePath(); c.fill()
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 14
        anchors.horizontalCenter: parent.horizontalCenter
        width: 126
        height: 25
        radius: 4
        color: "#071218dd"
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
