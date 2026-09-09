import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property var values: []
    property color lineColor: Theme.cyan
    property real minValue: 0
    property real maxValue: 100

    onValuesChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var c = getContext("2d")
        c.clearRect(0,0,width,height)

        c.strokeStyle = "#17313c"
        c.lineWidth = 1
        for (var gx=1; gx<4; ++gx) {
            var xg = gx*width/4
            c.beginPath(); c.moveTo(xg,0); c.lineTo(xg,height); c.stroke()
        }
        for (var gy=1; gy<3; ++gy) {
            var yg = gy*height/3
            c.beginPath(); c.moveTo(0,yg); c.lineTo(width,yg); c.stroke()
        }

        if (!values || values.length < 2) return
        c.strokeStyle = lineColor
        c.lineWidth = 2
        c.beginPath()
        var lastX = 0
        var lastY = height/2
        for (var i=0; i<values.length; ++i) {
            var x = i * width / Math.max(1, values.length-1)
            var n = (values[i]-minValue)/Math.max(0.0001,maxValue-minValue)
            var y = height - Math.max(0,Math.min(1,n))*height
            if (i===0) c.moveTo(x,y); else c.lineTo(x,y)
            lastX=x; lastY=y
        }
        c.stroke()

        c.fillStyle = lineColor
        c.beginPath()
        c.arc(lastX,lastY,3.5,0,Math.PI*2)
        c.fill()
    }
}
