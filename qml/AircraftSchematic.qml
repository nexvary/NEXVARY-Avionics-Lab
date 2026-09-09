import QtQuick
import "Theme.js" as Theme
Canvas {
    onPaint: {
        var c=getContext("2d"); c.reset(); c.strokeStyle=Theme.cyan; c.lineWidth=2; c.shadowColor="#2e9bd1"; c.shadowBlur=14;
        c.beginPath(); c.moveTo(width*.50,height*.03); c.lineTo(width*.56,height*.33); c.lineTo(width*.95,height*.54); c.lineTo(width*.60,height*.59); c.lineTo(width*.58,height*.89); c.lineTo(width*.70,height*.96); c.lineTo(width*.53,height*.93); c.lineTo(width*.50,height*.99); c.lineTo(width*.47,height*.93); c.lineTo(width*.30,height*.96); c.lineTo(width*.42,height*.89); c.lineTo(width*.40,height*.59); c.lineTo(width*.05,height*.54); c.lineTo(width*.44,height*.33); c.closePath(); c.stroke();
        c.shadowBlur=0; c.strokeStyle="#274a5b"; c.lineWidth=1; c.beginPath(); c.moveTo(width*.5,height*.05); c.lineTo(width*.5,height*.94); c.stroke();
        for(var r=.15;r<.48;r+=.1){ c.beginPath(); c.arc(width*.5,height*.52,width*r,0,Math.PI*2); c.stroke(); }
    }
}
