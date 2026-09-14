import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property var subsystemRows: []
    property string platformId: cockpit.activePlatformId
    property color accent: Theme.signalCyan
    antialiasing: true

    onSubsystemRowsChanged: requestPaint()
    onPlatformIdChanged: requestPaint()
    onAccentChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function stateColorAt(index) {
        if (!subsystemRows || index >= subsystemRows.length) return Theme.radarGreen
        return Theme.stateColor(subsystemRows[index].state)
    }

    function fillStroke(c) {
        c.fill()
        c.stroke()
    }

    function polygon(c, pts, w, h) {
        c.beginPath()
        c.moveTo(w * pts[0][0], h * pts[0][1])
        for (var i = 1; i < pts.length; ++i) c.lineTo(w * pts[i][0], h * pts[i][1])
        c.closePath()
        fillStroke(c)
    }

    function drawGrid(c, w, h) {
        c.strokeStyle = Theme.grid
        c.lineWidth = 1
        c.globalAlpha = .54
        var step = Math.max(22, Math.min(w, h) / 17)
        for (var x = step; x < w; x += step) {
            c.beginPath(); c.moveTo(x, 0); c.lineTo(x, h); c.stroke()
        }
        for (var y = step; y < h; y += step) {
            c.beginPath(); c.moveTo(0, y); c.lineTo(w, y); c.stroke()
        }
        c.globalAlpha = .33
        c.strokeStyle = Theme.metallicSilver
        c.setLineDash([6, 8])
        c.beginPath(); c.moveTo(w*.5,h*.025); c.lineTo(w*.5,h*.975); c.stroke()
        c.beginPath(); c.moveTo(w*.035,h*.5); c.lineTo(w*.965,h*.5); c.stroke()
        c.setLineDash([])
        c.globalAlpha = 1
    }

    function drawReferenceFrame(c, w, h) {
        c.strokeStyle = Theme.metallicSilver
        c.lineWidth = 1
        c.globalAlpha = .52
        var m=12, l=18
        c.beginPath(); c.moveTo(m,m+l); c.lineTo(m,m); c.lineTo(m+l,m); c.stroke()
        c.beginPath(); c.moveTo(w-m-l,m); c.lineTo(w-m,m); c.lineTo(w-m,m+l); c.stroke()
        c.beginPath(); c.moveTo(m,h-m-l); c.lineTo(m,h-m); c.lineTo(m+l,h-m); c.stroke()
        c.beginPath(); c.moveTo(w-m-l,h-m); c.lineTo(w-m,h-m); c.lineTo(w-m,h-m-l); c.stroke()

        c.fillStyle=Theme.silver
        c.font="600 11px 'Noto Sans Mono'"
        c.fillText("TOP / PLANFORM",m+8,m+15)
        c.textAlign="right"
        c.fillText("SCALE 1:GEN",w-m-8,m+15)
        c.textAlign="left"
        c.globalAlpha=1
    }

    function setAirframeStyle(c, w, h) {
        var g=c.createLinearGradient(w*.22,h*.18,w*.78,h*.82)
        g.addColorStop(0,"#263D48")
        g.addColorStop(.52,"#172A34")
        g.addColorStop(1,"#0C171E")
        c.fillStyle=g
        c.strokeStyle=Theme.metallicSilver
        c.lineWidth=1.45
        c.lineJoin="round"
    }

    function drawJet(c, w, h) {
        setAirframeStyle(c,w,h)

        polygon(c,[[.475,.31],[.405,.38],[.105,.535],[.075,.595],[.115,.625],[.425,.555],[.465,.66]],w,h)
        polygon(c,[[.525,.31],[.595,.38],[.895,.535],[.925,.595],[.885,.625],[.575,.555],[.535,.66]],w,h)
        polygon(c,[[.466,.70],[.395,.765],[.285,.855],[.31,.89],[.458,.828]],w,h)
        polygon(c,[[.534,.70],[.605,.765],[.715,.855],[.69,.89],[.542,.828]],w,h)

        c.beginPath()
        c.moveTo(w*.50,h*.035)
        c.bezierCurveTo(w*.475,h*.10,w*.458,h*.21,w*.457,h*.34)
        c.bezierCurveTo(w*.45,h*.48,w*.445,h*.67,w*.462,h*.84)
        c.lineTo(w*.477,h*.945)
        c.quadraticCurveTo(w*.50,h*.985,w*.523,h*.945)
        c.lineTo(w*.538,h*.84)
        c.bezierCurveTo(w*.555,h*.67,w*.55,h*.48,w*.543,h*.34)
        c.bezierCurveTo(w*.542,h*.21,w*.525,h*.10,w*.50,h*.035)
        c.closePath()
        fillStroke(c)

        c.fillStyle="#0B141B"
        c.strokeStyle=Theme.signalCyan
        c.lineWidth=1.1
        c.beginPath()
        c.moveTo(w*.477,h*.18)
        c.quadraticCurveTo(w*.50,h*.12,w*.523,h*.18)
        c.lineTo(w*.532,h*.305)
        c.quadraticCurveTo(w*.50,h*.335,w*.468,h*.305)
        c.closePath()
        fillStroke(c)

        c.fillStyle="#0A1218"
        c.strokeStyle=Theme.royalGold
        c.globalAlpha=.82
        c.beginPath(); c.ellipse(w*.478,h*.45,w*.014,h*.085,0,0,Math.PI*2); fillStroke(c)
        c.beginPath(); c.ellipse(w*.522,h*.45,w*.014,h*.085,0,0,Math.PI*2); fillStroke(c)
        c.globalAlpha=1

        c.fillStyle="#263D48"
        c.strokeStyle=Theme.metallicSilver
        c.beginPath()
        c.moveTo(w*.487,h*.72); c.lineTo(w*.50,h*.57); c.lineTo(w*.513,h*.72)
        c.lineTo(w*.51,h*.865); c.lineTo(w*.49,h*.865); c.closePath()
        fillStroke(c)

        c.strokeStyle=Theme.signalCyan
        c.globalAlpha=.64
        c.lineWidth=1
        c.beginPath(); c.moveTo(w*.115,h*.59); c.lineTo(w*.455,h*.50); c.stroke()
        c.beginPath(); c.moveTo(w*.885,h*.59); c.lineTo(w*.545,h*.50); c.stroke()
        c.beginPath(); c.moveTo(w*.31,h*.875); c.lineTo(w*.465,h*.78); c.stroke()
        c.beginPath(); c.moveTo(w*.69,h*.875); c.lineTo(w*.535,h*.78); c.stroke()
        c.globalAlpha=1
    }

    function drawTurboprop(c,w,h) {
        setAirframeStyle(c,w,h)

        polygon(c,[[.46,.34],[.14,.48],[.08,.53],[.15,.57],[.458,.535]],w,h)
        polygon(c,[[.54,.34],[.86,.48],[.92,.53],[.85,.57],[.542,.535]],w,h)
        polygon(c,[[.465,.75],[.32,.84],[.29,.88],[.455,.835]],w,h)
        polygon(c,[[.535,.75],[.68,.84],[.71,.88],[.545,.835]],w,h)

        c.beginPath()
        c.moveTo(w*.50,h*.04)
        c.bezierCurveTo(w*.465,h*.12,w*.455,h*.30,w*.458,h*.54)
        c.lineTo(w*.47,h*.91)
        c.quadraticCurveTo(w*.50,h*.97,w*.53,h*.91)
        c.lineTo(w*.542,h*.54)
        c.bezierCurveTo(w*.545,h*.30,w*.535,h*.12,w*.50,h*.04)
        c.closePath()
        fillStroke(c)

        var engines=[.315,.685]
        for(var i=0;i<engines.length;++i){
            var ex=w*engines[i], ey=h*.505
            c.fillStyle="#101D25"
            c.strokeStyle=Theme.royalGold
            c.beginPath()
            c.moveTo(ex-w*.028,ey-h*.065)
            c.lineTo(ex+w*.028,ey-h*.065)
            c.lineTo(ex+w*.028,ey+h*.065)
            c.lineTo(ex-w*.028,ey+h*.065)
            c.closePath(); fillStroke(c)
            c.strokeStyle=Theme.signalCyan
            c.globalAlpha=.70
            c.beginPath(); c.arc(ex,ey,Math.min(w,h)*.085,0,Math.PI*2); c.stroke()
            c.beginPath(); c.moveTo(ex,ey-h*.09); c.lineTo(ex,ey+h*.09); c.stroke()
            c.beginPath(); c.moveTo(ex-w*.07,ey-h*.055); c.lineTo(ex+w*.07,ey+h*.055); c.stroke()
            c.globalAlpha=1
        }

        c.fillStyle="#0A141B"
        c.strokeStyle=Theme.signalCyan
        c.beginPath(); c.ellipse(w*.5,h*.245,w*.025,h*.085,0,0,Math.PI*2); fillStroke(c)
    }

    function drawHelicopter(c,w,h) {
        setAirframeStyle(c,w,h)

        c.strokeStyle=Theme.signalCyan
        c.lineWidth=1.2
        c.globalAlpha=.62
        c.beginPath(); c.ellipse(w*.50,h*.39,w*.405,h*.23,0,0,Math.PI*2); c.stroke()
        c.beginPath(); c.moveTo(w*.08,h*.39); c.lineTo(w*.92,h*.39); c.stroke()
        c.beginPath(); c.moveTo(w*.50,h*.11); c.lineTo(w*.50,h*.68); c.stroke()
        c.globalAlpha=1

        c.beginPath()
        c.moveTo(w*.50,h*.17)
        c.bezierCurveTo(w*.43,h*.19,w*.395,h*.31,w*.40,h*.47)
        c.bezierCurveTo(w*.405,h*.62,w*.455,h*.70,w*.50,h*.72)
        c.bezierCurveTo(w*.545,h*.70,w*.595,h*.62,w*.60,h*.47)
        c.bezierCurveTo(w*.605,h*.31,w*.57,h*.19,w*.50,h*.17)
        c.closePath()
        fillStroke(c)

        polygon(c,[[.435,.50],[.28,.62],[.31,.68],[.47,.58]],w,h)
        polygon(c,[[.565,.50],[.72,.62],[.69,.68],[.53,.58]],w,h)

        c.fillStyle="#162A34"
        c.strokeStyle=Theme.metallicSilver
        polygon(c,[[.48,.70],[.52,.70],[.535,.90],[.585,.935],[.56,.96],[.50,.925],[.44,.96],[.415,.935],[.465,.90]],w,h)

        c.strokeStyle=Theme.royalGold
        c.globalAlpha=.86
        c.beginPath(); c.arc(w*.50,h*.39,6,0,Math.PI*2); c.stroke()
        c.beginPath(); c.arc(w*.50,h*.92,Math.min(w,h)*.052,0,Math.PI*2); c.stroke()
        c.beginPath(); c.moveTo(w*.45,h*.92); c.lineTo(w*.55,h*.92); c.stroke()
        c.beginPath(); c.moveTo(w*.50,h*.87); c.lineTo(w*.50,h*.97); c.stroke()
        c.globalAlpha=1

        c.fillStyle="#081218"
        c.strokeStyle=Theme.signalCyan
        c.beginPath(); c.ellipse(w*.50,h*.31,w*.055,h*.105,0,0,Math.PI*2); fillStroke(c)
    }

    function drawUav(c,w,h) {
        setAirframeStyle(c,w,h)

        c.beginPath()
        c.moveTo(w*.50,h*.17)
        c.lineTo(w*.555,h*.29)
        c.bezierCurveTo(w*.68,h*.34,w*.83,h*.39,w*.93,h*.46)
        c.lineTo(w*.86,h*.59)
        c.lineTo(w*.61,h*.535)
        c.lineTo(w*.57,h*.70)
        c.lineTo(w*.50,h*.83)
        c.lineTo(w*.43,h*.70)
        c.lineTo(w*.39,h*.535)
        c.lineTo(w*.14,h*.59)
        c.lineTo(w*.07,h*.46)
        c.bezierCurveTo(w*.17,h*.39,w*.32,h*.34,w*.445,h*.29)
        c.closePath()
        fillStroke(c)

        c.fillStyle="#0A141A"
        c.strokeStyle=Theme.signalCyan
        c.beginPath(); c.ellipse(w*.50,h*.42,w*.045,h*.14,0,0,Math.PI*2); fillStroke(c)

        c.strokeStyle=Theme.rfViolet
        c.lineWidth=1.2
        c.globalAlpha=.72
        c.beginPath(); c.moveTo(w*.12,h*.51); c.lineTo(w*.41,h*.46); c.stroke()
        c.beginPath(); c.moveTo(w*.88,h*.51); c.lineTo(w*.59,h*.46); c.stroke()
        c.beginPath(); c.moveTo(w*.50,h*.21); c.lineTo(w*.50,h*.78); c.stroke()
        c.globalAlpha=1
    }

    function drawSystems(c,w,h) {
        var positions
        if(platformId.indexOf("helicopter")>=0)
            positions=[[.50,.29],[.44,.45],[.56,.45],[.40,.59],[.60,.59],[.50,.82]]
        else if(platformId.indexOf("uav")>=0)
            positions=[[.50,.35],[.30,.46],[.70,.46],[.42,.55],[.58,.55],[.50,.68]]
        else
            positions=[[.50,.26],[.34,.50],[.66,.50],[.46,.63],[.54,.63],[.50,.80]]

        c.strokeStyle=root.accent
        c.lineWidth=1
        c.globalAlpha=.62
        c.beginPath()
        c.moveTo(w*positions[0][0],h*positions[0][1])
        for(var j=1;j<positions.length;++j)c.lineTo(w*positions[j][0],h*positions[j][1])
        c.stroke()
        c.globalAlpha=1

        for(var i=0;i<positions.length;++i){
            var px=w*positions[i][0], py=h*positions[i][1], col=stateColorAt(i)
            c.fillStyle="#07131A"
            c.strokeStyle=col
            c.lineWidth=1.4
            c.beginPath(); c.arc(px,py,7,0,Math.PI*2); c.fill(); c.stroke()
            c.fillStyle=col
            c.beginPath(); c.arc(px,py,2.6,0,Math.PI*2); c.fill()
        }
    }

    function drawDimensions(c,w,h) {
        c.strokeStyle=Theme.royalGold
        c.fillStyle=Theme.royalGold
        c.lineWidth=1
        c.globalAlpha=.55
        c.beginPath(); c.moveTo(w*.07,h*.97); c.lineTo(w*.93,h*.97); c.stroke()
        c.beginPath(); c.moveTo(w*.07,h*.955); c.lineTo(w*.07,h*.985); c.stroke()
        c.beginPath(); c.moveTo(w*.93,h*.955); c.lineTo(w*.93,h*.985); c.stroke()
        c.font="600 11px 'Noto Sans Mono'"
        c.textAlign="center"
        c.fillText("REFERENCE SPAN",w*.50,h*.955)
        c.textAlign="left"
        c.globalAlpha=1
    }

    onPaint: {
        var c=getContext("2d")
        c.reset()
        var w=width, h=height
        c.fillStyle="#030A0F"
        c.fillRect(0,0,w,h)
        drawGrid(c,w,h)
        drawReferenceFrame(c,w,h)

        if(platformId.indexOf("turboprop")>=0) drawTurboprop(c,w,h)
        else if(platformId.indexOf("helicopter")>=0) drawHelicopter(c,w,h)
        else if(platformId.indexOf("uav")>=0) drawUav(c,w,h)
        else drawJet(c,w,h)

        drawSystems(c,w,h)
        drawDimensions(c,w,h)
    }
}
