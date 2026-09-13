import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    property var publicTracks: cockpit.publicFlightTracks
    property var aegisTracks: cockpit.airOperationsTracks

    function clamp(v, low, high) {
        return Math.max(low, Math.min(high, v))
    }

    function worldX(longitude, width) {
        return clamp((Number(longitude) + 180.0) / 360.0, 0.02, 0.98) * width
    }

    function worldY(latitude, height) {
        return clamp((90.0 - Number(latitude)) / 180.0, 0.04, 0.96) * height
    }

    function aircraftAccent(id) {
        if (id === "generic-jet") return Theme.signalCyan
        if (id === "generic-helicopter") return Theme.royalGold
        if (id === "generic-uav") return Theme.rfViolet
        return Theme.radarGreen
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 9
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 76
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Rectangle {
                    width: 5
                    Layout.fillHeight: true
                    color: Theme.signalCyan
                    radius: 2
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: cockpit.rtl ? "الصورة الجوية والذكاء البصري" : "AIR PICTURE & VISUAL INTELLIGENCE"
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl
                              ? "تتبّع عام للطائرات + AEGIS + رادار بصري + قياس RF سلبي + استعراض هندسي للطائرة"
                              : "PUBLIC FLIGHT FEED + AEGIS + VISUAL RADAR + PASSIVE RF + AIRCRAFT ENGINEERING EXPLORER"
                        color: Theme.signalCyan
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                Repeater {
                    model: [
                        {"label":"PUBLIC ADS-B", "value":String(cockpit.publicFlightTrackCount), "color":Theme.signalCyan},
                        {"label":"AEGIS TRACKS", "value":String(cockpit.airOperationsTrackCount), "color":Theme.royalGold},
                        {"label":"RF PEAK", "value":Number(cockpit.rfPeakLevelDbm).toFixed(0) + " dBm", "color":Theme.rfViolet}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.preferredWidth: 128
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: modelData.color
                        border.width: 1
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            spacing: 0
                            Text {
                                text: modelData.label
                                color: Theme.muted
                                font.pixelSize: 6
                                font.bold: true
                            }
                            Text {
                                text: modelData.value
                                color: modelData.color
                                font.family: "Consolas"
                                font.pixelSize: 15
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
            spacing: 7

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                border.width: 1
                radius: Theme.radius
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 5

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: cockpit.rtl ? "الرادار / الصورة الجوية الموحّدة" : "RADAR / UNIFIED AIR PICTURE"
                            color: Theme.platinum
                            font.pixelSize: 11
                            font.bold: true
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "PUBLIC/CIVIL + AEGIS REPLAY"
                            color: Theme.signalCyan
                            font.family: "Consolas"
                            font.pixelSize: 7
                            font.bold: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#0A171B"
                        border.color: Theme.deepBlue
                        border.width: 1
                        radius: Theme.radius
                        clip: true

                        Canvas {
                            id: radarCanvas
                            anchors.fill: parent
                            anchors.margins: 8

                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.strokeStyle = "#244A63"
                                ctx.lineWidth = 1
                                ctx.globalAlpha = 0.75

                                for (var gx = 1; gx < 8; ++gx) {
                                    ctx.beginPath()
                                    ctx.moveTo(width * gx / 8, 0)
                                    ctx.lineTo(width * gx / 8, height)
                                    ctx.stroke()
                                }
                                for (var gy = 1; gy < 6; ++gy) {
                                    ctx.beginPath()
                                    ctx.moveTo(0, height * gy / 6)
                                    ctx.lineTo(width, height * gy / 6)
                                    ctx.stroke()
                                }

                                var cx = width / 2
                                var cy = height / 2
                                var radius = Math.min(width, height) * 0.43
                                ctx.strokeStyle = "#3B6C70"
                                for (var ring = 1; ring <= 4; ++ring) {
                                    ctx.beginPath()
                                    ctx.arc(cx, cy, radius * ring / 4, 0, Math.PI * 2)
                                    ctx.stroke()
                                }

                                var sweep = (cockpit.tick % 360) * Math.PI / 180
                                ctx.strokeStyle = "#62C59A"
                                ctx.globalAlpha = 0.9
                                ctx.beginPath()
                                ctx.moveTo(cx, cy)
                                ctx.lineTo(cx + Math.cos(sweep) * radius, cy + Math.sin(sweep) * radius)
                                ctx.stroke()
                                ctx.globalAlpha = 1.0
                            }

                            Connections {
                                target: cockpit
                                function onDataChanged() { radarCanvas.requestPaint() }
                            }
                        }

                        Repeater {
                            model: page.publicTracks
                            delegate: Item {
                                required property int index
                                required property var modelData
                                width: 24
                                height: 24
                                x: page.worldX(modelData.longitude, parent.width) - width / 2
                                y: page.worldY(modelData.latitude, parent.height) - height / 2
                                rotation: Number(modelData.headingDegrees)

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 19
                                    height: 3
                                    radius: 1
                                    color: Theme.signalCyan
                                }
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 3
                                    height: 19
                                    radius: 1
                                    color: Theme.platinum
                                }
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    width: 4
                                    height: 5
                                    color: Theme.signalCyan
                                }
                                MouseArea {
                                    id: publicTrackArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                                ToolTip.visible: publicTrackArea.containsMouse
                                ToolTip.text: (modelData.callsign || modelData.icao24) + "\n" +
                                              Number(modelData.altitudeMeters).toFixed(0) + " m  •  " +
                                              Number(modelData.velocityMetersPerSecond).toFixed(0) + " m/s"
                            }
                        }

                        Repeater {
                            model: page.aegisTracks
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: 13
                                height: 13
                                radius: 7
                                x: page.worldX(modelData.longitude, parent.width) - width / 2
                                y: page.worldY(modelData.latitude, parent.height) - height / 2
                                color: modelData.threatLevel === "High" || modelData.threatLevel === "Critical" ? Theme.warmOrange : Theme.royalGold
                                border.color: Theme.platinum
                                border.width: 1
                                MouseArea {
                                    id: aegisArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                                ToolTip.visible: aegisArea.containsMouse
                                ToolTip.text: modelData.trackId + " • " + modelData.classification + " • " + modelData.threatLevel
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.margins: 9
                            width: 238
                            height: 72
                            color: "#B00C1319"
                            border.color: Theme.deepBlue
                            border.width: 1
                            radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 1
                                Text {
                                    text: cockpit.publicFlightFeedSource
                                    color: Theme.platinum
                                    font.pixelSize: 8
                                    font.bold: true
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: cockpit.publicFlightFeedStatus
                                    color: Theme.signalCyan
                                    font.family: "Consolas"
                                    font.pixelSize: 7
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: "AWARENESS / TRAINING — NO TARGETING"
                                    color: Theme.radarGreen
                                    font.pixelSize: 6
                                    font.bold: true
                                }
                            }
                        }

                        RowLayout {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 8
                            spacing: 10
                            Rectangle { width: 8; height: 8; color: Theme.signalCyan }
                            Text { text: "PUBLIC ADS-B"; color: Theme.silver; font.pixelSize: 6 }
                            Rectangle { width: 8; height: 8; radius: 4; color: Theme.royalGold }
                            Text { text: "AEGIS REPLAY"; color: Theme.silver; font.pixelSize: 6 }
                            Item { Layout.fillWidth: true }
                            Text { text: "GLOBAL PROJECTION / VISUAL AWARENESS"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 128
                        color: Theme.panel2
                        border.color: Theme.borderSoft
                        border.width: 1
                        radius: Theme.radius
                        clip: true

                        ListView {
                            anchors.fill: parent
                            anchors.margins: 5
                            orientation: ListView.Horizontal
                            spacing: 5
                            model: page.publicTracks
                            clip: true
                            delegate: Rectangle {
                                required property var modelData
                                width: 192
                                height: ListView.view.height
                                color: Theme.panel3
                                border.color: Theme.signalCyan
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 1
                                    Text { text: modelData.callsign || modelData.icao24; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.icao24.toUpperCase() + "  /  " + modelData.country; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                    Text { text: "ALT  " + Number(modelData.altitudeMeters).toFixed(0) + " m"; color: Theme.skyBlue; font.family: "Consolas"; font.pixelSize: 7 }
                                    Text { text: "SPD  " + Number(modelData.velocityMetersPerSecond).toFixed(0) + " m/s"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 7 }
                                    Text { text: "HDG  " + Number(modelData.headingDegrees).toFixed(0) + "°"; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 7 }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 430
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 338
                    color: Theme.panel
                    border.color: page.aircraftAccent(cockpit.activePlatformId)
                    border.width: 1
                    radius: Theme.radius
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 5

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "استعراض الطائرة" : "AIRCRAFT VISUAL EXPLORER"
                                color: Theme.platinum
                                font.pixelSize: 10
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: Theme.platformCode(cockpit.activePlatformId)
                                color: page.aircraftAccent(cockpit.activePlatformId)
                                font.family: "Consolas"
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            Repeater {
                                model: [
                                    {"id":"generic-jet", "label":"JET"},
                                    {"id":"generic-helicopter", "label":"ROTOR"},
                                    {"id":"generic-uav", "label":"UAV"},
                                    {"id":"generic-turboprop", "label":"TURBO"}
                                ]
                                delegate: Button {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 28
                                    text: modelData.label
                                    onClicked: cockpit.setActivePlatform(modelData.id)
                                    contentItem: Text {
                                        text: parent.text
                                        color: cockpit.activePlatformId === modelData.id ? Theme.platinum : Theme.muted
                                        font.pixelSize: 7
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    background: Rectangle {
                                        color: cockpit.activePlatformId === modelData.id ? Theme.panel3 : Theme.panel2
                                        border.color: cockpit.activePlatformId === modelData.id ? page.aircraftAccent(modelData.id) : Theme.borderSoft
                                        border.width: 1
                                        radius: Theme.radius
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#101C24"
                            border.color: Theme.deepBlue
                            border.width: 1
                            radius: Theme.radius

                            Canvas {
                                id: aircraftCanvas
                                anchors.fill: parent
                                anchors.margins: 8

                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.clearRect(0, 0, width, height)
                                    var cx = width / 2
                                    var cy = height / 2
                                    var accent = page.aircraftAccent(cockpit.activePlatformId)
                                    ctx.strokeStyle = accent
                                    ctx.fillStyle = accent
                                    ctx.lineWidth = 2

                                    ctx.globalAlpha = 0.12
                                    for (var g = 1; g < 6; ++g) {
                                        ctx.beginPath()
                                        ctx.moveTo(width * g / 6, 0)
                                        ctx.lineTo(width * g / 6, height)
                                        ctx.stroke()
                                    }
                                    ctx.globalAlpha = 1.0

                                    if (cockpit.activePlatformId === "generic-helicopter") {
                                        ctx.beginPath()
                                        ctx.ellipse(cx, cy, 58, 22, 0, 0, Math.PI * 2)
                                        ctx.stroke()
                                        ctx.beginPath()
                                        ctx.moveTo(cx + 55, cy)
                                        ctx.lineTo(cx + 135, cy - 4)
                                        ctx.lineTo(cx + 150, cy + 2)
                                        ctx.stroke()
                                        ctx.beginPath()
                                        ctx.moveTo(cx - 92, cy - 42)
                                        ctx.lineTo(cx + 92, cy - 42)
                                        ctx.stroke()
                                        ctx.beginPath()
                                        ctx.moveTo(cx, cy - 42)
                                        ctx.lineTo(cx, cy - 21)
                                        ctx.stroke()
                                    } else if (cockpit.activePlatformId === "generic-uav") {
                                        ctx.beginPath()
                                        ctx.moveTo(cx, cy - 54)
                                        ctx.lineTo(cx + 26, cy - 6)
                                        ctx.lineTo(cx + 126, cy + 13)
                                        ctx.lineTo(cx + 34, cy + 24)
                                        ctx.lineTo(cx + 15, cy + 59)
                                        ctx.lineTo(cx, cy + 45)
                                        ctx.lineTo(cx - 15, cy + 59)
                                        ctx.lineTo(cx - 34, cy + 24)
                                        ctx.lineTo(cx - 126, cy + 13)
                                        ctx.lineTo(cx - 26, cy - 6)
                                        ctx.closePath()
                                        ctx.stroke()
                                    } else {
                                        ctx.beginPath()
                                        ctx.moveTo(cx, cy - 72)
                                        ctx.lineTo(cx + 18, cy - 8)
                                        ctx.lineTo(cx + 128, cy + 14)
                                        ctx.lineTo(cx + 30, cy + 26)
                                        ctx.lineTo(cx + 20, cy + 74)
                                        ctx.lineTo(cx, cy + 57)
                                        ctx.lineTo(cx - 20, cy + 74)
                                        ctx.lineTo(cx - 30, cy + 26)
                                        ctx.lineTo(cx - 128, cy + 14)
                                        ctx.lineTo(cx - 18, cy - 8)
                                        ctx.closePath()
                                        ctx.stroke()
                                        if (cockpit.activePlatformId === "generic-turboprop") {
                                            ctx.beginPath()
                                            ctx.arc(cx - 44, cy + 4, 21, 0, Math.PI * 2)
                                            ctx.stroke()
                                            ctx.beginPath()
                                            ctx.arc(cx + 44, cy + 4, 21, 0, Math.PI * 2)
                                            ctx.stroke()
                                        }
                                    }

                                    ctx.fillStyle = Theme.platinum
                                    ctx.font = "bold 10px Consolas"
                                    ctx.fillText(cockpit.activePlatformName.toUpperCase(), 10, 18)
                                }

                                Connections {
                                    target: cockpit
                                    function onDataChanged() { aircraftCanvas.requestPaint() }
                                }
                            }

                            Rectangle {
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.margins: 8
                                width: 170
                                height: 54
                                color: "#B00C1319"
                                border.color: page.aircraftAccent(cockpit.activePlatformId)
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 0
                                    Text { text: cockpit.activePlatformCategory; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: cockpit.activePlatformPropulsion; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: "DX " + cockpit.diagnosticHealthScore + "%  •  TWIN " + cockpit.twinNominalCount; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                }
                            }
                        }

                        Text {
                            text: cockpit.rtl
                                  ? "الرسم الهندسي مدمج الآن؛ صور الطائرات المرخّصة ونماذج 3D ستستخدم نفس مساحة العرض."
                                  : "ENGINEERING RENDER ACTIVE — LICENSED AIRCRAFT PHOTOS / 3D ASSETS USE THE SAME VIEWPORT."
                            color: Theme.muted
                            font.pixelSize: 6
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.rfViolet
                    border.width: 1
                    radius: Theme.radius
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 5

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: cockpit.rtl ? "مراقبة طيف RF السلبية" : "PASSIVE RF SPECTRUM"
                                color: Theme.platinum
                                font.pixelSize: 10
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: Number(cockpit.rfPeakFrequencyMhz).toFixed(1) + " MHz"
                                color: Theme.rfViolet
                                font.family: "Consolas"
                                font.pixelSize: 9
                                font.bold: true
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#111724"
                            border.color: Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius

                            Row {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.top: parent.top
                                anchors.margins: 8
                                spacing: 1

                                Repeater {
                                    model: cockpit.rfSpectrumBins
                                    delegate: Rectangle {
                                        required property var modelData
                                        width: Math.max(2, (parent.width - 63) / 64)
                                        height: page.clamp((Number(modelData.levelDbm) + 110.0) / 80.0, 0.03, 1.0) * parent.height
                                        anchors.bottom: parent.bottom
                                        color: Number(modelData.levelDbm) > -60 ? Theme.warmOrange : (Number(modelData.levelDbm) > -78 ? Theme.rfViolet : Theme.signalCyan)
                                        opacity: 0.88
                                    }
                                }
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.margins: 6
                                text: "-30 dBm"
                                color: Theme.muted
                                font.family: "Consolas"
                                font.pixelSize: 6
                            }
                            Text {
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                anchors.margins: 6
                                text: "-110 dBm"
                                color: Theme.muted
                                font.family: "Consolas"
                                font.pixelSize: 6
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rfSpectrumMode; color: Theme.rfViolet; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                            Item { Layout.fillWidth: true }
                            Text { text: Number(cockpit.rfPeakLevelDbm).toFixed(1) + " dBm PEAK"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                        }
                        Text {
                            text: cockpit.rtl ? "استقبال/عرض سلبي فقط — لا إرسال، لا تشويش، لا تحكم." : "RECEIVE / VISUALIZE ONLY — NO TRANSMIT, JAMMING OR CONTROL."
                            color: Theme.radarGreen
                            font.pixelSize: 6
                            font.bold: true
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 66
            color: Theme.panel
            border.color: Theme.signalCyan
            border.width: 1
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 7

                ColumnLayout {
                    Layout.preferredWidth: 205
                    spacing: 0
                    Text { text: "PUBLIC FLIGHT API"; color: Theme.platinum; font.pixelSize: 8; font.bold: true }
                    Text { text: "HTTPS / OPEN DATA / CIVIL AWARENESS"; color: Theme.signalCyan; font.pixelSize: 6; font.bold: true }
                }

                TextField {
                    id: apiField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    placeholderText: "https://opensky-network.org/api/states/all"
                    text: "https://opensky-network.org/api/states/all"
                    color: Theme.platinum
                    font.family: "Consolas"
                    font.pixelSize: 8
                    selectByMouse: true
                    background: Rectangle {
                        color: Theme.panel2
                        border.color: Theme.borderSoft
                        border.width: 1
                        radius: Theme.radius
                    }
                }

                Button {
                    Layout.preferredWidth: 112
                    Layout.preferredHeight: 34
                    text: cockpit.rtl ? "جلب HTTPS" : "FETCH HTTPS"
                    onClicked: cockpit.fetchPublicFlightFeed(apiField.text)
                    contentItem: Text {
                        text: parent.text
                        color: Theme.platinum
                        font.pixelSize: 7
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: Theme.deepBlue
                        border.color: Theme.signalCyan
                        border.width: 1
                        radius: Theme.radius
                    }
                }

                Button {
                    Layout.preferredWidth: 78
                    Layout.preferredHeight: 34
                    text: "DEMO"
                    onClicked: cockpit.resetPublicFlightDemo()
                    contentItem: Text {
                        text: parent.text
                        color: Theme.platinum
                        font.pixelSize: 7
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: Theme.panel2
                        border.color: Theme.royalGold
                        border.width: 1
                        radius: Theme.radius
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 230
                    Layout.preferredHeight: 34
                    color: Theme.panel2
                    border.color: Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    Text {
                        anchors.centerIn: parent
                        width: parent.width - 10
                        text: cockpit.publicFlightFeedStatus
                        color: Theme.radarGreen
                        font.family: "Consolas"
                        font.pixelSize: 6
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
