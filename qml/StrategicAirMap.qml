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
    radius: 7
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
        GradientStop { position: 0.0; color: "#0A1B24" }
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

            c.strokeStyle = "#173540"
            c.lineWidth = 1
            c.globalAlpha = 0.72
            for (var gx = 1; gx < 11; ++gx) {
                var px = w * gx / 11
                c.beginPath(); c.moveTo(px, 0); c.lineTo(px, h); c.stroke()
            }
            for (var gy = 1; gy < 7; ++gy) {
                var py = h * gy / 7
                c.beginPath(); c.moveTo(0, py); c.lineTo(w, py); c.stroke()
            }
            c.globalAlpha = 1

            c.fillStyle = "#0B2833"
            c.beginPath()
            c.moveTo(0, 0)
            c.lineTo(w, 0)
            c.lineTo(w, h * 0.24)
            c.bezierCurveTo(w*0.82,h*0.20,w*0.67,h*0.27,w*0.53,h*0.23)
            c.bezierCurveTo(w*0.37,h*0.18,w*0.21,h*0.28,0,h*0.21)
            c.closePath(); c.fill()

            c.fillStyle = "#1C2E2D"
            c.strokeStyle = "#4B6872"
            c.lineWidth = 1.4
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

            c.fillStyle = "#0D3B50"
            c.beginPath(); c.moveTo(w*.505,h*.53); c.lineTo(w*.535,h*.56); c.lineTo(w*.58,h*.96); c.lineTo(w*.545,h*.96); c.closePath(); c.fill()
            c.beginPath(); c.moveTo(w*.49,h*.48); c.lineTo(w*.505,h*.51); c.lineTo(w*.52,h*.74); c.lineTo(w*.505,h*.72); c.closePath(); c.fill()

            c.fillStyle = "#7C98A1"
            c.font = root.rtl ? "700 13px Noto Kufi Arabic" : "700 13px Segoe UI"
            c.fillText(root.rtl ? "البحر المتوسط" : "MEDITERRANEAN", w*.15, h*.17)
            c.fillText(root.rtl ? "مصر" : "EGYPT", w*.27, h*.63)
            c.fillText(root.rtl ? "سيناء" : "SINAI", w*.47, h*.55)
            c.fillText(root.rtl ? "شرق المتوسط" : "LEVANT", w*.58, h*.31)
            c.fillText(root.rtl ? "السعودية" : "SAUDI ARABIA", w*.69, h*.69)
            c.fillText(root.rtl ? "البحر الأحمر" : "RED SEA", w*.54, h*.82)

            var sectors = [
                {x:.27,y:.30,w:.18,h:.20,c:"rgba(86,184,216,.12)",s:"#56B8D8",n:root.rtl?"قطاع C":"SECTOR C"},
                {x:.46,y:.31,w:.16,h:.20,c:"rgba(155,131,213,.11)",s:"#9B83D5",n:root.rtl?"قطاع D":"SECTOR D"},
                {x:.39,y:.54,w:.18,h:.21,c:"rgba(99,226,166,.09)",s:"#63E2A6",n:root.rtl?"منطقة طرفية":"TMA"},
                {x:.60,y:.49,w:.18,h:.18,c:"rgba(245,180,76,.09)",s:"#F5B44C",n:root.rtl?"تدريب":"TRAINING"}
            ]
            c.font = root.rtl ? "700 11px Noto Kufi Arabic" : "700 11px Segoe UI"
            for (var si=0; si<sectors.length; ++si) {
                var s=sectors[si]
                c.fillStyle=s.c; c.strokeStyle=s.s; c.globalAlpha=.96
                c.fillRect(w*s.x,h*s.y,w*s.w,h*s.h)
                c.strokeRect(w*s.x,h*s.y,w*s.w,h*s.h)
                c.fillStyle=s.s; c.fillText(s.n,w*s.x+9,h*s.y+18)
            }
            c.globalAlpha=1

            c.lineWidth = 2.4
            c.strokeStyle = "#2AA2C4"
            c.setLineDash([10,7])
            c.beginPath(); c.moveTo(w*.18,h*.45); c.bezierCurveTo(w*.35,h*.38,w*.48,h*.44,w*.66,h*.28); c.stroke()
            c.strokeStyle = "#D5A44F"
            c.beginPath(); c.moveTo(w*.34,h*.77); c.bezierCurveTo(w*.45,h*.61,w*.58,h*.58,w*.73,h*.70); c.stroke()
            c.setLineDash([])

            var cx=w*.91, cy=h*.12, rr=28
            c.strokeStyle="#7896A0"; c.lineWidth=1.2
            c.beginPath(); c.arc(cx,cy,rr,0,Math.PI*2); c.stroke()
            c.beginPath(); c.moveTo(cx,cy-rr); c.lineTo(cx,cy+rr); c.stroke()
            c.beginPath(); c.moveTo(cx-rr,cy); c.lineTo(cx+rr,cy); c.stroke()
            c.fillStyle="#E7ECEE"; c.font="bold 10px Consolas"; c.fillText("N",cx-4,cy-rr-7)
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPainted: {}
    }

    Repeater {
        model: root.publicTracks
        delegate: Item {
            required property var modelData
            width: 44; height: 44
            x: root.xFor(modelData.longitude) - width/2
            y: root.yFor(modelData.latitude) - height/2
            rotation: Number(modelData.headingDegrees)
            Rectangle { anchors.centerIn: parent; width: 30; height: 4; radius: 2; color: "#54C6E7" }
            Rectangle { anchors.centerIn: parent; width: 4; height: 25; radius: 2; color: "#EEF7F8" }
            Rectangle { anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top; width: 5; height: 10; radius: 2; color: "#54C6E7" }
            MouseArea { id: pma; anchors.fill: parent; hoverEnabled: true }
            ToolTip.visible: pma.containsMouse
            ToolTip.text: (modelData.callsign || modelData.icao24 || "AIRCRAFT") + "\n" + Math.round(Number(modelData.altitudeMeters || 0)) + " m"
        }
    }

    Repeater {
        model: root.aegisTracks
        delegate: Item {
            required property var modelData
            width: 46; height: 46
            x: root.xFor(modelData.longitude) - width/2
            y: root.yFor(modelData.latitude) - height/2
            Rectangle { anchors.centerIn: parent; width: 19; height: 19; rotation: 45; color: "#10191F"; border.color: root.threatColor(modelData.threatLevel); border.width: 2 }
            Text {
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.trackId || "TRACK"
                color: root.threatColor(modelData.threatLevel)
                font.family: Theme.mono
                font.pixelSize: 10
                font.bold: true
            }
            MouseArea { id: ama; anchors.fill: parent; hoverEnabled: true }
            ToolTip.visible: ama.containsMouse
            ToolTip.text: (modelData.trackId || "TRACK") + " • " + (modelData.classification || "UNKNOWN") + " • " + (modelData.threatLevel || "REVIEW")
        }
    }

    Repeater {
        model: root.bases
        delegate: Item {
            required property int index
            required property var modelData
            width: 166; height: 50
            x: root.baseX(index) - 12
            y: root.baseY(index) - 12

            Rectangle {
                width: 24; height: 24; radius: 12
                color: Number(modelData.supportPercent) >= 90 ? "#143329" : "#3A2B18"
                border.color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"
                border.width: 2
                Text { anchors.centerIn: parent; text: "✦"; color: parent.border.color; font.pixelSize: 11; font.bold: true }
            }

            Rectangle {
                x: 31; y: -2; width: 130; height: 44; radius: 5
                color: "#E60A1218"
                border.color: Number(modelData.supportPercent) >= 90 ? "#2A7157" : "#7C6230"
                border.width: 1
                Column {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 1
                    Text {
                        text: modelData.name || "AIRFIELD"
                        color: "#EDF2F3"
                        font.family: Theme.uiFont(root.rtl)
                        font.pixelSize: 10
                        font.bold: true
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    Text {
                        text: (modelData.runway || "RWY") + "  •  " + Number(modelData.supportPercent || 0) + "%"
                        color: Number(modelData.supportPercent) >= 90 ? "#63E2A6" : "#F5B44C"
                        font.family: Theme.mono
                        font.pixelSize: 9
                        width: parent.width
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 14
        width: Math.min(470, parent.width * .42)
        height: 82
        radius: 6
        color: "#E80A1117"
        border.color: "#35657A"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 2
            Text {
                text: root.rtl ? "الصورة الجوية المشتركة" : root.modeLabel
                color: "#F3F6F7"
                font.family: Theme.uiFont(root.rtl)
                font.pixelSize: 15
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            Text {
                text: root.rtl ? "ADS-B عام • AEGIS وعي جوي • قواعد ومطارات" : "PUBLIC ADS-B • AEGIS AWARENESS • BASES & AIRFIELDS"
                color: "#66C6E4"
                font.family: Theme.uiFont(root.rtl)
                font.pixelSize: 10
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            Text {
                text: root.rtl ? "المصدر: عام / إعادة / بيانات تدريبية بحسب التغذية" : "SOURCE: PUBLIC / REPLAY / SYNTHETIC BY FEED"
                color: "#91A1A8"
                font.family: Theme.uiFont(root.rtl)
                font.pixelSize: 9
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 14
        width: 292
        height: 58
        radius: 6
        color: "#E80A1117"
        border.color: "#31515F"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 9
            spacing: 10
            Rectangle { width: 10; height: 10; radius: 5; color: "#63E2A6" }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                Text {
                    text: root.rtl ? "حالة تكامل البيانات" : "DATA INTEGRATION"
                    color: "#96A5AB"
                    font.family: Theme.uiFont(root.rtl)
                    font.pixelSize: 9
                    font.bold: true
                }
                Text {
                    text: "ADS-B " + root.publicTracks.length + "   AEGIS " + root.aegisTracks.length + "   BASES " + root.bases.length
                    color: "#EDF2F3"
                    font.family: Theme.mono
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }
    }
}
