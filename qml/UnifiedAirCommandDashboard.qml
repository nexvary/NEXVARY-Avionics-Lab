import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function overallState() {
        if (cockpit.airOperationsHighCount > 0 || cockpit.twinFaultCount > 0)
            return cockpit.rtl ? "يتطلب مراجعة" : "REVIEW REQUIRED"
        if (cockpit.readinessFleetPercent < 85 || cockpit.activeAlertCount > 0)
            return cockpit.rtl ? "جاهزية محدودة" : "LIMITED READINESS"
        return cockpit.rtl ? "مستقر للتدريب" : "TRAINING NOMINAL"
    }
    function readinessColor(v) {
        if (v >= 90) return Theme.radarGreen
        if (v >= 80) return Theme.royalGold
        return Theme.warmOrange
    }
    function stateColor(s) {
        var v = String(s || "").toUpperCase()
        if (v === "READY" || v === "NOMINAL") return Theme.radarGreen
        if (v === "LIMITED" || v === "DEGRADED") return Theme.royalGold
        return Theme.warmOrange
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        // Executive masthead.
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
                spacing: 9
                Rectangle { width: 5; Layout.fillHeight: true; color: Theme.signalCyan; radius: 2 }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
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
                        text: cockpit.rtl ? "صورة جوية • ADS-B • AEGIS • C-UAS • RF سلبي • جاهزية • صيانة • توأم رقمي" : "AIR PICTURE • ADS-B • AEGIS • C-UAS • PASSIVE RF • READINESS • MAINTENANCE • DIGITAL TWIN"
                        color: Theme.signalCyan
                        font.pixelSize: 7
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 288
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 7
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

        // Dense command KPI strip.
        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 78
            columns: 7
            columnSpacing: 5
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "المسارات الجوية" : "AIR TRACKS"; value: String(cockpit.airOperationsTrackCount + cockpit.publicFlightTrackCount); subtitle: cockpit.publicFlightTrackCount + (cockpit.rtl ? " عام" : " PUBLIC"); iconText: "AIR"; accent: Theme.signalCyan }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "حوادث C-UAS" : "C-UAS INCIDENTS"; value: String(cockpit.airOperationsIncidentCount); subtitle: cockpit.airOperationsHighCount + (cockpit.rtl ? " عالية" : " HIGH"); iconText: "CUAS"; accent: cockpit.airOperationsHighCount > 0 ? Theme.warmOrange : Theme.royalGold }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "ذروة RF" : "RF PEAK"; value: Number(cockpit.rfPeakFrequencyMhz).toFixed(1); subtitle: Number(cockpit.rfPeakLevelDbm).toFixed(0) + " dBm"; iconText: "RF"; accent: Theme.rfViolet }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "جاهزية الأسطول" : "FLEET READY"; value: cockpit.readinessFleetPercent + "%"; subtitle: cockpit.readinessReadyCount + "/" + cockpit.readinessAssets.length + (cockpit.rtl ? " جاهزة" : " READY"); iconText: "RDY"; accent: page.readinessColor(cockpit.readinessFleetPercent) }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "الصيانة" : "MAINTENANCE"; value: String(cockpit.readinessMaintenanceOpenCount); subtitle: cockpit.rtl ? "بنود متابعة" : "FOLLOW-UP"; iconText: "MNT"; accent: Theme.royalGold }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "الصحة التشخيصية" : "DIAGNOSTICS"; value: cockpit.diagnosticHealthScore + "%"; subtitle: cockpit.diagnosticFindingCount + (cockpit.rtl ? " نتيجة" : " FINDINGS"); iconText: "DX"; accent: cockpit.diagnosticHealthScore >= 90 ? Theme.radarGreen : Theme.warmOrange }
            StatusCard { Layout.fillWidth: true; Layout.fillHeight: true; title: cockpit.rtl ? "التوأم الرقمي" : "DIGITAL TWIN"; value: String(cockpit.twinNominalCount); subtitle: cockpit.twinFaultCount + (cockpit.rtl ? " أعطال" : " FAULTS"); iconText: "DT"; accent: cockpit.twinFaultCount > 0 ? Theme.warmOrange : Theme.radarGreen }
        }

        // Main air picture and context column.
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                border.width: 1
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "الصورة الجوية الموحدة" : "UNIFIED AIR PICTURE"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text { text: cockpit.airOperationsSource + " • " + cockpit.airOperationsMode; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 6; elide: Text.ElideRight }
                    }
                    CommandAirMap {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        publicTracks: cockpit.publicFlightTracks
                        aegisTracks: cockpit.airOperationsTracks
                        rtl: cockpit.rtl
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 332
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 190
                    color: Theme.panel
                    border.color: Theme.signalCyan
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 4
                        Text { text: cockpit.rtl ? "سياق الصورة الجوية" : "AIR PICTURE CONTEXT"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            rowSpacing: 3
                            columnSpacing: 6
                            Text { text: cockpit.rtl ? "المصدر" : "SOURCE"; color: Theme.muted; font.pixelSize: 5 }
                            Text { text: cockpit.airOperationsSource; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 6; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: cockpit.rtl ? "المسارات" : "TRACKS"; color: Theme.muted; font.pixelSize: 5 }
                            Text { text: String(cockpit.airOperationsTrackCount + cockpit.publicFlightTrackCount); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            Text { text: cockpit.rtl ? "الأولوية" : "HIGH"; color: Theme.muted; font.pixelSize: 5 }
                            Text { text: String(cockpit.airOperationsHighCount); color: cockpit.airOperationsHighCount ? Theme.warmOrange : Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            Text { text: cockpit.rtl ? "المشاهدات" : "OBSERVATIONS"; color: Theme.muted; font.pixelSize: 5 }
                            Text { text: String(cockpit.airOperationsObservationCount); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8 }
                        }
                        Item { Layout.fillHeight: true }
                        Repeater {
                            model: [
                                {t:"AEGIS C-UAS",c:Theme.royalGold},
                                {t:"ADS-B / PUBLIC",c:Theme.signalCyan},
                                {t:"PASSIVE RF",c:Theme.rfViolet},
                                {t:"DIGITAL TWIN",c:Theme.radarGreen}
                            ]
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                Rectangle { width: 7; height: 7; radius: 4; color: modelData.c }
                                Text { text: modelData.t; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true }
                                Text { text: "ONLINE"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
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
                            Text { text: cockpit.rtl ? "الحوادث ذات الأولوية" : "PRIORITY INCIDENTS"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.airOperationsIncidentCount); color: Theme.warmOrange; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 3
                            model: cockpit.airOperationsIncidents
                            delegate: Rectangle {
                                required property var modelData
                                width: ListView.view.width
                                height: 47
                                color: Theme.panel2
                                border.color: Theme.warmOrange
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 0
                                    Text { text: modelData.trackId || modelData.incidentId || "INCIDENT"; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.summary || modelData.status || "Review record"; color: Theme.silver; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: String(modelData.peakThreatLevel || "REVIEW").toUpperCase(); color: Theme.warmOrange; font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Visual intelligence band.
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 190
            spacing: 6
            CuasSummaryPanel {
                Layout.fillWidth: true
                Layout.fillHeight: true
                tracks: cockpit.airOperationsTrackCount
                incidents: cockpit.airOperationsIncidentCount
                highCount: cockpit.airOperationsHighCount
                observations: cockpit.airOperationsObservationCount
                rtl: cockpit.rtl
            }
            RfSpectrumMini {
                Layout.fillWidth: true
                Layout.fillHeight: true
                bins: cockpit.rfSpectrumBins
                peakFrequencyMhz: cockpit.rfPeakFrequencyMhz
                peakLevelDbm: cockpit.rfPeakLevelDbm
                rtl: cockpit.rtl
            }
            AircraftCommandCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                rtl: cockpit.rtl
            }
        }

        // Compact readiness matrix instead of four oversized empty cards.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 112
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 4
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: cockpit.rtl ? "مصفوفة جاهزية المنصات" : "PLATFORM READINESS MATRIX"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                    Text { text: cockpit.readinessReadyCount + "/" + cockpit.readinessAssets.length + " READY"; color: page.readinessColor(cockpit.readinessFleetPercent); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 5
                    Repeater {
                        model: cockpit.readinessAssets
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Theme.panel2
                            border.color: page.stateColor(modelData.state)
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 6
                                Rectangle {
                                    Layout.preferredWidth: 50
                                    Layout.fillHeight: true
                                    color: "#0E1820"
                                    border.color: Theme.deepBlue
                                    border.width: 1
                                    radius: Theme.radius
                                    Text { anchors.centerIn: parent; text: Theme.platformCode(modelData.id); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: modelData.name || modelData.id; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: String(modelData.readiness) + "%"; color: page.readinessColor(Number(modelData.readiness)); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                        Item { Layout.fillWidth: true }
                                        Text { text: String(modelData.state); color: page.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                    }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 5
                                        color: Theme.shell
                                        radius: 2
                                        Rectangle { width: parent.width * Math.max(0, Math.min(1, Number(modelData.readiness)/100)); height: parent.height; radius: 2; color: page.readinessColor(Number(modelData.readiness)) }
                                    }
                                    Text { text: (cockpit.rtl ? "طاقم " : "CREW ") + modelData.crewReady + "/" + modelData.crewRequired + "  •  " + modelData.hoursToInspection + "h"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 5; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 22
            color: Theme.shell
            border.color: Theme.borderSoft
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 6
                Text { text: "AEGIS C-UAS"; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
                Text { text: "→"; color: Theme.muted; font.pixelSize: 6 }
                Text { text: "AIR OPS EXCHANGE"; color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
                Text { text: "→"; color: Theme.muted; font.pixelSize: 6 }
                Text { text: "AVIONICS LAB"; color: Theme.skyBlue; font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
                Text { text: "→"; color: Theme.muted; font.pixelSize: 6 }
                Text { text: "READINESS OPS"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 5; font.bold: true }
                Item { Layout.fillWidth: true }
                Text { text: cockpit.rtl ? "تدريب • محاكاة • تحليل • لا تحكم حي" : "TRAINING • SIMULATION • ANALYSIS • NO LIVE CONTROL"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 5 }
            }
        }
    }
}
