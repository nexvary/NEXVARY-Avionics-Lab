import QtQuick
import "Theme.js" as Theme

Item {
    id: root
    property var series: []
    property real cursorRatio: 0.72
    property bool cursorVisible: true

    // Distinct but restrained engineering palette for visual separation.
    // Colors are intentionally limited to telemetry traces, not the whole UI.
    property var colors: [
        "#4EA7E0", // electric blue
        "#55C7C2", // cyan / teal
        "#D29A48", // amber
        "#6FB58A", // nominal green
        "#9C7AD6", // diagnostic violet
        "#B7C0C7"  // metallic silver
    ]

    Rectangle {
        anchors.fill: parent
        color: Theme.panel2
        border.color: Theme.border
        border.width: Theme.frameWidth
        radius: Theme.radius
    }

    Canvas {
        id: plot
        anchors.fill: parent
        anchors.margins: 1

        onPaint: {
            var c = getContext("2d")
            c.reset()

            c.strokeStyle = Theme.grid
            c.lineWidth = 1
            c.globalAlpha = 0.75
            for (var gx = 1; gx < 10; ++gx) {
                var x = gx * width / 10
                c.beginPath()
                c.moveTo(x, 0)
                c.lineTo(x, height)
                c.stroke()
            }
            for (var gy = 1; gy < 6; ++gy) {
                var y = gy * height / 6
                c.beginPath()
                c.moveTo(0, y)
                c.lineTo(width, y)
                c.stroke()
            }
            c.globalAlpha = 1

            if (!root.series)
                return

            for (var s = 0; s < root.series.length; ++s) {
                var row = root.series[s]
                var values = row.values
                if (!values || values.length < 2)
                    continue

                var lo = Number(row.minimum)
                var hi = Number(row.maximum)
                if (Math.abs(hi - lo) < 0.0001)
                    hi = lo + 1

                c.strokeStyle = root.colors[s % root.colors.length]
                c.lineWidth = 1.8
                c.globalAlpha = 0.96
                c.beginPath()

                for (var i = 0; i < values.length; ++i) {
                    var px = i * width / Math.max(1, values.length - 1)
                    var n = (Number(values[i]) - lo) / (hi - lo)
                    var py = height - Math.max(0, Math.min(1, n)) * height
                    if (i === 0)
                        c.moveTo(px, py)
                    else
                        c.lineTo(px, py)
                }
                c.stroke()
            }
            c.globalAlpha = 1

            if (root.cursorVisible) {
                var cx = Math.max(0, Math.min(width, width * root.cursorRatio))
                c.strokeStyle = Theme.platinum
                c.globalAlpha = 0.55
                c.lineWidth = 1
                c.setLineDash([3, 4])
                c.beginPath()
                c.moveTo(cx, 0)
                c.lineTo(cx, height)
                c.stroke()
                c.setLineDash([])
                c.globalAlpha = 1
            }
        }

        Connections {
            target: cockpit
            function onDataChanged() {
                plot.requestPaint()
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: function(mouse) {
            root.cursorRatio = Math.max(0, Math.min(1, mouse.x / width))
            plot.requestPaint()
        }
    }
}
