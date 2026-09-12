import QtQuick
import "Theme.js" as Theme

Canvas {
    implicitWidth: 58
    implicitHeight: 58
    onPaint: {
        const c = getContext("2d")
        c.reset()

        // Executive avionics badge: restrained wing frame.
        c.strokeStyle = Theme.gold
        c.fillStyle = Theme.gold
        c.lineWidth = Math.max(1.2, width * 0.028)
        c.lineJoin = "round"
        c.beginPath()
        c.moveTo(width*.50,height*.08)
        c.lineTo(width*.66,height*.25)
        c.lineTo(width*.91,height*.17)
        c.lineTo(width*.74,height*.48)
        c.lineTo(width*.60,height*.44)
        c.lineTo(width*.56,height*.88)
        c.lineTo(width*.50,height*.96)
        c.lineTo(width*.44,height*.88)
        c.lineTo(width*.40,height*.44)
        c.lineTo(width*.26,height*.48)
        c.lineTo(width*.09,height*.17)
        c.lineTo(width*.34,height*.25)
        c.closePath()
        c.stroke()

        // Central aircraft / processor spine.
        c.fillStyle = Theme.accent
        c.beginPath()
        c.moveTo(width*.50,height*.15)
        c.lineTo(width*.56,height*.38)
        c.lineTo(width*.72,height*.50)
        c.lineTo(width*.55,height*.48)
        c.lineTo(width*.53,height*.76)
        c.lineTo(width*.62,height*.84)
        c.lineTo(width*.50,height*.80)
        c.lineTo(width*.38,height*.84)
        c.lineTo(width*.47,height*.76)
        c.lineTo(width*.45,height*.48)
        c.lineTo(width*.28,height*.50)
        c.lineTo(width*.44,height*.38)
        c.closePath()
        c.fill()

        // Circuit traces communicate avionics/electronics rather than a generic aircraft logo.
        c.strokeStyle = Theme.metallicSilver
        c.lineWidth = Math.max(1, width * 0.018)
        c.beginPath()
        c.moveTo(width*.24,height*.61); c.lineTo(width*.39,height*.61); c.lineTo(width*.45,height*.56)
        c.moveTo(width*.76,height*.61); c.lineTo(width*.61,height*.61); c.lineTo(width*.55,height*.56)
        c.moveTo(width*.30,height*.70); c.lineTo(width*.42,height*.70)
        c.moveTo(width*.70,height*.70); c.lineTo(width*.58,height*.70)
        c.stroke()

        c.fillStyle = Theme.green
        const r = Math.max(1.8, width * .035)
        ;[[.24,.61],[.76,.61],[.30,.70],[.70,.70]].forEach(function(p){
            c.beginPath(); c.arc(width*p[0],height*p[1],r,0,Math.PI*2); c.fill()
        })
    }
}
