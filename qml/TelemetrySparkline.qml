import QtQuick
import "Theme.js" as Theme
Canvas {
    id: root
    property var values: []
    property color lineColor: Theme.cyan
    property real minValue: 0
    property real maxValue: 100
    onValuesChanged: requestPaint()
    onPaint: {
        var c = getContext("2d"); c.reset(); c.strokeStyle = lineColor; c.lineWidth = 2;
        if (!values || values.length < 2) return;
        c.beginPath();
        for (var i=0; i<values.length; ++i) {
            var x = i * width / Math.max(1, values.length-1);
            var n = (values[i]-minValue)/Math.max(0.0001,maxValue-minValue);
            var y = height - Math.max(0,Math.min(1,n))*height;
            if (i===0) c.moveTo(x,y); else c.lineTo(x,y);
        }
        c.stroke();
    }
}
