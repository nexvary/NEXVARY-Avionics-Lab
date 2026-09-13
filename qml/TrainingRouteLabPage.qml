import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirspaceData.js" as AirspaceData
import "AirspaceLocale.js" as AirspaceLocale
import "RouteAnalysis.js" as RouteAnalysis

Item {
    id: page
    clip: true
    property int selectedPreset: 0
    property var routePoints: AirspaceData.routePresets[selectedPreset].points
    property var routeSummary: RouteAnalysis.summary(routePoints, AirspaceData.zones)

    function classColor(code) {
        if (code === "A") return Theme.royalGold
        if (code === "B") return Theme.rfViolet
        if (code === "C") return Theme.signalCyan
        if (code === "D") return Theme.warmOrange
        if (code === "E") return Theme.skyBlue
        if (code === "F") return Theme.amber
        return Theme.radarGreen
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
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
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: cockpit.rtl ? "مختبر تحليل المسار التدريبي" : "TRAINING ROUTE LAB"
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "تحليل المسافة والقطاعات وتصنيفات المجال على مسارات تدريبية قابلة للتبديل" : "DISTANCE, SECTOR AND AIRSPACE-CLASS REVIEW ACROSS SELECTABLE TRAINING ROUTES"
                        color: Theme.radarGreen
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }

                ComboBox {
                    id: routePresetBox
                    model: AirspaceData.routePresets
                    textRole: "name"
                    Layout.preferredWidth: 210
                    currentIndex: page.selectedPreset
                    contentItem: Text {
                        text: routePresetBox.displayText
                        color: Theme.platinum
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 8
                        font.bold: true
                        elide: Text.ElideRight
                    }
                    background: Rectangle {
                        color: Theme.panel2
                        border.color: Theme.radarGreen
                        border.width: 1
                        radius: Theme.radius
                    }
                    onActivated: page.selectedPreset = currentIndex
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
                        anchors.margins: 6
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
                            text: AirspaceData.routePresets[page.selectedPreset].id + " / TRAINING SCALE"
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

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            spacing: 7
            Repeater {
                model: [
                    {title: cockpit.rtl ? "المسافة" : "DISTANCE", value: routeSummary.distanceKm + " km", color: Theme.signalCyan},
                    {title: cockpit.rtl ? "المقاطع" : "SEGMENTS", value: routeSummary.segmentCount, color: Theme.royalGold},
                    {title: cockpit.rtl ? "القطاعات المتقاطعة" : "CROSSED ZONES", value: routeSummary.zoneCount, color: Theme.rfViolet},
                    {title: cockpit.rtl ? "متحكم بها" : "CONTROLLED", value: routeSummary.controlledCount, color: Theme.radarGreen}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: modelData.color
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 2
                        Text { text: modelData.title; color: Theme.silver; font.pixelSize: 7; font.bold: true }
                        Text { text: String(modelData.value); color: modelData.color; font.family: "Consolas"; font.pixelSize: 20; font.bold: true }
                        Text { text: "TRAINING ANALYSIS"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7

            Rectangle {
                id: mapFrame
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#10222A"
                border.color: Theme.border
                border.width: 1
                radius: Theme.radius
                clip: true

                Canvas {
                    id: routeCanvas
                    anchors.fill: parent
                    onPaint: {
                        var c = getContext("2d")
                        c.reset()
                        c.fillStyle = "#102A37"
                        c.fillRect(0, 0, width, height)
                        c.strokeStyle = "#284552"
                        c.lineWidth = 1
                        for (var gx = 0; gx <= 10; ++gx) {
                            var x = width * gx / 10
                            c.beginPath()
                            c.moveTo(x, 0)
                            c.lineTo(x, height)
                            c.stroke()
                        }
                        for (var gy = 0; gy <= 8; ++gy) {
                            var y = height * gy / 8
                            c.beginPath()
                            c.moveTo(0, y)
                            c.lineTo(width, y)
                            c.stroke()
                        }
                        c.strokeStyle = Theme.radarGreen
                        c.lineWidth = 3
                        c.beginPath()
                        for (var i = 0; i < page.routePoints.length; ++i) {
                            var p = page.routePoints[i]
                            var px = width * p.x
                            var py = height * p.y
                            if (i === 0) c.moveTo(px, py)
                            else c.lineTo(px, py)
                        }
                        c.stroke()
                    }
                }

                onWidthChanged: routeCanvas.requestPaint()
                onHeightChanged: routeCanvas.requestPaint()
                Connections {
                    target: page
                    function onSelectedPresetChanged() { routeCanvas.requestPaint() }
                }

                Repeater {
                    model: AirspaceData.zones
                    delegate: Rectangle {
                        required property var modelData
                        x: mapFrame.width * modelData.x
                        y: mapFrame.height * modelData.y
                        width: mapFrame.width * modelData.w
                        height: mapFrame.height * modelData.h
                        color: page.classColor(modelData.classCode)
                        opacity: 0.16
                        border.color: page.classColor(modelData.classCode)
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: modelData.classCode
                            color: Theme.platinum
                            font.family: "Consolas"
                            font.pixelSize: 16
                            font.bold: true
                        }
                    }
                }

                Repeater {
                    model: page.routePoints
                    delegate: Rectangle {
                        required property int index
                        required property var modelData
                        x: mapFrame.width * modelData.x - 7
                        y: mapFrame.height * modelData.y - 7
                        width: 14
                        height: 14
                        radius: 7
                        color: index === 0 ? Theme.royalGold : (index === page.routePoints.length - 1 ? Theme.warmOrange : Theme.radarGreen)
                        border.color: Theme.platinum
                        border.width: 1
                        Text {
                            x: 17
                            y: -3
                            text: "WP" + (index + 1)
                            color: Theme.platinum
                            font.family: "Consolas"
                            font.pixelSize: 7
                            font.bold: true
                        }
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: 8
                    width: 350
                    height: 48
                    color: Theme.panel
                    opacity: 0.95
                    border.color: Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 1
                        Text {
                            text: routeSummary.advisory
                            color: Theme.radarGreen
                            font.family: "Consolas"
                            font.pixelSize: 7
                            font.bold: true
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            text: "CLASSES  " + routeSummary.classes.join(" / ")
                            color: Theme.silver
                            font.family: "Consolas"
                            font.pixelSize: 6
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 390
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 230
                    color: Theme.panel
                    border.color: Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "القطاعات المتقاطعة" : "CROSSED AIRSPACE"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: routeSummary.zones
                            clip: true
                            spacing: 3
                            delegate: Rectangle {
                                required property var modelData
                                width: ListView.view.width
                                height: 42
                                color: Theme.panel2
                                border.color: page.classColor(modelData.classCode)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 6
                                    Rectangle {
                                        width: 28
                                        height: 28
                                        radius: 14
                                        color: Theme.panel3
                                        border.color: page.classColor(modelData.classCode)
                                        border.width: 1
                                        Text { anchors.centerIn: parent; text: modelData.classCode; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.floor + " → " + modelData.ceiling; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 170
                    color: Theme.panel
                    border.color: Theme.signalCyan
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "نقاط المسار" : "ROUTE WAYPOINTS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: page.routePoints
                            delegate: RowLayout {
                                required property int index
                                required property var modelData
                                Layout.fillWidth: true
                                Text { text: "WP" + (index + 1); color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.preferredWidth: 42 }
                                Text { text: "X " + modelData.x.toFixed(3) + "   Y " + modelData.y.toFixed(3); color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true }
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
                        Text { text: cockpit.rtl ? "ملاحظات التحليل" : "ANALYSIS NOTES"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: cockpit.rtl ? "• المسافة تقريبية ومبنية على مقياس تدريب داخلي." : "• Distance is approximate and uses an internal training scale."; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        Text { text: cockpit.rtl ? "• يمكن تبديل المسارات لمقارنة عبور التصنيفات المختلفة." : "• Presets can be switched to compare different class crossings."; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        Text { text: cockpit.rtl ? "• لا توجد أوامر طيران أو توجيه تشغيلي حي." : "• No live flight commands or operational guidance are produced."; color: Theme.warmOrange; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                    }
                }
            }
        }
    }
}
