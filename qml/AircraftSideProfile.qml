import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property string platformId: cockpit.activePlatformId
    property var subsystemRows: []
    property color accent: Theme.skyBlue
    antialiasing: true

    onPlatformIdChanged: requestPaint()
    onSubsystemRowsChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function nodeColor(index) {
        if (!subsystemRows || index >= subsystemRows.length) return Theme.radarGreen
        return Theme.stateColor(subsystemRows[index].state)
    }

    function drawGrid(c, w, h) {
        c.strokeStyle = Theme.grid
        c.lineWidth = 1
        c.globalAlpha = .72
        for (var x = 20; x < w; x += 20) {
            c.beginPath(); c.moveTo(x, 0); c.lineTo(x, h); c.stroke()
        }
        for (var y = 20; y < h; y += 20) {
            c.beginPath(); c.moveTo(0, y); c.lineTo(w, y); c.stroke()
        }
        c.globalAlpha = 1
    }

    function drawJet(c, w, h) {
        c.beginPath()
        c.moveTo(w*.08,h*.58)
        c.quadraticCurveTo(w*.23,h*.45,w*.47,h*.44)
        c.lineTo(w*.78,h*.43)
        c.quadraticCurveTo(w*.91,h*.44,w*.96,h*.51)
        c.quadraticCurveTo(w*.90,h*.56,w*.77,h*.58)
        c.lineTo(w*.44,h*.62)
        c.lineTo(w*.19,h*.66)
        c.closePath()
        c.fill(); c.stroke()
        c.beginPath(); c.moveTo(w*.19,h*.48); c.lineTo(w*.13,h*.22); c.lineTo(w*.25,h*.45); c.stroke(); c.fill()
        c.beginPath(); c.moveTo(w*.46,h*.59); c.lineTo(w*.38,h*.82); c.lineTo(w*.61,h*.61); c.stroke(); c.fill()
        c.beginPath(); c.moveTo(w*.64,h*.44); c.lineTo(w*.72,h*.31); c.lineTo(w*.82,h*.43); c.stroke(); c.fill()
        c.strokeStyle = Theme.signalCyan
        c.beginPath(); c.moveTo(w*.75,h*.46); c.quadraticCurveTo(w*.86,h*.46,w*.90,h*.51); c.stroke()
    }

    function drawTurboprop(c, w, h) {
        drawJet(c, w, h)
        c.strokeStyle = Theme.royalGold
        c.lineWidth = 1.5
        c.beginPath(); c.arc(w*.88,h*.51,Math.min(w,h)*.16,0,Math.PI*2); c.stroke()
        c.beginPath(); c.moveTo(w*.88,h*.33); c.lineTo(w*.88,h*.69); c.stroke()
        c.beginPath(); c.moveTo(w*.83,h*.38); c.lineTo(w*.93,h*.64); c.stroke()
    }

    function drawHelicopter(c, w, h) {
        c.beginPath()
        c.moveTo(w*.29,h*.46)
        c.quadraticCurveTo(w*.36,h*.30,w*.52,h*.33)
        c.quadraticCurveTo(w*.63,h*.36,w*.67,h*.49)
        c.lineTo(w*.91,h*.43)
        c.lineTo(w*.94,h*.48)
        c.lineTo(w*.66,h*.58)
        c.quadraticCurveTo(w*.51,h*.72,w*.35,h*.60)
        c.closePath(); c.fill(); c.stroke()
        c.beginPath(); c.moveTo(w*.38,h*.61); c.lineTo(w*.33,h*.72); c.lineTo(w*.66,h*.72); c.stroke()
        c.beginPath(); c.moveTo(w*.49,h*.32); c.lineTo(w*.49,h*.20); c.stroke()
        c.beginPath(); c.moveTo(w*.12,h*.20); c.lineTo(w*.86,h*.20); c.stroke()
        c.beginPath(); c.arc(w*.94,h*.47,Math.min(w,h)*.08,0,Math.PI*2); c.stroke()
    }

    function drawUav(c, w, h) {
        c.beginPath()
        c.moveTo(w*.10,h*.57)
        c.quadraticCurveTo(w*.28,h*.45,w*.54,h*.44)
        c.lineTo(w*.91,h*.49)
        c.lineTo(w*.96,h*.53)
        c.lineTo(w*.89,h*.57)
        c.lineTo(w*.49,h*.59)
        c.lineTo(w*.18,h*.62)
        c.closePath(); c.fill(); c.stroke()
        c.beginPath(); c.moveTo(w*.48,h*.45); c.lineTo(w*.58,h*.27); c.lineTo(w*.68,h*.46); c.stroke(); c.fill()
        c.beginPath(); c.moveTo(w*.29,h*.59); c.lineTo(w*.39,h*.77); c.lineTo(w*.58,h*.58); c.stroke(); c.fill()
        c.beginPath(); c.moveTo(w*.17,h*.52); c.lineTo(w*.12,h*.34); c.lineTo(w*.25,h*.48); c.stroke(); c.fill()
    }

    function drawOverlay(c, w, h) {
        var positions = [[.21,.54],[.38,.51],[.55,.50],[.71,.50],[.86,.52]]
        c.strokeStyle = root.accent
        c.lineWidth = 1.2
        c.globalAlpha = .72
        c.beginPath(); c.moveTo(w*.20,h*.54); c.lineTo(w*.87,h*.52); c.stroke()
        c.globalAlpha = 1
        for (var i = 0; i < positions.length; ++i) {
            var x = w*positions[i][0]
            var y = h*positions[i][1]
            var color = nodeColor(i)
            c.fillStyle = Theme.panel2
            c.strokeStyle = color
            c.lineWidth = 1.4
            c.beginPath(); c.arc(x,y,7,0,Math.PI*2); c.fill(); c.stroke()
            c.fillStyle = color
            c.beginPath(); c.arc(x,y,2.5,0,Math.PI*2); c.fill()
        }
    }

    onPaint: {
        var c = getContext("2d")
        c.reset()
        var w = width
        var h = height
        c.fillStyle = Theme.shell
        c.fillRect(0,0,w,h)
        drawGrid(c,w,h)
        c.fillStyle = "#151515"
        c.strokeStyle = root.accent
        c.lineWidth = 1.8
        if (platformId === "generic-helicopter" || platformId === "helicopter") drawHelicopter(c,w,h)
        else if (platformId === "generic-uav" || platformId === "uav") drawUav(c,w,h)
        else if (platformId === "generic-turboprop" || platformId === "turboprop") drawTurboprop(c,w,h)
        else drawJet(c,w,h)
        drawOverlay(c,w,h)

        c.fillStyle = Theme.silver
        c.font = "700 10px 'Noto Sans Mono'"
        c.textAlign = "left"
        c.fillText("SIDE PROFILE / SYSTEM BUS", 12, 20)
        c.fillStyle = root.accent
        c.fillText(Theme.platformCode(platformId) + "  •  SYNTHETIC ENGINEERING VIEW", 12, h - 12)
    }
}
