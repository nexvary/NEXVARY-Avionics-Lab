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
        var w = width, h = height, cx = w*0.5

        // Precision engineering grid.
        c.strokeStyle = Theme.grid
        c.lineWidth = 1
        c.globalAlpha = .72
        for (var x=22; x<w; x+=22) { c.beginPath(); c.moveTo(x,0); c.lineTo(x,h); c.stroke() }
        for (var y=22; y<h; y+=22) { c.beginPath(); c.moveTo(0,y); c.lineTo(w,y); c.stroke() }
        c.globalAlpha = 1

        c.save()
        c.strokeStyle = Theme.silver
        c.globalAlpha = .26
        c.setLineDash([5,7])
        c.beginPath(); c.moveTo(cx,h*.025); c.lineTo(cx,h*.965); c.stroke()
        c.beginPath(); c.moveTo(w*.035,h*.49); c.lineTo(w*.965,h*.49); c.stroke()
        c.setLineDash([])
        c.restore()

        // Generic high-performance aircraft planform; technical visualization only.
        var outline = [
            [0.50,.035],[.535,.16],[.55,.27],[.60,.34],[.905,.475],[.90,.525],
            [.64,.55],[.60,.62],[.585,.79],[.705,.895],[.675,.92],[.56,.88],
            [.535,.955],[.50,.978],[.465,.955],[.44,.88],[.325,.92],[.295,.895],
            [.415,.79],[.40,.62],[.36,.55],[.10,.525],[.095,.475],[.40,.34],[.45,.27],[.465,.16]
        ]

        c.fillStyle = "#17232C"
        c.strokeStyle = Theme.accent
        c.lineWidth = 1.7
        c.beginPath(); c.moveTo(w*outline[0][0],h*outline[0][1])
        for (var p=1;p<outline.length;++p) c.lineTo(w*outline[p][0],h*outline[p][1])
        c.closePath(); c.fill(); c.stroke()

        // Secondary metallic outline.
        c.strokeStyle = Theme.silver
        c.globalAlpha = .42
        c.lineWidth = .8
        c.beginPath(); c.moveTo(cx,h*.07); c.lineTo(w*.52,h*.29); c.lineTo(w*.57,h*.38); c.lineTo(w*.82,h*.49); c.lineTo(w*.59,h*.53); c.lineTo(w*.55,h*.61); c.lineTo(w*.54,h*.84); c.lineTo(cx,h*.93); c.stroke()
        c.beginPath(); c.moveTo(cx,h*.07); c.lineTo(w*.48,h*.29); c.lineTo(w*.43,h*.38); c.lineTo(w*.18,h*.49); c.lineTo(w*.41,h*.53); c.lineTo(w*.45,h*.61); c.lineTo(w*.46,h*.84); c.lineTo(cx,h*.93); c.stroke()
        c.globalAlpha = 1

        // Structural stations and wing ribs.
        c.strokeStyle = "#53636E"
        c.lineWidth = .8
        c.globalAlpha = .5
        var fuselageStations=[.18,.25,.32,.40,.49,.57,.66,.75,.84]
        for(var s=0;s<fuselageStations.length;++s){
            var yy=h*fuselageStations[s]
            var half=(s<2? w*.035 : (s<6?w*.055:w*.045))
            c.beginPath(); c.moveTo(cx-half,yy); c.lineTo(cx+half,yy); c.stroke()
        }
        var wingYs=[.405,.445,.485,.525]
        for(var wy=0;wy<wingYs.length;++wy){
            var yv=h*wingYs[wy]
            c.beginPath(); c.moveTo(w*.20,yv); c.lineTo(w*.80,yv); c.stroke()
        }
        c.globalAlpha=1

        // Dual avionics buses A/B.
        c.strokeStyle = Theme.accent
        c.lineWidth = 1.15
        c.globalAlpha=.9
        c.beginPath(); c.moveTo(cx-8,h*.17); c.lineTo(cx-8,h*.82); c.stroke()
        c.beginPath(); c.moveTo(cx+8,h*.17); c.lineTo(cx+8,h*.82); c.stroke()
        c.beginPath(); c.moveTo(w*.31,h*.49); c.lineTo(w*.69,h*.49); c.stroke()
        c.beginPath(); c.moveTo(w*.42,h*.61); c.lineTo(w*.58,h*.61); c.stroke()

        // Branch routing to avionics zones.
        var nodes=[
            {x:cx,y:h*.22,c:stateColorAt(1),label:"COM"},
            {x:w*.36,y:h*.49,c:stateColorAt(2),label:"SENS"},
            {x:w*.64,y:h*.49,c:stateColorAt(0),label:"PWR"},
            {x:cx,y:h*.62,c:stateColorAt(3),label:"HYD"},
            {x:cx,y:h*.79,c:stateColorAt(4),label:"FUEL"}
        ]
        for(var n=0;n<nodes.length;++n){
            var nd=nodes[n]
            c.strokeStyle=Theme.accent; c.globalAlpha=.45; c.lineWidth=.8
            c.beginPath(); c.moveTo(cx,nd.y); c.lineTo(nd.x,nd.y); c.stroke(); c.globalAlpha=1
            c.fillStyle=Theme.panel2; c.strokeStyle=nd.c; c.lineWidth=1
            c.beginPath(); c.arc(nd.x,nd.y,9,0,Math.PI*2); c.fill(); c.stroke()
            c.fillStyle=nd.c; c.beginPath(); c.arc(nd.x,nd.y,3.2,0,Math.PI*2); c.fill()
            c.fillStyle=Theme.silver; c.font="7px Consolas"; c.textAlign="center"; c.fillText(nd.label,nd.x,nd.y+20)
        }

        // Central bus controller / data fusion node.
        var bw=Math.min(178,w*.34), bh=44, bx=cx-bw/2, by=h*.425
        c.fillStyle=Theme.panel2; c.strokeStyle=Theme.border; c.lineWidth=1
        c.fillRect(bx,by,bw,bh); c.strokeRect(bx,by,bw,bh)
        c.fillStyle=Theme.platinum; c.textAlign="center"; c.font="bold 9px Consolas"
        c.fillText("AVIONICS DATA CORE",cx,by+16)
        c.fillStyle=Theme.accent; c.font="7px Consolas"
        c.fillText("BUS A/B  •  "+(subsystemRows?subsystemRows.length:0)+" SUBSYSTEMS",cx,by+31)

        // Corner reference marks.
        c.strokeStyle=Theme.silver; c.globalAlpha=.42; c.lineWidth=1
        var m=16
        c.beginPath(); c.moveTo(4,m); c.lineTo(4,4); c.lineTo(m,4); c.stroke()
        c.beginPath(); c.moveTo(w-m,4); c.lineTo(w-4,4); c.lineTo(w-4,m); c.stroke()
        c.beginPath(); c.moveTo(4,h-m); c.lineTo(4,h-4); c.lineTo(m,h-4); c.stroke()
        c.beginPath(); c.moveTo(w-m,h-4); c.lineTo(w-4,h-4); c.lineTo(w-4,h-m); c.stroke()
        c.globalAlpha=1
    }
}
