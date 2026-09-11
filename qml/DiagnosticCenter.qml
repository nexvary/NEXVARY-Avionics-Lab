import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page

    property bool scanComplete: false
    property int selectedCode: 0
    property string codeQuery: ""
    property string systemFilter: "ALL"
    property int lastScanTick: -1

    property var codeCatalog: [
        {"code":"NXD-PWR-101","system":"POWER","severity":"WARNING","title":"Bus Voltage Below Training Envelope","meaning":"The simulated main electrical bus is below the configured nominal training range.","cause":"Synthetic power-transient scenario, injected low-power preset, or invalid bus-voltage channel.","isolation":"Confirm bus_voltage_v validity; compare current value with recent trend; correlate with power subsystem health and event timeline.","recovery":"Clear the training fault or return the scenario to nominal, then verify stable bus voltage and nominal power-subsystem state.","sensor":"bus_voltage_v"},
        {"code":"NXD-CMP-201","system":"COMPUTE","severity":"WARNING","title":"Compute Thermal Excursion","meaning":"The simulated compute temperature is above its configured training threshold.","cause":"Synthetic thermal-rise scenario, compute-hot preset, or abnormal temperature-channel trend.","isolation":"Review cpu_temp_c quality and slope; compare with compute Digital Twin state and recent warnings.","recovery":"Remove the synthetic thermal condition and verify temperature trend returns toward the nominal envelope.","sensor":"cpu_temp_c"},
        {"code":"NXD-FLT-301","system":"FLIGHT SENSORS","severity":"FAULT","title":"Attitude Channel Unavailable","meaning":"One or more simulated attitude channels are invalid or unavailable for the current frame.","cause":"Sensor-dropout scenario, injected IMU dropout, or invalid telemetry sample.","isolation":"Check imu_pitch_deg and imu_roll_deg validity; inspect missing/invalid counters; correlate with flight-sensor twin state.","recovery":"Restore valid synthetic IMU samples and verify both attitude channels return to nominal quality.","sensor":"imu_pitch_deg"},
        {"code":"NXD-HYD-401","system":"HYDRAULICS","severity":"WARNING","title":"Hydraulic Pressure Degraded","meaning":"The simulated hydraulic pressure has moved outside the preferred training band or quality has degraded.","cause":"Scenario-driven degradation, invalid pressure sample, or synthetic subsystem fault.","isolation":"Inspect hydraulic_pressure_pct latest value, quality, delta and subsystem health before clearing the finding.","recovery":"Return the channel to a stable nominal value and verify the hydraulic Digital Twin state is NOMINAL.","sensor":"hydraulic_pressure_pct"},
        {"code":"NXD-FUL-501","system":"FUEL","severity":"WARNING","title":"Fuel Quantity Channel Mismatch","meaning":"The simulated fuel channel is inconsistent with the expected training-state progression.","cause":"Injected synthetic offset, discontinuity in recorded frames, or abnormal trend.","isolation":"Compare fuel_level_pct with previous frames, delta and recorder continuity; confirm channel quality is valid.","recovery":"Restore a continuous nominal synthetic fuel signal and verify the mismatch no longer appears.","sensor":"fuel_level_pct"},
        {"code":"NXD-DAT-601","system":"DATA","severity":"FAULT","title":"Telemetry Sequence Integrity Fault","meaning":"The recorded training session contains a missing, invalid or non-monotonic telemetry condition.","cause":"Corrupted synthetic session, missing frame, invalid sample, or sequence/time-order failure.","isolation":"Run verification, inspect recorder/session evidence, then identify the first invalid or missing frame/channel.","recovery":"Use a valid session or regenerate the synthetic run, then pass sequence and timestamp verification gates.","sensor":""},
        {"code":"NXD-NAV-701","system":"NAVIGATION","severity":"WARNING","title":"Navigation Sensor Disagreement","meaning":"Simulated navigation-related channels disagree beyond the configured training tolerance.","cause":"Synthetic sensor offset, dropout, or inconsistent replay frame.","isolation":"Correlate altitude/attitude channels and quality metrics with the event timeline and current scenario.","recovery":"Restore coherent synthetic channels and confirm the related Digital Twin subsystem returns to NOMINAL.","sensor":"altitude_m"},
        {"code":"NXD-REC-801","system":"RECORDER","severity":"FAULT","title":"Recorder Continuity Failure","meaning":"The training recorder cannot provide a continuous evidence chain for the selected run.","cause":"Empty recording, frame discontinuity, invalid timestamp order, or corrupted archive.","isolation":"Check recorded frame count, timeline monotonicity and verification evidence before using replay results.","recovery":"Create a fresh valid recording and confirm verification gates pass before analysis.","sensor":""}
    ]

    function severityColor(s) {
        if (s === "FAULT") return Theme.red
        if (s === "WARNING") return Theme.amber
        return Theme.green
    }

    function invalidSensorCount() {
        var n = 0
        for (var i=0; i<cockpit.sensorRows.length; ++i) if (!cockpit.sensorRows[i].valid) ++n
        return n
    }

    function degradedTwinCount() {
        return cockpit.twinDegradedCount + cockpit.twinFaultCount + cockpit.twinUnknownCount
    }

    function liveFindingCount() {
        var n = 0
        if (invalidSensorCount() > 0) ++n
        if (cockpit.twinFaultCount > 0) ++n
        if (cockpit.twinDegradedCount > 0) ++n
        if (cockpit.activeAlertCount > 0) ++n
        return n
    }

    function filteredCatalog() {
        var out = []
        var q = codeQuery.trim().toLowerCase()
        for (var i=0; i<codeCatalog.length; ++i) {
            var c = codeCatalog[i]
            var systemOk = systemFilter === "ALL" || c.system === systemFilter
            var queryOk = q.length === 0 || c.code.toLowerCase().indexOf(q) >= 0 || c.title.toLowerCase().indexOf(q) >= 0 || c.system.toLowerCase().indexOf(q) >= 0
            if (systemOk && queryOk) out.push(c)
        }
        return out
    }

    function selected() {
        var list = filteredCatalog()
        if (list.length === 0) return ({"code":"—","system":"—","severity":"INFO","title":"No matching training code","meaning":"Adjust the search or system filter.","cause":"—","isolation":"—","recovery":"—","sensor":""})
        return list[Math.max(0, Math.min(selectedCode, list.length-1))]
    }

    function runScan() {
        scanComplete = true
        lastScanTick = cockpit.tick
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            spacing: 7

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 11
                    spacing: 12
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1
                        Text {
                            text: cockpit.rtl ? "مركز تشخيص أنظمة الطيران" : "AVIONICS DIAGNOSTIC CENTER"
                            color: Theme.platinum
                            font.pixelSize: 20
                            font.bold: true
                            Layout.fillWidth: true
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        }
                        Text {
                            text: cockpit.rtl ? "فحص الأنظمة • تفسير الأكواد • عزل الأعطال • دليل الاستعادة" : "SYSTEM SCAN / CODE INTERPRETER / FAULT ISOLATION / RECOVERY EVIDENCE"
                            color: Theme.accent
                            font.pixelSize: 8
                            font.bold: true
                            font.letterSpacing: .6
                        }
                        Text {
                            text: cockpit.rtl ? "أكواد NEXVARY تدريبية وليست أكواد مصنع أو اعتماد صلاحية طيران" : "NEXVARY TRAINING CODES — NOT OEM OR AIRWORTHINESS CODES"
                            color: Theme.muted
                            font.pixelSize: 7
                        }
                    }
                    Rectangle { width: 1; Layout.fillHeight: true; color: Theme.borderSoft }
                    ColumnLayout {
                        Layout.preferredWidth: 150
                        spacing: 1
                        Text { text: "SCAN STATE"; color: Theme.muted; font.pixelSize: 7 }
                        Text { text: scanComplete ? "COMPLETE" : "READY"; color: scanComplete ? Theme.green : Theme.accent; font.family: "Consolas"; font.pixelSize: 14; font.bold: true }
                        Text { text: lastScanTick < 0 ? "NOT RUN" : "TICK " + lastScanTick; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8 }
                    }
                    MinisterialButton {
                        text: cockpit.rtl ? "تشغيل الفحص" : "RUN SYNTHETIC SCAN"
                        implicitWidth: 160
                        accent: Theme.accent
                        onClicked: page.runScan()
                    }
                }
            }

            StatusCard { Layout.preferredWidth: 170; Layout.fillHeight: true; title: "LIVE FINDINGS"; value: String(page.liveFindingCount()); subtitle: "CURRENT RUN"; iconText: "DX"; accent: page.liveFindingCount() > 0 ? Theme.amber : Theme.accent }
            StatusCard { Layout.preferredWidth: 170; Layout.fillHeight: true; title: "INVALID CHANNELS"; value: String(page.invalidSensorCount()); subtitle: "TELEMETRY"; iconText: "CH"; accent: page.invalidSensorCount() > 0 ? Theme.red : Theme.accent }
            StatusCard { Layout.preferredWidth: 170; Layout.fillHeight: true; title: "TWIN ISSUES"; value: String(page.degradedTwinCount()); subtitle: "SYSTEM MODEL"; iconText: "DT"; accent: page.degradedTwinCount() > 0 ? Theme.amber : Theme.accent }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7

            Rectangle {
                Layout.preferredWidth: 390
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 5
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "فحص الأنظمة الحالي" : "CURRENT SYSTEM SCAN"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text { text: cockpit.scenario.toUpperCase(); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    Repeater {
                        model: cockpit.twinRows
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 58
                            color: index % 2 ? Theme.panel2 : Theme.panel
                            border.color: Theme.borderSoft
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                Rectangle { width: 4; height: 30; color: Theme.stateColor(modelData.state) }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Text { text: modelData.label; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: "CHANNELS " + modelData.valid + "/" + modelData.expected + "  •  ISSUES " + modelData.issues; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                                }
                                ColumnLayout {
                                    Layout.preferredWidth: 86
                                    spacing: 0
                                    Text { text: modelData.state; color: Theme.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.alignment: Qt.AlignRight }
                                    Text { text: Number(modelData.health).toFixed(0) + "%"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 10; Layout.alignment: Qt.AlignRight }
                                }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 76
                        color: Theme.panel2
                        border.color: Theme.border
                        radius: Theme.radius
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 2
                            Text { text: cockpit.rtl ? "ملخص التشخيص" : "DIAGNOSTIC SUMMARY"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                            Text { text: "ALERTS " + cockpit.activeAlertCount + "  •  INVALID " + page.invalidSensorCount() + "  •  TWIN FAULTS " + cockpit.twinFaultCount; color: page.liveFindingCount() > 0 ? Theme.amber : Theme.green; font.family: "Consolas"; font.pixelSize: 8 }
                            Text { text: scanComplete ? (page.liveFindingCount() > 0 ? "FINDINGS REQUIRE TRAINING REVIEW" : "NO ACTIVE TRAINING FINDINGS") : "RUN SCAN TO CAPTURE CURRENT EVIDENCE"; color: Theme.muted; font.pixelSize: 7 }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 505
                Layout.fillHeight: true
                color: Theme.panel
                border.color: Theme.border
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 5
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "مكتبة أكواد الأعطال" : "FAULT-CODE LIBRARY"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                        Text { text: page.filteredCatalog().length + " CODES"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        TextField {
                            id: searchField
                            Layout.fillWidth: true
                            placeholderText: cockpit.rtl ? "بحث بالكود أو النظام أو الوصف" : "Search code, system or description"
                            color: Theme.platinum
                            font.pixelSize: 8
                            onTextChanged: { page.codeQuery = text; page.selectedCode = 0 }
                            background: Rectangle { color: Theme.panel2; border.color: searchField.activeFocus ? Theme.accent : Theme.border; radius: Theme.radius }
                        }
                        ComboBox {
                            id: filterBox
                            Layout.preferredWidth: 145
                            model: ["ALL","POWER","COMPUTE","FLIGHT SENSORS","HYDRAULICS","FUEL","DATA","NAVIGATION","RECORDER"]
                            onActivated: { page.systemFilter = currentText; page.selectedCode = 0 }
                            contentItem: Text { text: filterBox.displayText; color: Theme.platinum; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.family: "Consolas"; font.pixelSize: 7 }
                            background: Rectangle { color: Theme.panel2; border.color: Theme.border; radius: Theme.radius }
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24
                        Text { text: "CODE"; color: Theme.muted; Layout.preferredWidth: 100; font.pixelSize: 7 }
                        Text { text: "SYSTEM"; color: Theme.muted; Layout.preferredWidth: 105; font.pixelSize: 7 }
                        Text { text: "DESCRIPTION"; color: Theme.muted; Layout.fillWidth: true; font.pixelSize: 7 }
                        Text { text: "LEVEL"; color: Theme.muted; Layout.preferredWidth: 66; horizontalAlignment: Text.AlignRight; font.pixelSize: 7 }
                    }
                    ListView {
                        id: codeList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: page.filteredCatalog()
                        clip: true
                        spacing: 1
                        currentIndex: page.selectedCode
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            width: ListView.view.width
                            height: 54
                            color: index === page.selectedCode ? "#14232C" : (index % 2 ? Theme.panel2 : Theme.panel)
                            border.color: index === page.selectedCode ? Theme.accent : Theme.borderSoft
                            MouseArea { anchors.fill: parent; onClicked: page.selectedCode = index }
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 6
                                Text { text: modelData.code; color: Theme.platinum; Layout.preferredWidth: 100; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                Text { text: modelData.system; color: Theme.silver; Layout.preferredWidth: 105; font.family: "Consolas"; font.pixelSize: 7; elide: Text.ElideRight }
                                Text { text: modelData.title; color: Theme.platinum; Layout.fillWidth: true; font.pixelSize: 8; elide: Text.ElideRight }
                                Text { text: modelData.severity; color: page.severityColor(modelData.severity); Layout.preferredWidth: 66; horizontalAlignment: Text.AlignRight; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
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
                radius: Theme.radius
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 7

                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1
                            Text { text: page.selected().code; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 18; font.bold: true }
                            Text { text: page.selected().system; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle {
                            Layout.preferredWidth: 84
                            Layout.preferredHeight: 26
                            color: Theme.panel2
                            border.color: page.severityColor(page.selected().severity)
                            radius: Theme.radius
                            Text { anchors.centerIn: parent; text: page.selected().severity; color: page.severityColor(page.selected().severity); font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                    }

                    Text { text: page.selected().title; color: Theme.platinum; font.pixelSize: 12; font.bold: true; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    Text { text: cockpit.rtl ? "المعنى" : "MEANING"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                    Text { text: page.selected().meaning; color: Theme.silver; font.pixelSize: 9; Layout.fillWidth: true; wrapMode: Text.WordWrap }

                    Text { text: cockpit.rtl ? "الأسباب المحتملة" : "POSSIBLE CAUSES"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                    Text { text: page.selected().cause; color: Theme.silver; font.pixelSize: 9; Layout.fillWidth: true; wrapMode: Text.WordWrap }

                    Text { text: cockpit.rtl ? "مسار عزل العطل" : "FAULT ISOLATION PATH"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 92
                        color: Theme.panel2
                        border.color: Theme.border
                        radius: Theme.radius
                        Text { anchors.fill: parent; anchors.margins: 8; text: page.selected().isolation; color: Theme.platinum; font.pixelSize: 9; wrapMode: Text.WordWrap; verticalAlignment: Text.AlignVCenter }
                    }

                    Text { text: cockpit.rtl ? "معيار الاستعادة" : "RECOVERY CRITERIA"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 78
                        color: Theme.panel2
                        border.color: Theme.accent
                        radius: Theme.radius
                        Text { anchors.fill: parent; anchors.margins: 8; text: page.selected().recovery; color: Theme.silver; font.pixelSize: 9; wrapMode: Text.WordWrap; verticalAlignment: Text.AlignVCenter }
                    }

                    Item { Layout.fillHeight: true }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        color: "#101A20"
                        border.color: Theme.border
                        radius: Theme.radius
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text { text: "LINKED EVIDENCE"; color: Theme.muted; font.pixelSize: 7 }
                                Text { text: page.selected().sensor.length ? page.selected().sensor : "SESSION / TIMELINE"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                            }
                            Text { text: "TRAINING ONLY"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                    }
                }
            }
        }
    }
}
