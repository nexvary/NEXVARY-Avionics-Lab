import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "UnifiedCommandLocale.js" as UnifiedLocale

Item {
    id: page
    clip: true

    function upper(value) { return String(value || "").toUpperCase() }
    function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)) }
    function threatColor(level) {
        var t = upper(level)
        if (t === "CRITICAL" || t === "HIGH") return Theme.warmOrange
        if (t === "MEDIUM") return Theme.royalGold
        if (t === "LOW") return Theme.skyBlue
        return Theme.radarGreen
    }
    function readinessColor(value) {
        if (value >= 90) return Theme.radarGreen
        if (value >= 80) return Theme.royalGold
        return Theme.warmOrange
    }
    function aircraftAccent(id) {
        if (id === "generic-jet") return Theme.signalCyan
        if (id === "generic-helicopter") return Theme.royalGold
        if (id === "generic-uav") return Theme.rfViolet
        return Theme.radarGreen
    }
    function worldX(longitude, width) {
        return clamp((Number(longitude) + 180.0) / 360.0, 0.03, 0.97) * width
    }
    function worldY(latitude, height) {
        return clamp((90.0 - Number(latitude)) / 180.0, 0.05, 0.95) * height
    }
    function overallState() {
        if (cockpit.airOperationsHighCount > 0 || cockpit.twinFaultCount > 0)
            return cockpit.rtl ? "يتطلب مراجعة" : "REVIEW REQUIRED"
        if (cockpit.readinessFleetPercent < 85 || cockpit.activeAlertCount > 0)
            return cockpit.rtl ? "جاهزية محدودة" : "LIMITED READINESS"
        return cockpit.rtl ? "مستقر للتدريب" : "TRAINING NOMINAL"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 66
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                Rectangle { width: 5; Layout.fillHeight: true; color: Theme.signalCyan; radius: 2 }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: cockpit.rtl ? "مركز القيادة الجوية الموحد" : "UNIFIED AIR COMMAND CENTER"
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "صورة جوية + ADS-B + AEGIS + RF سلبي + جاهزية + صيانة + توأم رقمي" : "AIR PICTURE + ADS-B + AEGIS + PASSIVE RF + READINESS + MAINTENANCE + DIGITAL TWIN"
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
                    border.color: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8
                        Rectangle {
                            width: 34; height: 34; radius: 17
                            color: "transparent"
                            border.color: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.radarGreen
                            border.width: 2
                            Text { anchors.centerIn: parent; text: cockpit.airOperationsHighCount > 0 ? "!" : "✓"; color: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.radarGreen; font.pixelSize: 16; font.bold: true }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: cockpit.rtl ? "الحالة التنفيذية" : "EXECUTIVE STATE"; color: Theme.muted; font.pixelSize: 6; font.bold: true }
                            Text { text: page.overallState(); color: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: "AWARENESS • TRAINING • REVIEW"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
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
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "المسارات" : "AIR TRACKS"; value: String(cockpit.airOperationsTrackCount); subtitle: cockpit.publicFlightTrackCount + (cockpit.rtl ? " مدني/عام" : " PUBLIC"); iconText: "AIR"; accent: Theme.signalCyan }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "C-UAS عالي" : "C-UAS HIGH"; value: String(cockpit.airOperationsHighCount); subtitle: cockpit.airOperationsIncidentCount + (cockpit.rtl ? " حوادث" : " INCIDENTS"); iconText: "CU"; accent: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.radarGreen }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "جاهزية الأسطول" : "FLEET READINESS"; value: cockpit.readinessFleetPercent + "%"; subtitle: cockpit.readinessReadyCount + " / " + cockpit.readinessAssets.length + (cockpit.rtl ? " جاهزة" : " READY"); iconText: "RDY"; accent: page.readinessColor(cockpit.readinessFleetPercent) }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "الصيانة" : "MAINTENANCE"; value: String(cockpit.readinessMaintenanceOpenCount); subtitle: cockpit.rtl ? "متابعة هندسية" : "FOLLOW-UP"; iconText: "MNT"; accent: Theme.royalGold }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "RF الذروة" : "RF PEAK"; value: Number(cockpit.rfPeakLevelDbm).toFixed(0) + " dBm"; subtitle: Number(cockpit.rfPeakFrequencyMhz).toFixed(1) + " MHz"; iconText: "RF"; accent: Theme.rfViolet }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "صحة التشخيص" : "DIAGNOSTIC"; value: cockpit.diagnosticHealthScore + "%"; subtitle: cockpit.twinNominalCount + (cockpit.rtl ? " عقد سليمة" : " TWIN NOMINAL"); iconText: "DX"; accent: cockpit.diagnosticHealthScore >= 90 ? Theme.radarGreen : Theme.warmOrange }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.signalCyan
                    border.width: 1
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "الصورة الجوية والرادار" : "AIR PICTURE / RADAR"; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.publicFlightFeedSource + "  •  " + cockpit.airOperationsSource; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 6; elide: Text.ElideRight }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Rectangle {
                            id: radarFrame
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#0A171B"
                            border.color: Theme.deepBlue
                            border.width: 1
                            radius: Theme.radius
                            clip: true
                            Canvas {
                                id: radarCanvas
                                anchors.fill: parent
                                anchors.margins: 6
                                onPaint: {
                                    var c = getContext("2d")
                                    c.clearRect(0,0,width,height)
                                    c.strokeStyle = "#244A63"
                                    c.lineWidth = 1
                                    c.globalAlpha = 0.65
                                    for (var gx = 1; gx < 10; ++gx) { c.beginPath(); c.moveTo(width*gx/10,0); c.lineTo(width*gx/10,height); c.stroke() }
                                    for (var gy = 1; gy < 7; ++gy) { c.beginPath(); c.moveTo(0,height*gy/7); c.lineTo(width,height*gy/7); c.stroke() }
                                    var cx = width/2
                                    var cy = height/2
                                    var r = Math.min(width,height)*0.44
                                    c.strokeStyle = "#3B6C70"
                                    c.globalAlpha = 0.9
                                    for (var ring=1; ring<=5; ++ring) { c.beginPath(); c.arc(cx,cy,r*ring/5,0,Math.PI*2); c.stroke() }
                                    for (var a=0; a<360; a+=30) { var rad=a*Math.PI/180; c.beginPath(); c.moveTo(cx,cy); c.lineTo(cx+Math.cos(rad)*r,cy+Math.sin(rad)*r); c.stroke() }
                                    var sweep=(cockpit.tick%360)*Math.PI/180
                                    c.strokeStyle=Theme.radarGreen
                                    c.lineWidth=2
                                    c.globalAlpha=0.95
                                    c.beginPath(); c.moveTo(cx,cy); c.lineTo(cx+Math.cos(sweep)*r,cy+Math.sin(sweep)*r); c.stroke()
                                    c.globalAlpha=1
                                }
                                Connections { target: cockpit; function onDataChanged() { radarCanvas.requestPaint() } }
                            }
                            Repeater {
                                model: cockpit.publicFlightTracks
                                delegate: Item {
                                    required property var modelData
                                    width: 88; height: 34
                                    x: page.worldX(modelData.longitude, radarFrame.width) - 11
                                    y: page.worldY(modelData.latitude, radarFrame.height) - 11
                                    Item {
                                        width: 22; height: 22
                                        rotation: Number(modelData.headingDegrees)
                                        Rectangle { anchors.centerIn: parent; width: 18; height: 3; radius: 1; color: Theme.signalCyan }
                                        Rectangle { anchors.centerIn: parent; width: 3; height: 18; radius: 1; color: Theme.platinum }
                                    }
                                    Rectangle {
                                        x: 24; y: 0; width: 62; height: 30
                                        color: "#C0121B22"
                                        border.color: Theme.signalCyan
                                        border.width: 1
                                        radius: Theme.radius
                                        Column {
                                            anchors.fill: parent; anchors.margins: 3; spacing: 0
                                            Text { text: modelData.callsign || modelData.icao24; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 6; font.bold: true; elide: Text.ElideRight; width: parent.width }
                                            Text { text: Math.round(Number(modelData.altitudeMeters)) + "m"; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 5 }
                                        }
                                    }
                                }
                            }
                            Repeater {
                                model: cockpit.airOperationsTracks
                                delegate: Item {
                                    required property int index
                                    required property var modelData
                                    width: 118; height: 40
                                    x: Math.max(10, Math.min(radarFrame.width-width-10, radarFrame.width*(0.18+((index*0.29)%0.68))))
                                    y: Math.max(10, Math.min(radarFrame.height-height-10, radarFrame.height*(0.20+((index*0.23)%0.62))))
                                    Rectangle { x: 0; y: 12; width: 14; height: 14; radius: 7; color: page.threatColor(modelData.threatLevel); border.color: Theme.platinum; border.width: 1 }
                                    Rectangle {
                                        x: 18; y: 0; width: 98; height: 38
                                        color: "#D018232C"
                                        border.color: page.threatColor(modelData.threatLevel)
                                        border.width: 1
                                        radius: Theme.radius
                                        Column {
                                            anchors.fill: parent; anchors.margins: 4; spacing: 0
                                            Text { text: modelData.trackId + "  " + page.upper(modelData.threatLevel); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                            Text { text: modelData.classification; color: page.threatColor(modelData.threatLevel); font.pixelSize: 6; elide: Text.ElideRight; width: parent.width }
                                            Text { text: Math.round(Number(modelData.altitudeMeters)) + "m  " + Math.round(Number(modelData.speedMetersPerSecond)) + "m/s"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 5 }
                                        }
                                    }
                                }
                            }
                            Rectangle {
                                anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 8
                                width: 220; height: 62
                                color: "#D00C1319"
                                border.color: Theme.signalCyan
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 6; spacing: 1
                                    Text { text: "PUBLIC ADS-B  " + cockpit.publicFlightTrackCount; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                    Text { text: "AEGIS / C-UAS  " + cockpit.airOperationsTrackCount; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                    Text { text: "HIGH  " + cockpit.airOperationsHighCount + "  •  INC  " + cockpit.airOperationsIncidentCount; color: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 6 }
                                }
                            }
                            RowLayout {
                                anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 8; spacing: 8
                                Rectangle { width: 8; height: 8; color: Theme.signalCyan }
                                Text { text: "PUBLIC ADS-B"; color: Theme.silver; font.pixelSize: 6 }
                                Rectangle { width: 8; height: 8; radius: 4; color: Theme.royalGold }
                                Text { text: "AEGIS / C-UAS"; color: Theme.silver; font.pixelSize: 6 }
                                Item { Layout.fillWidth: true }
                                Text { text: cockpit.rtl ? "وعي موقفي وتحليل فقط" : "AWARENESS / ANALYSIS ONLY"; color: Theme.radarGreen; font.pixelSize: 6; font.bold: true }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 166
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 7; spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "جاهزية المنصات" : "PLATFORM READINESS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.readinessReadyCount + " / " + cockpit.readinessAssets.length + " READY"; color: page.readinessColor(cockpit.readinessFleetPercent); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true; Layout.fillHeight: true
                            orientation: ListView.Horizontal
                            model: cockpit.readinessAssets
                            spacing: 5
                            clip: true
                            delegate: Rectangle {
                                required property var modelData
                                width: 230
                                height: ListView.view.height
                                color: Theme.panel2
                                border.color: page.readinessColor(Number(modelData.readiness))
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 7; spacing: 7
                                    Rectangle {
                                        width: 46; height: 46
                                        color: Theme.panel3
                                        border.color: page.aircraftAccent(modelData.id)
                                        border.width: 1
                                        radius: Theme.radius
                                        Text { anchors.centerIn: parent; text: Theme.platformCode(modelData.id); color: page.aircraftAccent(modelData.id); font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true; spacing: 1
                                        Text { text: modelData.name || modelData.id; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: (modelData.readiness || 0) + "%  •  " + (modelData.state || "UNKNOWN"); color: page.readinessColor(Number(modelData.readiness)); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                        Text { text: "CREW " + (modelData.crewReady || 0) + "/" + (modelData.crewRequired || 0); color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                                        Rectangle {
                                            Layout.fillWidth: true; height: 5; color: Theme.panel3; radius: 1
                                            Rectangle { width: parent.width * page.clamp(Number(modelData.readiness || 0)/100.0,0,1); height: parent.height; color: page.readinessColor(Number(modelData.readiness)); radius: 1 }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 420
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 245
                    color: Theme.panel
                    border.color: page.aircraftAccent(cockpit.activePlatformId)
                    border.width: 1
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 7; spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "الطائرة المختارة" : "SELECTED AIRCRAFT"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: Theme.platformCode(cockpit.activePlatformId); color: page.aircraftAccent(cockpit.activePlatformId); font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true
                            color: "#0E1820"
                            border.color: Theme.deepBlue
                            border.width: 1
                            radius: Theme.radius
                            AircraftSchematic {
                                anchors.fill: parent
                                anchors.margins: 10
                                platformId: cockpit.activePlatformId
                                subsystemRows: cockpit.twinRows
                                accent: page.aircraftAccent(cockpit.activePlatformId)
                            }
                            Rectangle {
                                anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 6
                                width: 205; height: 48
                                color: "#D00C1319"
                                border.color: page.aircraftAccent(cockpit.activePlatformId)
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent; anchors.margins: 5; spacing: 0
                                    Text { text: cockpit.activePlatformName; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: cockpit.activePlatformCategory + " • " + cockpit.activePlatformPropulsion; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 5; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: "DX " + cockpit.diagnosticHealthScore + "%  •  TWIN " + cockpit.twinNominalCount; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 165
                    color: Theme.panel
                    border.color: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 7; spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "مركز استجابة C-UAS" : "C-UAS RESPONSE"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: cockpit.airOperationsHighCount + " HIGH"; color: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 4
                            columnSpacing: 5
                            Repeater {
                                model: [
                                    {t:"TRACKS",v:cockpit.airOperationsTrackCount,c:Theme.signalCyan},
                                    {t:"INC",v:cockpit.airOperationsIncidentCount,c:Theme.royalGold},
                                    {t:"HIGH",v:cockpit.airOperationsHighCount,c:Theme.warmOrange},
                                    {t:"OBS",v:cockpit.airOperationsObservationCount,c:Theme.radarGreen}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true; Layout.preferredHeight: 48
                                    color: Theme.panel2; border.color: modelData.c; border.width: 1; radius: Theme.radius
                                    ColumnLayout {
                                        anchors.fill: parent; anchors.margins: 4; spacing: 0
                                        Text { text: modelData.t; color: Theme.muted; font.pixelSize: 5; font.bold: true }
                                        Text { text: String(modelData.v); color: modelData.c; font.family: "Consolas"; font.pixelSize: 11; font.bold: true }
                                    }
                                }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true; spacing: 3
                            Repeater {
                                model: ["DETECT","CLASSIFY","VERIFY","COORD","RECORD"]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true; Layout.preferredHeight: 24
                                    color: Theme.panel2; border.color: Theme.radarGreen; border.width: 1; radius: Theme.radius
                                    Text { anchors.centerIn: parent; text: modelData; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
                                }
                            }
                        }
                        Text { text: cockpit.rtl ? "تنسيق ومراجعة تدريبية فقط — بدون تشويش أو استحواذ أو اشتباك حي" : "TRAINING COORDINATION / REVIEW ONLY — NO LIVE JAMMING, TAKEOVER OR ENGAGEMENT"; color: Theme.warmOrange; font.pixelSize: 6; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.rfViolet
                    border.width: 1
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 7; spacing: 4
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "طيف RF السلبي" : "PASSIVE RF SPECTRUM"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                            Text { text: Number(cockpit.rfPeakFrequencyMhz).toFixed(1) + " MHz"; color: Theme.rfViolet; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Rectangle {
                            Layout.fillWidth: true; Layout.fillHeight: true
                            color: "#111724"
                            border.color: Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius
                            Row {
                                anchors.fill: parent; anchors.margins: 6; spacing: 1
                                Repeater {
                                    model: cockpit.rfSpectrumBins
                                    delegate: Rectangle {
                                        required property var modelData
                                        width: Math.max(2,(parent.width-63)/64)
                                        height: page.clamp((Number(modelData.levelDbm)+110.0)/80.0,0.03,1.0)*parent.height
                                        anchors.bottom: parent.bottom
                                        color: Number(modelData.levelDbm)>-60 ? Theme.warmOrange : (Number(modelData.levelDbm)>-78 ? Theme.rfViolet : Theme.signalCyan)
                                        opacity: 0.9
                                    }
                                }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rfSpectrumMode; color: Theme.rfViolet; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                            Item { Layout.fillWidth: true }
                            Text { text: Number(cockpit.rfPeakLevelDbm).toFixed(1) + " dBm"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            color: Theme.panel
            border.color: Theme.radarGreen
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent; anchors.margins: 5
                Text { text: "AEGIS C-UAS"; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.muted; font.pixelSize: 7 }
                Text { text: "AIR OPS EXCHANGE"; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.muted; font.pixelSize: 7 }
                Text { text: "AVIONICS LAB"; color: Theme.skyBlue; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                Text { text: "→"; color: Theme.muted; font.pixelSize: 7 }
                Text { text: "READINESS OPS"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                Item { Layout.fillWidth: true }
                Text { text: cockpit.rtl ? "تدريب • محاكاة • تحليل • لا تحكم حي" : "TRAINING • SIMULATION • ANALYSIS • NO LIVE CONTROL"; color: Theme.radarGreen; font.pixelSize: 6; font.bold: true }
            }
        }
    }
}
