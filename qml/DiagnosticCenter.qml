import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "DiagnosticCodeCatalog.js" as DxCodes

Item {
    id: page

    property int selectedCode: 0
    property string codeQuery: ""
    property string systemFilter: "ALL"
    property string categoryFilter: "ALL"
    property var codeCatalog: DxCodes.catalog()

    function severityColor(value) {
        if (value === "FAULT") return Theme.red
        if (value === "WARNING") return Theme.amber
        return Theme.green
    }

    function filteredCatalog() {
        var out = []
        var q = codeQuery.trim().toLowerCase()
        for (var i = 0; i < codeCatalog.length; ++i) {
            var c = codeCatalog[i]
            var systemOk = systemFilter === "ALL" || c.system === systemFilter
            var categoryOk = categoryFilter === "ALL" || c.category === categoryFilter
            var haystack = (c.code + " " + c.system + " " + c.category + " " + c.title + " " + c.meaning + " " + c.cause + " " + c.sensor).toLowerCase()
            var queryOk = q.length === 0 || haystack.indexOf(q) >= 0
            if (systemOk && categoryOk && queryOk) out.push(c)
        }
        return out
    }

    function selected() {
        var rows = filteredCatalog()
        if (rows.length === 0)
            return {"code":"—","system":"—","category":"—","severity":"INFO","title":"No matching training code","meaning":"Adjust the search or filters.","cause":"—","isolation":"—","recovery":"—","sensor":""}
        return rows[Math.max(0, Math.min(selectedCode, rows.length - 1))]
    }

    function findingFor(code) {
        for (var i = 0; i < cockpit.diagnosticFindings.length; ++i)
            if (cockpit.diagnosticFindings[i].code === code) return cockpit.diagnosticFindings[i]
        return null
    }

    function historyFor(code) {
        for (var i = 0; i < cockpit.diagnosticHistoryRows.length; ++i)
            if (cockpit.diagnosticHistoryRows[i].code === code) return cockpit.diagnosticHistoryRows[i]
        return null
    }

    function selectFinding(code) {
        systemFilter = "ALL"
        categoryFilter = "ALL"
        systemBox.currentIndex = 0
        categoryBox.currentIndex = 0
        searchField.text = code
        selectedCode = 0
    }

    function runScan() {
        cockpit.runDiagnosticScan()
        if (cockpit.diagnosticFindings.length > 0)
            selectFinding(cockpit.diagnosticFindings[0].code)
    }

    RowLayout {
        id: headerBand
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        height: 94
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
                        text: cockpit.rtl ? "مركز التشخيص والتحليل الهندسي" : "AVIONICS DIAGNOSTIC INTELLIGENCE CENTER"
                        color: Theme.platinum
                        font.pixelSize: 18
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "فحص حتمي • ترتيب الأسباب • ربط الأدلة • التحقق من الاستعادة" : "DETERMINISTIC SCAN / ROOT-CAUSE RANKING / EVIDENCE CORRELATION / RECOVERY VERIFICATION"
                        color: Theme.accent
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl ? "144 كودًا تدريبيًا • 12 منظومة • 36 تصنيفًا فرعيًا • بيانات صناعية فقط" : "144 TRAINING CODES • 12 SYSTEMS • 36 SUBCATEGORIES • SYNTHETIC DATA ONLY"
                        color: Theme.muted
                        font.pixelSize: 7
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }

                MinisterialButton {
                    text: cockpit.rtl ? "تشغيل التشخيص" : "RUN DIAGNOSTIC ENGINE"
                    implicitWidth: 168
                    accent: Theme.accent
                    onClicked: page.runScan()
                }
            }
        }

        StatusCard {
            Layout.preferredWidth: 145
            Layout.fillHeight: true
            title: "HEALTH SCORE"
            value: String(cockpit.diagnosticHealthScore)
            subtitle: "DIAGNOSTIC / 100"
            iconText: "HS"
            accent: cockpit.diagnosticHealthScore >= 90 ? Theme.green : (cockpit.diagnosticHealthScore >= 70 ? Theme.amber : Theme.red)
        }
        StatusCard {
            Layout.preferredWidth: 132
            Layout.fillHeight: true
            title: "FINDINGS"
            value: String(cockpit.diagnosticFindingCount)
            subtitle: "RANKED"
            iconText: "DX"
            accent: cockpit.diagnosticFindingCount > 0 ? Theme.amber : Theme.accent
        }
        StatusCard {
            Layout.preferredWidth: 122
            Layout.fillHeight: true
            title: "FAULTS"
            value: String(cockpit.diagnosticFaultCount)
            subtitle: "ACTIVE"
            iconText: "F"
            accent: cockpit.diagnosticFaultCount > 0 ? Theme.red : Theme.accent
        }
        StatusCard {
            Layout.preferredWidth: 132
            Layout.fillHeight: true
            title: "RECURRENT"
            value: String(cockpit.diagnosticRecurrentCount)
            subtitle: "2+ SCANS"
            iconText: "H"
            accent: cockpit.diagnosticRecurrentCount > 0 ? Theme.amber : Theme.accent
        }
    }

    RowLayout {
        id: workArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerBand.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 7
        anchors.bottomMargin: 10
        spacing: 7

        Rectangle {
            Layout.preferredWidth: Math.max(300, Math.min(370, page.width * 0.26))
            Layout.minimumWidth: 300
            Layout.fillHeight: true
            color: Theme.panel
            border.color: Theme.border
            radius: Theme.radius

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 22
                    Text {
                        text: cockpit.rtl ? "نتيجة الفحص الحي" : "LIVE DIAGNOSTIC SCAN"
                        color: Theme.platinum
                        font.pixelSize: 10
                        font.bold: true
                        Layout.fillWidth: true
                    }
                    Text {
                        text: cockpit.diagnosticScanTick > 0 ? "TICK " + cockpit.diagnosticScanTick : "NOT RUN"
                        color: Theme.accent
                        font.family: "Consolas"
                        font.pixelSize: 7
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                Text { text: cockpit.rtl ? "حالة الأنظمة" : "SYSTEM STATE"; color: Theme.muted; font.pixelSize: 7; font.bold: true }

                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(150, Math.min(230, workArea.height * 0.33))
                    model: cockpit.twinRows
                    clip: true
                    spacing: 1

                    delegate: Rectangle {
                        required property int index
                        required property var modelData
                        width: ListView.view.width
                        height: 42
                        color: index % 2 ? Theme.panel2 : Theme.panel

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 6
                            Rectangle { width: 3; height: 24; color: Theme.stateColor(modelData.state) }
                            Text { text: modelData.label; color: Theme.platinum; font.pixelSize: 8; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: modelData.state; color: Theme.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                            Text { text: Number(modelData.health).toFixed(0) + "%"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8 }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 22
                    Text { text: cockpit.rtl ? "النتائج المرتبة" : "RANKED FINDINGS"; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true }
                    Text { text: cockpit.diagnosticFindingCount + " ITEMS"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                }
                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: cockpit.diagnosticFindings
                    clip: true
                    spacing: 2

                    delegate: Rectangle {
                        required property int index
                        required property var modelData
                        width: ListView.view.width
                        height: 62
                        color: Theme.panel2
                        border.color: page.severityColor(modelData.severity)
                        radius: Theme.radius

                        MouseArea { anchors.fill: parent; onClicked: page.selectFinding(modelData.code) }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 6
                            Rectangle { width: 4; height: 34; color: page.severityColor(modelData.severity) }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text { text: modelData.code + "  /  " + modelData.system; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.title; color: Theme.silver; font.pixelSize: 8; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                            ColumnLayout {
                                Layout.preferredWidth: 66
                                spacing: 0
                                Text { text: modelData.confidencePercent + "%"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 10; font.bold: true; Layout.alignment: Qt.AlignRight }
                                Text { text: "P" + modelData.priority; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7; Layout.alignment: Qt.AlignRight }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: cockpit.diagnosticFindings.length === 0
                        width: parent.width - 24
                        text: cockpit.rtl ? "شغّل محرك التشخيص لالتقاط الأدلة" : "RUN THE DIAGNOSTIC ENGINE TO CAPTURE EVIDENCE"
                        color: Theme.muted
                        font.pixelSize: 8
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: Math.max(390, Math.min(520, page.width * 0.36))
            Layout.minimumWidth: 390
            Layout.fillHeight: true
            color: Theme.panel
            border.color: Theme.border
            radius: Theme.radius

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 22
                    Text { text: cockpit.rtl ? "مكتبة الأكواد التدريبية" : "TRAINING FAULT-CODE LIBRARY"; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
                    Text { text: page.filteredCatalog().length + " / " + page.codeCatalog.length; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                }

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    placeholderText: cockpit.rtl ? "بحث بالكود أو النظام أو الوصف أو السبب" : "Search code, system, category, description or cause"
                    color: Theme.platinum
                    font.pixelSize: 8
                    onTextChanged: { page.codeQuery = text; page.selectedCode = 0 }
                    background: Rectangle { color: Theme.panel2; border.color: searchField.activeFocus ? Theme.accent : Theme.border; radius: Theme.radius }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    spacing: 5

                    ComboBox {
                        id: systemBox
                        Layout.fillWidth: true
                        model: DxCodes.systems()
                        onActivated: {
                            page.systemFilter = currentText
                            page.categoryFilter = "ALL"
                            categoryBox.currentIndex = 0
                            page.selectedCode = 0
                        }
                        contentItem: Text { text: systemBox.displayText; color: Theme.platinum; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.family: "Consolas"; font.pixelSize: 7 }
                        background: Rectangle { color: Theme.panel2; border.color: Theme.border; radius: Theme.radius }
                    }

                    ComboBox {
                        id: categoryBox
                        Layout.fillWidth: true
                        model: DxCodes.categories(page.systemFilter)
                        onActivated: { page.categoryFilter = currentText; page.selectedCode = 0 }
                        contentItem: Text { text: categoryBox.displayText; color: Theme.platinum; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.family: "Consolas"; font.pixelSize: 7 }
                        background: Rectangle { color: Theme.panel2; border.color: Theme.border; radius: Theme.radius }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 22
                    Text { text: "CODE"; color: Theme.muted; Layout.preferredWidth: 102; font.pixelSize: 7 }
                    Text { text: "SYSTEM / CATEGORY"; color: Theme.muted; Layout.preferredWidth: 142; font.pixelSize: 7 }
                    Text { text: "DESCRIPTION"; color: Theme.muted; Layout.fillWidth: true; font.pixelSize: 7 }
                    Text { text: "LEVEL"; color: Theme.muted; Layout.preferredWidth: 58; horizontalAlignment: Text.AlignRight; font.pixelSize: 7 }
                }
                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

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
                        height: 51
                        color: index === page.selectedCode ? "#14232C" : (index % 2 ? Theme.panel2 : Theme.panel)
                        border.color: index === page.selectedCode ? Theme.accent : Theme.borderSoft

                        MouseArea { anchors.fill: parent; onClicked: page.selectedCode = index }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 5
                            Text { text: modelData.code; color: Theme.platinum; Layout.preferredWidth: 102; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            ColumnLayout {
                                Layout.preferredWidth: 142
                                spacing: 0
                                Text { text: modelData.system; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.category; color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                            }
                            Text { text: modelData.title; color: Theme.platinum; Layout.fillWidth: true; font.pixelSize: 8; elide: Text.ElideRight }
                            Text { text: modelData.severity; color: page.severityColor(modelData.severity); Layout.preferredWidth: 58; horizontalAlignment: Text.AlignRight; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumWidth: 300
            Layout.fillHeight: true
            color: Theme.panel
            border.color: Theme.border
            radius: Theme.radius

            ScrollView {
                id: detailsScroll
                anchors.fill: parent
                anchors.margins: 9
                clip: true

                ColumnLayout {
                    width: detailsScroll.availableWidth
                    spacing: 7

                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1
                            Text { text: page.selected().code; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 18; font.bold: true }
                            Text { text: page.selected().system + "  /  " + page.selected().category; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                        Rectangle {
                            Layout.preferredWidth: 78
                            Layout.preferredHeight: 25
                            color: Theme.panel2
                            border.color: page.severityColor(page.selected().severity)
                            radius: Theme.radius
                            Text { anchors.centerIn: parent; text: page.selected().severity; color: page.severityColor(page.selected().severity); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                        }
                    }

                    Text { text: page.selected().title; color: Theme.platinum; font.pixelSize: 12; font.bold: true; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: page.findingFor(page.selected().code) ? 90 : 58
                        color: Theme.panel2
                        border.color: page.findingFor(page.selected().code) ? Theme.accent : Theme.border
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            spacing: 1
                            Text { text: "LIVE SCAN CORRELATION"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                            Text {
                                text: page.findingFor(page.selected().code) ? ("MATCHED  •  CONF " + page.findingFor(page.selected().code).confidencePercent + "%  •  PRIORITY " + page.findingFor(page.selected().code).priority) : "NO ACTIVE MATCH IN LAST SCAN"
                                color: page.findingFor(page.selected().code) ? Theme.accent : Theme.silver
                                font.family: "Consolas"
                                font.pixelSize: 8
                                font.bold: true
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                            Text {
                                visible: page.findingFor(page.selected().code) !== null
                                text: page.findingFor(page.selected().code) ? (page.findingFor(page.selected().code).evidenceSource + "/" + page.findingFor(page.selected().code).evidenceKey + "  •  " + page.findingFor(page.selected().code).evidenceObservation) : ""
                                color: Theme.silver
                                font.pixelSize: 8
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }
                        }
                    }

                    Text { text: cockpit.rtl ? "المعنى" : "MEANING"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                    Text { text: page.selected().meaning; color: Theme.silver; font.pixelSize: 9; Layout.fillWidth: true; wrapMode: Text.WordWrap }

                    Text { text: cockpit.rtl ? "الأسباب المحتملة" : "POSSIBLE CAUSES"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                    Text { text: page.selected().cause; color: Theme.silver; font.pixelSize: 9; Layout.fillWidth: true; wrapMode: Text.WordWrap }

                    Text { text: cockpit.rtl ? "مسار عزل العطل" : "FAULT ISOLATION PATH"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 82
                        color: Theme.panel2
                        border.color: Theme.border
                        radius: Theme.radius
                        Text { anchors.fill: parent; anchors.margins: 7; text: page.selected().isolation; color: Theme.platinum; font.pixelSize: 9; wrapMode: Text.WordWrap; verticalAlignment: Text.AlignVCenter }
                    }

                    Text { text: cockpit.rtl ? "معيار الاستعادة" : "RECOVERY CRITERIA"; color: Theme.muted; font.pixelSize: 7; font.bold: true }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 76
                        color: Theme.panel2
                        border.color: Theme.accent
                        radius: Theme.radius
                        Text { anchors.fill: parent; anchors.margins: 7; text: page.selected().recovery; color: Theme.silver; font.pixelSize: 9; wrapMode: Text.WordWrap; verticalAlignment: Text.AlignVCenter }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 74
                        color: "#101A20"
                        border.color: Theme.border
                        radius: Theme.radius

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 7
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1
                                Text { text: "REPORT FINGERPRINT"; color: Theme.muted; font.pixelSize: 7 }
                                Text { text: cockpit.diagnosticFingerprint.length ? cockpit.diagnosticFingerprint : "NOT GENERATED"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: "SCAN AGE  " + (cockpit.diagnosticScanTick > 0 ? Math.max(0, cockpit.tick - cockpit.diagnosticScanTick) + " TICKS" : "—"); color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7 }
                            }
                            ColumnLayout {
                                Layout.preferredWidth: 108
                                spacing: 1
                                Text { text: "HISTORY"; color: Theme.muted; font.pixelSize: 7 }
                                Text { text: page.historyFor(page.selected().code) ? (page.historyFor(page.selected().code).scansSeen + " SCANS") : "NO HISTORY"; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                Text { text: "TRAINING ONLY"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7 }
                            }
                        }
                    }

                    Text { text: cockpit.rtl ? "توصيات التدريب" : "TRAINING RECOMMENDATIONS"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                    Repeater {
                        model: cockpit.diagnosticRecommendations
                        delegate: Text {
                            required property var modelData
                            text: "• " + modelData
                            color: Theme.silver
                            font.pixelSize: 8
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
    }
}
