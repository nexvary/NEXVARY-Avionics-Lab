import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    property int tracks: 0
    property int incidents: 0
    property int highCount: 0
    property var observations: 0
    property bool rtl: false
    color: Theme.panel
    border.color: Theme.royalGold
    border.width: 1
    radius: Theme.radius

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 5
        RowLayout {
            Layout.fillWidth: true
            Text { text: root.rtl ? "ملخص استجابة C-UAS" : "C-UAS RESPONSE SUMMARY"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
            Text { text: root.highCount > 0 ? (root.rtl ? "مراجعة" : "REVIEW") : "NOMINAL"; color: root.highCount > 0 ? Theme.warmOrange : Theme.radarGreen; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6
            Repeater {
                model: [
                    {n:"01", en:"DETECT", ar:"رصد", v:root.tracks, c:Theme.signalCyan},
                    {n:"02", en:"CLASSIFY", ar:"تصنيف", v:root.tracks, c:Theme.rfViolet},
                    {n:"03", en:"VERIFY", ar:"تحقق", v:root.highCount, c:Theme.royalGold},
                    {n:"04", en:"COORDINATE", ar:"تنسيق", v:root.incidents, c:Theme.radarGreen},
                    {n:"05", en:"RECORD", ar:"توثيق", v:root.observations, c:Theme.skyBlue}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: modelData.c
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 1
                        Text { text: modelData.n; color: modelData.c; font.family:"Consolas"; font.pixelSize:6; font.bold:true }
                        Item { Layout.fillHeight: true }
                        Text { text: String(modelData.v); color: modelData.c; font.family:"Consolas"; font.pixelSize:16; font.bold:true }
                        Text { text: root.rtl ? modelData.ar : modelData.en; color: Theme.platinum; font.pixelSize:6; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                    }
                }
            }
        }
        Text {
            text: root.rtl ? "وعي وتنسيق واستجابة تدريبية فقط — دون تشويش أو استحواذ أو اشتباك حي" : "AWARENESS / COORDINATION / TRAINING RESPONSE ONLY — NO JAMMING, TAKEOVER OR LIVE ENGAGEMENT"
            color: Theme.muted
            font.pixelSize: 5
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }
    }
}
