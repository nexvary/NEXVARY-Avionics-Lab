import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true
    property int selectedSection: 0

    function sectionColor() {
        return [Theme.signalCyan, Theme.rfViolet, Theme.warmOrange, Theme.radarGreen][selectedSection]
    }

    function sectionTitle() {
        if (cockpit.rtl) return ["الكشف والوعي", "التصنيف والتحقق", "مراجعة الحوادث", "تنسيق الاستجابة"][selectedSection]
        return ["DETECTION & AWARENESS", "CLASSIFICATION & VERIFICATION", "INCIDENT REVIEW", "RESPONSE COORDINATION"][selectedSection]
    }

    function sectionNote() {
        if (cockpit.rtl) return [
            "دمج مسارات AEGIS وسجل المستشعرات والمناطق المحمية",
            "فئة المسار ودرجة الثقة ومراجعة الأدلة",
            "سجل الحوادث والتسلسل الزمني والأثر التدقيقي",
            "سير استجابة تدريبي بشري القرار؛ دون اشتباك أو تشويش"
        ][selectedSection]
        return [
            "AEGIS TRACK FUSION, SENSOR EVIDENCE AND GEOFENCE AWARENESS",
            "TRACK CLASS, CONFIDENCE AND EVIDENCE VERIFICATION",
            "INCIDENT RECORD, TIMELINE AND AUDITABLE EVIDENCE",
            "HUMAN-LED TRAINING WORKFLOW; NO ENGAGEMENT OR JAMMING"
        ][selectedSection]
    }

    function responseRows() {
        return [
            {step:"01", title:cockpit.rtl ? "الرصد" : "DETECT", summary:cockpit.rtl ? "استلام المسار من مصدر الوعي" : "INGEST AWARENESS TRACK", status:"COMPLETE", color:Theme.signalCyan},
            {step:"02", title:cockpit.rtl ? "التصنيف" : "CLASSIFY", summary:cockpit.rtl ? "مراجعة الفئة والثقة" : "REVIEW CLASS AND CONFIDENCE", status:"COMPLETE", color:Theme.rfViolet},
            {step:"03", title:cockpit.rtl ? "التحقق" : "VERIFY", summary:cockpit.rtl ? "ربط المستشعرات والأدلة" : "CORRELATE SENSORS AND EVIDENCE", status:"REVIEW", color:Theme.royalGold},
            {step:"04", title:cockpit.rtl ? "التنسيق" : "COORDINATE", summary:cockpit.rtl ? "إخطار الأطراف البشرية" : "NOTIFY HUMAN STAKEHOLDERS", status:"READY", color:Theme.radarGreen},
            {step:"05", title:cockpit.rtl ? "التوثيق" : "RECORD", summary:cockpit.rtl ? "حفظ الأثر التدقيقي" : "RETAIN AUDIT TRAIL", status:"READY", color:Theme.skyBlue}
        ]
    }

    function entryModel() {
        if (selectedSection === 2) return cockpit.airOperationsIncidents
        if (selectedSection === 3) return responseRows()
        return cockpit.airOperationsTracks
    }

    function entryCode(row) {
        if (selectedSection === 2) return row.incidentId || "INC"
        if (selectedSection === 3) return row.step
        return selectedSection === 1 ? "CLS" : "TRK"
    }

    function entryTitle(row) {
        if (selectedSection === 2) return row.incidentId || row.trackId || "INCIDENT"
        if (selectedSection === 3) return row.title
        return row.trackId || row.id || "TRACK"
    }

    function entrySummary(row) {
        if (selectedSection === 2) return row.summary || row.status || "Review record"
        if (selectedSection === 3) return row.summary
        if (selectedSection === 1) return (row.classification || "UNKNOWN") + "  •  CONF " + Math.round(Number(row.confidence || 0) * 100) + "%"
        return (row.sensors || "SENSOR FUSION") + "  •  " + (row.zoneName || "MONITORED AIRSPACE")
    }

    function entryDetail(row) {
        if (selectedSection === 2) return (row.peakThreatLevel || "REVIEW") + "  •  " + (row.status || "OPEN")
        if (selectedSection === 3) return row.status
        if (selectedSection === 1) return "EVIDENCE CORRELATION  •  " + (row.sensors || "AEGIS")
        return Math.round(Number(row.altitudeMeters || 0)) + " M  •  " + Math.round(Number(row.headingDegrees || 0)) + "°  •  " + (row.insideProtectedZone ? "GEOFENCE" : "MONITOR")
    }

    function entrySeverity(row) {
        if (selectedSection === 2) return severityColor(row.peakThreatLevel)
        if (selectedSection === 3) return row.color
        return severityColor(row.threatLevel)
    }

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
            Layout.minimumHeight: 76
            Layout.maximumHeight: 76
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
                        text: page.sectionTitle()
                        color: Theme.platinum
                        font.pixelSize: Theme.pageTitlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: page.sectionNote()
                        color: page.sectionColor()
                        font.pixelSize: Theme.secondaryPx
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
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 1
                        Text { text: cockpit.rtl ? "محاكاة استجابة فقط" : "RESPONSE SIMULATION ONLY"; color: Theme.warmOrange; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                        Text { text: "AEGIS C-UAS / AWARENESS + REVIEW"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            Layout.minimumHeight: 92
            Layout.maximumHeight: 92
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
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 2
                        Text { text: modelData.title; color: Theme.silver; font.pixelSize: Theme.smallPx; font.bold: true }
                        Text { text: String(modelData.value); color: modelData.color; font.family: Theme.mono; font.pixelSize: 20; font.bold: true }
                        Text { text: cockpit.airOperationsMode; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; elide: Text.ElideRight; Layout.fillWidth: true }
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
                color: "#111111"
                border.color: Theme.border
                border.width: 1
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: page.sectionTitle(); color: Theme.platinum; font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                        Text { text: cockpit.airOperationsSource; color: page.sectionColor(); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: page.selectedSection === 3
                        Layout.preferredHeight: page.selectedSection < 2 ? 236 : (page.selectedSection === 2 ? 90 : 420)
                        Layout.minimumHeight: page.selectedSection === 2 ? 78 : 180
                        model: page.entryModel()
                        clip: true
                        spacing: 4
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: 78
                            color: Theme.panel2
                            border.color: Theme.border
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 8
                                Rectangle {
                                    width: 48; height: 48; radius: 5
                                    color: Theme.panel3
                                    border.color: Theme.border
                                    border.width: 2
                                    Text { anchors.centerIn: parent; text: page.entryCode(modelData); color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: page.entryTitle(modelData); color: Theme.platinum; font.pixelSize: Theme.bodyPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: page.entrySummary(modelData); color: page.sectionColor(); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: page.entryDetail(modelData); color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                                ColumnLayout {
                                    Layout.preferredWidth: 130
                                    spacing: 1
                                    Text { text: page.selectedSection === 3 ? String(modelData.status) : String(modelData.threatLevel || modelData.peakThreatLevel || "REVIEW").toUpperCase(); color: page.entrySeverity(modelData); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                                    Text { text: "AWARENESS"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: Text.AlignRight }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: page.selectedSection < 2
                        color: Theme.shell
                        border.color: Theme.border
                        border.width: 1
                        radius: Theme.radius
                        clip: true

                        Canvas {
                            id: tacticalPlot
                            objectName: "cuasTacticalPlot"
                            anchors.fill: parent
                            anchors.margins: 7
                            antialiasing: true
                            property var tracks: cockpit.airOperationsTracks
                            property real sweepAngle: -Math.PI / 2
                            onTracksChanged: requestPaint()
                            onSweepAngleChanged: requestPaint()
                            onWidthChanged: requestPaint()
                            onHeightChanged: requestPaint()
                            NumberAnimation on sweepAngle {
                                from: -Math.PI / 2
                                to: Math.PI * 1.5
                                duration: 6200
                                loops: Animation.Infinite
                                running: tacticalPlot.visible
                            }
                            onPaint: {
                                var c = getContext("2d")
                                c.reset()
                                var w = width
                                var h = height
                                var cx = w * .48
                                var cy = h * .53
                                var radius = Math.max(40, Math.min(w * .40, h * .42))
                                c.fillStyle = "#050505"
                                c.fillRect(0, 0, w, h)

                                c.strokeStyle = "#665820"
                                c.lineWidth = 1
                                for (var ring = 1; ring <= 5; ++ring) {
                                    c.globalAlpha = .45 + ring * .06
                                    c.beginPath()
                                    c.arc(cx, cy, radius * ring / 5, 0, Math.PI * 2)
                                    c.stroke()
                                }
                                c.globalAlpha = .62
                                for (var bearing = 0; bearing < 360; bearing += 30) {
                                    var a = (bearing - 90) * Math.PI / 180
                                    c.beginPath()
                                    c.moveTo(cx, cy)
                                    c.lineTo(cx + Math.cos(a) * radius, cy + Math.sin(a) * radius)
                                    c.stroke()
                                }

                                for (var tick = 0; tick < 360; tick += 10) {
                                    var tickAngle = (tick - 90) * Math.PI / 180
                                    var tickInner = radius * (tick % 30 === 0 ? .94 : .975)
                                    c.globalAlpha = tick % 30 === 0 ? .78 : .42
                                    c.beginPath()
                                    c.moveTo(cx + Math.cos(tickAngle) * tickInner,
                                             cy + Math.sin(tickAngle) * tickInner)
                                    c.lineTo(cx + Math.cos(tickAngle) * radius,
                                             cy + Math.sin(tickAngle) * radius)
                                    c.stroke()
                                }

                                c.globalAlpha = .08
                                c.fillStyle = Theme.radarGreen
                                c.beginPath()
                                c.moveTo(cx, cy)
                                c.arc(cx, cy, radius, tacticalPlot.sweepAngle - .34, tacticalPlot.sweepAngle)
                                c.closePath()
                                c.fill()
                                c.globalAlpha = .88
                                c.strokeStyle = Theme.radarGreen
                                c.lineWidth = 1.5
                                c.beginPath()
                                c.moveTo(cx, cy)
                                c.lineTo(cx + Math.cos(tacticalPlot.sweepAngle) * radius,
                                         cy + Math.sin(tacticalPlot.sweepAngle) * radius)
                                c.stroke()

                                c.setLineDash([8, 5])
                                c.strokeStyle = "#D4AF37"
                                c.globalAlpha = .82
                                c.beginPath()
                                c.arc(cx, cy, radius * .58, 0, Math.PI * 2)
                                c.stroke()
                                c.setLineDash([])
                                c.globalAlpha = 1

                                c.fillStyle = "#9E9B98"
                                c.font = "700 " + Theme.smallPx + "px 'Noto Sans Mono'"
                                c.textAlign = "center"
                                c.fillText("000", cx, cy - radius - 8)
                                c.fillText("090", cx + radius + 24, cy + 4)
                                c.fillText("180", cx, cy + radius + 17)
                                c.fillText("270", cx - radius - 24, cy + 4)
                                c.fillStyle = "#D4AF37"
                                c.fillText(page.selectedSection === 0 ? "PROTECTED GEOFENCE" : "CLASSIFICATION ZONE", cx, cy - radius * .58 - 7)

                                for (var i = 0; i < tracks.length; ++i) {
                                    var track = tracks[i]
                                    var heading = Number(track.headingDegrees || (42 + i * 71))
                                    var angle = (heading - 90) * Math.PI / 180
                                    var distance = radius * (.30 + (i % 3) * .20)
                                    var tx = cx + Math.cos(angle) * distance
                                    var ty = cy + Math.sin(angle) * distance
                                    var color = page.severityColor(track.threatLevel)

                                    c.strokeStyle = color
                                    c.lineWidth = 2
                                    c.globalAlpha = .18
                                    c.beginPath()
                                    c.moveTo(cx, cy)
                                    c.lineTo(tx, ty)
                                    c.stroke()
                                    for (var trail = 1; trail <= 5; ++trail) {
                                        c.globalAlpha = .65 - trail * .09
                                        c.fillStyle = color
                                        c.beginPath()
                                        c.arc(tx - Math.cos(angle) * trail * 11, ty - Math.sin(angle) * trail * 11, 2.4, 0, Math.PI * 2)
                                        c.fill()
                                    }
                                    c.globalAlpha = 1
                                    c.fillStyle = "#111111"
                                    c.strokeStyle = color
                                    c.lineWidth = 2
                                    c.beginPath()
                                    c.moveTo(tx, ty - 9)
                                    c.lineTo(tx + 9, ty)
                                    c.lineTo(tx, ty + 9)
                                    c.lineTo(tx - 9, ty)
                                    c.closePath()
                                    c.fill()
                                    c.stroke()

                                    var labelX = tx + (tx > cx ? -155 : 15)
                                    var labelY = ty - 28 + i * 4
                                    c.fillStyle = "#EC0A0A0A"
                                    c.fillRect(labelX, labelY, 140, 40)
                                    c.strokeStyle = color
                                    c.lineWidth = 1
                                    c.strokeRect(labelX, labelY, 140, 40)
                                    c.textAlign = "left"
                                    c.fillStyle = color
                                    c.font = "700 " + Theme.smallPx + "px 'Noto Sans Mono'"
                                    c.fillText(track.trackId || "TRACK", labelX + 6, labelY + 15)
                                    c.fillStyle = "#9E9B98"
                                    c.font = Theme.smallPx + "px 'Noto Sans Mono'"
                                    c.fillText((track.classification || "UNKNOWN") + " / " + Math.round(Number(track.confidence || 0) * 100) + "%", labelX + 6, labelY + 30)
                                }
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.margins: 12
                            width: 248
                            height: 55
                            color: "#E80A0A0A"
                            border.color: Theme.borderSoft
                            radius: 4
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 1
                                Text { text: page.selectedSection === 0 ? (cockpit.rtl ? "رادار الوعي السلبي" : "PASSIVE AWARENESS PLOT") : (cockpit.rtl ? "طبقة التصنيف" : "CLASSIFICATION OVERLAY"); color: page.sectionColor(); font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true }
                                Text { text: "RANGE 25 KM  •  AEGIS  •  RECEIVE ONLY"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                            }
                        }

                        Rectangle {
                            visible: page.selectedSection === 0 || page.selectedSection === 1
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 12
                            width: 276
                            height: 62
                            color: "#E80A0A0A"
                            border.color: Theme.signalCyan
                            border.width: 1
                            radius: 5
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8
                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: 16
                                    color: "#142CCEFF"
                                    border.color: Theme.signalCyan
                                    border.width: 1
                                    Text { anchors.centerIn: parent; text: "ID"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: "OPEN DRONE ID / REMOTE ID"; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: "PASSIVE RECEIVE • REPLAY • " + cockpit.airOperationsTrackCount + " CORRELATED"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                                Rectangle { width: 8; height: 8; radius: 4; color: Theme.radarGreen }
                            }
                        }

                        RfSpectrumMini {
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 12
                            width: Math.min(320, parent.width * .27)
                            height: 148
                            bins: cockpit.rfSpectrumBins
                            peakFrequencyMhz: cockpit.rfPeakFrequencyMhz
                            peakLevelDbm: cockpit.rfPeakLevelDbm
                            rtl: cockpit.rtl
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: page.selectedSection === 2
                        color: Theme.shell
                        border.color: Theme.border
                        border.width: 1
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 11
                            spacing: 9
                            Text { text: cockpit.rtl ? "الأدلة والأثر التدقيقي" : "EVIDENCE & AUDIT TRAIL"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            GridLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 180
                                columns: 2
                                columnSpacing: 8
                                rowSpacing: 8
                                Repeater {
                                    model: [
                                        {label:cockpit.rtl ? "مصدر المسار" : "TRACK SOURCE", value:cockpit.airOperationsSource, detail:"AEGIS / READ-ONLY", color:Theme.signalCyan},
                                        {label:cockpit.rtl ? "ترابط المستشعرات" : "SENSOR CORRELATION", value:"3 / 3", detail:cockpit.rtl ? "أدلة مرتبطة" : "EVIDENCE LINKED", color:Theme.rfViolet},
                                        {label:cockpit.rtl ? "وعي السياج الجغرافي" : "GEOFENCE AWARENESS", value:"ACTIVE", detail:cockpit.rtl ? "منطقة تدريبية" : "TRAINING ZONE", color:Theme.royalGold},
                                        {label:cockpit.rtl ? "حفظ السجل" : "AUDIT RETENTION", value:"VERIFIED", detail:cockpit.rtl ? "غير قابل للتعديل" : "IMMUTABLE RECORD", color:Theme.radarGreen}
                                    ]
                                    delegate: Rectangle {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        color: Theme.panel2
                                        border.color: Theme.border
                                        border.width: 1
                                        radius: 4
                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 9
                                            spacing: 2
                                            Text { text: modelData.label; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                            Text { text: modelData.value; color: modelData.color; font.family: Theme.mono; font.pixelSize: 16; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                            Text { text: modelData.detail; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        }
                                    }
                                }
                            }
                            Text { text: cockpit.rtl ? "التسلسل الزمني للحادث" : "INCIDENT TIMELINE"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true }
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                Repeater {
                                    model: page.responseRows()
                                    delegate: Rectangle {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        height: 66
                                        color: Theme.panel2
                                        border.color: Theme.border
                                        radius: 4
                                        ColumnLayout {
                                            anchors.centerIn: parent
                                            spacing: 1
                                            Text { text: modelData.step; color: modelData.color; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                            Text { text: modelData.title; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                            Text { text: modelData.status; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.alignment: Qt.AlignHCenter }
                                        }
                                    }
                                }
                            }
                            Item { Layout.fillHeight: true }
                            Text { text: cockpit.rtl ? "سجل الوعي والتحليل فقط — لا ينشئ توجيه اشتباك أو سيطرة على مؤثرات." : "AWARENESS AND ANALYSIS RECORD ONLY — NO ENGAGEMENT DIRECTION OR EFFECTOR CONTROL."; color: Theme.warmOrange; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 410
                Layout.minimumWidth: 410
                Layout.maximumWidth: 410
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
                        Text { text: cockpit.rtl ? "سير الاستجابة التدريبية" : "TRAINING RESPONSE WORKFLOW"; color: Theme.platinum; font.pixelSize: Theme.smallPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: page.responseRows()
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredHeight: 34
                                color: (page.selectedSection === 0 && index === 0) || (page.selectedSection === 1 && index === 1) || (page.selectedSection === 2 && index === 4) || (page.selectedSection === 3 && index === 3) ? Theme.panel3 : Theme.panel2
                                border.color: Theme.border
                                border.width: (page.selectedSection === 0 && index === 0) || (page.selectedSection === 1 && index === 1) || (page.selectedSection === 2 && index === 4) || (page.selectedSection === 3 && index === 3) ? 2 : 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    Text { text: modelData.step; color: modelData.color; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.preferredWidth: 30 }
                                    Text { text: modelData.title; color: Theme.platinum; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true }
                                    Text { text: modelData.status; color: modelData.status === "REVIEW" ? Theme.royalGold : Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
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
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "الحوادث والسجل" : "INCIDENT REVIEW"; color: Theme.platinum; font.pixelSize: Theme.smallPx; font.bold: true }
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
                                border.color: Theme.border
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 1
                                    Text { text: modelData.trackId || modelData.incidentId || "INCIDENT"; color: Theme.platinum; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.summary || modelData.status || "Review record"; color: Theme.silver; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: String(modelData.peakThreatLevel || modelData.level || "REVIEW").toUpperCase(); color: page.severityColor(modelData.peakThreatLevel || modelData.level); font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                }
                            }
                        }
                        Text {
                            text: cockpit.rtl ? "لا يتضمن هذا القسم اعتراضًا فعليًا أو تشويشًا أو استحواذًا أو توجيه اشتباك." : "NO LIVE INTERCEPTION, JAMMING, TAKEOVER OR ENGAGEMENT CONTROL IS PROVIDED."
                            color: Theme.warmOrange
                            font.pixelSize: Theme.smallPx
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
