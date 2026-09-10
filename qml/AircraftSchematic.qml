import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property var subsystemRows: []
    property color accent: Theme.accent
    antialiasing: true

    onSubsystemRowsChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function stateColorAt(index) {
        if (!subsystemRows || index >= subsystemRows.length) return Theme.silver
        return Theme.stateColor(subsystemRows[index].state)
    }

    onPaint: {
        var c = getContext("2d")
        c.reset()
        var w = width, h = height, cx = w * 0.5

        c.strokeStyle = Theme.grid
        c.lineWidth = 1
        for (var x = 26; x < w; x += 26) {
            c.beginPath(); c.moveTo(x, 0); c.lineTo(x, h); c.stroke()
        }
        for (var y = 26; y < h; y += 26) {
            c.beginPath(); c.moveTo(0, y); c.lineTo(w, y); c.stroke()
        }

        c.save()
        c.strokeStyle = "#41515D"
        c.globalAlpha = .55
        c.setLineDash([4, 6])
        c.beginPath(); c.moveTo(cx, h * .05); c.lineTo(cx, h * .94); c.stroke()
        c.beginPath(); c.moveTo(w * .08, h * .48); c.lineTo(w * .92, h * .48); c.stroke()
        c.setLineDash([])
        c.restore()

        // Generic technical cutaway silhouette for training visualization.
        c.fillStyle = "#15212A"
        c.strokeStyle = Theme.accent
        c.lineWidth = 1.8
        c.beginPath()
        c.moveTo(cx, h * .05)
        c.lineTo(w * .555, h * .29)
        c.lineTo(w * .615, h * .36)
        c.lineTo(w * .90, h * .50)
        c.lineTo(w * .655, h * .54)
        c.lineTo(w * .59, h * .61)
        c.lineTo(w * .57, h * .80)
        c.lineTo(w * .70, h * .90)
        c.lineTo(w * .56, h * .875)
        c.lineTo(cx, h * .955)
        c.lineTo(w * .44, h * .875)
        c.lineTo(w * .30, h * .90)
        c.lineTo(w * .43, h * .80)
        c.lineTo(w * .41, h * .61)
        c.lineTo(w * .345, h * .54)
        c.lineTo(w * .10, h * .50)
        c.lineTo(w * .385, h * .36)
        c.lineTo(w * .445, h * .29)
        c.closePath(); c.fill(); c.stroke()

        // Structural ribs / cutaway lines.
        c.strokeStyle = "#6A88A0"
        c.globalAlpha = .35
        c.lineWidth = 1
        var ribs = [.22,.30,.38,.46,.54,.62,.70,.78]
        for (var i = 0; i < ribs.length; ++i) {
            var yy = h * ribs[i]
            c.beginPath(); c.moveTo(w*.39, yy); c.lineTo(w*.61, yy); c.stroke()
        }
        c.beginPath(); c.moveTo(cx,h*.08); c.lineTo(cx,h*.90); c.stroke()
        c.beginPath(); c.moveTo(w*.18,h*.49); c.lineTo(w*.82,h*.49); c.stroke()
        c.beginPath(); c.moveTo(w*.30,h*.42); c.lineTo(w*.70,h*.42); c.stroke()
        c.globalAlpha = 1

        var zones = [
            {x:cx, y:h*.23, color:stateColorAt(1)},
            {x:w*.38, y:h*.48, color:stateColorAt(2)},
            {x:w*.62, y:h*.48, color:stateColorAt(0)},
            {x:cx, y:h*.61, color:stateColorAt(3)},
            {x:cx, y:h*.79, color:stateColorAt(4)}
        ]
        for (var z = 0; z < zones.length; ++z) {
            c.fillStyle = zones[z].color
            c.beginPath(); c.arc(zones[z].x,zones[z].y,5,0,Math.PI*2); c.fill()
            c.strokeStyle = "#D9D7D4"; c.globalAlpha=.55
            c.beginPath(); c.arc(zones[z].x,zones[z].y,10,0,Math.PI*2); c.stroke(); c.globalAlpha=1
        }

        // Data bus and branch routing.
        c.strokeStyle = Theme.accent
        c.lineWidth = 1.1
        c.beginPath(); c.moveTo(cx,h*.20); c.lineTo(cx,h*.82); c.stroke()
        c.beginPath(); c.moveTo(w*.38,h*.48); c.lineTo(w*.62,h*.48); c.stroke()
        c.beginPath(); c.moveTo(w*.43,h*.61); c.lineTo(w*.57,h*.61); c.stroke()

        c.fillStyle = Theme.panel2
        c.strokeStyle = Theme.border
        var bw = Math.min(190,w*.38), bh = 42, bx = cx-bw/2, by = h*.43
        c.fillRect(bx,by,bw,bh); c.strokeRect(bx,by,bw,bh)
        c.fillStyle = Theme.platinum
        c.textAlign = "center"; c.font = "bold 10px Consolas"
        c.fillText("PLATFORM DATA BUS",cx,by+16)
        c.fillStyle = Theme.accent; c.font = "8px Consolas"
        c.fillText((subsystemRows ? subsystemRows.length : 0)+" SUBSYSTEMS / SYNTHETIC",cx,by+31)
    }
}
