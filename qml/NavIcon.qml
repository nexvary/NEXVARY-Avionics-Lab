import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property string kind: "dashboard"
    property color iconColor: Theme.silver
    implicitWidth: 24
    implicitHeight: 24
    onKindChanged: requestPaint()
    onIconColorChanged: requestPaint()

    onPaint: {
        const c = getContext("2d")
        c.reset()
        c.strokeStyle = iconColor
        c.fillStyle = iconColor
        c.lineWidth = 2
        c.lineCap = "round"
        c.lineJoin = "round"

        const w = width
        const h = height

        function line(x1, y1, x2, y2) {
            c.beginPath()
            c.moveTo(x1 * w, y1 * h)
            c.lineTo(x2 * w, y2 * h)
            c.stroke()
        }

        if (kind === "dashboard") {
            c.strokeRect(.14*w,.16*h,.29*w,.27*h)
            c.strokeRect(.57*w,.16*h,.29*w,.27*h)
            c.strokeRect(.14*w,.57*h,.29*w,.27*h)
            c.strokeRect(.57*w,.57*h,.29*w,.27*h)
        } else if (kind === "health") {
            c.beginPath()
            c.moveTo(.08*w,.55*h)
            c.lineTo(.28*w,.55*h)
            c.lineTo(.38*w,.27*h)
            c.lineTo(.52*w,.76*h)
            c.lineTo(.64*w,.45*h)
            c.lineTo(.9*w,.45*h)
            c.stroke()
        } else if (kind === "sensors") {
            c.beginPath()
            c.arc(.5*w,.5*h,.08*w,0,Math.PI*2)
            c.fill()
            for (let r of [.24,.38]) {
                c.beginPath()
                c.arc(.5*w,.5*h,r*w,-.75*Math.PI,.75*Math.PI)
                c.stroke()
            }
        } else if (kind === "events") {
            c.strokeRect(.22*w,.12*h,.56*w,.76*h)
            line(.32,.32,.68,.32)
            line(.32,.48,.68,.48)
            line(.32,.64,.61,.64)
        } else if (kind === "replay") {
            c.beginPath()
            c.arc(.5*w,.5*h,.36*w,.25*Math.PI,1.92*Math.PI)
            c.stroke()
            c.beginPath()
            c.moveTo(.19*w,.28*h)
            c.lineTo(.18*w,.52*h)
            c.lineTo(.36*w,.4*h)
            c.stroke()
            c.beginPath()
            c.moveTo(.44*w,.34*h)
            c.lineTo(.7*w,.5*h)
            c.lineTo(.44*w,.66*h)
            c.closePath()
            c.fill()
        } else if (kind === "trends") {
            line(.12,.78,.28,.58)
            line(.28,.58,.43,.67)
            line(.43,.67,.61,.31)
            line(.61,.31,.86,.43)
            line(.12,.84,.9,.84)
        } else if (kind === "twin") {
            c.beginPath()
            c.moveTo(.5*w,.1*h)
            c.lineTo(.82*w,.29*h)
            c.lineTo(.82*w,.69*h)
            c.lineTo(.5*w,.89*h)
            c.lineTo(.18*w,.69*h)
            c.lineTo(.18*w,.29*h)
            c.closePath()
            c.stroke()
            line(.18,.29,.5,.5)
            line(.82,.29,.5,.5)
            line(.5,.5,.5,.89)
        } else if (kind === "platform") {
            line(.50,.12,.50,.86)
            line(.20,.46,.80,.46)
            line(.34,.70,.66,.70)
            line(.50,.12,.43,.30)
            line(.50,.12,.57,.30)
            line(.20,.46,.32,.38)
            line(.80,.46,.68,.38)
            c.beginPath()
            c.arc(.5*w,.46*h,.07*w,0,Math.PI*2)
            c.stroke()
        } else if (kind === "fault") {
            c.beginPath()
            c.moveTo(.5*w,.1*h)
            c.lineTo(.9*w,.84*h)
            c.lineTo(.1*w,.84*h)
            c.closePath()
            c.stroke()
            line(.5,.35,.5,.61)
            c.beginPath()
            c.arc(.5*w,.72*h,.03*w,0,Math.PI*2)
            c.fill()
        } else if (kind === "diagnostic") {
            c.beginPath()
            c.arc(.5*w,.45*h,.28*w,0,Math.PI*2)
            c.stroke()
            line(.33,.45,.44,.45)
            line(.56,.45,.67,.45)
            line(.5,.28,.5,.37)
            line(.5,.53,.5,.62)
            c.beginPath()
            c.arc(.5*w,.45*h,.07*w,0,Math.PI*2)
            c.stroke()
            line(.68,.66,.88,.86)
            c.beginPath()
            c.arc(.72*w,.70*h,.05*w,0,Math.PI*2)
            c.fill()
        } else if (kind === "verify") {
            c.strokeRect(.18*w,.15*h,.64*w,.7*h)
            line(.3,.42,.44,.56)
            line(.44,.56,.7,.3)
            line(.3,.68,.68,.68)
        } else if (kind === "about") {
            c.beginPath()
            c.arc(.5*w,.5*h,.36*w,0,Math.PI*2)
            c.stroke()
            c.beginPath()
            c.arc(.5*w,.30*h,.035*w,0,Math.PI*2)
            c.fill()
            line(.5,.43,.5,.72)
            line(.43,.72,.57,.72)
        } else if (kind === "map") {
            c.beginPath()
            c.moveTo(.12*w,.25*h); c.lineTo(.34*w,.14*h); c.lineTo(.66*w,.27*h); c.lineTo(.88*w,.16*h)
            c.lineTo(.88*w,.75*h); c.lineTo(.66*w,.86*h); c.lineTo(.34*w,.73*h); c.lineTo(.12*w,.84*h)
            c.closePath(); c.stroke()
            line(.34,.14,.34,.73); line(.66,.27,.66,.86)
        } else if (kind === "airspace") {
            c.beginPath(); c.arc(.5*w,.5*h,.37*w,0,Math.PI*2); c.stroke()
            c.beginPath(); c.arc(.5*w,.5*h,.22*w,0,Math.PI*2); c.stroke()
            line(.5,.08,.5,.92); line(.08,.5,.92,.5)
        } else if (kind === "route") {
            c.beginPath(); c.arc(.18*w,.72*h,.08*w,0,Math.PI*2); c.stroke()
            c.beginPath(); c.arc(.82*w,.24*h,.08*w,0,Math.PI*2); c.stroke()
            c.beginPath(); c.moveTo(.25*w,.67*h); c.bezierCurveTo(.38*w,.25*h,.62*w,.75*h,.75*w,.29*h); c.stroke()
        } else if (kind === "data" || kind === "source") {
            c.strokeRect(.16*w,.14*h,.68*w,.19*h)
            c.strokeRect(.16*w,.41*h,.68*w,.19*h)
            c.strokeRect(.16*w,.68*h,.68*w,.19*h)
        } else if (kind === "fleet") {
            line(.5,.09,.5,.88); line(.16,.48,.84,.48); line(.31,.68,.69,.68)
            c.beginPath(); c.moveTo(.5*w,.09*h); c.lineTo(.42*w,.31*h); c.lineTo(.58*w,.31*h); c.closePath(); c.stroke()
        } else if (kind === "base") {
            c.beginPath(); c.moveTo(.5*w,.10*h); c.lineTo(.89*w,.38*h); c.lineTo(.76*w,.38*h); c.lineTo(.76*w,.86*h); c.lineTo(.24*w,.86*h); c.lineTo(.24*w,.38*h); c.lineTo(.11*w,.38*h); c.closePath(); c.stroke()
            line(.39,.86,.39,.59); line(.61,.86,.61,.59); line(.39,.59,.61,.59)
        } else if (kind === "crew") {
            c.beginPath(); c.arc(.5*w,.30*h,.16*w,0,Math.PI*2); c.stroke()
            c.beginPath(); c.arc(.25*w,.43*h,.10*w,0,Math.PI*2); c.stroke()
            c.beginPath(); c.arc(.75*w,.43*h,.10*w,0,Math.PI*2); c.stroke()
            c.beginPath(); c.arc(.5*w,.91*h,.32*w,1.04*Math.PI,1.96*Math.PI); c.stroke()
        } else if (kind === "training") {
            c.beginPath(); c.moveTo(.10*w,.34*h); c.lineTo(.50*w,.14*h); c.lineTo(.90*w,.34*h); c.lineTo(.50*w,.54*h); c.closePath(); c.stroke()
            line(.23,.42,.23,.67); c.beginPath(); c.arc(.50*w,.56*h,.25*w,.08*Math.PI,.92*Math.PI); c.stroke()
        } else if (kind === "maintenance") {
            c.beginPath(); c.arc(.38*w,.38*h,.24*w,.2*Math.PI,1.75*Math.PI); c.stroke()
            line(.54,.56,.86,.86); line(.76,.86,.86,.76)
        } else if (kind === "radar") {
            c.beginPath(); c.arc(.5*w,.5*h,.38*w,0,Math.PI*2); c.stroke()
            c.beginPath(); c.arc(.5*w,.5*h,.23*w,0,Math.PI*2); c.stroke()
            line(.5,.5,.81,.23)
            c.beginPath(); c.arc(.68*w,.36*h,.04*w,0,Math.PI*2); c.fill()
        } else if (kind === "classify") {
            c.strokeRect(.14*w,.14*h,.30*w,.30*h); c.strokeRect(.56*w,.14*h,.30*w,.30*h)
            c.strokeRect(.14*w,.56*h,.30*w,.30*h); c.beginPath(); c.arc(.71*w,.71*h,.15*w,0,Math.PI*2); c.stroke()
        } else if (kind === "incident") {
            c.beginPath(); c.moveTo(.5*w,.08*h); c.lineTo(.91*w,.85*h); c.lineTo(.09*w,.85*h); c.closePath(); c.stroke()
            line(.5,.33,.5,.60); c.beginPath(); c.arc(.5*w,.72*h,.03*w,0,Math.PI*2); c.fill()
        } else if (kind === "response") {
            c.beginPath(); c.moveTo(.5*w,.08*h); c.lineTo(.82*w,.20*h); c.lineTo(.78*w,.60*h); c.quadraticCurveTo(.70*w,.81*h,.5*w,.91*h); c.quadraticCurveTo(.30*w,.81*h,.22*w,.60*h); c.lineTo(.18*w,.20*h); c.closePath(); c.stroke()
            line(.35,.50,.46,.61); line(.46,.61,.68,.36)
        } else if (kind === "report") {
            c.strokeRect(.20*w,.10*h,.60*w,.80*h); line(.31,.31,.69,.31); line(.31,.48,.69,.48); line(.31,.65,.60,.65)
        } else if (kind === "settings") {
            c.beginPath(); c.arc(.5*w,.5*h,.17*w,0,Math.PI*2); c.stroke()
            for (let a = 0; a < 8; ++a) {
                const angle = a*Math.PI/4
                line(.5+.25*Math.cos(angle),.5+.25*Math.sin(angle),.5+.38*Math.cos(angle),.5+.38*Math.sin(angle))
            }
        }
    }
}
