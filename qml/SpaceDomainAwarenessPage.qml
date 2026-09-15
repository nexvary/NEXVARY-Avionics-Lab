import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    property var orbitalObjects: [
        {id:"MEO-01", family:"NAV-A", altitude:"20,180 KM", inclination:"55.0°", period:"718 MIN", health:"NOMINAL", color:Theme.signalCyan, phase:.10, plane:"PLANE A"},
        {id:"MEO-04", family:"NAV-A", altitude:"20,190 KM", inclination:"55.0°", period:"718 MIN", health:"NOMINAL", color:Theme.signalCyan, phase:.42, plane:"PLANE A"},
        {id:"MEO-07", family:"NAV-B", altitude:"23,222 KM", inclination:"56.0°", period:"845 MIN", health:"OBSERVED", color:Theme.royalGold, phase:.68, plane:"PLANE B"},
        {id:"MEO-09", family:"NAV-B", altitude:"23,215 KM", inclination:"56.0°", period:"845 MIN", health:"NOMINAL", color:Theme.royalGold, phase:.91, plane:"PLANE B"},
        {id:"MEO-11", family:"NAV-C", altitude:"19,130 KM", inclination:"64.8°", period:"676 MIN", health:"REVIEW", color:Theme.rfViolet, phase:.26, plane:"PLANE C"},
        {id:"MEO-12", family:"NAV-C", altitude:"19,145 KM", inclination:"64.8°", period:"676 MIN", health:"NOMINAL", color:Theme.rfViolet, phase:.56, plane:"PLANE C"}
    ]

    function statusColor(value) {
        if (value === "REVIEW") return Theme.amber
        if (value === "OBSERVED") return Theme.royalGold
        return Theme.radarGreen
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bg
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            color: Theme.panel
            border.color: Theme.royalGold
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                Rectangle {
                    width: 5
                    Layout.fillHeight: true
                    radius: 3
                    color: Theme.royalGold
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: cockpit.rtl ? "الوعي بالمجال الفضائي" : "SPACE DOMAIN AWARENESS"
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.pageTitlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl
                              ? "تتبّع مدارات MEO العامة • التنبؤ بالمرور • صحة المصدر • تدريب وتحليل فقط"
                              : "PUBLIC MEO ORBITS • PASS PREDICTION • SOURCE HEALTH • TRAINING & ANALYSIS ONLY"
                        color: Theme.signalCyan
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.secondaryPx
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }

                Repeater {
                    model: [
                        {label:cockpit.rtl ? "أجسام MEO" : "MEO OBJECTS", value:"12", color:Theme.signalCyan},
                        {label:cockpit.rtl ? "مستويات مدارية" : "ORBIT PLANES", value:"03", color:Theme.royalGold},
                        {label:cockpit.rtl ? "نوافذ مرور" : "ACCESS WINDOWS", value:"04", color:Theme.radarGreen},
                        {label:cockpit.rtl ? "تنبيهات اقتران" : "CONJUNCTION", value:"01", color:Theme.amber}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.preferredWidth: 124
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: modelData.color
                        border.width: Theme.frameWidth
                        radius: Theme.radius
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.label
                                color: Theme.silver
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.value
                                color: modelData.color
                                font.family: Theme.mono
                                font.pixelSize: 20
                                font.bold: true
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 820
                color: "#02080D"
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius
                clip: true

                Canvas {
                    id: orbitalPlot
                    objectName: "orbitalSituationPlot"
                    anchors.fill: parent
                    antialiasing: true
                    property real orbitalPhase: 0

                    NumberAnimation on orbitalPhase {
                        from: 0
                        to: Math.PI * 2
                        duration: 18000
                        loops: Animation.Infinite
                        running: orbitalPlot.visible
                    }
                    onOrbitalPhaseChanged: requestPaint()
                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()

                    function traceEllipse(c, cx, cy, rx, ry, rotation) {
                        c.beginPath()
                        for (var step = 0; step <= 100; ++step) {
                            var a = Math.PI * 2 * step / 100
                            var px = rx * Math.cos(a)
                            var py = ry * Math.sin(a)
                            var x = cx + px * Math.cos(rotation) - py * Math.sin(rotation)
                            var y = cy + px * Math.sin(rotation) + py * Math.cos(rotation)
                            if (step === 0) c.moveTo(x, y)
                            else c.lineTo(x, y)
                        }
                        c.stroke()
                    }

                    function orbitPoint(cx, cy, rx, ry, rotation, angle) {
                        var px = rx * Math.cos(angle)
                        var py = ry * Math.sin(angle)
                        return {
                            x: cx + px * Math.cos(rotation) - py * Math.sin(rotation),
                            y: cy + px * Math.sin(rotation) + py * Math.cos(rotation)
                        }
                    }

                    onPaint: {
                        var c = getContext("2d")
                        c.reset()
                        var w = width
                        var h = height
                        var cx = w * .49
                        var cy = h * .53
                        var earthRadius = Math.min(w, h) * .205

                        var background = c.createRadialGradient(cx, cy, earthRadius * .2, cx, cy, Math.max(w, h) * .62)
                        background.addColorStop(0, "#0B2532")
                        background.addColorStop(.42, "#04101A")
                        background.addColorStop(1, "#000204")
                        c.fillStyle = background
                        c.fillRect(0, 0, w, h)

                        for (var star = 0; star < 90; ++star) {
                            var sx = (Math.sin(star * 93.17) * .5 + .5) * w
                            var sy = (Math.sin(star * 47.81 + 1.3) * .5 + .5) * h
                            var alpha = .18 + (star % 5) * .08
                            c.fillStyle = "rgba(158,171,181," + alpha + ")"
                            c.fillRect(sx, sy, star % 9 === 0 ? 2 : 1, star % 9 === 0 ? 2 : 1)
                        }

                        c.strokeStyle = "#17323E"
                        c.lineWidth = 1
                        c.globalAlpha = .42
                        for (var gx = 1; gx < 12; ++gx) {
                            c.beginPath()
                            c.moveTo(w * gx / 12, 0)
                            c.lineTo(w * gx / 12, h)
                            c.stroke()
                        }
                        for (var gy = 1; gy < 8; ++gy) {
                            c.beginPath()
                            c.moveTo(0, h * gy / 8)
                            c.lineTo(w, h * gy / 8)
                            c.stroke()
                        }
                        c.globalAlpha = 1

                        var orbitColors = [Theme.signalCyan, Theme.royalGold, Theme.rfViolet]
                        var rotations = [-.44, .10, .58]
                        for (var orbit = 0; orbit < 3; ++orbit) {
                            c.strokeStyle = orbitColors[orbit]
                            c.lineWidth = orbit === 1 ? 1.6 : 1.15
                            c.globalAlpha = orbit === 1 ? .62 : .42
                            traceEllipse(c, cx, cy,
                                         earthRadius * (2.02 + orbit * .18),
                                         earthRadius * (.73 + orbit * .08),
                                         rotations[orbit])
                        }
                        c.globalAlpha = 1

                        var earthGradient = c.createRadialGradient(cx - earthRadius * .35, cy - earthRadius * .42, earthRadius * .05,
                                                                  cx, cy, earthRadius)
                        earthGradient.addColorStop(0, "#1B6179")
                        earthGradient.addColorStop(.53, "#0A3448")
                        earthGradient.addColorStop(1, "#03131D")
                        c.fillStyle = earthGradient
                        c.strokeStyle = Theme.signalCyan
                        c.lineWidth = 1.4
                        c.beginPath()
                        c.arc(cx, cy, earthRadius, 0, Math.PI * 2)
                        c.fill()
                        c.stroke()

                        c.save()
                        c.beginPath()
                        c.arc(cx, cy, earthRadius - 1, 0, Math.PI * 2)
                        c.clip()
                        c.fillStyle = "#163D35"
                        c.globalAlpha = .90
                        c.beginPath()
                        c.moveTo(cx - earthRadius * .72, cy - earthRadius * .30)
                        c.lineTo(cx - earthRadius * .40, cy - earthRadius * .58)
                        c.lineTo(cx - earthRadius * .08, cy - earthRadius * .48)
                        c.lineTo(cx + earthRadius * .05, cy - earthRadius * .18)
                        c.lineTo(cx - earthRadius * .18, cy + earthRadius * .02)
                        c.lineTo(cx - earthRadius * .05, cy + earthRadius * .56)
                        c.lineTo(cx - earthRadius * .38, cy + earthRadius * .72)
                        c.lineTo(cx - earthRadius * .62, cy + earthRadius * .22)
                        c.closePath()
                        c.fill()
                        c.beginPath()
                        c.moveTo(cx + earthRadius * .12, cy - earthRadius * .42)
                        c.lineTo(cx + earthRadius * .65, cy - earthRadius * .30)
                        c.lineTo(cx + earthRadius * .82, cy + earthRadius * .08)
                        c.lineTo(cx + earthRadius * .48, cy + earthRadius * .20)
                        c.lineTo(cx + earthRadius * .28, cy + earthRadius * .62)
                        c.lineTo(cx + earthRadius * .02, cy + earthRadius * .22)
                        c.closePath()
                        c.fill()

                        c.strokeStyle = "#65BFFF"
                        c.lineWidth = 1
                        c.globalAlpha = .24
                        for (var lat = -2; lat <= 2; ++lat)
                            traceEllipse(c, cx, cy + earthRadius * lat * .20,
                                         earthRadius * Math.sqrt(Math.max(.08, 1 - lat * lat * .035)),
                                         earthRadius * .16, 0)
                        for (var lon = -2; lon <= 2; ++lon)
                            traceEllipse(c, cx, cy, earthRadius * (.18 + Math.abs(lon) * .02), earthRadius, lon * .30)
                        c.restore()
                        c.globalAlpha = 1

                        c.strokeStyle = Theme.royalGold
                        c.lineWidth = 1
                        c.setLineDash([7, 6])
                        c.globalAlpha = .54
                        c.beginPath()
                        c.arc(cx, cy, earthRadius * 1.18, Math.PI * 1.12, Math.PI * 1.86)
                        c.stroke()
                        c.setLineDash([])
                        c.globalAlpha = 1

                        for (var i = 0; i < page.orbitalObjects.length; ++i) {
                            var object = page.orbitalObjects[i]
                            var plane = i % 3
                            var rx = earthRadius * (2.02 + plane * .18)
                            var ry = earthRadius * (.73 + plane * .08)
                            var angle = orbitalPlot.orbitalPhase * (.72 + plane * .11) + object.phase * Math.PI * 2
                            var p = orbitPoint(cx, cy, rx, ry, rotations[plane], angle)
                            var objectColor = object.color

                            c.strokeStyle = objectColor
                            c.fillStyle = "#02070B"
                            c.lineWidth = 1.4
                            c.beginPath()
                            c.moveTo(p.x, p.y - 6)
                            c.lineTo(p.x + 6, p.y)
                            c.lineTo(p.x, p.y + 6)
                            c.lineTo(p.x - 6, p.y)
                            c.closePath()
                            c.fill()
                            c.stroke()
                            c.fillStyle = objectColor
                            c.fillRect(p.x - 15, p.y - 2, 7, 4)
                            c.fillRect(p.x + 8, p.y - 2, 7, 4)

                            c.font = "700 " + Theme.smallPx + "px 'Noto Sans Mono'"
                            c.fillStyle = objectColor
                            c.textAlign = p.x > cx ? "right" : "left"
                            c.fillText(object.id, p.x + (p.x > cx ? -18 : 18), p.y - 8)
                        }
                        c.textAlign = "left"

                        c.fillStyle = Theme.platinum
                        c.font = "700 " + Theme.secondaryPx + "px 'Noto Sans Mono'"
                        c.fillText("MEO ORBITAL PICTURE / ECI TRAINING VIEW", 18, h - 28)
                        c.fillStyle = Theme.muted
                        c.font = Theme.smallPx + "px 'Noto Sans Mono'"
                        c.fillText("PUBLIC EPHEMERIS COMPATIBLE • REPLAY ACTIVE • NOT FOR NAVIGATION", 18, h - 10)
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.margins: 13
                    width: 292
                    height: 70
                    color: "#EC050D13"
                    border.color: Theme.border
                    border.width: 1
                    radius: 5
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 9
                        Rectangle {
                            width: 42
                            height: 42
                            radius: 21
                            color: "transparent"
                            border.color: Theme.signalCyan
                            border.width: 1
                            Rectangle { anchors.centerIn: parent; width: 8; height: 8; radius: 4; color: Theme.royalGold }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1
                            Text { text: cockpit.rtl ? "صورة المدارات المتوسطة" : "MEDIUM EARTH ORBIT"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "MEO • 19,000–24,000 KM • 3 PLANES"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 13
                    spacing: 5
                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                    Repeater {
                        model: [
                            {label:"EPHEMERIS", color:Theme.signalCyan},
                            {label:"GROUND TRACE", color:Theme.radarGreen},
                            {label:"VISIBILITY", color:Theme.royalGold}
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            width: 104
                            height: 34
                            color: "#EC07131A"
                            border.color: modelData.color
                            border.width: 1
                            radius: 5
                            Text { anchors.centerIn: parent; text: modelData.label; color: modelData.color; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 410
                Layout.minimumWidth: 390
                Layout.maximumWidth: 430
                Layout.fillHeight: true
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 188
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "الجسم المحدد" : "SELECTED OBJECT"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: "MEO-07"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 2
                            columnSpacing: 10
                            rowSpacing: 4
                            Repeater {
                                model: [
                                    {label:cockpit.rtl ? "العائلة" : "FAMILY", value:"NAV-B / TRAINING"},
                                    {label:cockpit.rtl ? "الارتفاع" : "ALTITUDE", value:"23,222 KM"},
                                    {label:cockpit.rtl ? "الميل" : "INCLINATION", value:"56.0°"},
                                    {label:cockpit.rtl ? "الدورة" : "PERIOD", value:"845 MIN"},
                                    {label:cockpit.rtl ? "المصدر" : "SOURCE", value:"PUBLIC / REPLAY"},
                                    {label:cockpit.rtl ? "الجودة" : "QUALITY", value:"VERIFIED"}
                                ]
                                delegate: ColumnLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Text { text: modelData.label; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                    Text { text: modelData.value; color: modelData.value === "VERIFIED" ? Theme.radarGreen : Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.signalCyan
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "نوافذ المرور المتوقعة" : "PREDICTED ACCESS WINDOWS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: "NEXT 90 MIN"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: [
                                {time:"T+08", object:"MEO-07", node:"NODE CAI", elevation:"42°", color:Theme.royalGold},
                                {time:"T+21", object:"MEO-01", node:"NODE MED", elevation:"61°", color:Theme.signalCyan},
                                {time:"T+46", object:"MEO-11", node:"NODE EAST", elevation:"28°", color:Theme.rfViolet},
                                {time:"T+73", object:"MEO-04", node:"NODE CAI", elevation:"54°", color:Theme.radarGreen}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 52
                                color: Theme.panel2
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: 5
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 8
                                    Rectangle { width: 4; Layout.fillHeight: true; radius: 2; color: modelData.color }
                                    Text { text: modelData.time; color: modelData.color; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.preferredWidth: 50 }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.object + "  •  " + modelData.node; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: cockpit.rtl ? "مرور متوقع / للوعي فقط" : "PREDICTED PASS / AWARENESS ONLY"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    Text { text: modelData.elevation; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                                }
                            }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 112
                    color: Theme.panel
                    border.color: Theme.amber
                    border.width: 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        Rectangle {
                            width: 42
                            height: 42
                            radius: 21
                            color: "#18F4B942"
                            border.color: Theme.amber
                            border.width: 1
                            Text { anchors.centerIn: parent; text: "!"; color: Theme.amber; font.family: Theme.mono; font.pixelSize: 22; font.bold: true }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Text { text: cockpit.rtl ? "مراجعة اقتران" : "CONJUNCTION REVIEW"; color: Theme.amber; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: "MEO-11 / OBJECT R-204  •  T+18H"; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: cockpit.rtl ? "تقييم تحليلي فقط — لا توجد أوامر مناورة" : "ANALYTICAL ASSESSMENT ONLY — NO MANEUVER COMMANDS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 88
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 9
                spacing: 7
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                Rectangle {
                    Layout.preferredWidth: 228
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: Theme.radarGreen
                    border.width: 1
                    radius: 5
                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: cockpit.rtl ? "مصدر العناصر المدارية" : "EPHEMERIS PROVIDER"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "PUBLIC / REPLAY • FRESH"; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                    }
                }

                Repeater {
                    model: page.orbitalObjects
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: modelData.id === "MEO-07" ? Theme.royalGold : Theme.borderSoft
                        border.width: modelData.id === "MEO-07" ? Theme.activeFrameWidth : Theme.frameWidth
                        radius: 5
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            spacing: 1
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: modelData.id; color: modelData.color; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true }
                                Rectangle { width: 8; height: 8; radius: 4; color: page.statusColor(modelData.health) }
                            }
                            Text { text: modelData.plane + "  •  " + modelData.altitude; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: modelData.health; color: page.statusColor(modelData.health); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                        }
                    }
                }
            }
        }
    }
}
