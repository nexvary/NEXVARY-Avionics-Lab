import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirForceManagementLocale.js" as ForceLocale

Item {
    id: page
    clip: true

    function stateColor(state) {
        var s = String(state || "").toUpperCase()
        if (s === "READY" || s === "AVAILABLE" || s === "NOMINAL" || s === "ON TIME" || s === "CURRENT") return Theme.green
        if (s === "LIMITED" || s === "CAUTION" || s === "REVIEW" || s === "PENDING") return Theme.amber
        if (s === "FAULT" || s === "CRITICAL" || s === "CLOSED") return Theme.red
        return Theme.accent
    }

    function scoreColor(score) {
        if (score >= 90) return Theme.green
        if (score >= 80) return Theme.gold
        return Theme.amber
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 9
        spacing: 6

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
                spacing: 10

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: ForceLocale.label(cockpit.language)
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: ForceLocale.subtitle(cockpit.language)
                        color: Theme.accent
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 310
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: page.scoreColor(cockpit.forceFleetReadinessPercent)
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 0
                        Text {
                            text: cockpit.rtl ? "حالة القوة التدريبية" : "TRAINING FORCE STATE"
                            color: Theme.silver
                            font.pixelSize: 7
                            font.bold: true
                        }
                        Text {
                            text: cockpit.forceReadyPlatformCount + " / " + cockpit.forceAssignedPlatformCount + (cockpit.rtl ? " منصة جاهزة" : " PLATFORMS READY")
                            color: page.scoreColor(cockpit.forceFleetReadinessPercent)
                            font.family: "Consolas"
                            font.pixelSize: 10
                            font.bold: true
                        }
                        Text {
                            text: "OFFLINE • SYNTHETIC • TRAINING"
                            color: Theme.muted
                            font.family: "Consolas"
                            font.pixelSize: 6
                        }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 82
            columns: 6
            columnSpacing: 6

            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "القواعد المتاحة" : "AVAILABLE BASES"
                value: cockpit.forceAvailableBaseCount + " / " + cockpit.forceBases.length
                subtitle: cockpit.rtl ? "صورة تدريبية" : "TRAINING PICTURE"
                iconText: "BAS"
                accent: Theme.accent
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "المنصات" : "PLATFORMS"
                value: String(cockpit.forceAssignedPlatformCount)
                subtitle: cockpit.rtl ? "موزعة على الأسراب" : "ASSIGNED TO SQUADRONS"
                iconText: "FLT"
                accent: Theme.platinum
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "جاهزية القوة" : "FORCE READINESS"
                value: cockpit.forceFleetReadinessPercent + "%"
                subtitle: cockpit.forceReadyPlatformCount + (cockpit.rtl ? " جاهزة" : " READY")
                iconText: "RDY"
                accent: page.scoreColor(cockpit.forceFleetReadinessPercent)
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "جاهزية الأطقم" : "CREW READINESS"
                value: cockpit.forceCrewReadinessPercent + "%"
                subtitle: cockpit.rtl ? "توافر تدريبي" : "TRAINING AVAILABILITY"
                iconText: "CRW"
                accent: page.scoreColor(cockpit.forceCrewReadinessPercent)
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "قيود الطقس" : "WEATHER LIMITS"
                value: String(cockpit.forceWeatherConstraintCount)
                subtitle: cockpit.rtl ? "تتطلب مراجعة" : "REVIEW REQUIRED"
                iconText: "WX"
                accent: cockpit.forceWeatherConstraintCount > 0 ? Theme.amber : Theme.green
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "الصيانة المفتوحة" : "OPEN MAINTENANCE"
                value: String(cockpit.forceOpenMaintenanceCount)
                subtitle: cockpit.rtl ? "بنود تخطيط" : "PLANNING ITEMS"
                iconText: "MNT"
                accent: Theme.gold
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            ColumnLayout {
                Layout.preferredWidth: Math.max(650, page.width * 0.44)
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 245
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text {
                            text: ForceLocale.bases(cockpit.language)
                            color: Theme.platinum
                            font.pixelSize: 10
                            font.bold: true
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 3
                            columnSpacing: 5
                            rowSpacing: 5
                            Repeater {
                                model: cockpit.forceBases
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: Theme.panel2
                                    border.color: page.stateColor(modelData.state)
                                    border.width: 1
                                    radius: Theme.radius
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 7
                                        spacing: 2
                                        Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.code + " • " + modelData.region; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                        Text { text: modelData.state; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                        Text { text: modelData.weather; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.runway; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
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
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.squadrons(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.forceSquadrons
                            clip: true
                            spacing: 4
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 58
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: page.stateColor(modelData.state)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 7
                                    Rectangle { width: 4; Layout.fillHeight: true; color: page.stateColor(modelData.state) }
                                    ColumnLayout {
                                        Layout.preferredWidth: 180
                                        spacing: 0
                                        Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.platform; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        RowLayout {
                                            Layout.fillWidth: true
                                            Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true }
                                            Text { text: modelData.ready + " / " + modelData.assigned; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                        }
                                        Rectangle {
                                            Layout.fillWidth: true
                                            height: 6
                                            color: Theme.panel
                                            radius: 3
                                            Rectangle {
                                                width: parent.width * Math.max(0, Math.min(modelData.assigned, modelData.ready)) / Math.max(1, modelData.assigned)
                                                height: parent.height
                                                color: page.stateColor(modelData.state)
                                                radius: 3
                                            }
                                        }
                                    }
                                    Text { text: modelData.state; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 225
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.training(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.forceTrainingRows
                            clip: true
                            spacing: 3
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 44
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 6
                                    Text { text: modelData.time; color: Theme.gold; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.preferredWidth: 48 }
                                    Text { text: modelData.group; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.preferredWidth: 82 }
                                    Text { text: modelData.item; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
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
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.maintenance(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.forceMaintenancePlanRows
                            clip: true
                            spacing: 3
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 48
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: modelData.priority === "P2" ? Theme.amber : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 6
                                    Text { text: modelData.priority; color: modelData.priority === "P2" ? Theme.amber : Theme.accent; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.platform + " / " + modelData.item; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.due; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 360
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 185
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.crew(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: cockpit.forceCrewRows
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 5
                                Text { text: modelData.role; color: Theme.silver; font.pixelSize: 6; Layout.preferredWidth: 120; elide: Text.ElideRight }
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 7
                                    color: Theme.panel2
                                    radius: 3
                                    Rectangle { width: parent.width * modelData.score / 100; height: parent.height; color: page.scoreColor(modelData.score); radius: 3 }
                                }
                                Text { text: modelData.ready; color: page.scoreColor(modelData.score); font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.preferredWidth: 48 }
                            }
                        }
                    }
                }

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
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.reports(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.forceExecutiveReports
                            clip: true
                            spacing: 3
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 52
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: page.stateColor(modelData.status)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 5
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.title; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.stamp; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                                    }
                                    Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            color: Theme.panel2
            border.color: Theme.green
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 7
                Text { text: "AIRSPACE"; color: Theme.accent; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 8 }
                Text { text: "AVIONICS"; color: Theme.platinum; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 8 }
                Text { text: "READINESS"; color: Theme.gold; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.silver; font.pixelSize: 8 }
                Text { text: "FORCE MANAGEMENT"; color: Theme.green; font.pixelSize: 6; font.bold: true }
                Item { Layout.fillWidth: true }
                Text {
                    text: cockpit.rtl ? "إدارة تدريبية وتحليلية فقط — لا تحكم حي ولا توجيه أسلحة" : "TRAINING / ANALYSIS ONLY • NO LIVE CONTROL • NO WEAPONS TASKING"
                    color: Theme.green
                    font.pixelSize: 6
                    font.bold: true
                    elide: Text.ElideRight
                }
            }
        }
    }
}
