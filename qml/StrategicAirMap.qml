import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    property var publicTracks: []
    property var aegisTracks: []
    property var bases: []
    property bool rtl: false
    property string modeLabel: "COMMON AIR PICTURE"

    color: "#071218"
    border.color: "#2E566C"
    border.width: 1
    radius: 6
    clip: true

    function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)) }
    function xFor(lon) { return clamp((Number(lon) - 20.0) / 45.0, 0.03, 0.97) * width }
    function yFor(lat) { return clamp(1.0 - ((Number(lat) - 18.0) / 25.0), 0.04, 0.96) * height }
    function threatColor(level) {
        var t = String(level || "").toUpperCase()
        if (t === "CRITICAL" || t === "HIGH") return "#FF6B57"
        if (t === "MEDIUM") return "#F5B44C"
        return "#63E2A6"
    }
    function baseX(index) {
        var xs = [0.38, 0.47, 0.60, 0.69, 0.55, 0.31]
        return width * xs[index % xs.length]
    }
    function baseY(index) {
        var ys = [0.58, 0.44, 0.62, 0.47, 0.72, 0.68]
        return height * ys[index % ys.length]
    }

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#091A23" }
        GradientStop { position: 0.50; color: "#08151D" }
        GradientStop { position: 1.0; color: "#050D12" }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var c = getContext("2d")
            c.reset()
            var w = width
            var h = height

            c.fillStyle = "#08151D"
            c.fillRect(0, 0, w, h)

            // Latitude/longitude grid
            c.strokeStyle = "#16303B"
            c.lineWidth = 1
            c.globalAlpha = 0.65
            for (var gx = 1; gx < 11; ++gx) {
                var px = w * gx / 11
                c.beginPath(); c.moveTo(px, 0); c.lineTo(px, h); c.stroke()
            }
            for (var gy = 1; gy < 7; ++gy) {
                var py = h * gy / 7
                c.beginPath(); c.moveTo(0, py); c.lineTo(w, py); c.stroke()
            }
            c.globalAlpha = 1

            // Sea band
            c.fillStyle = "#0B2530"
            c.beginPath()
            c.moveTo(0, 0)
            c.lineTo(w, 0)
            c.lineTo(w, h * 0.24)
            c.bezierCurveTo(w*0.82,h*0.20,w*0.67,h*0.27,w*0.53,h*0.23)
            c.bezierCurveTo(w*0.37,h*0.18,w*0.21,h*0.28,0,h*0.21)
            c.closePath(); c.fill()

            // Land mass - North Africa / Egypt / Levant / Arabia stylized for management view
            c.fillStyle = "#1C2A2A"
            c.strokeStyle = "#45616A"
            c.lineWidth = 1.2
            c.beginPath()
            c.moveTo(0,h*0.35)
            c.lineTo(w*0.12,h*0.31)
            c.lineTo(w*0.22,h*0.36)
            c.lineTo(w*0.31,h*0.43)
            c.lineTo(w*0.39,h*0.45)
            c.lineTo(w*0.45,h*0.40)
            c.lineTo(w*0.49,h*0.46)
            c.lineTo(w*0.51,h*0.63)
            c.lineTo(w*0.55,h*0.93)
            c.lineTo(0,h*0.93)
            c.closePath(); c.fill(); c.stroke()

            c.beginPath()
            c.moveTo(w*0.49,h*0.46)
            c.lineTo(w*0.58,h*0.41)
            c.lineTo(w*0.69,h*0.35)
            c.lineTo(w*0.78,h*0.33)
            c.lineTo(w*0.87,h*0.40)
            c.lineTo(w*0.99,h*0.47)
            c.lineTo(w*0.99,h*0.93)
            c.lineTo(w*0.55,h*0.93)
            c.lineTo(w*0.51,h*0.63)
            c.closePath(); c.fill(); c.stroke()

            // Red Sea / Gulf of Suez
            c.fillStyle = "#0D3446"
            c.beginPath(); c.moveTo(w*.505,h*.53); c.lineTo(w*.535,h*.56); c.lineTo(w*.58,h*.96); c.lineTo(w*.545,h*.96); c.closePath(); c.fill()
            c.beginPath(); c.moveTo(w*.49,h*.48); c.lineTo(w*.505,h*.51); c.lineTo(w*.52,h*.74); c.lineTo(w*.505,h*.72); c.closePath(); c.fill()

            // Geographical labels
            c.fillStyle = "#6E8A93"
            c.font = "600 11px Sans Serif"
            c.fillText("MEDITERRANEAN", w*.16, h*.17)
            c.fillText("EGYPT", w*.27, h*.63)
            c.fillText("SINAI", w*.47, h*.55)
            c.fillText("LEVANT", w*.58, h*.31)
            c.fillText("SAUDI ARABIA", w*.69, h*.69)
            c.fillText("RED SEA", w*.54, h*.82)

            // Airspace sectors
            var sectors = [
                {x:.27,y:.30,w:.18,h:.20,c:"rgba(86,184,216,.11)",s:"#56B8D8",n:"SECTOR C"},
                {x:.46,y:.31,w:.16,h:.20,c:"rgba(155,131,213,.10)",s:"#9B83D5",n:"SECTOR D"},
                {x:.39,y:.54,w:.18,h:.21,c:"rgba(99,226,166,.08)",s:"#63E2A6",n:"TMA"},
                {x:.60,y:.49,w:.18,h:.18,c:"rgba(245,180,76,.08)",s:"#F5B44C",n:"TRAINING"}
            ]
            c.font = "700 8px Consolas"
            for (var si=0; si<sectors.length; ++si) {
                var s=sectors[si]
                c.fillStyle=s.c; c.strokeStyle=s.s; c.globalAlpha=.95
                c.fillRect(w*s.x,h*s.y,w*s.w,h*s.h)
                c.strokeRect(w*s.x,h*s.y,w*s.w,h*s.h)
                c.fillStyle=s.s; c.fillText(s.n,w*s.x+7,h*s.y+13)
            }
            c.globalAlpha=1

            // Civil/training corridors
            c.lineWidth = 2
            c.strokeStyle = "#2A8FAD"
            c.setLineDash([8,6])
            c.beginPath(); c.moveTo(w*.18,h*.45); c.bezierCurveTo(w*.35,h*.38,w*.48,h*.44,w*.66,h*.28); c.stroke()
            c.strokeStyle = "#B68A45"
            c.beginPath(); c.moveTo(w*.34,h*.77); c.bezierCurveTo(w*.45,h*.61,w*.58,h*.58,w*.73,h*.70); c.stroke()
            c.setLineDash([])

            // Compass rose
            var cx=w*.91, cy=h*.12, rr=24
            c.strokeStyle="#6C8792"; c.lineWidth=1
            c.beginPath(); c.arc(cx,cy,rr,0,Math.PI*2); c.stroke()
            c.beginPath(); c.moveTo(cx,cy-rr); c.lineTo(cx,cy+rr); c.stroke()
            c.beginPath(); c.moveTo(cx-rr,cy); c.lineTo(cx+rr,cy); c.stroke()
            c.fillStyle="#D9D7D4"; c.font="bold 8px Consolas"; c.fillText("N",cx-3,cy-rr-5)
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    // Public ADS-B traffic
    Repeater {
        model: root.publicTracks
        delegate: Item {
            required property var modelData
            width: 40; height: 40
            x: root.xFor(modelData.longitude) - width/2
            y: root.yFor(modelData.latitude) - height/2
            rotation: Number(modelData.headingDegrees)
            Rectangle { anchors.centerIn: parent; width: 27; height: 3; radius: 1.5; color: "#54C6E7" }
            Rectangle { anchors.centerIn: parent; width: 3; height: 22; radius: 1.5; color: "#E6F2F5" }
            Rectangle { anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top; width: 4; height: 9; radius: 2; color: "#54C6E7" }
            MouseArea { id: pma; anchors.fill: parent; hoverEnabled: true }
            ToolTip.visible: pma.containsMouse
            ToolTip.text: (modelData.callsign || modelData.icao24 || "AIRCRAFT") + "\n" + Math.round(Number(modelData.altitudeMeters || 0)) + " m"
        }
    }

    // AEGIS awareness tracks
    Repeater {
        model: root.aegisTracks
        delegate: Item {
            required property var modelData
            width: 42; height: 42
            x: root.xFor(modelData.longitude) - width/2
            y: root.yFor(modelData.latitude) - height/2
            Rectangle { anchors.centerIn: parent; width: 17; height: 17; rotation: 45; color: "#10191F"; border.color: root.threatColor(modelData.threatLevel); border.width: 2 }
            Text { anchors.left: parent.right; anchors.verticalCenter: parent.verticalCenter; text: modelData.trackId || "TRACK"; color: root.threatColor(modelData.threatLevel); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
            MouseArea { id: ama; anchors.fill: parent; hoverEnabled: true }
            ToolTip.visible: ama.containsMouse
            ToolTip.text: (modelData.trackId || "TRACK") + " • " + (modelData.classification || "UNKNOWN") + " • " + (modelData.threatLevel || "REVIEW")
        }
    }

    // Airfield/base pins
    Repeater {
        model: root.bases
        delegate: Item {
            required property int index
            required property var modelData
            width: 132; height: 42
            x: root.baseX(index) - 12
            y: root.baseY(index) - 12
            Rectangle {
                width: 20; height: 20; radius: 10
                color: Number(modelData.supportPercent) >= 90 ? "#143329" : "#3A2B18"
                border.color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"
                border.width: 2
                Text { anchors.centerIn: parent; text: "✦"; color: parent.border.color; font.pixelSize: 9; font.bold: true }
            }
            Rectangle {
                x: 26; y: -1; width: 102; height: 34; radius: 4
                color: "#D90A1218"; border.color: Number(modelData.supportPercent) >= 90 ? "#2A7157" : "#7C6230"; border.width: 1
                Column {
                    anchors.fill: parent; anchors.margins: 5; spacing: 0
                    Text { text: modelData.name || "AIRFIELD"; color: "#E8ECEE"; font.pixelSize: 7; font.bold: true; elide: Text.ElideRight; width: parent.width }
                    Text { text: (modelData.runway || "RWY") + "  •  " + Number(modelData.supportPercent || 0) + "%"; color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"; font.family: "Consolas"; font.pixelSize: 6; width: parent.width; elide: Text.ElideRight }
                }
            }
        }
    }

    // Map title / data provenance
    Rectangle {
        anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 12
        width: Math.min(410, parent.width * .38); height: 64; radius: 5
        color: "#E20A1117"; border.color: "#325A6C"; border.width: 1
        ColumnLayout {
            anchors.fill: parent; anchors.margins: 8; spacing: 1
            Text { text: root.rtl ? "الصورة الجوية المشتركة" : root.modeLabel; color: "#F0F3F5"; font.pixelSize: 12; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
            Text { text: root.rtl ? "ADS-B عام • AEGIS وعي جوي • قواعد تدريبية" : "PUBLIC ADS-B • AEGIS AWARENESS • TRAINING AIRFIELDS"; color: "#56B8D8"; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
            Text { text: root.rtl ? "البيانات المعروضة: عام / إعادة / صناعي بحسب المصدر" : "SOURCE MODE: PUBLIC / REPLAY / SYNTHETIC BY FEED"; color: "#83939B"; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
        }
    }

    Rectangle {
        anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 12
        width: 240; height: 46; radius: 5
        color: "#E20A1117"; border.color: "#2B4754"; border.width: 1
        RowLayout {
            anchors.fill: parent; anchors.margins: 7; spacing: 8
            Rectangle { width: 8; height: 8; radius: 4; color: "#63E2A6" }
            ColumnLayout {
                Layout.fillWidth: true; spacing: 0
                Text { text: root.rtl ? "حالة التكامل" : "DATA INTEGRATION"; color: "#8999A0"; font.pixelSize: 6; font.bold: true }
                Text { text: "ADS-B " + root.publicTracks.length + "   AEGIS " + root.aegisTracks.length + "   BASES " + root.bases.length; color: "#E5EAEC"; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
            }
        }
    }
}
