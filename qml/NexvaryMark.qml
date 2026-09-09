import QtQuick
import "Theme.js" as Theme

Canvas {
    implicitWidth: 58
    implicitHeight: 58
    onPaint: {
        const c = getContext("2d"); c.reset(); c.fillStyle = Theme.gold; c.strokeStyle = Theme.gold; c.lineWidth = 2;
        c.beginPath(); c.moveTo(width*.5,height*.1); c.lineTo(width*.72,height*.32); c.lineTo(width*.9,height*.22); c.lineTo(width*.72,height*.58); c.lineTo(width*.57,height*.48); c.lineTo(width*.57,height*.88); c.lineTo(width*.5,height*.96); c.lineTo(width*.43,height*.88); c.lineTo(width*.43,height*.48); c.lineTo(width*.28,height*.58); c.lineTo(width*.1,height*.22); c.lineTo(width*.28,height*.32); c.closePath(); c.fill();
        c.fillStyle="#061119"; c.beginPath(); c.moveTo(width*.5,height*.2); c.lineTo(width*.58,height*.36); c.lineTo(width*.5,height*.53); c.lineTo(width*.42,height*.36); c.closePath(); c.fill();
    }
}
