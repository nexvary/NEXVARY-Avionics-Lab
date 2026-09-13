import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function readinessColor(v) {
        if (v >= 90) return Theme.radarGreen
        if (v >= 80) return Theme.royalGold
        return Theme.warmOrange
    }

    function stateColor(state) {
        var s = String(state || "").toUpperCase()
        if (s === "READY" || s === "AVAILABLE" || s === "NOMINAL" || s === "ON TIME" || s === "CURRENT") return Theme.radarGreen
        if (s === "LIMITED" || s === "CAUTION" || s === "REVIEW" || s === "PENDING") return Theme.royalGold
        if (s === "FAULT" || s === "CRITICAL" || s === "CLOSED") return Theme.warmOrange
        return Theme.signalCyan
    }

    function executiveState() {
        if (cockpit.forceWeatherConstraintCount > 0 || cockpit.forceOpenMaintenanceCount > 0 || cockpit.airOperationsIncidentCount > 0)
            return cockpit.rtl ? "توجد عناصر تتطلب مراجعة" : "REVIEW ITEMS PRESENT"
        if (cockpit.forceFleetReadinessPercent < 85 || cockpit.forceCrewReadinessPercent < 85)
            return cockpit.rtl ? "جاهزية محدودة" : "LIMITED READINESS"
        return cockpit.rtl ? "الحالة مستقرة" : "MANAGEMENT NOMINAL"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 9
                spacing: 10

                Rectangle {
                    width: 4
                    Layout.fillHeight: true
                    color: Theme.signalCyan
                    radius: 2
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: cockpit.rtl ? "نظام إدارة القوة الجوية" : "AIR FORCE MANAGEMENT SYSTEM"
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "الجاهزية • القواعد • الأسراب • المجال الجوي • الصيانة • التدريب • التقارير" : "READINESS • BASES • SQUADRONS • AIRSPACE • SUSTAINMENT • TRAINING • REPORTING"
                        color: Theme.signalCyan
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 300
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: page.executiveState().indexOf("NOMINAL") >= 0 || page.executiveState().indexOf("مستقرة") >= 0 ? Theme.radarGreen : Theme.royalGold
                    border.width: 1
                    radius: Theme.radius

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8
                        Rectangle {
                            width: 34
                            height: 34
                            radius: 17
                            color: "transparent"
                            border.color: page.executiveState().indexOf("NOMINAL") >= 0 || page.executiveState().indexOf("مستقرة") >= 0 ? Theme.radarGreen : Theme.royalGold
                            border.width: 2
                            Text {
                                anchors.centerIn: parent
                                text: page.executiveState().indexOf("NOMINAL") >= 0 || page.executiveState().indexOf("مستقرة") >= 0 ? "✓" : "!"
                                color: parent.border.color
                                font.pixelSize: 15
                                font.bold: true
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: cockpit.rtl ? "الحالة الإدارية" : "MANAGEMENT STATE"; color: Theme.muted; font.pixelSize: 6; font.bold: true }
                            Text { text: page.executiveState(); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: "AWARENESS • READINESS • SUSTAINMENT"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 5 }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            spacing: 6

            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "جاهزية القوة" : "FORCE READINESS"
                value: cockpit.forceFleetReadinessPercent + "%"
                subtitle: cockpit.forceReadyPlatformCount + " / " + cockpit.forceAssignedPlatformCount + (cockpit.rtl ? " منصة" : " PLATFORMS")
                iconText: "RDY"
                accent: page.readinessColor(cockpit.forceFleetReadinessPercent)
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "القواعد المتاحة" : "BASE AVAILABILITY"
                value: cockpit.forceAvailableBaseCount + " / " + cockpit.forceBases.length
                subtitle: cockpit.forceWeatherConstraintCount + (cockpit.rtl ? " قيود طقس" : " WX LIMITS")
                iconText: "BAS"
                accent: cockpit.forceWeatherConstraintCount > 0 ? Theme.royalGold : Theme.radarGreen
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "جاهزية الأطقم" : "CREW READINESS"
                value: cockpit.forceCrewReadinessPercent + "%"
                subtitle: cockpit.rtl ? "توافر تدريبي" : "TRAINING AVAILABILITY"
                iconText: "CRW"
                accent: page.readinessColor(cockpit.forceCrewReadinessPercent)
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "الصيانة المفتوحة" : "OPEN MAINTENANCE"
                value: String(cockpit.forceOpenMaintenanceCount)
                subtitle: cockpit.rtl ? "بنود متابعة" : "FOLLOW-UP ITEMS"
                iconText: "MNT"
                accent: cockpit.forceOpenMaintenanceCount > 0 ? Theme.royalGold : Theme.radarGreen
            }
            StatusCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: cockpit.rtl ? "الصورة الجوية" : "AIR PICTURE"
                value: String(cockpit.airOperationsTrackCount + cockpit.publicFlightTrackCount)
                subtitle: cockpit.airOperationsIncidentCount + (cockpit.rtl ? " حوادث" : " INCIDENTS")
                iconText: "AIR"
                accent: Theme.signalCyan
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 420
            spacing: 6

            ColumnLayout {
                Layout.preferredWidth: 282
                Layout.minimumWidth: 260
                Layout.maximumWidth: 310
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    color: Theme.panel
                    border.color: Theme.borderSoft
                    border.width: 1
                    radius: Theme.radius
                    Text {
                        anchors.centerIn: parent
                        text: cockpit.rtl ? "القواعد والمطارات" : "BASES & AIRFIELDS"
                        color: Theme.platinum
                        font.pixelSize: 9
                        font.bold: true
                    }
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: cockpit.forceBases
                    clip: true
                    spacing: 5
                    delegate: Rectangle {
                        required property var modelData
                        width: ListView.view.width
                        height: 86
                        color: Theme.panel
                        border.color: page.stateColor(modelData.state)
                        border.width: 1
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            spacing: 2
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.code; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                            }
                            Text { text: modelData.region; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: modelData.state; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.fillWidth: true }
                                Text { text: modelData.weather; color: Theme.silver; font.pixelSize: 6; elide: Text.ElideRight }
                            }
                            Text { text: modelData.runway; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 5; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 650
                color: Theme.panel
                border.color: Theme.signalCyan
                border.width: 1
                radius: Theme.radius

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 7
                    spacing: 5

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "الصورة الجوية والإدراك الموقفي" : "AIRSPACE & SITUATIONAL AWARENESS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text {
                            text: cockpit.publicFlightFeedStatus + "  •  " + cockpit.airOperationsMode
                            color: Theme.signalCyan
                            font.family: "Consolas"
                            font.pixelSize: 6
                            font.bold: true
                            elide: Text.ElideRight
                        }
                    }

                    CommandAirMap {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        publicTracks: cockpit.publicFlightTracks
                        aegisTracks: cockpit.airOperationsTracks
                        rtl: cockpit.rtl
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        spacing: 5
                        Repeater {
                            model: [
                                {label:"ADS-B", value:cockpit.publicFlightTrackCount, color:Theme.signalCyan},
                                {label:"AEGIS", value:cockpit.airOperationsTrackCount, color:Theme.royalGold},
                                {label:"C-UAS INC", value:cockpit.airOperationsIncidentCount, color:Theme.warmOrange},
                                {label:"RF", value:Number(cockpit.rfPeakFrequencyMhz).toFixed(1) + " MHz", color:Theme.rfViolet}
                            ]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: modelData.color
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    Text { text: modelData.label; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 5; Layout.fillWidth: true }
                                    Text { text: String(modelData.value); color: modelData.color; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 350
                Layout.minimumWidth: 330
                Layout.maximumWidth: 380
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 178
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        Text { text: cockpit.rtl ? "جاهزية الأسراب" : "SQUADRON READINESS"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: cockpit.forceSquadrons
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 5
                                Text { text: modelData.name; color: Theme.silver; font.pixelSize: 6; Layout.preferredWidth: 112; elide: Text.ElideRight }
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 7
                                    color: Theme.panel2
                                    radius: 3
                                    Rectangle {
                                        width: parent.width * Math.max(0, Math.min(Number(modelData.ready), Number(modelData.assigned))) / Math.max(1, Number(modelData.assigned))
                                        height: parent.height
                                        color: page.stateColor(modelData.state)
                                        radius: 3
                                    }
                                }
                                Text { text: modelData.ready + "/" + modelData.assigned; color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 156
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
                            Text { text: cockpit.rtl ? "التدريب والطقس" : "TRAINING & WEATHER"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.forceWeatherConstraintCount + " WX"; color: cockpit.forceWeatherConstraintCount > 0 ? Theme.royalGold : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.forceTrainingRows
                            clip: true
                            spacing: 2
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width
                                height: 28
                                spacing: 5
                                Text { text: modelData.time; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.preferredWidth: 42 }
                                Text { text: modelData.item; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
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
                        anchors.margins: 7
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "المتابعة والصيانة" : "FOLLOW-UP & SUSTAINMENT"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.forceOpenMaintenanceCount); color: Theme.warmOrange; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.forceMaintenancePlanRows
                            clip: true
                            spacing: 3
                            delegate: Rectangle {
                                required property var modelData
                                width: ListView.view.width
                                height: 42
                                color: Theme.panel2
                                border.color: modelData.priority === "P2" ? Theme.royalGold : Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 6
                                    Text { text: modelData.priority; color: modelData.priority === "P2" ? Theme.royalGold : Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.platform + " / " + modelData.item; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.due; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 5 }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 7
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 0
                        Text { text: cockpit.rtl ? "الصحة الهندسية" : "ENGINEERING HEALTH"; color: Theme.muted; font.pixelSize: 5; font.bold: true }
                        Text { text: cockpit.diagnosticHealthScore + "%"; color: cockpit.diagnosticHealthScore >= 90 ? Theme.radarGreen : Theme.royalGold; font.family: "Consolas"; font.pixelSize: 12; font.bold: true }
                        Text { text: cockpit.diagnosticFindingCount + (cockpit.rtl ? " نتائج تشخيص" : " DIAGNOSTIC FINDINGS"); color: Theme.silver; font.pixelSize: 5 }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: cockpit.twinFaultCount > 0 ? Theme.warmOrange : Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 0
                        Text { text: "DIGITAL TWIN"; color: Theme.muted; font.pixelSize: 5; font.bold: true }
                        Text { text: cockpit.twinNominalCount + " NOMINAL"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                        Text { text: cockpit.twinFaultCount + (cockpit.rtl ? " أعطال" : " FAULTS"); color: cockpit.twinFaultCount > 0 ? Theme.warmOrange : Theme.silver; font.pixelSize: 5 }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: Theme.rfViolet
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 0
                        Text { text: cockpit.rtl ? "بيانات واتصالات" : "DATA & INTEGRATION"; color: Theme.muted; font.pixelSize: 5; font.bold: true }
                        Text { text: cockpit.publicFlightFeedSource; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: cockpit.airOperationsSource; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 5; Layout.fillWidth: true; elide: Text.ElideRight }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: cockpit.airOperationsIncidentCount > 0 ? Theme.warmOrange : Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 0
                        Text { text: cockpit.rtl ? "مراجعة الحوادث" : "INCIDENT REVIEW"; color: Theme.muted; font.pixelSize: 5; font.bold: true }
                        Text { text: String(cockpit.airOperationsIncidentCount); color: cockpit.airOperationsIncidentCount > 0 ? Theme.warmOrange : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 12; font.bold: true }
                        Text { text: cockpit.rtl ? "تنسيق وتوثيق فقط" : "COORDINATION / RECORD ONLY"; color: Theme.silver; font.pixelSize: 5 }
                    }
                }
            }
        }
    }
}
