import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function scoreColor(v) {
        if (v >= 90) return Theme.radarGreen
        if (v >= 80) return Theme.royalGold
        return Theme.warmOrange
    }
    function stateColor(s) {
        var v = String(s || "").toUpperCase()
        if (v === "READY" || v === "AVAILABLE" || v === "NOMINAL" || v === "CURRENT" || v === "ON TIME") return Theme.radarGreen
        if (v === "LIMITED" || v === "REVIEW" || v === "PENDING" || v === "CAUTION") return Theme.royalGold
        return Theme.warmOrange
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 58
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 9
                spacing: 10
                Rectangle { width: 4; Layout.fillHeight: true; color: Theme.signalCyan; radius: 2 }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: cockpit.rtl ? "مركز إدارة القوة الجوية" : "AIR FORCE MANAGEMENT CENTER"
                        color: Theme.platinum
                        font.pixelSize: 19
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "المجال الجوي • القواعد • الأسراب • الجاهزية • الأطقم • الصيانة • التدريب" : "AIRSPACE • BASES • SQUADRONS • READINESS • CREWS • SUSTAINMENT • TRAINING"
                        color: Theme.signalCyan
                        font.pixelSize: 10
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }
                RowLayout {
                    spacing: 5
                    Rectangle {
                        width: 104; height: 34; color: Theme.panel2; border.color: Theme.border; border.width: 1
                        Column { anchors.centerIn: parent; spacing: 0
                            Text { text: cockpit.rtl ? "القواعد" : "BASES"; color: Theme.muted; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                    }
                    Rectangle {
                        width: 104; height: 34; color: Theme.panel2; border.color: Theme.border; border.width: 1
                        Column { anchors.centerIn: parent; spacing: 0
                            Text { text: cockpit.rtl ? "الأسطول" : "FLEET"; color: Theme.muted; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: cockpit.forceFleetReadinessPercent + "%"; color: page.scoreColor(cockpit.forceFleetReadinessPercent); font.family: "Consolas"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                    }
                    Rectangle {
                        width: 104; height: 34; color: Theme.panel2; border.color: Theme.border; border.width: 1
                        Column { anchors.centerIn: parent; spacing: 0
                            Text { text: cockpit.rtl ? "الأطقم" : "CREWS"; color: Theme.muted; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: cockpit.forceCrewReadinessPercent + "%"; color: page.scoreColor(cockpit.forceCrewReadinessPercent); font.family: "Consolas"; font.pixelSize: 10; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 760
                color: Theme.panel
                border.color: Theme.signalCyan
                border.width: 1
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "الصورة الجوية وإتاحة القواعد" : "AIRSPACE & BASE AVAILABILITY"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text { text: "PUBLIC ADS-B  •  AEGIS AWARENESS  •  TRAINING DATA"; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 10 }
                    }
                    CommandAirMap {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        publicTracks: cockpit.publicFlightTracks
                        aegisTracks: cockpit.airOperationsTracks
                        rtl: cockpit.rtl
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 82
                        color: Theme.panel2
                        border.color: Theme.borderSoft
                        border.width: 1
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 4
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: cockpit.rtl ? "القواعد والمطارات" : "BASES & AIRFIELDS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                                Text { text: cockpit.forceWeatherConstraintCount + (cockpit.rtl ? " قيود طقس" : " WEATHER LIMITS"); color: cockpit.forceWeatherConstraintCount > 0 ? Theme.royalGold : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 5
                                Repeater {
                                    model: cockpit.forceBases
                                    delegate: Rectangle {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: Theme.panel
                                        border.color: Number(modelData.supportPercent) >= 90 ? Theme.radarGreen : Theme.royalGold
                                        border.width: 1
                                        radius: Theme.radius
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 5
                                            spacing: 0
                                            RowLayout {
                                                Layout.fillWidth: true
                                                Rectangle { width: 7; height: 7; radius: 3; color: Number(modelData.supportPercent) >= 90 ? Theme.radarGreen : Theme.royalGold }
                                                Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                                Text { text: modelData.supportPercent + "%"; color: Number(modelData.supportPercent) >= 90 ? Theme.radarGreen : Theme.royalGold; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                                            }
                                            Text { text: modelData.runway + " • " + modelData.weather; color: Theme.silver; font.pixelSize: 10; Layout.fillWidth: true; elide: Text.ElideRight }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: Math.min(430, Math.max(350, page.width * 0.28))
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        Text { text: cockpit.rtl ? "حالة القوة" : "FORCE STATUS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            rowSpacing: 5
                            columnSpacing: 8
                            Text { text: cockpit.rtl ? "منصات جاهزة" : "READY PLATFORMS"; color: Theme.muted; font.pixelSize: 10 }
                            Text { text: cockpit.forceReadyPlatformCount + " / " + cockpit.forceAssignedPlatformCount; color: page.scoreColor(cockpit.forceFleetReadinessPercent); font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: cockpit.rtl ? "الصيانة المفتوحة" : "OPEN MAINTENANCE"; color: Theme.muted; font.pixelSize: 10 }
                            Text { text: String(cockpit.forceOpenMaintenanceCount); color: cockpit.forceOpenMaintenanceCount > 0 ? Theme.royalGold : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: cockpit.rtl ? "حوادث الوعي الجوي" : "AIRSPACE INCIDENTS"; color: Theme.muted; font.pixelSize: 10 }
                            Text { text: String(cockpit.airOperationsIncidentCount); color: cockpit.airOperationsIncidentCount > 0 ? Theme.warmOrange : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: cockpit.rtl ? "صحة البيانات" : "DATA HEALTH"; color: Theme.muted; font.pixelSize: 10 }
                            Text { text: "NOMINAL"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "جاهزية الأسراب" : "SQUADRON READINESS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount; color: page.scoreColor(cockpit.forceFleetReadinessPercent); font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 4
                            model: cockpit.forceSquadrons
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 61
                                color: index % 2 ? Theme.panel2 : Theme.panel
                                border.color: Theme.border
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 2
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.ready + "/" + modelData.assigned; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                                    }
                                    Text { text: modelData.platform + "  •  CREW " + modelData.crewReady + "/" + modelData.crewRequired; color: Theme.silver; font.pixelSize: 10; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 5
                                        color: Theme.panel3
                                        radius: 2
                                        Rectangle { width: parent.width * Number(modelData.ready) / Math.max(1, Number(modelData.assigned)); height: parent.height; radius: 2; color: page.stateColor(modelData.state) }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 188
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "الصيانة والتدريب" : "SUSTAINMENT & TRAINING"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.forceOpenMaintenanceCount + " MNT"; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 78
                            clip: true
                            spacing: 2
                            model: cockpit.forceMaintenancePlanRows
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width
                                height: 24
                                spacing: 5
                                Text { text: modelData.priority; color: modelData.priority === "P2" ? Theme.warmOrange : Theme.royalGold; font.family: "Consolas"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 26 }
                                Text { text: modelData.platform + " / " + modelData.item; color: Theme.silver; font.pixelSize: 10; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.due; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 10 }
                            }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 2
                            model: cockpit.forceTrainingRows
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width
                                height: 23
                                spacing: 5
                                Text { text: modelData.time; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 40 }
                                Text { text: modelData.group; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 74; elide: Text.ElideRight }
                                Text { text: modelData.item; color: Theme.silver; font.pixelSize: 10; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            color: Theme.panel2
            border.color: Theme.borderSoft
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 12
                Text { text: "ADS-B"; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                Text { text: "AEGIS AWARENESS"; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                Text { text: "DIGITAL TWIN"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                Text { text: cockpit.rtl ? "مصادر البيانات وحالتها ظاهرة — إدارة وتدريب فقط" : "SOURCE-AWARE DATA • MANAGEMENT / TRAINING ONLY"; color: Theme.muted; font.pixelSize: 10; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignLeft : Text.AlignRight }
            }
        }
    }
}
