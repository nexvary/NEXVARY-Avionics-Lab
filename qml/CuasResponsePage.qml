import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function severityColor(level) {
        var v = String(level || "").toUpperCase()
        if (v === "CRITICAL" || v === "HIGH") return Theme.warmOrange
        if (v === "MEDIUM") return Theme.royalGold
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
                        text: cockpit.rtl ? "مركز الاستجابة للطائرات المسيّرة" : "C-UAS RESPONSE CENTER"
                        color: Theme.platinum
                        font.pixelSize: 19
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "رصد وتصنيف وتحقق وتنسيق استجابة تدريبية مع سجل حوادث — بدون تحكم أو تشويش حي" : "DETECT, CLASSIFY, VERIFY AND COORDINATE TRAINING RESPONSE WITH INCIDENT EVIDENCE — NO LIVE CONTROL OR JAMMING"
                        color: Theme.signalCyan
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 255
                    Layout.preferredHeight: 48
                    color: Theme.panel2
                    border.color: Theme.warmOrange
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 1
                        Text { text: cockpit.rtl ? "محاكاة استجابة فقط" : "RESPONSE SIMULATION ONLY"; color: Theme.warmOrange; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                        Text { text: "AEGIS C-UAS / AWARENESS + REVIEW"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
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
                    {title: cockpit.rtl ? "المسارات" : "TRACKS", value: cockpit.airOperationsTrackCount, color: Theme.signalCyan},
                    {title: cockpit.rtl ? "الحوادث" : "INCIDENTS", value: cockpit.airOperationsIncidentCount, color: Theme.royalGold},
                    {title: cockpit.rtl ? "عالية الأولوية" : "HIGH PRIORITY", value: cockpit.airOperationsHighCount, color: Theme.warmOrange},
                    {title: cockpit.rtl ? "المشاهدات" : "OBSERVATIONS", value: cockpit.airOperationsObservationCount, color: Theme.radarGreen}
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
                        Text { text: cockpit.airOperationsMode; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; elide: Text.ElideRight; Layout.fillWidth: true }
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
                color: "#0E1921"
                border.color: Theme.signalCyan
                border.width: 1
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "صورة التهديدات الجوية" : "AIR THREAT PICTURE"; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                        Text { text: cockpit.airOperationsSource; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: cockpit.airOperationsTracks
                        clip: true
                        spacing: 4
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: 64
                            color: Theme.panel2
                            border.color: page.severityColor(modelData.threatLevel || modelData.level)
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 8
                                Rectangle {
                                    width: 42; height: 42; radius: 21
                                    color: Theme.panel3
                                    border.color: page.severityColor(modelData.threatLevel || modelData.level)
                                    border.width: 2
                                    Text { anchors.centerIn: parent; text: "UAS"; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: modelData.trackId || modelData.id || "TRACK"; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: (modelData.classification || "UNKNOWN") + "  •  " + (modelData.sensors || "SENSOR FUSION"); color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: "CONF " + Math.round(Number(modelData.confidence || 0) * 100) + "%"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                                }
                                ColumnLayout {
                                    Layout.preferredWidth: 130
                                    spacing: 1
                                    Text { text: String(modelData.threatLevel || modelData.level || "REVIEW").toUpperCase(); color: page.severityColor(modelData.threatLevel || modelData.level); font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                                    Text { text: "AWARENESS"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 410
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 245
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "سير الاستجابة التدريبية" : "TRAINING RESPONSE WORKFLOW"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: [
                                {n:"01", en:"DETECT", ar:"الرصد", c:Theme.signalCyan},
                                {n:"02", en:"CLASSIFY", ar:"التصنيف", c:Theme.rfViolet},
                                {n:"03", en:"VERIFY", ar:"التحقق", c:Theme.royalGold},
                                {n:"04", en:"COORDINATE", ar:"التنسيق", c:Theme.radarGreen},
                                {n:"05", en:"RECORD", ar:"التوثيق", c:Theme.skyBlue}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 34
                                color: Theme.panel2
                                border.color: modelData.c
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    Text { text: modelData.n; color: modelData.c; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.preferredWidth: 30 }
                                    Text { text: cockpit.rtl ? modelData.ar : modelData.en; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true }
                                    Text { text: "READY"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 6 }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.warmOrange
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "الحوادث والسجل" : "INCIDENT REVIEW"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.airOperationsIncidents
                            clip: true
                            spacing: 4
                            delegate: Rectangle {
                                required property var modelData
                                width: ListView.view.width
                                height: 54
                                color: Theme.panel2
                                border.color: page.severityColor(modelData.peakThreatLevel || modelData.level)
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 1
                                    Text { text: modelData.trackId || modelData.incidentId || "INCIDENT"; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.summary || modelData.status || "Review record"; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: String(modelData.peakThreatLevel || modelData.level || "REVIEW").toUpperCase(); color: page.severityColor(modelData.peakThreatLevel || modelData.level); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                }
                            }
                        }
                        Text {
                            text: cockpit.rtl ? "لا يتضمن هذا القسم اعتراضًا فعليًا أو تشويشًا أو استحواذًا أو توجيه اشتباك." : "NO LIVE INTERCEPTION, JAMMING, TAKEOVER OR ENGAGEMENT CONTROL IS PROVIDED."
                            color: Theme.warmOrange
                            font.pixelSize: 7
                            font.bold: true
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
