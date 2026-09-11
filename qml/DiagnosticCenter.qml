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
    property string categoryFilter: "ALL"
    property int lastScanTick: -1
    property var scanMatches: []
    property var codeCatalog: DxCodes.catalog()

    function severityColor(s) {
        if (s === "FAULT") return Theme.red
        if (s === "WARNING") return Theme.amber
        return Theme.green
    }

    function invalidSensorCount() {
        var n = 0
        for (var i = 0; i < cockpit.sensorRows.length; ++i)
            if (!cockpit.sensorRows[i].valid) ++n
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
        var list = filteredCatalog()
        if (list.length === 0)
            return {"code":"—","system":"—","category":"—","severity":"INFO","title":"No matching training code","meaning":"Adjust the search, system or category filter.","cause":"—","isolation":"—","recovery":"—","sensor":""}
        return list[Math.max(0, Math.min(selectedCode, list.length - 1))]
    }

    function codeById(id) {
        for (var i = 0; i < codeCatalog.length; ++i)
            if (codeCatalog[i].code === id) return codeCatalog[i]
        return null
    }

    function addMatch(list, id, reason) {
        for (var i = 0; i < list.length; ++i)
            if (list[i].code === id) return
        var c = codeById(id)
        if (!c) return
        list.push({
            "code":c.code, "system":c.system, "category":c.category,
            "severity":c.severity, "title":c.title, "reason":reason
        })
    }

    function selectMatchedCode(id) {
        systemFilter = "ALL"
        categoryFilter = "ALL"
        systemBox.currentIndex = 0
        categoryBox.currentIndex = 0
        searchField.text = id
        selectedCode = 0
    }

    function runScan() {
        var matches = []

        for (var i = 0; i < cockpit.sensorRows.length; ++i) {
            var s = cockpit.sensorRows[i]
            if (s.valid) continue
            if (s.id === "bus_voltage_v") addMatch(matches, "NXD-PWR-109", "Invalid electrical-bus evidence")
            else if (s.id === "cpu_temp_c") addMatch(matches, "NXD-CMP-203", "Invalid compute-temperature evidence")
            else if (s.id === "imu_pitch_deg") addMatch(matches, "NXD-FLT-303", "Pitch channel invalid")
            else if (s.id === "imu_roll_deg") addMatch(matches, "NXD-FLT-304", "Roll channel invalid")
            else if (s.id === "altitude_m") addMatch(matches, "NXD-FLT-305", "Altitude channel invalid")
            else if (s.id === "airspeed_kph") addMatch(matches, "NXD-FLT-306", "Airspeed channel invalid")
            else if (s.id === "hydraulic_pressure_pct") addMatch(matches, "NXD-HYD-409", "Hydraulic evidence invalid")
            else if (s.id === "fuel_level_pct") addMatch(matches, "NXD-FUL-502", "Fuel-quantity evidence invalid")
            else addMatch(matches, "NXD-DAT-610", "Required telemetry channel invalid or missing")
        }

        for (var t = 0; t < cockpit.twinRows.length; ++t) {
            var twin = cockpit.twinRows[t]
            if (twin.state === "NOMINAL") continue
            var label = String(twin.label).toLowerCase()
            if (label.indexOf("power") >= 0) addMatch(matches, "NXD-PWR-111", "Power Digital Twin not nominal")
            else if (label.indexOf("compute") >= 0) addMatch(matches, "NXD-CMP-208", "Compute Digital Twin not nominal")
            else if (label.indexOf("flight") >= 0 || label.indexOf("sensor") >= 0) addMatch(matches, "NXD-FLT-309", "Flight-sensor Digital Twin not nominal")
            else if (label.indexOf("hyd") >= 0) addMatch(matches, "NXD-HYD-410", "Hydraulic Digital Twin not nominal")
            else if (label.indexOf("fuel") >= 0) addMatch(matches, "NXD-FUL-509", "Fuel Digital Twin not nominal")
            else addMatch(matches, "NXD-ASR-1209", "Digital Twin consistency requires review")
        }

        var scenario = String(cockpit.scenario).toLowerCase()
        if (scenario.indexOf("power") >= 0) addMatch(matches, "NXD-PWR-101", "Current scenario contains a power transient")
        if (scenario.indexOf("thermal") >= 0) {
            addMatch(matches, "NXD-CMP-201", "Current scenario contains a thermal rise")
            addMatch(matches, "NXD-ECS-1009", "Thermal scenario can reduce cooling margin")
        }
        if (scenario.indexOf("dropout") >= 0) {
            addMatch(matches, "NXD-FLT-301", "Current scenario contains a sensor dropout")
            addMatch(matches, "NXD-DAT-606", "Dropout can create stale-channel evidence")
        }

        if (cockpit.recordedFrames === 0 && cockpit.tick > 5)
            addMatch(matches, "NXD-REC-801", "No recorded evidence frames available after scan start")

        if (cockpit.twinFaultCount > 0 || cockpit.twinDegradedCount > 0)
            addMatch(matches, "NXD-ASR-1209", "Digital Twin state requires consistency review")

        scanMatches = matches
        scanComplete = true
        lastScanTick = cockpit.tick
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 88
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
                            text: cockpit.rtl ? "144 كود NEXVARY تدريبيًا • 12 منظومة • 36 تصنيفًا فرعيًا — ليست أكواد مصنع" : "144 NEXVARY TRAINING CODES • 12 SYSTEMS • 36 SUBCATEGORIES — NOT OEM CODES"
                            color: Theme.muted
                            font.pixelSize: 7
                        }
                    }

                    Rectangle { width: 1; Layout.fillHeight: true; color: Theme.borderSoft }

                    ColumnLayout {
                        Layout.preferredWidth: 145
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

            StatusCard { Layout.preferredWidth: 150; Layout.fillHeight: true; title: "CODE LIBRARY"; value: String(page.codeCatalog.length); subtitle: "36 SUBCATEGORIES"; iconText: "DB"; accent: Theme.accent }
            StatusCard { Layout.preferredWidth: 145; Layout.fillHeight: true; title: "SCAN MATCHES"; value: String(page.scanMatches.length); subtitle: "AUTO-LINKED"; iconText: "AI"; accent: page.scanMatches.length > 0 ? Theme.amber : Theme.accent }
            StatusCard { Layout.preferredWidth: 145; Layout.fillHeight: true; title: "INVALID"; value: String(page.invalidSensorCount()); subtitle: "CHANNELS"; iconText: "CH"; accent: page.invalidSensorCount() > 0 ? Theme.red : Theme.accent }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7

            Rectangle {
                Layout.preferredWidth: 370
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

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: cockpit.twinRows
                        clip: true
                        spacing: 1
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            width: ListView.view.width
                            height: 52
                            color: index % 2 ? Theme.panel2 : Theme.panel
                            border.color: Theme.borderSoft
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                Rectangle { width: 4; height: 28; color: Theme.stateColor(modelData.state) }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Text { text: modelData.label; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: "CHANNELS " + modelData.valid + "/" + modelData.expected + "  •  ISSUES " + modelData.issues; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                                }
                                ColumnLayout {
                                    Layout.preferredWidth: 78
                                    spacing: 0
                                    Text { text: modelData.state; color: Theme.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignRight }
                                    Text { text: Number(modelData.health).toFixed(0) + "%"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 9; Layout.alignment: Qt.AlignRight }
                                }
                            }
                        }
                    }

                    Text { text: cockpit.rtl ? "الأكواد المرشحة تلقائيًا" : "AUTO-LINKED DIAGNOSTIC CODES"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 165
                        color: Theme.panel2
                        border.color: page.scanMatches.length > 0 ? Theme.accent : Theme.border
                        radius: Theme.radius

                        ListView {
                            anchors.fill: parent
                            anchors.margins: 5
                            model: page.scanMatches
                            clip: true
                            spacing: 2

                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 48
                                color: Theme.panel
                                border.color: Theme.borderSoft
                                radius: Theme.radius
                                MouseArea { anchors.fill: parent; onClicked: page.selectMatchedCode(modelData.code) }
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 6
                                    Rectangle { width: 3; height: 25; color: page.severityColor(modelData.severity) }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.code + "  /  " + modelData.category; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.reason; color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    Text { text: modelData.severity; color: page.severityColor(modelData.severity); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                }
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            visible: page.scanMatches.length === 0
                            text: scanComplete ? (cockpit.rtl ? "لا توجد أكواد مرشحة في الفحص الحالي" : "NO AUTO-LINKED CODES FOR CURRENT SCAN") : (cockpit.rtl ? "شغّل الفحص لبناء قائمة التشخيص" : "RUN SCAN TO BUILD DIAGNOSTIC MATCHES")
                            color: Theme.muted
                            font.pixelSize: 7
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 595
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

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: cockpit.rtl ? "بحث بالكود أو النظام أو التصنيف أو الوصف أو السبب" : "Search code, system, subcategory, description or cause"
                        color: Theme.platinum
                        font.pixelSize: 8
                        onTextChanged: { page.codeQuery = text; page.selectedCode = 0 }
                        background: Rectangle { color: Theme.panel2; border.color: searchField.activeFocus ? Theme.accent : Theme.border; radius: Theme.radius }
                    }

                    RowLayout {
                        Layout.fillWidth: true
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

                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24
                        Text { text: "CODE"; color: Theme.muted; Layout.preferredWidth: 96; font.pixelSize: 7 }
                        Text { text: "SYSTEM"; color: Theme.muted; Layout.preferredWidth: 96; font.pixelSize: 7 }
                        Text { text: "SUBCATEGORY"; color: Theme.muted; Layout.preferredWidth: 88; font.pixelSize: 7 }
                        Text { text: "DESCRIPTION"; color: Theme.muted; Layout.fillWidth: true; font.pixelSize: 7 }
                        Text { text: "LEVEL"; color: Theme.muted; Layout.preferredWidth: 60; horizontalAlignment: Text.AlignRight; font.pixelSize: 7 }
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
                            height: 52
                            color: index === page.selectedCode ? "#14232C" : (index % 2 ? Theme.panel2 : Theme.panel)
                            border.color: index === page.selectedCode ? Theme.accent : Theme.borderSoft
                            radius: Theme.radius
                            MouseArea { anchors.fill: parent; onClicked: page.selectedCode = index }
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 5
                                Text { text: modelData.code; color: Theme.platinum; Layout.preferredWidth: 96; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                Text { text: modelData.system; color: Theme.silver; Layout.preferredWidth: 96; font.family: "Consolas"; font.pixelSize: 7; elide: Text.ElideRight }
                                Text { text: modelData.category; color: Theme.accent; Layout.preferredWidth: 88; font.pixelSize: 7; elide: Text.ElideRight }
                                Text { text: modelData.title; color: Theme.platinum; Layout.fillWidth: true; font.pixelSize: 7; elide: Text.ElideRight }
                                Text { text: modelData.severity; color: page.severityColor(modelData.severity); Layout.preferredWidth: 60; horizontalAlignment: Text.AlignRight; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
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
                            Text { text: page.selected().system + "  /  " + page.selected().category; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
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
                            Text { text: "NEXVARY TRAINING CODE"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                        }
                    }
                }
            }
        }
    }
}
