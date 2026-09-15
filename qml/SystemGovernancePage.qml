import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    property int selectedWorkspace: 0
    property bool weatherOverlayEnabled: true
    property bool trackTrailsEnabled: true
    property bool staleSourceWarningsEnabled: true
    property string actionStatus: cockpit.rtl ? "جاهز" : "READY"

    function stateColor(value) {
        const state = String(value || "").toUpperCase()
        if (state === "READY" || state === "NOMINAL") return Theme.radarGreen
        if (state === "DRAFT" || state === "REVIEW") return Theme.royalGold
        return Theme.accent
    }

    function auditRows() {
        let rows = []
        for (let i = 0; i < cockpit.eventRows.length; ++i) rows.push(cockpit.eventRows[i])
        rows.push({time:"T+001", source:"POLICY", message:cockpit.rtl ? "تم تثبيت حدود التدريب والتحليل" : "Training and analysis boundary asserted", severity:"INFO"})
        rows.push({time:"T+002", source:"PROVIDERS", message:cockpit.rtl ? "تم التحقق من سجل مصادر البيانات" : "Data-source registry verified", severity:"INFO"})
        rows.push({time:"T+003", source:"NAV", message:cockpit.rtl ? "تم تحميل سياسة مساحات العمل" : "Workspace navigation policy loaded", severity:"INFO"})
        rows.push({time:"T+004", source:"SECURITY", message:cockpit.rtl ? "لم تُكتشف مسارات تحكم حي" : "No live-control paths detected", severity:"INFO"})
        rows.push({time:"T+005", source:"LOCALE", message:cockpit.rtl ? "تم تطبيق اتجاه العرض" : "Display direction and locale applied", severity:"INFO"})
        return rows
    }

    Rectangle { anchors.fill: parent; color: Theme.bg }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10
        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            Layout.minimumHeight: 86
            Layout.maximumHeight: 86
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: 8
            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle { width: 6; Layout.fillHeight: true; radius: 3; color: selectedWorkspace === 0 ? Theme.signalCyan : (selectedWorkspace === 1 ? Theme.royalGold : Theme.rfViolet) }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3
                    Text {
                        text: selectedWorkspace === 0 ? (cockpit.rtl ? "التدقيق وسجل الأحداث" : "AUDIT & EVENT TRACE") : selectedWorkspace === 1 ? (cockpit.rtl ? "التقارير التنفيذية" : "EXECUTIVE REPORTS") : (cockpit.rtl ? "إعدادات جلسة العرض" : "SESSION DISPLAY SETTINGS")
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.titlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "حوكمة قابلة للتتبع • إعدادات آمنة • لا أسرار ولا مفاتيح داخل المستودع" : "TRACEABLE GOVERNANCE • SAFE SESSION SETTINGS • NO EMBEDDED SECRETS OR API KEYS"
                        color: Theme.accent
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: 11
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }
                Text { text: actionStatus; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: 12; font.bold: true }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            Layout.minimumHeight: 48
            Layout.maximumHeight: 48
            spacing: 8
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Repeater {
                model: [cockpit.rtl ? "التدقيق" : "AUDIT", cockpit.rtl ? "التقارير" : "REPORTS", cockpit.rtl ? "الإعدادات" : "SETTINGS"]
                delegate: Button {
                    required property int index
                    required property string modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    checkable: true
                    checked: page.selectedWorkspace === index
                    text: modelData
                    font.family: Theme.uiFont(cockpit.rtl)
                    font.pixelSize: 12
                    font.bold: true
                    contentItem: Text { text: parent.text; color: parent.checked ? Theme.platinum : Theme.silver; font: parent.font; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    background: Rectangle { radius: 6; color: parent.checked ? Theme.elevated : Theme.panel2; border.color: parent.checked ? Theme.accent : Theme.borderSoft; border.width: 1 }
                    onClicked: page.selectedWorkspace = index
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: page.selectedWorkspace

            Item {
                RowLayout {
                    anchors.fill: parent
                    spacing: 10
                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                    Rectangle {
                        Layout.preferredWidth: 360
                        Layout.minimumWidth: 360
                        Layout.maximumWidth: 360
                        Layout.fillHeight: true
                        color: Theme.panel
                        border.color: Theme.signalCyan
                        border.width: 1
                        radius: 8
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 10
                            Text { text: cockpit.rtl ? "خط أساس الحوكمة" : "GOVERNANCE BASELINE"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 16; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: [
                                    {label: cockpit.rtl ? "الوضع" : "OPERATING MODE", value:"OFFLINE / SYNTHETIC", color:Theme.radarGreen},
                                    {label: cockpit.rtl ? "مسارات التحكم الحي" : "LIVE CONTROL PATHS", value:"NONE", color:Theme.radarGreen},
                                    {label: cockpit.rtl ? "الأحداث المسجلة" : "EVENT RECORDS", value:String(cockpit.eventRows.length), color:Theme.signalCyan},
                                    {label: cockpit.rtl ? "الحوادث" : "INCIDENT RECORDS", value:String(cockpit.airOperationsIncidentCount), color:Theme.royalGold},
                                    {label: cockpit.rtl ? "المصادر" : "DATA SOURCES", value:String(cockpit.dataSourceRows.length), color:Theme.rfViolet}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 70
                                    radius: 6
                                    color: Theme.panel2
                                    border.color: Theme.border
                                    border.width: 1
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 9
                                        spacing: 2
                                        Text { text: modelData.label; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 11; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        Text { text: modelData.value; color: modelData.color; font.family: Theme.mono; font.pixelSize: 14; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                    }
                                }
                            }
                            Item { Layout.fillHeight: true }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.panel
                        border.color: Theme.border
                        border.width: 1
                        radius: 8
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 8
                            RowLayout {
                                Layout.fillWidth: true
                                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                Text { text: cockpit.rtl ? "التسلسل الزمني للأحداث" : "EVENT TIMELINE"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 16; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                Text { text: page.auditRows().length + " RECORDS"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 11; font.bold: true }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            ListView {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 390
                                Layout.minimumHeight: 320
                                Layout.maximumHeight: 390
                                model: page.auditRows()
                                clip: true
                                spacing: 6
                                delegate: Rectangle {
                                    required property int index
                                    required property var modelData
                                    width: ListView.view.width
                                    height: 64
                                    radius: 6
                                    color: index % 2 ? Theme.panel2 : Theme.panel3
                                    border.color: modelData.severity === "ERROR" ? Theme.warmOrange : Theme.borderSoft
                                    border.width: 1
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 9
                                        spacing: 10
                                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                        Text { text: modelData.time; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 10; Layout.preferredWidth: 94 }
                                        Text { text: modelData.source; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: 11; font.bold: true; Layout.preferredWidth: 150; elide: Text.ElideRight }
                                        Text { text: modelData.message; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 11; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        Text { text: modelData.severity; color: modelData.severity === "ERROR" ? Theme.warmOrange : Theme.radarGreen; font.family: Theme.mono; font.pixelSize: 10; font.bold: true }
                                    }
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: 6
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 8
                                    Text { text: cockpit.rtl ? "تغطية الأثر" : "TRACE COVERAGE"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 15; font.bold: true }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                    GridLayout {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 118
                                        columns: 3
                                        columnSpacing: 8
                                        Repeater {
                                            model: [
                                                {label:cockpit.rtl ? "سلامة السلسلة" : "CHAIN INTEGRITY", value:"VERIFIED", color:Theme.radarGreen},
                                                {label:cockpit.rtl ? "حدود المصدر" : "SOURCE BOUNDARIES", value:cockpit.dataSourceRows.length + " / 7", color:Theme.signalCyan},
                                                {label:cockpit.rtl ? "مسارات الكتابة" : "WRITE PATHS", value:"0", color:Theme.royalGold}
                                            ]
                                            delegate: Rectangle {
                                                required property var modelData
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                                color: Theme.shell
                                                border.color: Theme.border
                                                radius: 5
                                                ColumnLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 10
                                                    Text { text: modelData.label; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                                                    Item { Layout.fillHeight: true }
                                                    Text { text: modelData.value; color: modelData.color; font.family: Theme.mono; font.pixelSize: 18; font.bold: true }
                                                }
                                            }
                                        }
                                    }
                                    Text { text: cockpit.rtl ? "تسلسل الحوكمة" : "GOVERNANCE CHAIN"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 5
                                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                        Repeater {
                                            model: ["SESSION", "POLICY", "SOURCE", "EVENT", "REPORT"]
                                            delegate: Rectangle {
                                                required property string modelData
                                                Layout.fillWidth: true
                                                height: 44
                                                color: Theme.shell
                                                border.color: Theme.border
                                                radius: 4
                                                Text { anchors.centerIn: parent; text: modelData; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                            }
                                        }
                                    }
                                    Item { Layout.fillHeight: true }
                                    Text { text: cockpit.rtl ? "سجل محلي اصطناعي محفوظ للمراجعة والتحليل." : "LOCAL SYNTHETIC TRACE RETAINED FOR REVIEW AND ANALYSIS."; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                GridView {
                    id: reportGrid
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 400
                    cellWidth: width / 2
                    cellHeight: 190
                    model: cockpit.forceExecutiveReports
                    clip: true
                    delegate: Item {
                        required property var modelData
                        width: reportGrid.cellWidth
                        height: reportGrid.cellHeight
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 6
                            radius: 8
                            color: Theme.panel
                            border.color: Theme.border
                            border.width: 1
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8
                                RowLayout {
                                    Layout.fillWidth: true
                                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                    Text { text: modelData.title; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 16; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                    Text { text: modelData.status; color: page.stateColor(modelData.status); font.family: Theme.mono; font.pixelSize: 11; font.bold: true }
                                }
                                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                Text { text: cockpit.rtl ? "الفترة" : "REPORTING PERIOD"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 11 }
                                Text { text: modelData.stamp; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 18; font.bold: true }
                                Item { Layout.fillHeight: true }
                                MinisterialButton {
                                    Layout.alignment: cockpit.rtl ? Qt.AlignLeft : Qt.AlignRight
                                    text: cockpit.rtl ? "تحضير للمعاينة" : "PREPARE PREVIEW"
                                    accent: page.stateColor(modelData.status)
                                    implicitWidth: 150
                                    onClicked: page.actionStatus = cockpit.rtl ? "تم تجهيز المعاينة" : "PREVIEW PREPARED"
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: reportGrid.bottom
                    anchors.bottom: parent.bottom
                    anchors.margins: 6
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: 8
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10
                        Text { text: cockpit.rtl ? "مسار إنتاج التقرير" : "REPORT PRODUCTION PIPELINE"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 92
                            spacing: 7
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                            Repeater {
                                model: [
                                    {step:"01", label:cockpit.rtl ? "جمع البيانات" : "COLLECT", color:Theme.signalCyan},
                                    {step:"02", label:cockpit.rtl ? "التحقق" : "VERIFY", color:Theme.rfViolet},
                                    {step:"03", label:cockpit.rtl ? "المراجعة" : "REVIEW", color:Theme.royalGold},
                                    {step:"04", label:cockpit.rtl ? "المعاينة" : "PREVIEW", color:Theme.radarGreen}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: Theme.panel2
                                    border.color: Theme.border
                                    radius: 5
                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: 3
                                        Text { text: modelData.step; color: modelData.color; font.family: Theme.mono; font.pixelSize: 18; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                        Text { text: modelData.label; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                    }
                                }
                            }
                        }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 3
                            columnSpacing: 8
                            Repeater {
                                model: [
                                    {label:cockpit.rtl ? "تقارير جاهزة" : "READY REPORTS", value:"3 / 4", color:Theme.radarGreen},
                                    {label:cockpit.rtl ? "سجل الإصدار" : "RELEASE MANIFEST", value:"v3.5.0", color:Theme.signalCyan},
                                    {label:cockpit.rtl ? "نطاق البيانات" : "DATA SCOPE", value:"SYNTHETIC", color:Theme.royalGold}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    height: 74
                                    color: Theme.shell
                                    border.color: Theme.borderSoft
                                    radius: 5
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 9
                                        Text { text: modelData.label; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                        Text { text: modelData.value; color: modelData.color; font.family: Theme.mono; font.pixelSize: 16; font.bold: true }
                                    }
                                }
                            }
                        }
                        Item { Layout.fillHeight: true }
                        Text { text: cockpit.rtl ? "المعاينة محلية ولا ترسل ملفات أو رسائل إلى خدمات خارجية." : "PREVIEW IS LOCAL; NO FILE OR MESSAGE IS SENT TO AN EXTERNAL SERVICE."; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    }
                }
            }

            Item {
                RowLayout {
                    anchors.fill: parent
                    spacing: 10
                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.panel
                        border.color: Theme.border
                        border.width: 1
                        radius: 8
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 18
                            spacing: 13
                            Text { text: cockpit.rtl ? "طبقات العرض" : "DISPLAY LAYERS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 18; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: [
                                    {label:cockpit.rtl ? "إظهار قيود الطقس" : "Show weather constraints", checked:page.weatherOverlayEnabled, index:0, color:Theme.skyBlue},
                                    {label:cockpit.rtl ? "إظهار تاريخ المسارات" : "Show track history and trails", checked:page.trackTrailsEnabled, index:1, color:Theme.signalCyan},
                                    {label:cockpit.rtl ? "تحذير عند تقادم المصدر" : "Warn when a provider becomes stale", checked:page.staleSourceWarningsEnabled, index:2, color:Theme.royalGold}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 52
                                    color: Theme.panel2
                                    border.color: Theme.border
                                    radius: 5
                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 10
                                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                        Rectangle {
                                            width: 24; height: 24; radius: 4
                                            color: modelData.checked ? modelData.color : Theme.shell
                                            border.color: Theme.border
                                            Text { anchors.centerIn: parent; text: modelData.checked ? "✓" : ""; color: Theme.darkNavy; font.pixelSize: 15; font.bold: true }
                                        }
                                        Text { text: modelData.label; color: modelData.checked ? Theme.platinum : Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.bodyPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                        Text { text: modelData.checked ? "ON" : "OFF"; color: modelData.checked ? modelData.color : Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (modelData.index === 0) page.weatherOverlayEnabled = !page.weatherOverlayEnabled
                                            else if (modelData.index === 1) page.trackTrailsEnabled = !page.trackTrailsEnabled
                                            else page.staleSourceWarningsEnabled = !page.staleSourceWarningsEnabled
                                            page.actionStatus = cockpit.rtl ? "تم تحديث الجلسة" : "SESSION UPDATED"
                                        }
                                    }
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 210
                                color: Theme.shell
                                border.color: Theme.borderSoft
                                radius: 6
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 8
                                    Text { text: cockpit.rtl ? "معاينة طبقات العرض" : "DISPLAY LAYER PREVIEW"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: 8
                                        Repeater {
                                            model: [
                                                {label:"WEATHER", active:page.weatherOverlayEnabled, color:Theme.skyBlue},
                                                {label:"TRAILS", active:page.trackTrailsEnabled, color:Theme.signalCyan},
                                                {label:"STALE", active:page.staleSourceWarningsEnabled, color:Theme.royalGold}
                                            ]
                                            delegate: Rectangle {
                                                required property var modelData
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                                color: modelData.active ? Theme.panel3 : Theme.panel2
                                                border.color: modelData.active ? modelData.color : Theme.borderSoft
                                                radius: 5
                                                ColumnLayout {
                                                    anchors.centerIn: parent
                                                    spacing: 7
                                                    Rectangle { width: 42; height: 42; radius: 21; color: Theme.shell; border.color: Theme.border; border.width: 2; Text { anchors.centerIn: parent; text: modelData.active ? "●" : "○"; color: modelData.color; font.pixelSize: 18 } }
                                                    Text { text: modelData.label; color: modelData.active ? modelData.color : Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Item { Layout.fillHeight: true }
                            Text { text: cockpit.rtl ? "إعدادات جلسة محلية — لا تغيّر أي مصدر خارجي" : "LOCAL SESSION SETTINGS — NO EXTERNAL PROVIDER IS MODIFIED"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 11; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        }
                    }
                    Rectangle {
                        Layout.preferredWidth: 420
                        Layout.minimumWidth: 420
                        Layout.maximumWidth: 420
                        Layout.fillHeight: true
                        color: Theme.panel
                        border.color: Theme.royalGold
                        border.width: 1
                        radius: 8
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 18
                            spacing: 11
                            Text { text: cockpit.rtl ? "حدود السلامة" : "SAFETY BOUNDARY"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 18; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: [
                                    cockpit.rtl ? "وعي وإدارة وتدريب فقط" : "AWARENESS / MANAGEMENT / TRAINING ONLY",
                                    cockpit.rtl ? "استقبال RF سلبي فقط" : "PASSIVE RF RECEIVE / VISUALIZATION ONLY",
                                    cockpit.rtl ? "لا توجيه أسلحة أو اشتباك" : "NO WEAPONS TASKING OR ENGAGEMENT",
                                    cockpit.rtl ? "لا تشويش أو انتحال أو استيلاء" : "NO JAMMING, SPOOFING OR TAKEOVER"
                                ]
                                delegate: RowLayout {
                                    required property string modelData
                                    Layout.fillWidth: true
                                    spacing: 9
                                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                    Text { text: "✓"; color: Theme.radarGreen; font.pixelSize: 15; font.bold: true }
                                    Text { text: modelData; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 12; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; wrapMode: Text.WordWrap }
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 126
                                color: Theme.shell
                                border.color: Theme.borderSoft
                                radius: 5
                                GridLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    columns: 2
                                    rowSpacing: 8
                                    Text { text: cockpit.rtl ? "المصادر المقروءة" : "READ-ONLY SOURCES"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                    Text { text: cockpit.dataSourceRows.length + " / 7"; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: 16; font.bold: true }
                                    Text { text: cockpit.rtl ? "التحكم الحي" : "LIVE CONTROL"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                    Text { text: "NONE"; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: 16; font.bold: true }
                                    Text { text: cockpit.rtl ? "وضع الجلسة" : "SESSION MODE"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                    Text { text: "OFFLINE"; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 16; font.bold: true }
                                }
                            }
                            Item { Layout.fillHeight: true }
                        }
                    }
                }
            }
        }
    }
}
