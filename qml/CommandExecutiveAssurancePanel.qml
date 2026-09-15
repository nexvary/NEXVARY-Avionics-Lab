import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: panel
    property bool rtl: cockpit.rtl
    signal routeRequested(string routeId, int page, int workspace, string groupId)

    color: Theme.shell
    border.color: Theme.border
    border.width: Theme.frameWidth
    radius: Theme.radius

    function squadronReadiness() {
        var assigned = 0
        var ready = 0
        for (var i = 0; i < cockpit.forceSquadrons.length; ++i) {
            assigned += Number(cockpit.forceSquadrons[i].assigned || 0)
            ready += Number(cockpit.forceSquadrons[i].ready || 0)
        }
        return assigned > 0 ? Math.round(ready * 100 / assigned) : 0
    }

    function trainingReadiness() {
        var rows = cockpit.forceTrainingRows
        if (!rows || rows.length === 0) return 0
        var ready = 0
        for (var i = 0; i < rows.length; ++i) {
            var state = String(rows[i].status || "").toUpperCase()
            if (state.indexOf("HOLD") < 0 && state.indexOf("CANCEL") < 0 && state.indexOf("DELAY") < 0)
                ready++
        }
        return Math.round(ready * 100 / rows.length)
    }

    function validSensorCount() {
        var valid = 0
        for (var i = 0; i < cockpit.sensorRows.length; ++i)
            if (cockpit.sensorRows[i].valid) valid++
        return valid
    }

    function telemetryPercent() {
        return cockpit.sensorCount > 0 ? Math.round(validSensorCount() * 100 / cockpit.sensorCount) : 0
    }

    function verificationPassCount() {
        var count = 0
        if (cockpit.sensorCount > 0 && validSensorCount() === cockpit.sensorCount) count++
        if (cockpit.twinFaultCount === 0) count++
        if (cockpit.activeAlertCount === 0) count++
        if (cockpit.recordedFrames > 10) count++
        if (cockpit.tick > 0) count++
        if (cockpit.activeTrainingFaultCount === 0) count++
        return count
    }

    function verificationPercent() {
        return Math.round(verificationPassCount() * 100 / 6)
    }

    function readinessColor(value) {
        var v = Number(value)
        if (v >= 90) return Theme.radarGreen
        if (v >= 75) return Theme.royalGold
        return Theme.warmOrange
    }

    function faultColor(value) {
        return Number(value) > 0 ? Theme.warmOrange : Theme.radarGreen
    }

    function cards() {
        var squadron = squadronReadiness()
        var training = trainingReadiness()
        var telemetry = telemetryPercent()
        var verification = verificationPercent()
        var critical = Number(cockpit.diagnosticFaultCount || 0) + Number(cockpit.twinFaultCount || 0)
        var airfields = cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length
        return [
            {key:"FLEET", title:rtl ? "جاهزية الأسطول" : "FLEET READINESS", value:cockpit.forceFleetReadinessPercent + "%", sub:cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount + (rtl ? " متاحة" : " AVAILABLE"), color:readinessColor(cockpit.forceFleetReadinessPercent), route:"fleet", page:12, workspace:0, group:"force-management"},
            {key:"SQN", title:rtl ? "جاهزية الأسراب" : "SQUADRON READINESS", value:squadron + "%", sub:cockpit.forceSquadrons.length + (rtl ? " أسراب" : " SQUADRONS"), color:readinessColor(squadron), route:"squadrons", page:12, workspace:1, group:"force-management"},
            {key:"AIR", title:rtl ? "توفر الطائرات" : "AIRCRAFT AVAILABILITY", value:cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount, sub:cockpit.forceFleetReadinessPercent + (rtl ? "% جاهزية" : "% READY"), color:readinessColor(cockpit.forceFleetReadinessPercent), route:"fleet", page:12, workspace:0, group:"force-management"},
            {key:"MNT", title:rtl ? "تراكم الصيانة" : "MAINTENANCE BACKLOG", value:String(cockpit.forceOpenMaintenanceCount), sub:cockpit.forceMaintenancePlanRows.length + (rtl ? " بنود قادمة" : " UPCOMING"), color:faultColor(cockpit.forceOpenMaintenanceCount), route:"maintenance", page:12, workspace:5, group:"force-management"},
            {key:"CRW", title:rtl ? "الطاقم والتدريب" : "CREW / TRAINING", value:cockpit.forceCrewReadinessPercent + "%", sub:training + (rtl ? "% تدريب" : "% TRAINING"), color:readinessColor(Math.min(cockpit.forceCrewReadinessPercent, training)), route:"training", page:12, workspace:4, group:"force-management"},
            {key:"AFD", title:rtl ? "حالة المطارات" : "AIRFIELD STATUS", value:airfields, sub:cockpit.aerodromeWeatherCount + " METAR • " + cockpit.runwayConditionCount + " RWY", color:cockpit.forceAvailableBaseCount === cockpit.forceBases.length ? Theme.radarGreen : Theme.royalGold, route:"bases", page:12, workspace:2, group:"force-management"},
            {key:"ENG", title:rtl ? "تنبيهات الهندسة" : "ENGINEERING ALERTS", value:String(cockpit.activeAlertCount), sub:cockpit.diagnosticFindingCount + (rtl ? " نتائج تشخيص" : " DX FINDINGS"), color:faultColor(cockpit.activeAlertCount), route:"system-health", page:1, workspace:0, group:"engineering"},
            {key:"VER", title:rtl ? "حالة التحقق" : "VERIFICATION STATUS", value:verification + "%", sub:verificationPassCount() + "/6 " + (rtl ? "بوابات" : "GATES"), color:readinessColor(verification), route:"verification", page:10, workspace:0, group:"engineering"},
            {key:"TEL", title:rtl ? "صحة التليمترى" : "TELEMETRY HEALTH", value:telemetry + "%", sub:validSensorCount() + "/" + cockpit.sensorCount + (rtl ? " صالح" : " VALID"), color:readinessColor(telemetry), route:"sensors", page:2, workspace:0, group:"engineering"},
            {key:"TWN", title:rtl ? "التوأم الرقمي" : "DIGITAL TWIN STATUS", value:cockpit.twinFaultCount === 0 ? (rtl ? "مستقر" : "NOMINAL") : (rtl ? "مراجعة" : "REVIEW"), sub:cockpit.twinDegradedCount + " DEG • " + cockpit.twinFaultCount + " FLT", color:faultColor(cockpit.twinFaultCount), route:"digital-twin", page:6, workspace:0, group:"engineering"},
            {key:"FLT", title:rtl ? "الأعطال الحرجة" : "CRITICAL FAULTS", value:String(critical), sub:cockpit.diagnosticHealthScore + (rtl ? "% صحة" : "% HEALTH"), color:faultColor(critical), route:"diagnostics", page:9, workspace:0, group:"engineering"},
            {key:"TRD", title:rtl ? "الاتجاهات التاريخية" : "HISTORICAL TRENDS", value:String(cockpit.performanceSeries.length), sub:cockpit.trendWindow + (rtl ? " إطار نافذة" : " FRAME WINDOW"), color:Theme.royalGold, route:"trends", page:5, workspace:0, group:"engineering"}
        ]
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 7
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            layoutDirection: panel.rtl ? Qt.RightToLeft : Qt.LeftToRight
            Rectangle { width: 4; height: 15; radius: 2; color: Theme.royalGold }
            Text {
                text: panel.rtl ? "مصفوفة الضمان التنفيذي — اضغط للانتقال إلى التفاصيل" : "EXECUTIVE ASSURANCE MATRIX — SELECT A METRIC TO DRILL DOWN"
                color: Theme.platinum
                font.family: Theme.uiFont(panel.rtl)
                font.pixelSize: Theme.smallPx
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: panel.rtl ? Text.AlignRight : Text.AlignLeft
                elide: Text.ElideRight
            }
            Text {
                text: "READINESS • SUSTAINMENT • ENGINEERING • EVIDENCE"
                color: Theme.royalGold
                font.family: Theme.mono
                font.pixelSize: Theme.smallPx
                visible: width > 1160
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 6
            columnSpacing: 5
            rowSpacing: 5
            layoutDirection: panel.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Repeater {
                model: panel.cards()
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 120
                    Layout.minimumHeight: 42
                    color: mouse.containsMouse ? Theme.panel3 : Theme.panel2
                    border.color: mouse.containsMouse ? Theme.royalGold : Theme.borderSoft
                    border.width: mouse.containsMouse ? Theme.activeFrameWidth : Theme.frameWidth
                    radius: Theme.radius

                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: panel.routeRequested(modelData.route, modelData.page, modelData.workspace, modelData.group)
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 6
                        layoutDirection: panel.rtl ? Qt.RightToLeft : Qt.LeftToRight
                        Rectangle {
                            Layout.preferredWidth: 31
                            Layout.fillHeight: true
                            color: Theme.shell
                            border.color: modelData.color
                            border.width: 1
                            radius: Theme.radius
                            Text {
                                anchors.centerIn: parent
                                text: modelData.key
                                color: modelData.color
                                font.family: Theme.mono
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text {
                                text: modelData.title
                                color: Theme.silver
                                font.family: Theme.uiFont(panel.rtl)
                                font.pixelSize: Theme.smallPx
                                font.bold: true
                                Layout.fillWidth: true
                                horizontalAlignment: panel.rtl ? Text.AlignRight : Text.AlignLeft
                                elide: Text.ElideRight
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                Text {
                                    text: modelData.value
                                    color: modelData.color
                                    font.family: Theme.mono
                                    font.pixelSize: Theme.secondaryPx
                                    font.bold: true
                                }
                                Text {
                                    text: modelData.sub
                                    color: Theme.muted
                                    font.family: Theme.uiFont(panel.rtl)
                                    font.pixelSize: Theme.smallPx
                                    Layout.fillWidth: true
                                    horizontalAlignment: panel.rtl ? Text.AlignRight : Text.AlignLeft
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
