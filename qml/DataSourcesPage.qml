import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function countHealth(value) {
        let total = 0
        const rows = cockpit.dataSourceRows
        for (let i = 0; i < rows.length; ++i)
            if (String(rows[i].health) === value) ++total
        return total
    }

    function countFresh() {
        let total = 0
        const rows = cockpit.dataSourceRows
        for (let i = 0; i < rows.length; ++i)
            if (String(rows[i].freshness).indexOf("STALE") < 0) ++total
        return total
    }

    function stateColor(value) {
        const state = String(value || "").toUpperCase()
        if (state === "NOMINAL") return Theme.radarGreen
        if (state === "LIMITED") return Theme.royalGold
        return Theme.warmOrange
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#0A0A0A" }
            GradientStop { position: 1; color: Theme.bg }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10
        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            Layout.minimumHeight: 92
            Layout.maximumHeight: 92
            radius: 8
            color: Theme.panel
            border.color: Theme.signalCyan
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 14
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                Rectangle { width: 6; Layout.fillHeight: true; radius: 3; color: Theme.signalCyan }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3
                    Text {
                        text: cockpit.rtl ? "مصادر البيانات والتكامل" : "DATA SOURCES & INTEGRATION"
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.titlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "سجل موحّد للمصدر والوضع والصحة والحداثة وآخر تحديث وحدود الثقة" : "UNIFIED PROVIDER CONTRACT • SOURCE • MODE • HEALTH • FRESHNESS • LAST UPDATE • TRUST BOUNDARY"
                        color: Theme.signalCyan
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.secondaryPx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 230
                    Layout.fillHeight: true
                    radius: 7
                    color: Theme.panel2
                    border.color: Theme.border
                    border.width: 1
                    Column {
                        anchors.centerIn: parent
                        spacing: 3
                        Text { text: cockpit.rtl ? "سلامة السجل" : "REGISTRY HEALTH"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 11; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                        Text { text: page.countHealth("DEGRADED") === 0 ? "NOMINAL" : "REVIEW"; color: page.countHealth("DEGRADED") === 0 ? Theme.radarGreen : Theme.warmOrange; font.family: Theme.mono; font.pixelSize: 18; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 88
            Layout.minimumHeight: 88
            Layout.maximumHeight: 88
            columns: 4
            columnSpacing: 8

            Repeater {
                model: [
                    {title: cockpit.rtl ? "المصادر المسجلة" : "REGISTERED", value: String(cockpit.dataSourceRows.length), accent: Theme.signalCyan},
                    {title: cockpit.rtl ? "صحة اسمية" : "NOMINAL", value: String(page.countHealth("NOMINAL")), accent: Theme.radarGreen},
                    {title: cockpit.rtl ? "حديثة/متحققة" : "FRESH / VERIFIED", value: page.countFresh() + "/" + cockpit.dataSourceRows.length, accent: Theme.skyBlue},
                    {title: cockpit.rtl ? "مسارات كتابة" : "WRITE PATHS", value: "0", accent: Theme.royalGold}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 7
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 11
                        spacing: 10
                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                        Rectangle { width: 5; Layout.fillHeight: true; radius: 3; color: modelData.accent }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Text { text: modelData.title; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 11; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                            Text { text: modelData.value; color: modelData.accent; font.family: Theme.mono; font.pixelSize: 22; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            clip: true

            GridView {
                id: sourceGrid
                anchors.fill: parent
                anchors.margins: 10
                property int columnCount: width >= 1320 ? 3 : 2
                cellWidth: width / columnCount
                cellHeight: columnCount === 3 ? height / 3 : 176
                model: cockpit.dataSourceRows
                clip: true
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                delegate: Item {
                    required property var modelData
                    width: sourceGrid.cellWidth
                    height: sourceGrid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 5
                        radius: 8
                        color: Theme.panel2
                        border.color: Theme.border
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            RowLayout {
                                Layout.fillWidth: true
                                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                Rectangle { width: 11; height: 11; radius: 6; color: page.stateColor(modelData.health) }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: modelData.name; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 15; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                    Text { text: modelData.kind; color: Theme.accent; font.family: Theme.mono; font.pixelSize: 10; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft; elide: Text.ElideRight }
                                }
                                Rectangle {
                                    implicitWidth: statusLabel.implicitWidth + 16
                                    height: 28
                                    radius: 5
                                    color: Qt.rgba(page.stateColor(modelData.health).r, page.stateColor(modelData.health).g, page.stateColor(modelData.health).b, 0.13)
                                    border.color: Theme.border
                                    border.width: 1
                                    Text { id: statusLabel; anchors.centerIn: parent; text: modelData.health; color: page.stateColor(modelData.health); font.family: Theme.mono; font.pixelSize: 10; font.bold: true }
                                }
                            }

                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                            GridLayout {
                                Layout.fillWidth: true
                                columns: 4
                                columnSpacing: 8
                                rowSpacing: 5
                                Text { text: cockpit.rtl ? "المصدر" : "SOURCE"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 10 }
                                Text { text: modelData.source; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: 10; Layout.columnSpan: 3; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                Text { text: cockpit.rtl ? "الوضع" : "MODE"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 10 }
                                Text { text: modelData.mode; color: Theme.silver; font.family: Theme.mono; font.pixelSize: 10; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: cockpit.rtl ? "السجلات" : "RECORDS"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 10 }
                                Text { text: String(modelData.records); color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: 11; font.bold: true }
                                Text { text: cockpit.rtl ? "الحداثة" : "FRESHNESS"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 10 }
                                Text { text: modelData.freshness; color: String(modelData.freshness).indexOf("STALE") >= 0 ? Theme.warmOrange : Theme.radarGreen; font.family: Theme.mono; font.pixelSize: 10; font.bold: true }
                                Text { text: cockpit.rtl ? "آخر تحديث" : "UPDATED"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: 10 }
                                Text { text: modelData.lastUpdate; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: 10 }
                            }

                            Item { Layout.fillHeight: true }
                            Text { text: modelData.boundary + "  •  " + (modelData.readOnly ? "READ ONLY" : "WRITE ENABLED"); color: Theme.muted; font.family: Theme.mono; font.pixelSize: 10; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            Layout.minimumHeight: 44
            Layout.maximumHeight: 44
            radius: 6
            color: Theme.panel2
            border.color: Theme.royalGold
            border.width: 1
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Text { text: "●"; color: Theme.royalGold; font.pixelSize: 13 }
                Text {
                    Layout.fillWidth: true
                    text: cockpit.rtl ? "لا تُحفظ مفاتيح API داخل المستودع • جميع الموصلات هنا للقراءة والوعي والتدريب فقط" : "NO API KEYS IN REPOSITORY • PROVIDERS ARE READ-ONLY AND LIMITED TO AWARENESS, MANAGEMENT, TRAINING AND ANALYSIS"
                    color: Theme.silver
                    font.family: Theme.uiFont(cockpit.rtl)
                    font.pixelSize: 11
                    font.bold: true
                    horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    elide: Text.ElideRight
                }
            }
        }
    }
}
