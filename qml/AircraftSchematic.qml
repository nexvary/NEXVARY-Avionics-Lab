import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property var subsystemRows: []
    property color accent: Theme.cyan
    antialiasing: true

    onSubsystemRowsChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function stateColorAt(index) {
        if (!subsystemRows || index >= subsystemRows.length) return Theme.muted
        return Theme.stateColor(subsystemRows[index].state)
    }

    onPaint: {
        var c = getContext("2d")
        c.reset()
        var w = width, h = height, cx = w * 0.5, cy = h * 0.51

        // Tactical-style reference rings and crosshair, deliberately generic training artwork.
        c.save()
        c.strokeStyle = "#153442"
        c.lineWidth = 1
        for (var r = 0.16; r <= 0.46; r += 0.10) {
            c.beginPath(); c.arc(cx, cy, w * r, 0, Math.PI * 2); c.stroke()
        }
        c.setLineDash([4, 6])
        c.beginPath(); c.moveTo(cx, h * .05); c.lineTo(cx, h * .95); c.stroke()
        c.beginPath(); c.moveTo(w * .08, cy); c.lineTo(w * .92, cy); c.stroke()
        c.setLineDash([])
        c.restore()

        // Filled generic aircraft/platform silhouette — no longer a single empty outline.
        var grad = c.createLinearGradient(cx, h * .10, cx, h * .90)
        grad.addColorStop(0, "#15384a")
        grad.addColorStop(.42, "#0a2533")
        grad.addColorStop(1, "#07151d")
        c.fillStyle = grad
        c.strokeStyle = accent
        c.lineWidth = 2.2
        c.shadowColor = accent
        c.shadowBlur = 12
        c.beginPath()
        c.moveTo(cx, h * .055)
        c.lineTo(w * .555, h * .285)
        c.lineTo(w * .615, h * .355)
        c.lineTo(w * .905, h * .515)
        c.lineTo(w * .655, h * .555)
        c.lineTo(w * .595, h * .615)
        c.lineTo(w * .575, h * .82)
        c.lineTo(w * .705, h * .91)
        c.lineTo(w * .565, h * .885)
        c.lineTo(cx, h * .965)
        c.lineTo(w * .435, h * .885)
        c.lineTo(w * .295, h * .91)
        c.lineTo(w * .425, h * .82)
        c.lineTo(w * .405, h * .615)
        c.lineTo(w * .345, h * .555)
        c.lineTo(w * .095, h * .515)
        c.lineTo(w * .385, h * .355)
        c.lineTo(w * .445, h * .285)
        c.closePath()
        c.fill(); c.stroke()
        c.shadowBlur = 0

        // Fuselage spine and segmented system zones.
        c.strokeStyle = "#426473"
        c.lineWidth = 1
        c.beginPath(); c.moveTo(cx, h * .08); c.lineTo(cx, h * .92); c.stroke()
        c.beginPath(); c.moveTo(w * .37, h * .49); c.lineTo(w * .63, h * .49); c.stroke()
        c.beginPath(); c.moveTo(w * .43, h * .64); c.lineTo(w * .57, h * .64); c.stroke()

        var zones = [
            {x:cx, y:h*.23, r:10, color:stateColorAt(1)},
            {x:w*.39, y:h*.48, r:10, color:stateColorAt(2)},
            {x:w*.61, y:h*.48, r:10, color:stateColorAt(0)},
            {x:cx, y:h*.61, r:10, color:stateColorAt(3)},
            {x:cx, y:h*.79, r:10, color:stateColorAt(4)}
        ]
        for (var i=0; i<zones.length; ++i) {
            var z=zones[i]
            c.fillStyle = z.color
            c.shadowColor = z.color; c.shadowBlur = 9
            c.beginPath(); c.arc(z.x,z.y,z.r,0,Math.PI*2); c.fill()
            c.shadowBlur = 0
            c.fillStyle = "#031015"
            c.beginPath(); c.arc(z.x,z.y,z.r*.42,0,Math.PI*2); c.fill()
        }

        // Data-bus routes from subsystem zones to the platform spine.
        c.strokeStyle = "#36a8d8"
        c.lineWidth = 1.2
        c.globalAlpha = .75
        c.beginPath(); c.moveTo(w*.39,h*.48); c.lineTo(cx,h*.48); c.lineTo(cx,h*.23); c.stroke()
        c.beginPath(); c.moveTo(w*.61,h*.48); c.lineTo(cx,h*.48); c.lineTo(cx,h*.79); c.stroke()
        c.globalAlpha = 1

        // Compact platform data block fills the visual dead-center with real status counts.
        c.fillStyle = "#071a22"
        c.strokeStyle = "#2b6075"
        c.lineWidth = 1
        var bw = Math.min(170, w*.35), bh = 46
        var bx = cx-bw/2, by = cy-bh/2
        c.fillRect(bx,by,bw,bh); c.strokeRect(bx,by,bw,bh)
        c.fillStyle = Theme.silver
        c.font = "bold 10px Consolas"
        c.textAlign = "center"
        c.fillText("PLATFORM DATA BUS", cx, by+17)
        c.fillStyle = accent
        c.font = "9px Consolas"
        c.fillText((subsystemRows ? subsystemRows.length : 0)+" SUBSYSTEMS / SYNTHETIC", cx, by+34)
    }
}
