import QtQuick
import "Theme.js" as Theme

Item {
    id: root
    property var series: []
    property real cursorRatio: 0.72
    property bool cursorVisible: true
    property var colors: [Theme.cyan, Theme.gold, Theme.green, "#b98cff"]

    Rectangle { anchors.fill: parent; color: "#030a0f"; border.color: Theme.border; border.width: 1 }

    Canvas {
        id: plot
        anchors.fill: parent
        anchors.margins: 1
        onPaint: {
            var c = getContext("2d"); c.reset();
            c.strokeStyle = Theme.grid; c.lineWidth = 1;
            for (var gx=1; gx<10; ++gx) { var x=gx*width/10; c.beginPath(); c.moveTo(x,0); c.lineTo(x,height); c.stroke(); }
            for (var gy=1; gy<6; ++gy) { var y=gy*height/6; c.beginPath(); c.moveTo(0,y); c.lineTo(width,y); c.stroke(); }
            if (!root.series) return;
            for (var s=0; s<root.series.length; ++s) {
                var row=root.series[s]; var values=row.values; if (!values || values.length<2) continue;
                var lo=Number(row.minimum); var hi=Number(row.maximum); if (Math.abs(hi-lo)<0.0001) { hi=lo+1; }
                c.strokeStyle=root.colors[s%root.colors.length]; c.lineWidth=1.7; c.beginPath();
                for (var i=0;i<values.length;++i) {
                    var px=i*width/Math.max(1,values.length-1);
                    var n=(Number(values[i])-lo)/(hi-lo); var py=height-Math.max(0,Math.min(1,n))*height;
                    if(i===0)c.moveTo(px,py); else c.lineTo(px,py);
                }
                c.stroke();
            }
            if(root.cursorVisible){ var cx=Math.max(0,Math.min(width,width*root.cursorRatio)); c.strokeStyle="#d7e2e7"; c.lineWidth=1; c.setLineDash([4,4]); c.beginPath(); c.moveTo(cx,0); c.lineTo(cx,height); c.stroke(); c.setLineDash([]); }
        }
        Connections { target: cockpit; function onDataChanged(){ plot.requestPaint(); } }
    }

    MouseArea {
        anchors.fill: parent; hoverEnabled: true
        onPositionChanged: function(mouse){ root.cursorRatio=Math.max(0,Math.min(1,mouse.x/width)); plot.requestPaint(); }
    }
}
