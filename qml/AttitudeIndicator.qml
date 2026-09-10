import QtQuick
import "Theme.js" as Theme

Item {
    id: root
    property real pitch: 0
    property real roll: 0
    width: 300
    height: 300

    Behavior on pitch { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
    Behavior on roll { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

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
            c.beginPath(); c.arc(cx,cy,r,0,Math.PI*2); c.clip()
            c.translate(cx,cy)
            c.rotate(-root.roll*Math.PI/180)
            c.translate(0,root.pitch*2.05)

            // Muted sky/ground treatment to avoid a game-like presentation.
            c.fillStyle = "#2F4655"
            c.fillRect(-size,-size*1.4,size*2,size*1.4)
            c.fillStyle = "#3A3530"
            c.fillRect(-size,0,size*2,size*1.4)
            c.strokeStyle = Theme.platinum
            c.globalAlpha = .9
            c.lineWidth = 2
            c.beginPath(); c.moveTo(-size,0); c.lineTo(size,0); c.stroke()

            c.font = "9px Consolas"
            c.textBaseline = "middle"
            c.fillStyle = Theme.platinum
            var ladder = [-30,-20,-10,10,20,30]
            for (var i=0;i<ladder.length;++i) {
                var deg = ladder[i]
                var y = -deg*2.05
                var longLine = Math.abs(deg)%20===0
                var half = longLine ? 44 : 30
                c.lineWidth = 1.3
                c.beginPath(); c.moveTo(-half,y); c.lineTo(half,y); c.stroke()
                c.fillText(String(Math.abs(deg)), -half-24, y)
                c.fillText(String(Math.abs(deg)), half+8, y)
            }
            c.restore()

            c.globalAlpha = 1
            c.strokeStyle = Theme.border
            c.lineWidth = 4
            c.beginPath(); c.arc(cx,cy,r,0,Math.PI*2); c.stroke()
            c.strokeStyle = Theme.silver
            c.lineWidth = 1
            c.beginPath(); c.arc(cx,cy,r-5,0,Math.PI*2); c.stroke()

            var marks = [-60,-45,-30,-20,-10,0,10,20,30,45,60]
            c.strokeStyle = Theme.platinum
            for (var m=0;m<marks.length;++m) {
                var a = (marks[m]-90)*Math.PI/180
                var len = marks[m]%30===0 ? 12 : 7
                c.lineWidth = marks[m]===0 ? 2 : 1
                c.beginPath()
                c.moveTo(cx+Math.cos(a)*(r-len),cy+Math.sin(a)*(r-len))
                c.lineTo(cx+Math.cos(a)*r,cy+Math.sin(a)*r)
                c.stroke()
            }

            c.strokeStyle = Theme.accent
            c.lineWidth = 3
            c.beginPath()
            c.moveTo(cx-r*0.54,cy)
            c.lineTo(cx-r*0.16,cy)
            c.lineTo(cx,cy+12)
            c.lineTo(cx+r*0.16,cy)
            c.lineTo(cx+r*0.54,cy)
            c.stroke()

            c.fillStyle = Theme.platinum
            c.beginPath()
            c.moveTo(cx,cy-r*0.90)
            c.lineTo(cx-7,cy-r*0.80)
            c.lineTo(cx+7,cy-r*0.80)
            c.closePath(); c.fill()
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 14
        anchors.horizontalCenter: parent.horizontalCenter
        width: 126
        height: 25
        radius: Theme.radius
        color: Theme.panel2
        border.color: Theme.border
        Text {
            anchors.centerIn: parent
            text: "P " + Number(root.pitch).toFixed(1) + "°   R " + Number(root.roll).toFixed(1) + "°"
            color: Theme.silver
            font.family: "Consolas"
            font.pixelSize: 9
            font.bold: true
        }
    }
}
