import QtQuick
import "Theme.js" as Theme

Canvas {
    id: root
    property string kind: "dashboard"
    property color iconColor: Theme.silver
    implicitWidth: 28
    implicitHeight: 28
    onKindChanged: requestPaint()
    onIconColorChanged: requestPaint()
    onPaint: {
        const c = getContext("2d"); c.reset(); c.strokeStyle = iconColor; c.fillStyle = iconColor; c.lineWidth = 2.2; c.lineCap = "round"; c.lineJoin = "round";
        const w = width, h = height;
        function line(x1,y1,x2,y2){ c.beginPath(); c.moveTo(x1*w,y1*h); c.lineTo(x2*w,y2*h); c.stroke(); }
        if (kind === "dashboard") {
            c.beginPath(); c.moveTo(.14*w,.48*h); c.lineTo(.5*w,.18*h); c.lineTo(.86*w,.48*h); c.stroke();
            c.strokeRect(.25*w,.45*h,.5*w,.38*h); c.strokeRect(.46*w,.61*h,.12*w,.22*h);
        } else if (kind === "health") {
            c.beginPath(); c.moveTo(.08*w,.55*h); c.lineTo(.28*w,.55*h); c.lineTo(.38*w,.27*h); c.lineTo(.52*w,.76*h); c.lineTo(.64*w,.45*h); c.lineTo(.9*w,.45*h); c.stroke();
        } else if (kind === "sensors") {
            c.beginPath(); c.arc(.5*w,.5*h,.09*w,0,Math.PI*2); c.fill();
            for (let r of [.24,.38]) { c.beginPath(); c.arc(.5*w,.5*h,r*w,-.75*Math.PI,.75*Math.PI); c.stroke(); }
        } else if (kind === "events") {
            c.strokeRect(.22*w,.12*h,.56*w,.76*h); line(.32,.32,.68,.32); line(.32,.48,.68,.48); line(.32,.64,.61,.64);
        } else if (kind === "replay") {
            c.beginPath(); c.arc(.5*w,.5*h,.36*w,.25*Math.PI,1.92*Math.PI); c.stroke();
            c.beginPath(); c.moveTo(.19*w,.28*h); c.lineTo(.18*w,.52*h); c.lineTo(.36*w,.4*h); c.stroke();
            c.beginPath(); c.moveTo(.44*w,.34*h); c.lineTo(.7*w,.5*h); c.lineTo(.44*w,.66*h); c.closePath(); c.fill();
        } else if (kind === "trends") {
            for (let i=0;i<4;i++) c.strokeRect((.16+i*.18)*w,(.68-i*.13)*h,.1*w,(.18+i*.05)*h);
        } else if (kind === "twin") {
            c.beginPath(); c.moveTo(.5*w,.1*h); c.lineTo(.82*w,.29*h); c.lineTo(.82*w,.69*h); c.lineTo(.5*w,.89*h); c.lineTo(.18*w,.69*h); c.lineTo(.18*w,.29*h); c.closePath(); c.stroke();
            line(.18,.29,.5,.5); line(.82,.29,.5,.5); line(.5,.5,.5,.89);
        } else if (kind === "fault") {
            c.beginPath(); c.moveTo(.5*w,.1*h); c.lineTo(.9*w,.84*h); c.lineTo(.1*w,.84*h); c.closePath(); c.stroke(); line(.5,.35,.5,.61); c.beginPath(); c.arc(.5*w,.72*h,.03*w,0,Math.PI*2); c.fill();
        }
    }
}
