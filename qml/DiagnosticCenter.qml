import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "DiagnosticCodeCatalog.js" as DxCodes

Item {
    id: page

    property bool scanComplete: false
    property int selectedCode: 0
    property string codeQuery: ""
    property string systemFilter: "ALL"
    property int lastScanTick: -1

    property var codeCatalog: DxCodes.catalog()

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
            var haystack = (c.code + " " + c.system + " " + c.title + " " + c.meaning + " " + c.cause + " " + c.sensor).toLowerCase()
            var queryOk = q.length === 0 || haystack.indexOf(q) >= 0
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
                            text: cockpit.rtl ? "48 كود NEXVARY تدريبيًا عبر 12 منظومة — ليست أكواد مصنع أو اعتماد صلاحية طيران" : "48 NEXVARY TRAINING CODES ACROSS 12 SYSTEMS — NOT OEM OR AIRWORTHINESS CODES"
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

            StatusCard { Layout.preferredWidth: 170; Layout.fillHeight: true; title: "CODE LIBRARY"; value: String(page.codeCatalog.length); subtitle: "12 SYSTEMS"; iconText: "DB"; accent: Theme.accent }
            StatusCard { Layout.preferredWidth: 170; Layout.fillHeight: true; title: "LIVE FINDINGS"; value: String(page.liveFindingCount()); subtitle: "CURRENT RUN"; iconText: "DX"; accent: page.liveFindingCount() > 0 ? Theme.amber : Theme.accent }
            StatusCard { Layout.preferredWidth: 170; Layout.fillHeight: true; title: "INVALID CHANNELS"; value: String(page.invalidSensorCount()); subtitle: "TELEMETRY"; iconText: "CH"; accent: page.invalidSensorCount() > 0 ? Theme.red : Theme.accent }
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
                Layout.preferredWidth: 545
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
                        Text { text: page.filteredCatalog().length + " / " + page.codeCatalog.length + " CODES"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        TextField {
                            id: searchField
                            Layout.fillWidth: true
                            placeholderText: cockpit.rtl ? "بحث بالكود أو النظام أو الوصف أو السبب" : "Search code, system, description or cause"
                            color: Theme.platinum
                            font.pixelSize: 8
                            onTextChanged: { page.codeQuery = text; page.selectedCode = 0 }
                            background: Rectangle { color: Theme.panel2; border.color: searchField.activeFocus ? Theme.accent : Theme.border; radius: Theme.radius }
                        }
                        ComboBox {
                            id: filterBox
                            Layout.preferredWidth: 165
                            model: DxCodes.systems()
                            onActivated: { page.systemFilter = currentText; page.selectedCode = 0 }
                            contentItem: Text { text: filterBox.displayText; color: Theme.platinum; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.family: "Consolas"; font.pixelSize: 7 }
                            background: Rectangle { color: Theme.panel2; border.color: Theme.border; radius: Theme.radius }
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24
                        Text { text: "CODE"; color: Theme.muted; Layout.preferredWidth: 105; font.pixelSize: 7 }
                        Text { text: "SYSTEM"; color: Theme.muted; Layout.preferredWidth: 112; font.pixelSize: 7 }
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
                                Text { text: modelData.code; color: Theme.platinum; Layout.preferredWidth: 105; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                Text { text: modelData.system; color: Theme.silver; Layout.preferredWidth: 112; font.family: "Consolas"; font.pixelSize: 7; elide: Text.ElideRight }
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
