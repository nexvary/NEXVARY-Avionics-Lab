import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirReadinessLocale.js" as ReadyLocale

Item {
    id: page
    clip: true

    function readinessColor(value) {
        if (value >= 90) return Theme.green
        if (value >= 80) return Theme.gold
        return Theme.amber
    }

    function stateColor(state) {
        if (state === "READY") return Theme.green
        if (state === "LIMITED") return Theme.amber
        return Theme.red
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: ReadyLocale.label(cockpit.language)
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Text {
                        text: ReadyLocale.subtitle(cockpit.language)
                        color: Theme.accent
                        font.pixelSize: 9
                        font.bold: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 300
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: readinessColor(cockpit.readinessFleetPercent)
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 1
                        Text { text: cockpit.rtl ? "حالة الجاهزية التنفيذية" : "EXECUTIVE READINESS STATE"; color: Theme.silver; font.pixelSize: 8; font.bold: true }
                        Text { text: cockpit.readinessStatus; color: readinessColor(cockpit.readinessFleetPercent); font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                        Text { text: cockpit.rtl ? "بيانات صناعية للتدريب والتحليل فقط" : "SYNTHETIC TRAINING / ANALYSIS DATA"; color: Theme.muted; font.pixelSize: 7 }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            columns: 4
            columnSpacing: 7
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: ReadyLocale.fleet(cockpit.language); value: cockpit.readinessFleetPercent + "%"; subtitle: cockpit.rtl ? "متوسط الجاهزية الصناعية" : "SYNTHETIC FLEET AVERAGE"; iconText: "FLT"; accent: readinessColor(cockpit.readinessFleetPercent) }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: ReadyLocale.ready(cockpit.language); value: cockpit.readinessReadyCount + " / " + cockpit.readinessAssets.length; subtitle: cockpit.rtl ? "جاهزة للدورة التدريبية" : "READY FOR TRAINING CYCLE"; iconText: "RDY"; accent: Theme.green }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: ReadyLocale.maintenance(cockpit.language); value: String(cockpit.readinessMaintenanceOpenCount); subtitle: cockpit.rtl ? "بنود متابعة هندسية" : "ENGINEERING FOLLOW-UP ITEMS"; iconText: "MNT"; accent: Theme.gold }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: ReadyLocale.crew(cockpit.language); value: cockpit.readinessCrewPercent + "%"; subtitle: cockpit.rtl ? "توافر الأطقم التدريبية" : "TRAINING CREW AVAILABILITY"; iconText: "CRW"; accent: Theme.accent }
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
                border.width: Theme.frameWidth
                radius: Theme.radius
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 5

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: ReadyLocale.platformState(cockpit.language); color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                        Text { text: "ENGINEERING READINESS MATRIX"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    ListView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 280
                        clip: true
                        spacing: 4
                        model: cockpit.readinessAssets
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            width: ListView.view.width
                            height: 64
                            color: modelData.active ? Theme.panel3 : (index % 2 ? Theme.panel2 : Theme.panel)
                            border.color: modelData.active ? Theme.accent : Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 9

                                Rectangle { width: 4; height: 40; color: stateColor(modelData.state) }
                                ColumnLayout {
                                    Layout.preferredWidth: 170
                                    spacing: 1
                                    Text { text: modelData.tail + "  /  " + modelData.name; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.category; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                }

                                ColumnLayout {
                                    Layout.preferredWidth: 150
                                    spacing: 2
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true }
                                        Text { text: modelData.readiness + "%"; color: readinessColor(modelData.readiness); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                    }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 7
                                        color: Theme.panel3
                                        radius: 3
                                        Rectangle { width: parent.width * modelData.readiness / 100; height: parent.height; radius: 3; color: readinessColor(modelData.readiness) }
                                    }
                                }

                                ColumnLayout {
                                    Layout.preferredWidth: 128
                                    spacing: 1
                                    Text { text: cockpit.rtl ? "الطاقم" : "CREW"; color: Theme.muted; font.pixelSize: 7 }
                                    Text { text: modelData.crewReady + " / " + modelData.crewRequired; color: modelData.crewReady === modelData.crewRequired ? Theme.green : Theme.amber; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                }

                                ColumnLayout {
                                    Layout.preferredWidth: 130
                                    spacing: 1
                                    Text { text: cockpit.rtl ? "للفحص التالي" : "TO INSPECTION"; color: Theme.muted; font.pixelSize: 7 }
                                    Text { text: modelData.hoursToInspection + " h"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: ReadyLocale.trainingPlan(cockpit.language); color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.trainingSlot; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 78
                                    Layout.preferredHeight: 26
                                    color: Theme.panel3
                                    border.color: stateColor(modelData.state)
                                    border.width: 1
                                    radius: Theme.radius
                                    Text { anchors.centerIn: parent; text: modelData.state; color: stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                    Text { text: ReadyLocale.integration(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 4
                        columnSpacing: 5
                        Repeater {
                            model: [
                                {"code":"01", "title":"AEGIS C-UAS", "detail": cockpit.rtl ? "وعي بالمجال الجوي والحوادث" : "Airspace awareness and incident context"},
                                {"code":"02", "title":"AIR OPS EXCHANGE", "detail": cockpit.rtl ? "عقد تبادل رصد آمن" : "Awareness-only exchange contract"},
                                {"code":"03", "title":"AVIONICS LAB", "detail": cockpit.rtl ? "التوأم الرقمي والتشخيص" : "Digital twin and diagnostics"},
                                {"code":"04", "title":"READINESS OPS", "detail": cockpit.rtl ? "الجاهزية والصيانة والأطقم" : "Readiness, maintenance and crews"}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 78
                                color: Theme.panel2
                                border.color: modelData.code === "04" ? Theme.gold : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 7
                                    spacing: 2
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: modelData.code; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                        Text { text: modelData.title; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    Text { text: modelData.detail; color: Theme.silver; font.pixelSize: 7; wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight; Layout.fillWidth: true }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 420
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 6

                    Text { text: ReadyLocale.maintenanceQueue(cockpit.language); color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 4
                        model: cockpit.readinessMaintenanceRows
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            width: ListView.view.width
                            height: 82
                            color: index % 2 ? Theme.panel2 : Theme.panel3
                            border.color: modelData.priority === "P2" ? Theme.amber : Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 2
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text { text: modelData.priority + "  /  " + modelData.platform; color: modelData.priority === "P2" ? Theme.amber : Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true }
                                    Text { text: modelData.due; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                }
                                Text { text: modelData.system + "  •  " + modelData.state; color: Theme.silver; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.action; color: Theme.muted; font.pixelSize: 7; wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight; Layout.fillWidth: true }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 64
                        color: Theme.panel3
                        border.color: Theme.green
                        border.width: 1
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 2
                            Text { text: ReadyLocale.boundary(cockpit.language); color: Theme.green; font.pixelSize: 8; font.bold: true }
                            Text { text: ReadyLocale.boundaryText(cockpit.language); color: Theme.silver; font.pixelSize: 7; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                        }
                    }
                }
            }
        }
    }
}
