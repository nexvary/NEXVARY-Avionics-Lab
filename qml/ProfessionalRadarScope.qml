import QtQuick
import QtQuick.Controls
import "Theme.js" as Theme

Item {
    id: root
    objectName: "cuasTacticalPlot"

    property var tracks: []
    property bool rtl: false
    property bool classificationMode: false
    property real rangeKm: 25
    property string sourceText: "AEGIS / PASSIVE"
    property int selectedTrackIndex: 0
    property real sweepAngle: -Math.PI / 2
    readonly property real centerLatitude: 30.0500
    readonly property real centerLongitude: 31.2350

    function threatColor(level) {
        var value = String(level || "").toUpperCase()
        if (value === "CRITICAL" || value === "HIGH") return Theme.warmOrange
        if (value === "MEDIUM") return Theme.royalGold
        if (value === "LOW") return Theme.signalCyan
        return Theme.radarGreen
    }

    function trackPoint(track, plotWidth, plotHeight) {
        var cx = plotWidth * .48
        var cy = plotHeight * .53
        var radius = Math.max(40, Math.min(plotWidth * .40, plotHeight * .42))
        var latitude = Number(track.latitude)
        var longitude = Number(track.longitude)
        var dxKm = (longitude - centerLongitude) * 96.4
        var dyKm = (latitude - centerLatitude) * 111.0
        var distanceKm = Math.sqrt(dxKm * dxKm + dyKm * dyKm)
        if (!isFinite(distanceKm) || distanceKm < .08) {
            var fallbackHeading = Number(track.headingDegrees || 0) * Math.PI / 180
            distanceKm = rangeKm * .34
            dxKm = Math.sin(fallbackHeading) * distanceKm
            dyKm = Math.cos(fallbackHeading) * distanceKm
        }
        var scale = radius / rangeKm
        return {
            x: cx + dxKm * scale,
            y: cy - dyKm * scale,
            cx: cx,
            cy: cy,
            radius: radius,
            distanceKm: distanceKm,
            bearing: (Math.atan2(dxKm, dyKm) * 180 / Math.PI + 360) % 360
        }
    }

    function selectedTrack() {
        if (!tracks || tracks.length === 0) return null
        return tracks[Math.max(0, Math.min(selectedTrackIndex, tracks.length - 1))]
    }

    NumberAnimation on sweepAngle {
        from: -Math.PI / 2
        to: Math.PI * 1.5
        duration: 5600
        loops: Animation.Infinite
        running: root.visible
    }

    onTracksChanged: {
        if (selectedTrackIndex >= tracks.length) selectedTrackIndex = Math.max(0, tracks.length - 1)
        scope.requestPaint()
    }
    onSelectedTrackIndexChanged: scope.requestPaint()
    onClassificationModeChanged: scope.requestPaint()
    onSweepAngleChanged: scope.requestPaint()
    onWidthChanged: scope.requestPaint()
    onHeightChanged: scope.requestPaint()

    Canvas {
        id: scope
        anchors.fill: parent
        antialiasing: true

        function drawTrackSymbol(c, classification, x, y, heading, color, selected) {
            var kind = String(classification || "UNKNOWN").toUpperCase()
            c.save()
            c.translate(x, y)
            c.rotate(heading * Math.PI / 180)
            c.strokeStyle = selected ? Theme.platinum : color
            c.fillStyle = selected ? color : "#E6081010"
            c.lineWidth = selected ? 2.4 : 1.7
            c.beginPath()
            if (kind.indexOf("DRONE") >= 0 || kind.indexOf("UAV") >= 0) {
                c.moveTo(0, -10); c.lineTo(8, 8); c.lineTo(0, 4); c.lineTo(-8, 8); c.closePath()
            } else if (kind.indexOf("AIRCRAFT") >= 0) {
                c.moveTo(0, -11); c.lineTo(5, -1); c.lineTo(10, 3)
                c.lineTo(3, 2); c.lineTo(2, 9); c.lineTo(0, 6)
                c.lineTo(-2, 9); c.lineTo(-3, 2); c.lineTo(-10, 3)
                c.lineTo(-5, -1); c.closePath()
            } else if (kind.indexOf("BIRD") >= 0) {
                c.arc(0, 0, 6, 0, Math.PI * 2)
                c.moveTo(-10, 0); c.quadraticCurveTo(-5, -5, 0, 0)
                c.quadraticCurveTo(5, -5, 10, 0)
            } else {
                c.moveTo(0, -9); c.lineTo(9, 0); c.lineTo(0, 9); c.lineTo(-9, 0); c.closePath()
            }
            c.fill()
            c.stroke()
            c.restore()
        }

        onPaint: {
            var c = getContext("2d")
            c.reset()
            var w = width
            var h = height
            if (w < 20 || h < 20) return
            var cx = w * .48
            var cy = h * .53
            var radius = Math.max(40, Math.min(w * .40, h * .42))

            c.fillStyle = "#030707"
            c.fillRect(0, 0, w, h)
            var glow = c.createRadialGradient(cx, cy, 0, cx, cy, radius * 1.05)
            glow.addColorStop(0, "rgba(20,54,43,.34)")
            glow.addColorStop(.72, "rgba(5,20,17,.18)")
            glow.addColorStop(1, "rgba(0,0,0,0)")
            c.fillStyle = glow
            c.beginPath(); c.arc(cx, cy, radius * 1.05, 0, Math.PI * 2); c.fill()

            // Alternating azimuth sectors give the PPI depth without visual noise.
            for (var sector = 0; sector < 12; ++sector) {
                if (sector % 2 !== 0) continue
                var sectorStart = (sector * 30 - 90) * Math.PI / 180
                c.fillStyle = "rgba(70,226,160,.018)"
                c.beginPath(); c.moveTo(cx, cy)
                c.arc(cx, cy, radius, sectorStart, sectorStart + Math.PI / 6)
                c.closePath(); c.fill()
            }

            c.strokeStyle = "#1D624A"
            c.lineWidth = 1
            for (var ring = 1; ring <= 5; ++ring) {
                c.globalAlpha = ring === 5 ? .78 : .42
                c.beginPath(); c.arc(cx, cy, radius * ring / 5, 0, Math.PI * 2); c.stroke()
            }

            for (var bearing = 0; bearing < 360; bearing += 15) {
                var radial = (bearing - 90) * Math.PI / 180
                c.globalAlpha = bearing % 30 === 0 ? .38 : .16
                c.beginPath(); c.moveTo(cx, cy)
                c.lineTo(cx + Math.cos(radial) * radius, cy + Math.sin(radial) * radius); c.stroke()
            }

            // Precision bezel: five-degree ticks, labelled every thirty degrees.
            c.strokeStyle = bearingColor
            for (var tick = 0; tick < 360; tick += 5) {
                var tickAngle = (tick - 90) * Math.PI / 180
                var major = tick % 30 === 0
                var tickInner = radius * (major ? .94 : .978)
                c.globalAlpha = major ? .92 : .43
                c.lineWidth = major ? 1.5 : 1
                c.beginPath()
                c.moveTo(cx + Math.cos(tickAngle) * tickInner, cy + Math.sin(tickAngle) * tickInner)
                c.lineTo(cx + Math.cos(tickAngle) * radius, cy + Math.sin(tickAngle) * radius)
                c.stroke()
            }

            c.globalAlpha = .94
            c.fillStyle = Theme.metallicSilver
            c.font = "700 11px 'Noto Sans Mono'"
            c.textAlign = "center"
            c.textBaseline = "middle"
            for (var labelBearing = 0; labelBearing < 360; labelBearing += 30) {
                var labelAngle = (labelBearing - 90) * Math.PI / 180
                var labelRadius = radius + 18
                c.fillText(("00" + labelBearing).slice(-3),
                           cx + Math.cos(labelAngle) * labelRadius,
                           cy + Math.sin(labelAngle) * labelRadius)
            }

            c.textAlign = "left"
            c.fillStyle = Theme.muted
            c.font = "10px 'Noto Sans Mono'"
            for (var rangeRing = 1; rangeRing <= 5; ++rangeRing) {
                c.fillText(Math.round(rangeKm * rangeRing / 5) + " KM",
                           cx + 5, cy - radius * rangeRing / 5 + 12)
            }

            // Protected training geofence and monitored approach sector.
            c.setLineDash([7, 5])
            c.strokeStyle = Theme.royalGold
            c.globalAlpha = .70
            c.lineWidth = 1.3
            c.beginPath(); c.arc(cx, cy, radius * .46, 0, Math.PI * 2); c.stroke()
            c.setLineDash([])
            c.fillStyle = "rgba(212,175,55,.045)"
            c.beginPath(); c.moveTo(cx, cy)
            c.arc(cx, cy, radius * .82, -.78, -.18); c.closePath(); c.fill()

            // Multi-band phosphor afterglow.
            for (var band = 0; band < 7; ++band) {
                var tail = .12 + band * .075
                c.fillStyle = "rgba(70,226,160," + (.085 - band * .010) + ")"
                c.beginPath(); c.moveTo(cx, cy)
                c.arc(cx, cy, radius, root.sweepAngle - tail, root.sweepAngle - Math.max(0, tail - .09))
                c.closePath(); c.fill()
            }
            c.strokeStyle = Theme.radarGreen
            c.globalAlpha = .94
            c.lineWidth = 1.8
            c.beginPath(); c.moveTo(cx, cy)
            c.lineTo(cx + Math.cos(root.sweepAngle) * radius,
                     cy + Math.sin(root.sweepAngle) * radius); c.stroke()
            c.globalAlpha = 1
            c.fillStyle = Theme.radarGreen
            c.beginPath(); c.arc(cx, cy, 3.5, 0, Math.PI * 2); c.fill()

            for (var i = 0; i < root.tracks.length; ++i) {
                var track = root.tracks[i]
                var point = root.trackPoint(track, w, h)
                var tx = point.x
                var ty = point.y
                var heading = Number(track.headingDegrees || 0)
                var velocity = Number(track.speedMetersPerSecond || 0)
                var direction = (heading - 90) * Math.PI / 180
                var color = root.threatColor(track.threatLevel)
                var selected = i === root.selectedTrackIndex

                // Time-faded history trail and predicted velocity vector.
                c.lineWidth = selected ? 2 : 1.2
                for (var trail = 7; trail >= 1; --trail) {
                    var trailDistance = 5 + trail * (3.2 + Math.min(velocity, 140) / 60)
                    var hx = tx - Math.cos(direction) * trailDistance
                    var hy = ty - Math.sin(direction) * trailDistance
                    c.globalAlpha = .12 + (7 - trail) * .075
                    c.fillStyle = color
                    c.beginPath(); c.arc(hx, hy, selected ? 2.2 : 1.7, 0, Math.PI * 2); c.fill()
                }
                c.globalAlpha = .74
                c.strokeStyle = color
                c.setLineDash([5, 4])
                c.beginPath(); c.moveTo(tx, ty)
                c.lineTo(tx + Math.cos(direction) * (20 + Math.min(velocity, 140) * .18),
                         ty + Math.sin(direction) * (20 + Math.min(velocity, 140) * .18)); c.stroke()
                c.setLineDash([])
                c.globalAlpha = 1

                if (selected) {
                    c.strokeStyle = Theme.royalGold
                    c.globalAlpha = .55
                    c.lineWidth = 1.5
                    c.beginPath(); c.arc(tx, ty, 17, 0, Math.PI * 2); c.stroke()
                    c.globalAlpha = 1
                }
                drawTrackSymbol(c, track.classification, tx, ty, heading, color, selected)

                var boxWidth = 178
                var boxHeight = 48
                var labelOnLeft = i % 2 === 1 || tx > cx + radius * .42
                var labelX = labelOnLeft ? tx - boxWidth - 18 : tx + 18
                var labelY = ty - boxHeight / 2 + (i - 1) * 5
                labelX = Math.max(7, Math.min(w - boxWidth - 7, labelX))
                labelY = Math.max(78, Math.min(h - boxHeight - 10, labelY))
                c.strokeStyle = selected ? Theme.royalGold : color
                c.lineWidth = selected ? 1.5 : 1
                c.globalAlpha = .72
                c.beginPath(); c.moveTo(tx, ty)
                c.lineTo(labelOnLeft ? labelX + boxWidth : labelX, labelY + boxHeight / 2); c.stroke()
                c.globalAlpha = 1
                c.fillStyle = "#F0060B0B"
                c.fillRect(labelX, labelY, boxWidth, boxHeight)
                c.strokeRect(labelX, labelY, boxWidth, boxHeight)
                c.textAlign = "left"
                c.textBaseline = "alphabetic"
                c.fillStyle = selected ? Theme.platinum : color
                c.font = "700 11px 'Noto Sans Mono'"
                c.fillText((selected ? "● " : "") + (track.trackId || "TRACK"), labelX + 7, labelY + 15)
                c.fillStyle = Theme.silver
                c.font = "10px 'Noto Sans Mono'"
                c.fillText((track.classification || "UNKNOWN").toUpperCase() +
                           "  C" + Math.round(Number(track.confidence || 0) * 100),
                           labelX + 7, labelY + 29)
                c.fillText("A" + Math.round(Number(track.altitudeMeters || 0)) +
                           "  S" + Math.round(velocity) + "  H" + Math.round(heading),
                           labelX + 7, labelY + 42)
            }

            c.globalAlpha = 1
            c.strokeStyle = Theme.royalGold
            c.lineWidth = 1.4
            c.beginPath(); c.arc(cx, cy, radius + 2, 0, Math.PI * 2); c.stroke()
            c.beginPath(); c.arc(cx, cy, radius + 7, 0, Math.PI * 2); c.stroke()
        }

        property color bearingColor: Theme.royalGold
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.CrossCursor
        onClicked: function(mouse) {
            var nearest = -1
            var nearestDistance = 28
            for (var i = 0; i < root.tracks.length; ++i) {
                var point = root.trackPoint(root.tracks[i], width, height)
                var distance = Math.sqrt(Math.pow(mouse.x - point.x, 2) + Math.pow(mouse.y - point.y, 2))
                if (distance < nearestDistance) {
                    nearest = i
                    nearestDistance = distance
                }
            }
            if (nearest >= 0) root.selectedTrackIndex = nearest
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 12
        width: 266
        height: 68
        color: "#EE070B0B"
        border.color: Theme.royalGold
        border.width: 1
        radius: 5
        Column {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2
            Text {
                text: root.classificationMode
                      ? (root.rtl ? "طبقة التصنيف والتحقق" : "CLASSIFICATION / VERIFICATION")
                      : (root.rtl ? "صورة الوعي الرادارية السلبية" : "PASSIVE RADAR AWARENESS PICTURE")
                color: Theme.platinum
                font.family: Theme.uiFont(root.rtl)
                font.pixelSize: Theme.secondaryPx
                font.bold: true
            }
            Text {
                text: "PPI 360°  •  " + root.rangeKm + " KM  •  " + root.sourceText
                color: Theme.radarGreen
                font.family: Theme.mono
                font.pixelSize: Theme.smallPx
                font.bold: true
            }
        }
    }

    Rectangle {
        visible: root.selectedTrack() !== null
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 12
        width: 335
        height: 68
        color: "#F0070B0B"
        border.color: Theme.royalGold
        border.width: 1
        radius: 5
        Row {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 10
            Rectangle {
                width: 6
                height: parent.height
                color: root.threatColor(root.selectedTrack() ? root.selectedTrack().threatLevel : "")
                radius: 3
            }
            Column {
                width: parent.width - 24
                spacing: 2
                Text {
                    text: (root.selectedTrack() ? root.selectedTrack().trackId : "") +
                          "  /  " + (root.selectedTrack() ? root.selectedTrack().classification : "")
                    color: Theme.platinum
                    font.family: Theme.mono
                    font.pixelSize: Theme.secondaryPx
                    font.bold: true
                }
                Text {
                    text: root.selectedTrack()
                          ? "BRG " + Math.round(root.trackPoint(root.selectedTrack(), root.width, root.height).bearing) +
                            "°  •  RNG " + root.trackPoint(root.selectedTrack(), root.width, root.height).distanceKm.toFixed(1) +
                            " KM  •  CONF " + Math.round(Number(root.selectedTrack().confidence || 0) * 100) + "%"
                          : ""
                    color: Theme.radarGreen
                    font.family: Theme.mono
                    font.pixelSize: Theme.smallPx
                    font.bold: true
                }
                Text {
                    text: root.rtl ? "اختيار للتحليل فقط — لا توجيه أو اشتباك" : "ANALYTICAL SELECTION ONLY — NO TARGETING / ENGAGEMENT"
                    color: Theme.muted
                    font.family: Theme.uiFont(root.rtl)
                    font.pixelSize: Theme.smallPx
                }
            }
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 13
        width: 250
        height: 26
        color: "#D9070B0B"
        border.color: Theme.borderSoft
        radius: 4
        Text {
            anchors.centerIn: parent
            text: root.rtl ? "المسح نشط • استقبال سلبي" : "SWEEP ACTIVE  •  PASSIVE RECEIVE"
            color: Theme.radarGreen
            font.family: Theme.uiFont(root.rtl)
            font.pixelSize: Theme.smallPx
            font.bold: true
        }
    }
}
