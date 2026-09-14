import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    implicitWidth: 64
    implicitHeight: 64
    antialiasing: true
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        const c = getContext("2d")
        c.reset()
        const w = width
        const h = height
        const cx = w * .5
        const cy = h * .5
        const r = Math.min(w, h) * .42

        c.strokeStyle = Theme.electricBlue
        c.lineWidth = Math.max(1.2, w * .025)
        c.globalAlpha = .90
        c.beginPath(); c.arc(cx, cy, r, -.36, Math.PI * .88); c.stroke()
        c.beginPath(); c.arc(cx, cy, r, Math.PI * 1.03, Math.PI * 1.72); c.stroke()
        c.globalAlpha = .34
        c.beginPath(); c.arc(cx, cy, r * .79, 0, Math.PI * 2); c.stroke()
        c.globalAlpha = 1

        c.strokeStyle = Theme.signalCyan
        c.fillStyle = Theme.signalCyan
        c.lineWidth = 1
        ;[[.50,.03,.50,.13],[.50,.87,.50,.97],[.03,.50,.13,.50],[.87,.50,.97,.50]].forEach(function(p) {
            c.beginPath(); c.moveTo(w*p[0],h*p[1]); c.lineTo(w*p[2],h*p[3]); c.stroke()
            c.beginPath(); c.arc(w*p[2],h*p[3],Math.max(1.4,w*.026),0,Math.PI*2); c.fill()
        })

        c.strokeStyle = Theme.platinum
        c.lineWidth = Math.max(4, w * .095)
        c.lineCap = "square"
        c.lineJoin = "miter"
        c.beginPath()
        c.moveTo(w*.25,h*.73); c.lineTo(w*.25,h*.29)
        c.lineTo(w*.69,h*.73); c.lineTo(w*.69,h*.28)
        c.stroke()

        c.strokeStyle = Theme.electricBlue
        c.lineWidth = Math.max(3, w * .072)
        c.beginPath(); c.moveTo(w*.36,h*.77); c.lineTo(w*.76,h*.23); c.stroke()
        c.strokeStyle = Theme.metallicSilver
        c.lineWidth = Math.max(2.5, w * .055)
        c.beginPath(); c.moveTo(w*.35,h*.24); c.lineTo(w*.76,h*.77); c.stroke()

        c.fillStyle = Theme.royalGold
        c.beginPath(); c.arc(w*.82,h*.18,Math.max(1.4,w*.025),0,Math.PI*2); c.fill()
    }
}
