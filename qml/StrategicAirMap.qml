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
    property bool showTrackRoster: true
    property bool showTitleOverlay: true
    property bool showDataBadge: true
    property bool showBaseLabels: true
    property bool showRadar: true
    property real sweepAngle: 0

    color: "#02080D"
    border.color: Theme.border
    border.width: 1
    radius: Theme.radius
    clip: true

    function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)) }
    function xFor(lon) { return clamp((Number(lon) - 20.0) / 45.0, 0.035, 0.965) * width }
    function yFor(lat) { return clamp(1.0 - ((Number(lat) - 18.0) / 25.0), 0.045, 0.955) * height }
    function threatColor(level) {
        var t = String(level || "").toUpperCase()
        if (t === "CRITICAL" || t === "HIGH") return Theme.red
        if (t === "MEDIUM") return Theme.amber
        return Theme.radarGreen
    }
    function baseX(index) {
        var xs = [0.37, 0.46, 0.59, 0.68, 0.54, 0.30]
        return width * xs[index % xs.length]
    }
    function baseY(index) {
        var ys = [0.60, 0.45, 0.64, 0.48, 0.74, 0.69]
        return height * ys[index % ys.length]
    }

    NumberAnimation on sweepAngle {
        from: 0
        to: 360
        duration: 7200
        loops: Animation.Infinite
        running: root.visible && root.showRadar
    }
    onSweepAngleChanged: mapCanvas.requestPaint()

    Canvas {
        id: mapCanvas
        anchors.fill: parent
        antialiasing: true

        function drawLandRegion(c, points, fill, stroke, w, h) {
            c.beginPath()
            c.moveTo(points[0][0] * w, points[0][1] * h)
            for (var i = 1; i < points.length; ++i)
                c.lineTo(points[i][0] * w, points[i][1] * h)
            c.closePath()
            c.fillStyle = fill
            c.strokeStyle = stroke
            c.fill()
            c.stroke()
        }

        onPaint: {
            var c = getContext("2d")
            c.reset()
            var w = width
            var h = height

            var sea = c.createLinearGradient(0, 0, 0, h)
            sea.addColorStop(0, "#04101A")
            sea.addColorStop(.54, "#020A10")
            sea.addColorStop(1, "#000407")
            c.fillStyle = sea
            c.fillRect(0, 0, w, h)

            c.strokeStyle = "#17323E"
            c.lineWidth = 1
            c.globalAlpha = .62
            for (var gx = 1; gx < 13; ++gx) {
                var px = w * gx / 13
                c.beginPath(); c.moveTo(px, 0); c.lineTo(px, h); c.stroke()
            }
            for (var gy = 1; gy < 9; ++gy) {
                var py = h * gy / 9
                c.beginPath(); c.moveTo(0, py); c.lineTo(w, py); c.stroke()
            }
            c.globalAlpha = 1

            c.lineWidth = 1.25
            drawLandRegion(c, [
                [0,.34],[.10,.31],[.18,.33],[.25,.37],[.31,.42],[.38,.45],
                [.44,.41],[.48,.46],[.505,.61],[.545,.94],[0,.94]
            ], "#0B202A", "#527383", w, h)
            drawLandRegion(c, [
                [.48,.46],[.55,.42],[.62,.38],[.69,.34],[.77,.32],[.84,.37],
                [.90,.42],[.99,.47],[.99,.94],[.545,.94],[.505,.61]
            ], "#0D2430", "#527383", w, h)

            c.fillStyle = "#021017"
            c.beginPath()
            c.moveTo(w*.498,h*.51); c.lineTo(w*.526,h*.55); c.lineTo(w*.575,h*.97)
            c.lineTo(w*.542,h*.97); c.closePath(); c.fill()
            c.strokeStyle = "#315664"
            c.stroke()

            c.strokeStyle = "#264A59"
            c.globalAlpha = .72
            c.lineWidth = 1
            var borders = [
                [[.11,.42],[.22,.47],[.29,.61],[.32,.91]],
                [[.32,.42],[.40,.53],[.43,.92]],
                [[.58,.42],[.61,.60],[.67,.93]],
                [[.70,.36],[.73,.55],[.79,.92]],
                [[.84,.38],[.82,.61],[.88,.92]]
            ]
            for (var bi=0; bi<borders.length; ++bi) {
                var b=borders[bi]
                c.beginPath(); c.moveTo(w*b[0][0],h*b[0][1])
                for (var bj=1; bj<b.length; ++bj) c.lineTo(w*b[bj][0],h*b[bj][1])
                c.stroke()
            }
            c.globalAlpha = 1

            var sectors = [
                {x:.265,y:.30,w:.18,h:.20,f:"rgba(212,175,55,.075)",s:Theme.royalGold,n:root.rtl?"قطاع C":"SECTOR C"},
                {x:.455,y:.31,w:.16,h:.20,f:"rgba(169,132,233,.075)",s:Theme.rfViolet,n:root.rtl?"قطاع D":"SECTOR D"},
                {x:.385,y:.54,w:.18,h:.21,f:"rgba(70,226,160,.070)",s:Theme.radarGreen,n:root.rtl?"منطقة طرفية":"TMA"},
                {x:.595,y:.49,w:.18,h:.18,f:"rgba(255,155,84,.070)",s:Theme.warmOrange,n:root.rtl?"منطقة تدريب":"TRAINING"}
            ]
            c.lineWidth = 1.2
            c.font = root.rtl ? "700 12px 'Noto Kufi Arabic'" : "700 12px 'Noto Sans'"
            for (var si=0; si<sectors.length; ++si) {
                var s=sectors[si]
                c.fillStyle=s.f; c.strokeStyle=s.s
                c.fillRect(w*s.x,h*s.y,w*s.w,h*s.h)
                c.strokeRect(w*s.x,h*s.y,w*s.w,h*s.h)
                c.fillStyle=s.s
                c.fillText(s.n,w*s.x+9,h*s.y+19)
            }

            c.lineWidth = 2.1
            c.setLineDash([11,8])
            c.strokeStyle = Theme.signalCyan
            c.beginPath()
            c.moveTo(w*.14,h*.48)
            c.bezierCurveTo(w*.29,h*.36,w*.46,h*.45,w*.69,h*.25)
            c.stroke()
            c.strokeStyle = Theme.royalGold
            c.beginPath()
            c.moveTo(w*.31,h*.80)
            c.bezierCurveTo(w*.44,h*.60,w*.58,h*.58,w*.77,h*.72)
            c.stroke()
            c.setLineDash([])

            if (root.showRadar) {
                var rx=w*.485
                var ry=h*.565
                var rr=Math.min(w,h)*.40
                c.strokeStyle=Theme.radarGreen
                c.lineWidth=1
                c.globalAlpha=.24
                for (var ring=1; ring<=4; ++ring) {
                    c.beginPath(); c.arc(rx,ry,rr*ring/4,0,Math.PI*2); c.stroke()
                }
                for (var deg=0; deg<360; deg+=30) {
                    var rad=deg*Math.PI/180
                    c.beginPath(); c.moveTo(rx,ry)
                    c.lineTo(rx+Math.cos(rad)*rr,ry+Math.sin(rad)*rr); c.stroke()
                }
                var ang=(root.sweepAngle-90)*Math.PI/180
                var sweepGradient=c.createRadialGradient(rx,ry,0,rx,ry,rr)
                sweepGradient.addColorStop(0,"rgba(70,226,160,.02)")
                sweepGradient.addColorStop(1,"rgba(70,226,160,.18)")
                c.fillStyle=sweepGradient
                c.globalAlpha=.72
                c.beginPath(); c.moveTo(rx,ry)
                c.arc(rx,ry,rr,ang-.42,ang)
                c.closePath(); c.fill()
                c.strokeStyle=Theme.radarGreen
                c.lineWidth=1.5
                c.globalAlpha=.74
                c.beginPath(); c.moveTo(rx,ry)
                c.lineTo(rx+Math.cos(ang)*rr,ry+Math.sin(ang)*rr); c.stroke()
                c.fillStyle=Theme.radarGreen
                c.beginPath(); c.arc(rx,ry,3.5,0,Math.PI*2); c.fill()
                c.globalAlpha=1
            }

            c.fillStyle = Theme.silver
            c.font = root.rtl ? "700 13px 'Noto Kufi Arabic'" : "700 13px 'Noto Sans'"
            c.fillText(root.rtl ? "البحر المتوسط" : "MEDITERRANEAN", w*.14, h*.20)
            c.fillText(root.rtl ? "مصر" : "EGYPT", w*.25, h*.66)
            c.fillText(root.rtl ? "سيناء" : "SINAI", w*.47, h*.57)
            c.fillText(root.rtl ? "شرق المتوسط" : "LEVANT", w*.61, h*.28)
            c.fillText(root.rtl ? "السعودية" : "SAUDI ARABIA", w*.69, h*.72)
            c.fillText(root.rtl ? "البحر الأحمر" : "RED SEA", w*.535, h*.84)

            var nx=w*.925, ny=h*.12, nr=28
            c.strokeStyle=Theme.metallicSilver
            c.lineWidth=1.2
            c.globalAlpha=.78
            c.beginPath(); c.arc(nx,ny,nr,0,Math.PI*2); c.stroke()
            c.beginPath(); c.moveTo(nx,ny-nr); c.lineTo(nx,ny+nr); c.stroke()
            c.beginPath(); c.moveTo(nx-nr,ny); c.lineTo(nx+nr,ny); c.stroke()
            c.globalAlpha=1
            c.fillStyle=Theme.platinum
            c.font="700 11px 'Noto Sans Mono'"
            c.textAlign="center"
            c.fillText("N",nx,ny-nr-7)
            c.textAlign="left"
        }

        Connections {
            target: cockpit
            function onDataChanged() { mapCanvas.requestPaint() }
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    Repeater {
        model: root.publicTracks
        delegate: Item {
            required property int index
            required property var modelData
            width: 1
            height: 1
            x: root.xFor(modelData.longitude)
            y: root.yFor(modelData.latitude)
            z: 4

            Item {
                id: publicGlyph
                width: 38
                height: 38
                x: -19
                y: -19
                rotation: Number(modelData.headingDegrees || 0)

                Repeater {
                    model: 4
                    Rectangle {
                        required property int index
                        width: 3
                        height: 3
                        radius: 2
                        x: 17.5
                        y: 37 + index * 7
                        color: Theme.signalCyan
                        opacity: .48 - index * .08
                    }
                }

                Canvas {
                    anchors.fill: parent
                    antialiasing: true
                    onPaint: {
                        var c=getContext("2d")
                        c.reset()
                        c.fillStyle=Theme.signalCyan
                        c.strokeStyle=Theme.platinum
                        c.lineWidth=1
                        c.beginPath()
                        c.moveTo(width*.50,height*.04)
                        c.lineTo(width*.58,height*.39)
                        c.lineTo(width*.91,height*.60)
                        c.lineTo(width*.88,height*.69)
                        c.lineTo(width*.58,height*.57)
                        c.lineTo(width*.57,height*.82)
                        c.lineTo(width*.70,height*.92)
                        c.lineTo(width*.66,height*.98)
                        c.lineTo(width*.50,height*.89)
                        c.lineTo(width*.34,height*.98)
                        c.lineTo(width*.30,height*.92)
                        c.lineTo(width*.43,height*.82)
                        c.lineTo(width*.42,height*.57)
                        c.lineTo(width*.12,height*.69)
                        c.lineTo(width*.09,height*.60)
                        c.lineTo(width*.42,height*.39)
                        c.closePath()
                        c.fill(); c.stroke()
                    }
                }
            }

            MouseArea { id: pma; x: -23; y: -23; width: 46; height: 46; hoverEnabled: true }
            ToolTip.visible: pma.containsMouse
            ToolTip.text: (modelData.callsign || modelData.icao24 || "AIRCRAFT") + "\n" +
                          Math.round(Number(modelData.altitudeMeters || 0)) + " m"
        }
    }

    Repeater {
        model: root.aegisTracks
        delegate: Item {
            required property int index
            required property var modelData
            width: 1
            height: 1
            x: root.xFor(modelData.longitude)
            y: root.yFor(modelData.latitude)
            z: 5

            Item {
                width: 42
                height: 42
                x: -21
                y: -21
                rotation: Number(modelData.headingDegrees || 0)

                Repeater {
                    model: 4
                    Rectangle {
                        required property int index
                        width: 4
                        height: 4
                        radius: 2
                        x: 19
                        y: 39 + index * 8
                        color: root.threatColor(modelData.threatLevel)
                        opacity: .56 - index * .09
                    }
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    rotation: 45
                    color: "#12000000"
                    border.color: root.threatColor(modelData.threatLevel)
                    border.width: 2
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 5
                    height: 5
                    radius: 3
                    color: root.threatColor(modelData.threatLevel)
                }
            }

            MouseArea { id: ama; x: -24; y: -24; width: 48; height: 48; hoverEnabled: true }
            ToolTip.visible: ama.containsMouse
            ToolTip.text: (modelData.trackId || "TRACK") + " • " +
                          (modelData.classification || "UNKNOWN") + " • " +
                          (modelData.threatLevel || "REVIEW")
        }
    }

    Repeater {
        model: root.bases
        delegate: Item {
            required property int index
            required property var modelData
            width: root.showBaseLabels ? 176 : 28
            height: root.showBaseLabels ? 48 : 28
            x: root.baseX(index) - 14
            y: root.baseY(index) - 14
            z: 3

            Rectangle {
                width: 28
                height: 28
                radius: 14
                color: Theme.shell
                border.color: Number(modelData.supportPercent) >= 90 ? Theme.radarGreen : Theme.amber
                border.width: 2
                Text {
                    anchors.centerIn: parent
                    text: "✦"
                    color: parent.border.color
                    font.pixelSize: 13
                    font.bold: true
                }

                SequentialAnimation on opacity {
                    running: root.visible
                    loops: Animation.Infinite
                    NumberAnimation { to: .68; duration: 900 }
                    NumberAnimation { to: 1; duration: 900 }
                }
            }

            Rectangle {
                visible: root.showBaseLabels
                x: 36
                y: -3
                width: 136
                height: 46
                radius: 5
                color: "#EB07131A"
                border.color: Number(modelData.supportPercent) >= 90 ? "#397A62" : "#86682D"
                border.width: 1
                Column {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 1
                    Text {
                        text: modelData.name || "AIRFIELD"
                        color: Theme.platinum
                        font.family: Theme.uiFont(root.rtl)
                        font.pixelSize: Theme.smallPx
                        font.bold: true
                        width: parent.width
                        elide: Text.ElideRight
                    }
                    Text {
                        text: (modelData.runway || "RWY") + "  •  " + Number(modelData.supportPercent || 0) + "%"
                        color: Number(modelData.supportPercent) >= 90 ? Theme.radarGreen : Theme.amber
                        font.family: Theme.mono
                        font.pixelSize: Theme.smallPx
                        width: parent.width
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    Column {
        visible: root.showTrackRoster
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 14
        anchors.topMargin: root.showTitleOverlay ? 108 : 14
        spacing: 5
        z: 8

        Repeater {
            model: root.publicTracks
            delegate: Rectangle {
                required property int index
                required property var modelData
                visible: index < 4
                width: 192
                height: 42
                color: "#EB07131A"
                border.color: Theme.signalCyan
                border.width: 1
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 7
                    Rectangle { width: 8; height: 8; radius: 4; color: Theme.signalCyan }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text { text: modelData.callsign || modelData.icao24 || "PUBLIC TRACK"; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: Math.round(Number(modelData.altitudeMeters || 0)) + " M  /  ADS-B"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }
            }
        }
    }

    Column {
        visible: root.showTrackRoster
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 14
        anchors.topMargin: root.showTitleOverlay ? 108 : 14
        spacing: 5
        z: 8

        Repeater {
            model: root.aegisTracks
            delegate: Rectangle {
                required property int index
                required property var modelData
                visible: index < 4
                width: 208
                height: 42
                color: "#EB07131A"
                border.color: root.threatColor(modelData.threatLevel)
                border.width: 1
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 8
                    Rectangle { width: 10; height: 10; rotation: 45; color: Theme.panel3; border.color: root.threatColor(modelData.threatLevel); border.width: 2 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text { text: (modelData.trackId || "TRACK") + "  /  " + (modelData.classification || "UNKNOWN"); color: root.threatColor(modelData.threatLevel); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: Math.round(Number(modelData.altitudeMeters || 0)) + " M  •  " + Math.round(Number(modelData.confidence || 0) * 100) + "%"; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                    }
                }
            }
        }
    }

    Rectangle {
        visible: root.showTitleOverlay
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 14
        width: Math.min(500, parent.width * .44)
        height: 88
        radius: 6
        color: "#EB050D13"
        border.color: Theme.border
        border.width: 1
        z: 9

        RowLayout {
            anchors.fill: parent
            anchors.margins: 11
            spacing: 10
            layoutDirection: root.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Rectangle { width: 4; Layout.fillHeight: true; radius: 2; color: Theme.royalGold }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    text: root.rtl ? "الصورة الجوية المشتركة" : root.modeLabel
                    color: Theme.platinum
                    font.family: Theme.uiFont(root.rtl)
                    font.pixelSize: Theme.sectionPx
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    text: root.rtl ? "ADS-B عام • AEGIS • قواعد ومطارات" : "PUBLIC ADS-B • AEGIS • BASES & AIRFIELDS"
                    color: Theme.royalGold
                    font.family: Theme.uiFont(root.rtl)
                    font.pixelSize: Theme.smallPx
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    text: root.rtl ? "وعي جوي تدريبي — ليس للملاحة" : "TRAINING AWARENESS — NOT FOR NAVIGATION"
                    color: Theme.silver
                    font.family: Theme.uiFont(root.rtl)
                    font.pixelSize: Theme.smallPx
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
        }
    }

    Rectangle {
        visible: root.showDataBadge
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 14
        width: 330
        height: 62
        radius: 6
        color: "#EB050D13"
        border.color: Theme.border
        border.width: 1
        z: 9

        RowLayout {
            anchors.fill: parent
            anchors.margins: 9
            spacing: 10
            layoutDirection: root.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Item {
                width: 38
                height: 38
                Rectangle {
                    anchors.centerIn: parent
                    width: 30
                    height: 30
                    radius: 15
                    color: "transparent"
                    border.color: Theme.radarGreen
                    border.width: 1
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 4
                    height: 4
                    radius: 2
                    color: Theme.radarGreen
                }
                Rectangle {
                    width: 1
                    height: 15
                    color: Theme.radarGreen
                    anchors.bottom: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    transformOrigin: Item.Bottom
                    rotation: root.sweepAngle
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                Text {
                    text: root.rtl ? "تكامل البيانات / مسح الرادار" : "DATA FUSION / RADAR SWEEP"
                    color: Theme.silver
                    font.family: Theme.uiFont(root.rtl)
                    font.pixelSize: Theme.smallPx
                    font.bold: true
                }
                Text {
                    text: "ADS-B " + root.publicTracks.length + "   AEGIS " + root.aegisTracks.length + "   BASES " + root.bases.length
                    color: Theme.platinum
                    font.family: Theme.mono
                    font.pixelSize: Theme.smallPx
                    font.bold: true
                }
            }
            Rectangle { width: 8; height: 8; radius: 4; color: Theme.radarGreen }
        }
    }
}
