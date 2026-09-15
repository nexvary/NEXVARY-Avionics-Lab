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
    property bool showWeather: true
    property bool showAirspace: true
    property bool showRoutes: true
    property real sweepAngle: 0
    property string selectedPublicTrackId: ""
    property var selectedPublicTrack: ({})
    property int publicLodStride: publicTracks.length > 1000 ? 4 : (publicTracks.length > 400 ? 2 : 1)
    property bool showSelectedPublicPopup: true
    signal publicTrackSelected(var track)
    signal aircraftDetailsRequested(var track)

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
    function trackId(track) { return String(track && track.icao24 ? track.icao24 : "").toLowerCase() }
    function available(value) { return value !== undefined && value !== null && String(value).trim() !== "" }
    function textOr(value, fallback) { return available(value) ? String(value) : fallback }
    function numberOrNa(value, decimals, suffix) {
        return available(value) && !isNaN(Number(value)) ? Number(value).toFixed(decimals) + suffix : "N/A"
    }
    function popupTopFor(pointY, popupHeight) {
        var safeTop = 14
        var safeBottom = height - 78
        var candidate = pointY + 22
        if (candidate + popupHeight > safeBottom)
            candidate = pointY - popupHeight - 24
        return clamp(candidate, safeTop, Math.max(safeTop, safeBottom - popupHeight))
    }
    function selectPublicTrack(track, requestDetails) {
        selectedPublicTrackId = trackId(track)
        selectedPublicTrack = track
        publicTrackSelected(track)
        if (requestDetails) aircraftDetailsRequested(track)
    }
    onPublicTracksChanged: {
        if (selectedPublicTrackId === "" && publicTracks.length > 0) {
            selectedPublicTrackId = trackId(publicTracks[0])
            selectedPublicTrack = publicTracks[0]
            return
        }
        for (var i = 0; i < publicTracks.length; ++i) {
            if (trackId(publicTracks[i]) === selectedPublicTrackId) {
                selectedPublicTrack = publicTracks[i]
                return
            }
        }
        selectedPublicTrackId = ""
        selectedPublicTrack = ({})
    }

    NumberAnimation on sweepAngle {
        from: 0
        to: 360
        duration: 7200
        loops: Animation.Infinite
        running: root.visible && root.showRadar
    }
    onSweepAngleChanged: mapCanvas.requestPaint()
    onShowWeatherChanged: mapCanvas.requestPaint()
    onShowAirspaceChanged: mapCanvas.requestPaint()
    onShowRoutesChanged: mapCanvas.requestPaint()

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
            c.globalAlpha = root.showAirspace ? 1 : 0
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
            c.globalAlpha = 1

            c.globalAlpha = root.showRoutes ? 1 : 0
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
            c.globalAlpha = 1

            if (root.showWeather) {
                var weatherCells = [
                    {x:.21,y:.25,t:"18°C",wind:"NW 16 KT",color:Theme.skyBlue},
                    {x:.61,y:.19,t:"21°C",wind:"W 09 KT",color:Theme.radarGreen},
                    {x:.77,y:.58,t:"31°C",wind:"SE 22 KT",color:Theme.amber}
                ]
                c.textAlign = "center"
                for (var wi = 0; wi < weatherCells.length; ++wi) {
                    var wc = weatherCells[wi]
                    var wx = w * wc.x
                    var wy = h * wc.y
                    c.fillStyle = "#D9050D13"
                    c.strokeStyle = wc.color
                    c.lineWidth = 1
                    c.fillRect(wx - 42, wy - 19, 84, 38)
                    c.strokeRect(wx - 42, wy - 19, 84, 38)
                    c.fillStyle = wc.color
                    c.font = "700 11px 'Noto Sans Mono'"
                    c.fillText(wc.t, wx, wy - 3)
                    c.fillStyle = Theme.silver
                    c.font = "10px 'Noto Sans Mono'"
                    c.fillText(wc.wind, wx, wy + 12)
                }
                c.textAlign = "left"
            }

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
            id: publicPoint
            required property int index
            required property var modelData
            property string identity: root.trackId(modelData)
            property bool selected: identity !== "" && (identity === root.selectedPublicTrackId || (root.selectedPublicTrackId === "" && index === 0))
            width: 1
            height: 1
            x: root.xFor(modelData.longitude)
            y: root.yFor(modelData.latitude)
            z: 4
            visible: selected || index % root.publicLodStride === 0

            Item {
                id: publicGlyph
                width: publicPoint.selected ? 28 : 24
                height: width
                x: -width / 2
                y: -height / 2
                rotation: Number(modelData.headingDegrees || 0)

                Repeater {
                    model: publicPoint.selected ? 5 : 3
                    Rectangle {
                        required property int index
                        width: 2.5
                        height: 2.5
                        radius: 2
                        x: publicGlyph.width / 2 - 1.25
                        y: publicGlyph.height + 4 + index * 6
                        color: publicPoint.selected ? Theme.royalGold : Theme.signalCyan
                        opacity: .55 - index * .07
                    }
                }

                Rectangle {
                    visible: publicPoint.selected
                    anchors.centerIn: parent
                    width: 38; height: 38; radius: 19
                    color: "transparent"; border.color: Theme.royalGold; border.width: 1
                    opacity: .72
                    SequentialAnimation on opacity {
                        running: publicPoint.selected && root.visible
                        loops: Animation.Infinite
                        NumberAnimation { to: .26; duration: 850 }
                        NumberAnimation { to: .72; duration: 850 }
                    }
                }

                Canvas {
                    property bool activeSelection: publicPoint.selected
                    anchors.fill: parent
                    antialiasing: true
                    onActiveSelectionChanged: requestPaint()
                    onPaint: {
                        var c=getContext("2d")
                        c.reset()
                        c.fillStyle=publicPoint.selected ? Theme.royalGold : Theme.signalCyan
                        c.strokeStyle=publicPoint.selected ? Theme.platinum : "#D8F4FF"
                        c.lineWidth=publicPoint.selected ? 1.4 : 1
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

            MouseArea {
                id: pma
                x: -18; y: -18; width: 36; height: 36
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.selectPublicTrack(modelData, false)
                onDoubleClicked: root.selectPublicTrack(modelData, true)
            }

            Rectangle {
                id: trackPopup
                objectName: "publicAircraftPopup_" + publicPoint.index
                visible: pma.containsMouse || (publicPoint.selected && root.showSelectedPublicPopup)
                x: publicPoint.x < 540 ? root.width - publicPoint.x - 330 : (publicPoint.x > root.width - 350 ? -330 : 20)
                y: root.popupTopFor(publicPoint.y, height) - publicPoint.y
                width: 316
                height: 288
                radius: Theme.radius
                color: "#F2080808"
                border.color: publicPoint.selected ? Theme.royalGold : Theme.signalCyan
                border.width: publicPoint.selected ? Theme.activeFrameWidth : 1
                z: 30

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        layoutDirection: root.rtl ? Qt.RightToLeft : Qt.LeftToRight
                        Rectangle { width: 4; Layout.preferredHeight: 34; radius: 2; color: publicPoint.selected ? Theme.royalGold : Theme.signalCyan }
                        ColumnLayout {
                            Layout.fillWidth: true; spacing: 0
                            Text { text: root.textOr(modelData.callsign, root.textOr(modelData.icao24, "AIRCRAFT")); color: Theme.platinum; font.family: Theme.mono; font.pixelSize: 16; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: root.textOr(modelData.aircraftModel, root.textOr(modelData.aircraftTypeCode, "TYPE N/A")); color: Theme.signalCyan; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                        Text { text: root.textOr(modelData.registration, "N/A"); color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2; columnSpacing: 10; rowSpacing: 3
                        Text { text: root.rtl ? "الرحلة" : "FLIGHT"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: root.textOr(modelData.flightNumber, "N/A"); color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        Text { text: "ICAO / HEX"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                        Text { text: root.textOr(modelData.icao24, "N/A").toUpperCase(); color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        Text { text: root.rtl ? "النوع" : "TYPE"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: root.textOr(modelData.aircraftTypeCode, "N/A"); color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        Text { text: root.rtl ? "الارتفاع" : "ALTITUDE"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: root.numberOrNa(modelData.altitudeMeters, 0, " m"); color: Theme.skyBlue; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        Text { text: root.rtl ? "السرعة" : "SPEED"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: root.numberOrNa(modelData.velocityMetersPerSecond, 1, " m/s"); color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        Text { text: root.rtl ? "الاتجاه" : "TRACK"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: root.numberOrNa(modelData.headingDegrees, 0, "°"); color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        Text { text: root.rtl ? "الصعود/الهبوط" : "VERT RATE"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: root.numberOrNa(modelData.verticalRateMetersPerSecond, 1, " m/s"); color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        Text { text: "SQUAWK / AGE"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                        Text { text: root.textOr(modelData.squawk, "N/A") + " / " + root.numberOrNa(modelData.dataAgeSeconds, 0, "s"); color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                        Text { text: root.rtl ? "المصدر" : "SOURCE"; color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx }
                        Text { text: root.textOr(modelData.telemetrySource, "PUBLIC ADS-B"); color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight; elide: Text.ElideRight }
                    }
                    Item { Layout.fillHeight: true }
                    Button {
                        Layout.fillWidth: true; Layout.preferredHeight: 32
                        text: root.rtl ? "فتح تفاصيل الطائرة" : "OPEN AIRCRAFT DETAILS"
                        onClicked: root.selectPublicTrack(modelData, true)
                        contentItem: Text { text: parent.text; color: Theme.deepBlack; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        background: Rectangle { color: Theme.royalGold; radius: Theme.radius }
                    }
                }
            }
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
        objectName: "airMapDataBadge"
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

    Rectangle {
        objectName: "airMapLayerToolbar"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 14
        width: 478
        height: 50
        color: "#EB050D13"
        border.color: Theme.border
        border.width: 1
        radius: 6
        z: 10

        RowLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 5
            layoutDirection: root.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Repeater {
                model: [
                    {label:root.rtl ? "رادار" : "RADAR", active:root.showRadar, color:Theme.radarGreen, index:0},
                    {label:root.rtl ? "طقس" : "WEATHER", active:root.showWeather, color:Theme.skyBlue, index:1},
                    {label:root.rtl ? "قطاعات" : "AIRSPACE", active:root.showAirspace, color:Theme.rfViolet, index:2},
                    {label:root.rtl ? "مسارات" : "ROUTES", active:root.showRoutes, color:Theme.royalGold, index:3}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: modelData.active ? Theme.panel3 : Theme.panel2
                    border.color: modelData.active ? modelData.color : Theme.borderSoft
                    border.width: modelData.active ? Theme.activeFrameWidth : Theme.frameWidth
                    radius: 5
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 5
                        Rectangle { width: 7; height: 7; radius: 4; color: modelData.active ? modelData.color : Theme.muted }
                        Text { text: modelData.label; color: modelData.active ? Theme.platinum : Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.index === 0) root.showRadar = !root.showRadar
                            else if (modelData.index === 1) root.showWeather = !root.showWeather
                            else if (modelData.index === 2) root.showAirspace = !root.showAirspace
                            else root.showRoutes = !root.showRoutes
                        }
                    }
                }
            }
        }
    }
}
