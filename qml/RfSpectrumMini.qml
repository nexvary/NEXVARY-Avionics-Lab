import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    property var bins: []
    property double peakFrequencyMhz: 0
    property double peakLevelDbm: -110
    property bool rtl: false
    color: Theme.panel
    border.color: Theme.border
    border.width: 1
    radius: Theme.radius
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4
        RowLayout {
            Layout.fillWidth: true
            Text { text: root.rtl ? "مراقبة الطيف الترددي السلبي" : "PASSIVE RF SPECTRUM"; color: Theme.platinum; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
            Rectangle { width: 7; height: 7; radius: 4; color: Theme.radarGreen }
            Text { text: Number(root.peakFrequencyMhz).toFixed(1) + " MHz"; color: Theme.rfViolet; font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#151515"
            border.color: Theme.borderSoft
            border.width: 1
            radius: Theme.radius
            Row {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 1
                Repeater {
                    model: root.bins
                    delegate: Rectangle {
                        required property var modelData
                        width: Math.max(2, (parent.width - 64) / Math.max(1, root.bins.length))
                        height: Math.max(3, Math.min(parent.height, ((Number(modelData.levelDbm) + 110.0) / 80.0) * parent.height))
                        anchors.bottom: parent.bottom
                        color: Number(modelData.levelDbm) > -60 ? Theme.warmOrange : (Number(modelData.levelDbm) > -78 ? Theme.rfViolet : Theme.signalCyan)
                        opacity: 0.9
                    }
                }
            }
            Text { anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 5; text: "-30"; color: Theme.muted; font.family:"Consolas"; font.pixelSize: Theme.smallPx }
            Text { anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 5; text: "-110"; color: Theme.muted; font.family:"Consolas"; font.pixelSize: Theme.smallPx }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: Theme.warmOrange
                opacity: 0.45
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Text { text: root.rtl ? "استقبال / عرض فقط" : "RECEIVE / VISUALIZE ONLY"; color: Theme.radarGreen; font.pixelSize: Theme.smallPx; font.bold: true }
            Item { Layout.fillWidth: true }
            Text { text: Number(root.peakLevelDbm).toFixed(1) + " dBm PEAK"; color: Theme.silver; font.family:"Consolas"; font.pixelSize: Theme.smallPx }
        }
    }
}
