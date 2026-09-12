import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page

    function currentProfile() {
        for (var i = 0; i < cockpit.platformProfiles.length; ++i)
            if (cockpit.platformProfiles[i].id === cockpit.activePlatformId) return cockpit.platformProfiles[i]
        return cockpit.platformProfiles.length ? cockpit.platformProfiles[0] : ({})
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            color: Theme.panel
            border.color: Theme.border
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 14
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: cockpit.rtl ? "مكتبة منصات الطائرات" : "AIRCRAFT PLATFORM LIBRARY"
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "ملفات تدريبية عامة متعددة المنصات • توأم رقمي • قنوات • تشخيص • سيناريوهات" : "MULTI-PLATFORM TRAINING PROFILES / DIGITAL TWIN / CHANNEL MAP / DIAGNOSTICS / SCENARIOS"
                        color: Theme.accent
                        font.pixelSize: 8
                        font.bold: true
                        font.letterSpacing: 0.5
                    }
                    Text {
                        text: cockpit.rtl ? "لا تمثل هذه الملفات طرازات تشغيلية أو بيانات صيانة مصنّع" : "GENERIC TRAINING PROFILES — NO OEM MAINTENANCE DATA OR LIVE AIRCRAFT CONTROL"
                        color: Theme.muted
                        font.pixelSize: 7
                    }
                }
                StatusCard { Layout.preferredWidth: 150; Layout.fillHeight: true; title: "PROFILES"; value: String(cockpit.platformProfiles.length); subtitle: "GENERIC TYPES"; iconText: "PL"; accent: Theme.accent }
                StatusCard { Layout.preferredWidth: 165; Layout.fillHeight: true; title: "ACTIVE"; value: cockpit.activePlatformId.toUpperCase(); subtitle: cockpit.activePlatformCategory; iconText: "ID"; accent: Theme.green }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

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
                    Text { text: cockpit.rtl ? "المنصات المتاحة" : "AVAILABLE TRAINING PLATFORMS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: cockpit.platformProfiles
                        clip: true
                        spacing: 5
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: 122
                            color: modelData.active ? "#14232C" : Theme.panel2
                            border.color: modelData.active ? Theme.accent : Theme.border
                            radius: Theme.radius
                            MouseArea { anchors.fill: parent; onClicked: cockpit.setActivePlatform(modelData.id) }
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 9
                                spacing: 3
                                RowLayout {
                                    Layout.fillWidth: true
                                    Rectangle { width: 4; height: 30; color: modelData.active ? Theme.green : Theme.accent }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                                        Text { text: modelData.category; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true }
                                    }
                                    Text { text: modelData.active ? "ACTIVE" : "SELECT"; color: modelData.active ? Theme.green : Theme.silver; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                }
                                Text { text: modelData.propulsion; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8 }
                                Text { text: modelData.description; color: Theme.muted; font.pixelSize: 8; Layout.fillWidth: true; wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight }
                                Text { text: modelData.systemCount + " SYSTEMS  •  " + modelData.channelCount + " CHANNELS  •  " + modelData.diagnosticFamilyCount + " DX FAMILIES"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7 }
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
                            Text { text: page.currentProfile().name || "—"; color: Theme.platinum; font.pixelSize: 18; font.bold: true }
                            Text { text: (page.currentProfile().category || "—") + "  /  " + (page.currentProfile().propulsion || "—"); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        Rectangle {
                            Layout.preferredWidth: 168
                            Layout.preferredHeight: 38
                            color: Theme.panel2
                            border.color: Theme.green
                            radius: Theme.radius
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 0
                                Text { text: "PROFILE ACTIVE"; color: Theme.green; font.family: "Consolas"; font.pixelSize: 8; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                Text { text: "SYNTHETIC / OFFLINE"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7; Layout.alignment: Qt.AlignHCenter }
                            }
                        }
                    }
                    Text { text: page.currentProfile().description || ""; color: Theme.silver; font.pixelSize: 9; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        columnSpacing: 8
                        rowSpacing: 8

                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 205; color: Theme.panel2; border.color: Theme.border; radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 9; spacing: 4
                                Text { text: cockpit.rtl ? "خريطة الأنظمة" : "SYSTEM MAP"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                Repeater {
                                    model: page.currentProfile().systems || []
                                    delegate: RowLayout {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Rectangle { width: 5; height: 5; radius: 2; color: Theme.green }
                                        Text { text: modelData; color: Theme.silver; font.pixelSize: 8; Layout.fillWidth: true }
                                        Text { text: "MONITORED"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 205; color: Theme.panel2; border.color: Theme.border; radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 9; spacing: 4
                                Text { text: cockpit.rtl ? "عائلات التشخيص" : "DIAGNOSTIC FAMILIES"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                Repeater {
                                    model: page.currentProfile().diagnosticFamilies || []
                                    delegate: RowLayout {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Text { text: "DX"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                        Text { text: modelData; color: Theme.silver; font.pixelSize: 8; Layout.fillWidth: true }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 188; color: Theme.panel2; border.color: Theme.border; radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 9; spacing: 4
                                Text { text: cockpit.rtl ? "قنوات القياس" : "TELEMETRY CHANNEL MAP"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                Repeater {
                                    model: page.currentProfile().channels || []
                                    delegate: RowLayout {
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Text { text: "CH"; color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7 }
                                        Text { text: modelData; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 188; color: Theme.panel2; border.color: Theme.border; radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 9; spacing: 4
                                Text { text: cockpit.rtl ? "سيناريوهات التدريب" : "TRAINING SCENARIOS"; color: Theme.platinum; font.pixelSize: 9; font.bold: true }
                                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                                Repeater {
                                    model: page.currentProfile().trainingScenarios || []
                                    delegate: RowLayout {
                                        required property int index
                                        required property var modelData
                                        Layout.fillWidth: true
                                        Text { text: "S" + (index + 1); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                        Text { text: modelData; color: Theme.silver; font.pixelSize: 8; Layout.fillWidth: true }
                                    }
                                }
                                Item { Layout.fillHeight: true }
                                Text { text: cockpit.rtl ? "التبديل بين الملفات يعيد تهيئة جلسة المحاكاة ويحافظ على فصل سجل التشخيص بين المنصات." : "Changing platform resets the synthetic session and isolates diagnostic history between platform contexts."; color: Theme.muted; font.pixelSize: 7; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                            }
                        }
                    }
                }
            }
        }
    }
}
