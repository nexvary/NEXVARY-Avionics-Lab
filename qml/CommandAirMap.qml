import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    property var publicTracks: []
    property var aegisTracks: []
    property bool rtl: false
    color: "#0A171B"
    border.color: Theme.deepBlue
    border.width: 1
    radius: Theme.radius
    clip: true

    function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)) }
    function xFor(lon) { return clamp((Number(lon) - 20.0) / 45.0, 0.03, 0.97) * width }
    function yFor(lat) { return clamp(1.0 - ((Number(lat) - 18.0) / 25.0), 0.04, 0.96) * height }
    function threatColor(level) {
        var t = String(level || "").toUpperCase()
        if (t === "CRITICAL" || t === "HIGH") return Theme.warmOrange
        if (t === "MEDIUM") return Theme.royalGold
        return Theme.radarGreen
    }

    Canvas {
        id: mapCanvas
        anchors.fill: parent
        onPaint: {
            var c = getContext("2d")
            c.reset()
            c.fillStyle = "#0A171B"
            c.fillRect(0, 0, width, height)
            c.strokeStyle = "#17303D"
            c.lineWidth = 1
            c.globalAlpha = 0.75
            for (var gx = 1; gx < 12; ++gx) { var px = width * gx / 12; c.beginPath(); c.moveTo(px,0); c.lineTo(px,height); c.stroke() }
            for (var gy = 1; gy < 8; ++gy) { var py = height * gy / 8; c.beginPath(); c.moveTo(0,py); c.lineTo(width,py); c.stroke() }
            c.globalAlpha = 1.0
            c.fillStyle = "#182B2B"
            c.strokeStyle = "#38515A"
            c.lineWidth = 1.3
            c.beginPath(); c.moveTo(width*0.00,height*0.36); c.lineTo(width*0.11,height*0.32); c.lineTo(width*0.22,height*0.35); c.lineTo(width*0.31,height*0.42); c.lineTo(width*0.40,height*0.45); c.lineTo(width*0.46,height*0.43); c.lineTo(width*0.49,height*0.49); c.lineTo(width*0.52,height*0.63); c.lineTo(width*0.57,height*0.93); c.lineTo(width*0.00,height*0.93); c.closePath(); c.fill(); c.stroke()
            c.beginPath(); c.moveTo(width*0.49,height*0.49); c.lineTo(width*0.58,height*0.44); c.lineTo(width*0.68,height*0.38); c.lineTo(width*0.77,height*0.36); c.lineTo(width*0.86,height*0.42); c.lineTo(width*0.98,height*0.49); c.lineTo(width*0.98,height*0.93); c.lineTo(width*0.57,height*0.93); c.lineTo(width*0.52,height*0.63); c.closePath(); c.fill(); c.stroke()
            c.fillStyle = "#0C2A38"; c.beginPath(); c.moveTo(width*0.50,height*0.55); c.lineTo(width*0.535,height*0.57); c.lineTo(width*0.58,height*0.96); c.lineTo(width*0.545,height*0.96); c.closePath(); c.fill()
            c.fillStyle = "#6E8790"; c.font = "bold 11px Sans Serif"; c.fillText("EGYPT",width*0.24,height*0.64); c.fillText("SINAI",width*0.48,height*0.58); c.fillText("SAUDI ARABIA",width*0.67,height*0.74); c.fillText("LEVANT",width*0.58,height*0.34); c.fillText("MEDITERRANEAN",width*0.20,height*0.29)
            c.strokeStyle = Theme.warmOrange; c.fillStyle = "rgba(210,140,98,0.10)"; c.lineWidth = 1.2
            var zones=[[0.43,0.41,0.08,0.12],[0.55,0.47,0.10,0.11]]
            for (var zi=0; zi<zones.length; ++zi) { var z=zones[zi]; c.fillRect(width*z[0],height*z[1],width*z[2],height*z[3]); c.strokeRect(width*z[0],height*z[1],width*z[2],height*z[3]) }
            var cx=width*0.48, cy=height*0.52, r=Math.min(width,height)*0.42
            c.strokeStyle = "#356270"; c.globalAlpha=0.65
            for (var ring=1; ring<=4; ++ring) { c.beginPath(); c.arc(cx,cy,r*ring/4,0,Math.PI*2); c.stroke() }
            for (var a=0; a<360; a+=45) { var rad=a*Math.PI/180; c.beginPath(); c.moveTo(cx,cy); c.lineTo(cx+Math.cos(rad)*r,cy+Math.sin(rad)*r); c.stroke() }
            c.globalAlpha=1.0
            var sweep=(cockpit.tick%360)*Math.PI/180
            c.fillStyle="rgba(86,184,216,0.09)"; c.beginPath(); c.moveTo(cx,cy); c.arc(cx,cy,r,sweep-0.30,sweep+0.30); c.closePath(); c.fill()
            c.strokeStyle=Theme.signalCyan; c.globalAlpha=0.8; c.beginPath(); c.moveTo(cx,cy); c.lineTo(cx+Math.cos(sweep)*r,cy+Math.sin(sweep)*r); c.stroke(); c.globalAlpha=1.0
        }
        Connections { target: cockpit; function onDataChanged() { mapCanvas.requestPaint() } }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    Repeater {
        model: root.publicTracks
        delegate: Item {
            required property var modelData
            width: 34; height: 34
            x: root.xFor(modelData.longitude)-17
            y: root.yFor(modelData.latitude)-17
            rotation: Number(modelData.headingDegrees)
            Rectangle { anchors.centerIn: parent; width: 23; height: 3; radius: 1; color: Theme.signalCyan }
            Rectangle { anchors.centerIn: parent; width: 3; height: 19; radius: 1; color: Theme.platinum }
            Rectangle { anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top; width: 4; height: 8; color: Theme.signalCyan }
            MouseArea { id: civArea; anchors.fill: parent; hoverEnabled: true }
            ToolTip.visible: civArea.containsMouse
            ToolTip.text: (modelData.callsign || modelData.icao24) + "\n" + Math.round(Number(modelData.altitudeMeters)) + " m"
        }
    }

    Repeater {
        model: root.aegisTracks
        delegate: Item {
            required property var modelData
            width: 36; height: 36
            x: root.xFor(modelData.longitude)-18
            y: root.yFor(modelData.latitude)-18
            Rectangle { anchors.centerIn: parent; width: 16; height: 16; rotation: 45; color: "transparent"; border.color: root.threatColor(modelData.threatLevel); border.width: 2 }
            Text { anchors.left: parent.right; anchors.verticalCenter: parent.verticalCenter; text: modelData.trackId; color: root.threatColor(modelData.threatLevel); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
            MouseArea { id: aegisArea; anchors.fill: parent; hoverEnabled: true }
            ToolTip.visible: aegisArea.containsMouse
            ToolTip.text: modelData.trackId + " • " + modelData.classification + " • " + modelData.threatLevel
        }
    }

    Rectangle {
        anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 9
        width: 176; height: 112
        color: "#D00C1319"; border.color: Theme.deepBlue; border.width: 1; radius: Theme.radius
        ColumnLayout {
            anchors.fill: parent; anchors.margins: 7; spacing: 3
            Text { text: root.rtl ? "مفتاح الرموز" : "SYMBOL LEGEND"; color: Theme.platinum; font.pixelSize: 8; font.bold: true }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
            RowLayout { Rectangle { width: 12; height: 3; color: Theme.signalCyan } Text { text: root.rtl ? "طيران عام / ADS-B" : "PUBLIC / ADS-B"; color: Theme.silver; font.pixelSize: 6 } }
            RowLayout { Rectangle { width: 10; height: 10; rotation:45; color:"transparent"; border.color:Theme.royalGold; border.width:1 } Text { text: "AEGIS / C-UAS"; color: Theme.silver; font.pixelSize: 6 } }
            RowLayout { Rectangle { width: 10; height: 10; color:"transparent"; border.color:Theme.warmOrange; border.width:1 } Text { text: root.rtl ? "منطقة مقيدة" : "RESTRICTED ZONE"; color: Theme.silver; font.pixelSize: 6 } }
            RowLayout { Rectangle { width: 10; height: 10; radius:5; color:Theme.radarGreen } Text { text: root.rtl ? "مصدر/موقع" : "SITE / SOURCE"; color: Theme.silver; font.pixelSize: 6 } }
        }
    }

    Rectangle {
        anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 9
        width: 188; height: 80
        color: "#D00C1319"; border.color: Theme.signalCyan; border.width: 1; radius: Theme.radius
        GridLayout {
            anchors.fill: parent; anchors.margins: 7; columns:2; rowSpacing:2; columnSpacing:8
            Text { text: root.rtl ? "عام" : "PUBLIC"; color: Theme.muted; font.pixelSize:6 }
            Text { text: String(root.publicTracks.length); color: Theme.signalCyan; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
            Text { text: "AEGIS"; color: Theme.muted; font.pixelSize:6 }
            Text { text: String(root.aegisTracks.length); color: Theme.royalGold; font.family:"Consolas"; font.pixelSize:9; font.bold:true }
            Text { text: root.rtl ? "النمط" : "MODE"; color: Theme.muted; font.pixelSize:6 }
            Text { text: "AWARENESS"; color: Theme.radarGreen; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
        }
    }

    Text {
        anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 7
        text: root.rtl ? "خريطة تشغيلية تدريبية / ليست للملاحة" : "TRAINING OPERATIONAL VIEW / NOT FOR NAVIGATION"
        color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6
    }
}
