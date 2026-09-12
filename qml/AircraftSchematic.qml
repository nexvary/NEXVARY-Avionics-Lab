import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property var subsystemRows: []
    property string platformId: "generic-jet"
    property color accent: Theme.accent
    antialiasing: true

    onSubsystemRowsChanged: requestPaint()
    onPlatformIdChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function stateColorAt(index) {
        if (!subsystemRows || index >= subsystemRows.length) return Theme.silver
        return Theme.stateColor(subsystemRows[index].state)
    }

    function polygon(c, pts, w, h) {
        c.beginPath(); c.moveTo(w*pts[0][0], h*pts[0][1])
        for (var i=1; i<pts.length; ++i) c.lineTo(w*pts[i][0], h*pts[i][1])
        c.closePath(); c.fill(); c.stroke()
    }

    function drawGrid(c,w,h) {
        c.strokeStyle = Theme.grid; c.lineWidth = 1; c.globalAlpha = .62
        for (var x=22; x<w; x+=22) { c.beginPath(); c.moveTo(x,0); c.lineTo(x,h); c.stroke() }
        for (var y=22; y<h; y+=22) { c.beginPath(); c.moveTo(0,y); c.lineTo(w,y); c.stroke() }
        c.globalAlpha = 1
        c.strokeStyle = Theme.silver; c.globalAlpha = .22; c.setLineDash([5,7])
        c.beginPath(); c.moveTo(w*.5,h*.03); c.lineTo(w*.5,h*.97); c.stroke()
        c.beginPath(); c.moveTo(w*.04,h*.5); c.lineTo(w*.96,h*.5); c.stroke()
        c.setLineDash([]); c.globalAlpha = 1
    }

    function drawJet(c,w,h) {
        var pts=[[.50,.04],[.535,.17],[.55,.29],[.60,.36],[.91,.48],[.91,.52],[.62,.56],[.59,.64],[.58,.80],[.70,.90],[.67,.93],[.56,.89],[.535,.96],[.50,.98],[.465,.96],[.44,.89],[.33,.93],[.30,.90],[.42,.80],[.41,.64],[.38,.56],[.09,.52],[.09,.48],[.40,.36],[.45,.29],[.465,.17]]
        polygon(c,pts,w,h)
        c.strokeStyle=Theme.silver; c.globalAlpha=.38; c.lineWidth=.8
        c.beginPath(); c.moveTo(w*.5,h*.08); c.lineTo(w*.5,h*.91); c.stroke()
        for(var y=.38;y<=.58;y+=.05){c.beginPath();c.moveTo(w*.22,h*y);c.lineTo(w*.78,h*y);c.stroke()}
        c.globalAlpha=1
    }

    function drawTurboprop(c,w,h) {
        var pts=[[.50,.05],[.54,.18],[.55,.32],[.59,.40],[.86,.47],[.86,.53],[.60,.57],[.56,.66],[.55,.86],[.66,.92],[.62,.95],[.53,.90],[.50,.97],[.47,.90],[.38,.95],[.34,.92],[.45,.86],[.44,.66],[.40,.57],[.14,.53],[.14,.47],[.41,.40],[.45,.32],[.46,.18]]
        polygon(c,pts,w,h)
        c.strokeStyle=Theme.silver; c.lineWidth=1; c.globalAlpha=.45
        c.beginPath(); c.arc(w*.31,h*.48,Math.min(w,h)*.09,0,Math.PI*2); c.stroke()
        c.beginPath(); c.arc(w*.69,h*.48,Math.min(w,h)*.09,0,Math.PI*2); c.stroke()
        c.beginPath(); c.moveTo(w*.22,h*.48); c.lineTo(w*.40,h*.48); c.stroke()
        c.beginPath(); c.moveTo(w*.60,h*.48); c.lineTo(w*.78,h*.48); c.stroke()
        c.globalAlpha=1
    }

    function drawHelicopter(c,w,h) {
        c.strokeStyle=Theme.silver; c.lineWidth=1; c.globalAlpha=.42
        c.beginPath(); c.moveTo(w*.10,h*.28); c.lineTo(w*.90,h*.28); c.stroke()
        c.beginPath(); c.moveTo(w*.50,h*.08); c.lineTo(w*.50,h*.52); c.stroke()
        c.beginPath(); c.arc(w*.50,h*.28,Math.min(w,h)*.20,0,Math.PI*2); c.stroke()
        c.globalAlpha=1
        var body=[[.46,.30],[.54,.30],[.60,.40],[.59,.56],[.54,.64],[.53,.82],[.61,.91],[.58,.94],[.50,.87],[.42,.94],[.39,.91],[.47,.82],[.46,.64],[.41,.56],[.40,.40]]
        polygon(c,body,w,h)
        c.strokeStyle=Theme.accent; c.lineWidth=1
        c.beginPath(); c.moveTo(w*.50,h*.64); c.lineTo(w*.78,h*.80); c.lineTo(w*.87,h*.79); c.stroke()
        c.beginPath(); c.arc(w*.87,h*.79,Math.min(w,h)*.045,0,Math.PI*2); c.stroke()
        c.strokeStyle=Theme.silver; c.globalAlpha=.4
        c.beginPath(); c.moveTo(w*.41,h*.57); c.lineTo(w*.33,h*.64); c.lineTo(w*.67,h*.64); c.lineTo(w*.59,h*.57); c.stroke()
        c.globalAlpha=1
    }

    function drawUav(c,w,h) {
        var wing=[[.50,.20],[.56,.31],[.91,.43],[.84,.56],[.61,.53],[.56,.69],[.50,.82],[.44,.69],[.39,.53],[.16,.56],[.09,.43],[.44,.31]]
        polygon(c,wing,w,h)
        c.strokeStyle=Theme.silver; c.lineWidth=.8; c.globalAlpha=.45
        c.beginPath(); c.moveTo(w*.50,h*.22); c.lineTo(w*.50,h*.79); c.stroke()
        c.beginPath(); c.moveTo(w*.16,h*.48); c.lineTo(w*.84,h*.48); c.stroke()
        c.beginPath(); c.moveTo(w*.31,h*.40); c.lineTo(w*.69,h*.56); c.stroke()
        c.beginPath(); c.moveTo(w*.69,h*.40); c.lineTo(w*.31,h*.56); c.stroke()
        c.globalAlpha=1
    }

    function drawBuses(c,w,h) {
        c.strokeStyle=Theme.accent; c.lineWidth=1.1; c.globalAlpha=.78
        c.beginPath(); c.moveTo(w*.485,h*.24); c.lineTo(w*.485,h*.76); c.stroke()
        c.beginPath(); c.moveTo(w*.515,h*.24); c.lineTo(w*.515,h*.76); c.stroke()
        c.beginPath(); c.moveTo(w*.30,h*.50); c.lineTo(w*.70,h*.50); c.stroke()
        c.globalAlpha=1
    }

    function drawNodes(c,w,h) {
        var positions=[[.50,.28],[.32,.48],[.68,.48],[.44,.66],[.56,.66],[.50,.79]]
        for(var i=0;i<positions.length;++i){
            var px=w*positions[i][0], py=h*positions[i][1], sc=stateColorAt(i)
            c.fillStyle=Theme.panel2; c.strokeStyle=sc; c.lineWidth=1
            c.beginPath(); c.arc(px,py,7.5,0,Math.PI*2); c.fill(); c.stroke()
            c.fillStyle=sc; c.beginPath(); c.arc(px,py,2.5,0,Math.PI*2); c.fill()
        }
    }

    onPaint: {
        var c=getContext("2d"); c.reset(); var w=width,h=height
        drawGrid(c,w,h)
        c.fillStyle="#17232C"; c.strokeStyle=Theme.accent; c.lineWidth=1.6
        if(platformId==="turboprop") drawTurboprop(c,w,h)
        else if(platformId==="helicopter") drawHelicopter(c,w,h)
        else if(platformId==="uav") drawUav(c,w,h)
        else drawJet(c,w,h)
        drawBuses(c,w,h); drawNodes(c,w,h)

        var bw=Math.min(190,w*.40), bh=42, bx=w*.5-bw/2, by=h*.515
        c.fillStyle=Theme.panel2; c.strokeStyle=Theme.border; c.lineWidth=1
        c.fillRect(bx,by,bw,bh); c.strokeRect(bx,by,bw,bh)
        c.fillStyle=Theme.platinum; c.textAlign="center"; c.font="bold 9px Consolas"
        c.fillText(Theme.platformCode(platformId)+"  AVIONICS CORE",w*.5,by+15)
        c.fillStyle=Theme.accent; c.font="7px Consolas"
        c.fillText("BUS A/B  •  "+(subsystemRows?subsystemRows.length:0)+" NODES  •  SYNTHETIC",w*.5,by+30)

        c.strokeStyle=Theme.silver; c.globalAlpha=.42; c.lineWidth=1; var m=15
        c.beginPath();c.moveTo(4,m);c.lineTo(4,4);c.lineTo(m,4);c.stroke()
        c.beginPath();c.moveTo(w-m,4);c.lineTo(w-4,4);c.lineTo(w-4,m);c.stroke()
        c.beginPath();c.moveTo(4,h-m);c.lineTo(4,h-4);c.lineTo(m,h-4);c.stroke()
        c.beginPath();c.moveTo(w-m,h-4);c.lineTo(w-4,h-4);c.lineTo(w-4,h-m);c.stroke();c.globalAlpha=1
    }
}
