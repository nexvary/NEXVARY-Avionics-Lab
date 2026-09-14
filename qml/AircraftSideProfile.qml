import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property string platformId: cockpit.activePlatformId
    property var subsystemRows: []
    property color accent: Theme.signalCyan
    antialiasing: true

    onPlatformIdChanged: requestPaint()
    onSubsystemRowsChanged: requestPaint()
    onAccentChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function nodeColor(index) {
        if (!subsystemRows || index >= subsystemRows.length) return Theme.radarGreen
        return Theme.stateColor(subsystemRows[index].state)
    }

    function fillStroke(c) {
        c.fill()
        c.stroke()
    }

    function oval(c, cx, cy, rx, ry) {
        c.ellipse(cx - rx, cy - ry, rx * 2, ry * 2)
    }

    function setAirframeStyle(c,w,h) {
        var g=c.createLinearGradient(w*.08,h*.28,w*.92,h*.70)
        g.addColorStop(0,"#0C171E")
        g.addColorStop(.50,"#263D48")
        g.addColorStop(1,"#101E26")
        c.fillStyle=g
        c.strokeStyle=Theme.metallicSilver
        c.lineWidth=1.5
        c.lineJoin="round"
    }

    function drawGrid(c,w,h) {
        c.strokeStyle=Theme.grid
        c.lineWidth=1
        c.globalAlpha=.54
        var step=Math.max(20,Math.min(w,h)/12)
        for(var x=step;x<w;x+=step){c.beginPath();c.moveTo(x,0);c.lineTo(x,h);c.stroke()}
        for(var y=step;y<h;y+=step){c.beginPath();c.moveTo(0,y);c.lineTo(w,y);c.stroke()}
        c.globalAlpha=.30
        c.strokeStyle=Theme.metallicSilver
        c.setLineDash([6,8])
        c.beginPath();c.moveTo(w*.04,h*.56);c.lineTo(w*.96,h*.56);c.stroke()
        c.setLineDash([])
        c.globalAlpha=1
    }

    function drawReference(c,w,h) {
        c.fillStyle=Theme.silver
        c.font="600 11px 'Noto Sans Mono'"
        c.fillText("SIDE ELEVATION",12,19)
        c.textAlign="right"
        c.fillText("ENGINEERING REFERENCE",w-12,19)
        c.textAlign="left"

        c.strokeStyle=Theme.royalGold
        c.globalAlpha=.55
        c.beginPath();c.moveTo(w*.08,h*.88);c.lineTo(w*.94,h*.88);c.stroke()
        c.beginPath();c.moveTo(w*.08,h*.86);c.lineTo(w*.08,h*.90);c.stroke()
        c.beginPath();c.moveTo(w*.94,h*.86);c.lineTo(w*.94,h*.90);c.stroke()
        c.fillStyle=Theme.royalGold
        c.textAlign="center"
        c.fillText("REFERENCE LENGTH",w*.51,h*.85)
        c.textAlign="left"
        c.globalAlpha=1
    }

    function drawJet(c,w,h) {
        setAirframeStyle(c,w,h)

        c.beginPath()
        c.moveTo(w*.075,h*.58)
        c.quadraticCurveTo(w*.16,h*.50,w*.30,h*.47)
        c.bezierCurveTo(w*.44,h*.39,w*.63,h*.37,w*.79,h*.41)
        c.quadraticCurveTo(w*.91,h*.43,w*.96,h*.50)
        c.quadraticCurveTo(w*.92,h*.57,w*.78,h*.60)
        c.bezierCurveTo(w*.60,h*.65,w*.39,h*.66,w*.23,h*.64)
        c.lineTo(w*.075,h*.64)
        c.closePath()
        fillStroke(c)

        c.beginPath()
        c.moveTo(w*.15,h*.52)
        c.lineTo(w*.115,h*.25)
        c.quadraticCurveTo(w*.17,h*.28,w*.255,h*.48)
        c.closePath()
        fillStroke(c)

        c.beginPath()
        c.moveTo(w*.42,h*.61)
        c.lineTo(w*.34,h*.79)
        c.lineTo(w*.63,h*.61)
        c.closePath()
        fillStroke(c)

        c.beginPath()
        c.moveTo(w*.20,h*.62)
        c.lineTo(w*.16,h*.72)
        c.lineTo(w*.33,h*.64)
        c.closePath()
        fillStroke(c)

        c.fillStyle="#07131A"
        c.strokeStyle=Theme.signalCyan
        c.lineWidth=1.2
        c.beginPath()
        c.moveTo(w*.63,h*.405)
        c.quadraticCurveTo(w*.69,h*.29,w*.78,h*.415)
        c.lineTo(w*.72,h*.45)
        c.closePath()
        fillStroke(c)

        c.fillStyle="#030A0F"
        c.strokeStyle=Theme.royalGold
        c.beginPath()
        c.moveTo(w*.54,h*.52)
        c.quadraticCurveTo(w*.63,h*.47,w*.70,h*.51)
        c.lineTo(w*.66,h*.57)
        c.lineTo(w*.56,h*.58)
        c.closePath()
        fillStroke(c)

        c.strokeStyle=Theme.signalCyan
        c.globalAlpha=.70
        c.lineWidth=1
        c.beginPath();c.moveTo(w*.25,h*.55);c.lineTo(w*.49,h*.52);c.stroke()
        c.beginPath();c.moveTo(w*.73,h*.47);c.lineTo(w*.87,h*.50);c.stroke()
        c.beginPath();c.moveTo(w*.30,h*.48);c.lineTo(w*.30,h*.64);c.stroke()
        c.globalAlpha=1

        c.fillStyle="#02070B"
        c.strokeStyle=Theme.metallicSilver
        c.beginPath();root.oval(c,w*.083,h*.61,w*.025,h*.045);fillStroke(c)
    }

    function drawTurboprop(c,w,h) {
        setAirframeStyle(c,w,h)

        c.beginPath()
        c.moveTo(w*.09,h*.55)
        c.quadraticCurveTo(w*.25,h*.45,w*.54,h*.45)
        c.lineTo(w*.82,h*.46)
        c.quadraticCurveTo(w*.91,h*.46,w*.94,h*.52)
        c.quadraticCurveTo(w*.89,h*.58,w*.79,h*.59)
        c.lineTo(w*.27,h*.62)
        c.lineTo(w*.09,h*.61)
        c.closePath()
        fillStroke(c)

        c.beginPath();c.moveTo(w*.17,h*.49);c.lineTo(w*.13,h*.27);c.lineTo(w*.26,h*.48);c.closePath();fillStroke(c)
        c.beginPath();c.moveTo(w*.45,h*.59);c.lineTo(w*.34,h*.75);c.lineTo(w*.68,h*.58);c.closePath();fillStroke(c)

        c.fillStyle="#0A141B"
        c.strokeStyle=Theme.signalCyan
        c.beginPath();c.moveTo(w*.67,h*.45);c.quadraticCurveTo(w*.72,h*.34,w*.80,h*.46);c.lineTo(w*.76,h*.49);c.closePath();fillStroke(c)

        var px=w*.925, py=h*.52, pr=Math.min(w,h)*.16
        c.strokeStyle=Theme.royalGold
        c.lineWidth=1.4
        c.globalAlpha=.82
        c.beginPath();c.arc(px,py,pr,0,Math.PI*2);c.stroke()
        c.beginPath();c.moveTo(px,py-pr);c.lineTo(px,py+pr);c.stroke()
        c.beginPath();c.moveTo(px-pr*.75,py-pr*.65);c.lineTo(px+pr*.75,py+pr*.65);c.stroke()
        c.globalAlpha=1
    }

    function drawHelicopter(c,w,h) {
        setAirframeStyle(c,w,h)

        c.beginPath()
        c.moveTo(w*.18,h*.57)
        c.quadraticCurveTo(w*.23,h*.35,w*.43,h*.34)
        c.quadraticCurveTo(w*.60,h*.34,w*.67,h*.50)
        c.lineTo(w*.89,h*.46)
        c.lineTo(w*.94,h*.50)
        c.lineTo(w*.66,h*.59)
        c.quadraticCurveTo(w*.49,h*.72,w*.29,h*.64)
        c.closePath()
        fillStroke(c)

        c.fillStyle="#07131A"
        c.strokeStyle=Theme.signalCyan
        c.beginPath()
        c.moveTo(w*.26,h*.49)
        c.quadraticCurveTo(w*.31,h*.36,w*.43,h*.37)
        c.lineTo(w*.48,h*.50)
        c.closePath()
        fillStroke(c)

        c.strokeStyle=Theme.metallicSilver
        c.lineWidth=1.3
        c.beginPath();c.moveTo(w*.31,h*.65);c.lineTo(w*.28,h*.76);c.lineTo(w*.66,h*.76);c.stroke()
        c.beginPath();c.moveTo(w*.61,h*.61);c.lineTo(w*.66,h*.76);c.stroke()

        c.beginPath();c.moveTo(w*.45,h*.34);c.lineTo(w*.45,h*.22);c.stroke()
        c.strokeStyle=Theme.signalCyan
        c.globalAlpha=.68
        c.beginPath();c.moveTo(w*.07,h*.21);c.lineTo(w*.84,h*.21);c.stroke()
        c.beginPath();c.arc(w*.94,h*.49,Math.min(w,h)*.075,0,Math.PI*2);c.stroke()
        c.beginPath();c.moveTo(w*.94,h*.42);c.lineTo(w*.94,h*.56);c.stroke()
        c.beginPath();c.moveTo(w*.88,h*.49);c.lineTo(w*.99,h*.49);c.stroke()
        c.globalAlpha=1

        c.fillStyle=Theme.royalGold
        c.beginPath();c.arc(w*.45,h*.22,3,0,Math.PI*2);c.fill()
    }

    function drawUav(c,w,h) {
        setAirframeStyle(c,w,h)

        c.beginPath()
        c.moveTo(w*.09,h*.57)
        c.quadraticCurveTo(w*.24,h*.45,w*.48,h*.43)
        c.lineTo(w*.84,h*.46)
        c.quadraticCurveTo(w*.93,h*.47,w*.96,h*.52)
        c.lineTo(w*.90,h*.57)
        c.lineTo(w*.49,h*.60)
        c.lineTo(w*.18,h*.63)
        c.closePath()
        fillStroke(c)

        c.beginPath();c.moveTo(w*.43,h*.45);c.lineTo(w*.54,h*.27);c.lineTo(w*.66,h*.45);c.closePath();fillStroke(c)
        c.beginPath();c.moveTo(w*.29,h*.60);c.lineTo(w*.39,h*.76);c.lineTo(w*.64,h*.59);c.closePath();fillStroke(c)
        c.beginPath();c.moveTo(w*.16,h*.54);c.lineTo(w*.12,h*.39);c.lineTo(w*.25,h*.49);c.closePath();fillStroke(c)

        c.fillStyle="#07131A"
        c.strokeStyle=Theme.rfViolet
        c.beginPath();root.oval(c,w*.74,h*.50,w*.055,h*.035);fillStroke(c)
    }

    function drawSystems(c,w,h) {
        var positions=[[.20,.58],[.36,.54],[.52,.52],[.67,.51],[.83,.52]]
        c.strokeStyle=root.accent
        c.lineWidth=1.2
        c.globalAlpha=.72
        c.beginPath();c.moveTo(w*positions[0][0],h*positions[0][1])
        for(var j=1;j<positions.length;++j)c.lineTo(w*positions[j][0],h*positions[j][1])
        c.stroke()
        c.globalAlpha=1

        for(var i=0;i<positions.length;++i){
            var x=w*positions[i][0], y=h*positions[i][1], col=nodeColor(i)
            c.fillStyle="#07131A"
            c.strokeStyle=col
            c.lineWidth=1.4
            c.beginPath();c.arc(x,y,7,0,Math.PI*2);c.fill();c.stroke()
            c.fillStyle=col
            c.beginPath();c.arc(x,y,2.6,0,Math.PI*2);c.fill()
        }
    }

    onPaint: {
        var c=getContext("2d")
        c.reset()
        var w=width, h=height
        c.fillStyle="#030A0F"
        c.fillRect(0,0,w,h)
        drawGrid(c,w,h)
        drawReference(c,w,h)

        if(platformId.indexOf("helicopter")>=0) drawHelicopter(c,w,h)
        else if(platformId.indexOf("uav")>=0) drawUav(c,w,h)
        else if(platformId.indexOf("turboprop")>=0) drawTurboprop(c,w,h)
        else drawJet(c,w,h)

        drawSystems(c,w,h)

        c.fillStyle=root.accent
        c.font="700 11px 'Noto Sans Mono'"
        c.fillText(Theme.platformCode(platformId)+"  •  SYSTEM OVERLAY  •  SYNTHETIC",12,h-12)
    }
}
