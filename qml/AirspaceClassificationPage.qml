import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirspaceData.js" as AirspaceData
import "AirspaceLocale.js" as AirspaceLocale

Item {
    id: page
    clip: true

    property string selectedClass: "ALL"
    property var selectedZone: AirspaceData.zones[2]
    property bool showAirports: true
    property bool showNavaids: true
    property bool showTraffic: true
    property bool showRoute: true

    function classColor(code) {
        if (code === "A") return Theme.royalGold
        if (code === "B") return Theme.rfViolet
        if (code === "C") return Theme.signalCyan
        if (code === "D") return Theme.warmOrange
        if (code === "E") return Theme.skyBlue
        if (code === "F") return Theme.amber
        return Theme.radarGreen
    }

    function zoneVisible(zone) {
        return selectedClass === "ALL" || zone.classCode === selectedClass
    }

    function lonToX(lon) {
        return Math.max(0.02, Math.min(0.98, (lon - 24.0) / 13.0))
    }

    function latToY(lat) {
        return Math.max(0.02, Math.min(0.98, 1.0 - ((lat - 21.0) / 12.5)))
    }

    function layerChip(parentItem, labelText, activeValue) {
        return activeValue
    }

    onShowRouteChanged: chartCanvas.requestPaint()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: AirspaceLocale.label(cockpit.language)
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: AirspaceLocale.subtitle(cockpit.language)
                        color: Theme.signalCyan
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 46
                    color: Theme.panel2
                    border.color: Theme.warmOrange
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 1
                        Text {
                            text: AirspaceLocale.notForNavigation(cockpit.language)
                            color: Theme.warmOrange
                            font.pixelSize: 8
                            font.bold: true
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            text: "SYNTHETIC CLASSIFICATION DATASET"
                            color: Theme.muted
                            font.family: "Consolas"
                            font.pixelSize: 6
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            color: Theme.panel
            border.color: Theme.borderSoft
            border.width: 1
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 6

                Text {
                    text: AirspaceLocale.layers(cockpit.language)
                    color: Theme.platinum
                    font.pixelSize: 8
                    font.bold: true
                }

                Repeater {
                    model: ["ALL", "A", "B", "C", "D", "E", "F", "G"]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.preferredWidth: modelData === "ALL" ? 54 : 38
                        Layout.preferredHeight: 28
                        color: page.selectedClass === modelData ? page.classColor(modelData === "ALL" ? "C" : modelData) : Theme.panel2
                        border.color: modelData === "ALL" ? Theme.signalCyan : page.classColor(modelData)
                        border.width: 1
                        radius: Theme.radius
                        Text {
                            anchors.centerIn: parent
                            text: modelData === "ALL" ? AirspaceLocale.all(cockpit.language) : modelData
                            color: page.selectedClass === modelData ? Theme.darkNavy : Theme.platinum
                            font.family: "Consolas"
                            font.pixelSize: 8
                            font.bold: true
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: page.selectedClass = modelData
                        }
                    }
                }

                Rectangle { width: 1; Layout.fillHeight: true; color: Theme.borderSoft }

                Repeater {
                    model: [
                        {key:"airports", label:AirspaceLocale.airports(cockpit.language), active:page.showAirports, color:Theme.royalGold},
                        {key:"navaids", label:AirspaceLocale.navaids(cockpit.language), active:page.showNavaids, color:Theme.rfViolet},
                        {key:"traffic", label:AirspaceLocale.traffic(cockpit.language), active:page.showTraffic, color:Theme.signalCyan},
                        {key:"route", label:AirspaceLocale.route(cockpit.language), active:page.showRoute, color:Theme.radarGreen}
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.preferredWidth: 118
                        Layout.preferredHeight: 28
                        color: modelData.active ? Theme.panel3 : Theme.panel2
                        border.color: modelData.active ? modelData.color : Theme.borderSoft
                        border.width: 1
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 5
                            Rectangle {
                                width: 7
                                height: 7
                                radius: 3
                                color: modelData.active ? modelData.color : Theme.muted
                            }
                            Text {
                                text: modelData.label
                                color: modelData.active ? Theme.platinum : Theme.muted
                                font.pixelSize: 6
                                font.bold: true
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.key === "airports") page.showAirports = !page.showAirports
                                else if (modelData.key === "navaids") page.showNavaids = !page.showNavaids
                                else if (modelData.key === "traffic") page.showTraffic = !page.showTraffic
                                else page.showRoute = !page.showRoute
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }
                Text {
                    text: cockpit.publicFlightFeedSource + "  •  " + cockpit.publicFlightTrackCount + " TRACKS"
                    color: Theme.signalCyan
                    font.family: "Consolas"
                    font.pixelSize: 7
                    font.bold: true
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7

            Rectangle {
                id: chartFrame
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#10222A"
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius
                clip: true

                Canvas {
                    id: chartCanvas
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.fillStyle = "#102A37"
                        ctx.fillRect(0, 0, width, height)

                        ctx.strokeStyle = "#2A4B57"
                        ctx.lineWidth = 1
                        for (var gx = 0; gx <= 10; ++gx) {
                            var px = width * gx / 10
                            ctx.beginPath()
                            ctx.moveTo(px, 0)
                            ctx.lineTo(px, height)
                            ctx.stroke()
                        }
                        for (var gy = 0; gy <= 8; ++gy) {
                            var py = height * gy / 8
                            ctx.beginPath()
                            ctx.moveTo(0, py)
                            ctx.lineTo(width, py)
                            ctx.stroke()
                        }

                        ctx.fillStyle = "#253B35"
                        ctx.strokeStyle = "#6A8179"
                        ctx.lineWidth = 1.5
                        ctx.beginPath()
                        ctx.moveTo(width * 0.08, height * 0.18)
                        ctx.lineTo(width * 0.50, height * 0.16)
                        ctx.lineTo(width * 0.60, height * 0.28)
                        ctx.lineTo(width * 0.62, height * 0.52)
                        ctx.lineTo(width * 0.56, height * 0.94)
                        ctx.lineTo(width * 0.20, height * 0.94)
                        ctx.lineTo(width * 0.08, height * 0.66)
                        ctx.closePath()
                        ctx.fill()
                        ctx.stroke()

                        ctx.beginPath()
                        ctx.moveTo(width * 0.60, height * 0.28)
                        ctx.lineTo(width * 0.78, height * 0.31)
                        ctx.lineTo(width * 0.72, height * 0.58)
                        ctx.lineTo(width * 0.62, height * 0.52)
                        ctx.closePath()
                        ctx.fill()
                        ctx.stroke()

                        ctx.fillStyle = "#143846"
                        ctx.beginPath()
                        ctx.moveTo(width * 0.62, height * 0.54)
                        ctx.lineTo(width * 0.70, height * 0.98)
                        ctx.lineTo(width * 0.79, height * 0.98)
                        ctx.lineTo(width * 0.71, height * 0.58)
                        ctx.closePath()
                        ctx.fill()

                        if (page.showRoute) {
                            ctx.strokeStyle = Theme.radarGreen
                            ctx.lineWidth = 2
                            ctx.beginPath()
                            for (var i = 0; i < AirspaceData.route.length; ++i) {
                                var rp = AirspaceData.route[i]
                                var rx = width * rp.x
                                var ry = height * rp.y
                                if (i === 0) ctx.moveTo(rx, ry)
                                else ctx.lineTo(rx, ry)
                            }
                            ctx.stroke()
                        }
                    }
                }

                Repeater {
                    model: AirspaceData.zones
                    delegate: Rectangle {
                        required property var modelData
                        visible: page.zoneVisible(modelData)
                        x: chartFrame.width * modelData.x
                        y: chartFrame.height * modelData.y
                        width: chartFrame.width * modelData.w
                        height: chartFrame.height * modelData.h
                        color: page.classColor(modelData.classCode)
                        opacity: 0.22
                        border.color: page.classColor(modelData.classCode)
                        border.width: page.selectedZone && page.selectedZone.id === modelData.id ? 3 : 1
                        radius: 3

                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.classCode
                                color: Theme.platinum
                                font.family: "Consolas"
                                font.pixelSize: Math.max(15, Math.min(26, parent.width / 5))
                                font.bold: true
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.name
                                color: Theme.platinum
                                font.pixelSize: 7
                                font.bold: true
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.floor + " — " + modelData.ceiling
                                color: Theme.platinum
                                font.family: "Consolas"
                                font.pixelSize: 6
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: page.selectedZone = modelData
                        }
                    }
                }

                Repeater {
                    model: AirspaceData.airports
                    delegate: Item {
                        required property var modelData
                        visible: page.showAirports
                        x: chartFrame.width * modelData.x - 6
                        y: chartFrame.height * modelData.y - 6
                        width: 82
                        height: 28
                        Rectangle {
                            width: 11
                            height: 11
                            radius: 5
                            color: Theme.royalGold
                            border.color: Theme.platinum
                            border.width: 1
                        }
                        Text {
                            x: 15
                            y: -2
                            text: modelData.code
                            color: Theme.royalGold
                            font.family: "Consolas"
                            font.pixelSize: 7
                            font.bold: true
                        }
                        Text {
                            x: 15
                            y: 9
                            text: modelData.name
                            color: Theme.silver
                            font.pixelSize: 6
                        }
                    }
                }

                Repeater {
                    model: AirspaceData.navaids
                    delegate: Item {
                        required property var modelData
                        visible: page.showNavaids
                        x: chartFrame.width * modelData.x - 5
                        y: chartFrame.height * modelData.y - 5
                        width: 74
                        height: 25
                        Rectangle {
                            width: 9
                            height: 9
                            rotation: 45
                            color: Theme.rfViolet
                            border.color: Theme.platinum
                            border.width: 1
                        }
                        Text {
                            x: 14
                            y: -2
                            text: modelData.code
                            color: Theme.rfViolet
                            font.family: "Consolas"
                            font.pixelSize: 6
                            font.bold: true
                        }
                        Text {
                            x: 14
                            y: 8
                            text: modelData.type
                            color: Theme.muted
                            font.pixelSize: 5
                        }
                    }
                }

                Repeater {
                    model: cockpit.publicFlightTracks
                    delegate: Item {
                        required property var modelData
                        visible: page.showTraffic
                        x: chartFrame.width * page.lonToX(Number(modelData.longitude)) - 7
                        y: chartFrame.height * page.latToY(Number(modelData.latitude)) - 7
                        width: 96
                        height: 34
                        Rectangle {
                            width: 13
                            height: 13
                            radius: 6
                            color: Theme.signalCyan
                            border.color: Theme.platinum
                            border.width: 1
                            Rectangle {
                                anchors.centerIn: parent
                                width: 16
                                height: 2
                                color: Theme.signalCyan
                                rotation: Number(modelData.headingDegrees)
                                transformOrigin: Item.Center
                            }
                        }
                        Column {
                            x: 18
                            y: -2
                            spacing: 0
                            Text {
                                text: modelData.callsign || modelData.icao24
                                color: Theme.signalCyan
                                font.family: "Consolas"
                                font.pixelSize: 7
                                font.bold: true
                            }
                            Text {
                                text: Math.round(Number(modelData.altitudeMeters)) + "m  " + Math.round(Number(modelData.velocityMetersPerSecond)) + "m/s"
                                color: Theme.platinum
                                font.family: "Consolas"
                                font.pixelSize: 6
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: 8
                    width: 310
                    height: 36
                    color: Theme.panel
                    opacity: 0.94
                    border.color: Theme.warmOrange
                    border.width: 1
                    radius: Theme.radius
                    Text {
                        anchors.centerIn: parent
                        text: AirspaceLocale.notForNavigation(cockpit.language)
                        color: Theme.warmOrange
                        font.pixelSize: 7
                        font.bold: true
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 350
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 210
                    color: Theme.panel
                    border.color: page.selectedZone ? page.classColor(page.selectedZone.classCode) : Theme.border
                    border.width: 1
                    radius: Theme.radius

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 5
                        Text {
                            text: AirspaceLocale.details(cockpit.language)
                            color: Theme.platinum
                            font.pixelSize: 10
                            font.bold: true
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        RowLayout {
                            Layout.fillWidth: true
                            Rectangle {
                                Layout.preferredWidth: 52
                                Layout.preferredHeight: 52
                                color: page.selectedZone ? page.classColor(page.selectedZone.classCode) : Theme.panel2
                                radius: 26
                                Text {
                                    anchors.centerIn: parent
                                    text: page.selectedZone ? page.selectedZone.classCode : "-"
                                    color: Theme.darkNavy
                                    font.family: "Consolas"
                                    font.pixelSize: 24
                                    font.bold: true
                                }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1
                                Text {
                                    text: page.selectedZone ? page.selectedZone.name : "—"
                                    color: Theme.platinum
                                    font.pixelSize: 10
                                    font.bold: true
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: page.selectedZone ? page.selectedZone.id : "—"
                                    color: Theme.muted
                                    font.family: "Consolas"
                                    font.pixelSize: 7
                                }
                                Text {
                                    text: page.selectedZone && page.selectedZone.controlled ? AirspaceLocale.controlled(cockpit.language) : AirspaceLocale.uncontrolled(cockpit.language)
                                    color: page.selectedZone && page.selectedZone.controlled ? Theme.signalCyan : Theme.radarGreen
                                    font.pixelSize: 7
                                    font.bold: true
                                }
                            }
                        }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: 6
                            rowSpacing: 4
                            Text { text: cockpit.rtl ? "الحد السفلي" : "FLOOR"; color: Theme.muted; font.pixelSize: 6 }
                            Text { text: page.selectedZone ? page.selectedZone.floor : "—"; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            Text { text: cockpit.rtl ? "الحد العلوي" : "CEILING"; color: Theme.muted; font.pixelSize: 6 }
                            Text { text: page.selectedZone ? page.selectedZone.ceiling : "—"; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Text {
                            text: page.selectedZone ? page.selectedZone.note : ""
                            color: Theme.silver
                            font.pixelSize: 7
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 245
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 4
                        Text {
                            text: AirspaceLocale.legend(cockpit.language)
                            color: Theme.platinum
                            font.pixelSize: 10
                            font.bold: true
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: AirspaceData.classInfo
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 7
                                Rectangle {
                                    Layout.preferredWidth: 26
                                    Layout.preferredHeight: 22
                                    color: page.classColor(modelData.code)
                                    radius: Theme.radius
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.code
                                        color: Theme.darkNavy
                                        font.family: "Consolas"
                                        font.pixelSize: 8
                                        font.bold: true
                                    }
                                }
                                Text {
                                    text: modelData.description
                                    color: Theme.silver
                                    font.pixelSize: 6
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text {
                            text: cockpit.rtl ? "ملخص الصورة" : "PICTURE SUMMARY"
                            color: Theme.platinum
                            font.pixelSize: 10
                            font.bold: true
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: 8
                            rowSpacing: 7
                            Text { text: cockpit.rtl ? "القطاعات" : "SECTORS"; color: Theme.muted; font.pixelSize: 6 }
                            Text { text: String(AirspaceData.zones.length); color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 13; font.bold: true }
                            Text { text: AirspaceLocale.airports(cockpit.language); color: Theme.muted; font.pixelSize: 6 }
                            Text { text: String(AirspaceData.airports.length); color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 13; font.bold: true }
                            Text { text: AirspaceLocale.navaids(cockpit.language); color: Theme.muted; font.pixelSize: 6 }
                            Text { text: String(AirspaceData.navaids.length); color: Theme.rfViolet; font.family: "Consolas"; font.pixelSize: 13; font.bold: true }
                            Text { text: AirspaceLocale.traffic(cockpit.language); color: Theme.muted; font.pixelSize: 6 }
                            Text { text: String(cockpit.publicFlightTrackCount); color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 13; font.bold: true }
                        }
                        Item { Layout.fillHeight: true }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 54
                            color: Theme.panel2
                            border.color: Theme.signalCyan
                            border.width: 1
                            radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 1
                                Text {
                                    text: cockpit.publicFlightFeedStatus
                                    color: Theme.signalCyan
                                    font.family: "Consolas"
                                    font.pixelSize: 7
                                    font.bold: true
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: cockpit.rtl ? "يمكن تبديل مصدر الحركة العامة من شاشة الصورة الجوية / RF." : "Public traffic source can be changed from the Air Picture / RF tab."
                                    color: Theme.muted
                                    font.pixelSize: 6
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
