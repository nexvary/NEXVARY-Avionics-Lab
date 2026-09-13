import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function activeProfile() {
        for (var i = 0; i < cockpit.platformProfiles.length; ++i)
            if (cockpit.platformProfiles[i].id === cockpit.activePlatformId) return cockpit.platformProfiles[i]
        return cockpit.platformProfiles.length ? cockpit.platformProfiles[0] : ({})
    }

    function readinessFor(id) {
        for (var i = 0; i < cockpit.readinessAssets.length; ++i)
            if (cockpit.readinessAssets[i].id === id) return cockpit.readinessAssets[i]
        return ({readiness:0, state:"UNKNOWN", crewReady:0, crewRequired:0, hoursToInspection:0})
    }

    property var profile: activeProfile()
    property var readiness: readinessFor(cockpit.activePlatformId)

    Connections {
        target: cockpit
        function onDataChanged() {
            page.profile = page.activeProfile()
            page.readiness = page.readinessFor(cockpit.activePlatformId)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
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
                    Text { text: cockpit.rtl ? "الاستعراض البصري للطائرة" : "AIRCRAFT VISUAL STORYBOARD"; color: Theme.platinum; font.pixelSize: 20; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    Text { text: cockpit.rtl ? "عرض تقني للمنصة والأنظمة والجاهزية والتوأم الرقمي في شاشة واحدة" : "TECHNICAL PLATFORM, SYSTEM, READINESS AND DIGITAL-TWIN STORY IN ONE VISUAL WORKSPACE"; color: Theme.skyBlue; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                }
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 46
                    color: Theme.panel2
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 1
                        Text { text: cockpit.activePlatformName; color: Theme.royalGold; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                        Text { text: cockpit.activePlatformCategory + "  •  " + cockpit.activePlatformPropulsion; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            spacing: 6
            Repeater {
                model: cockpit.platformProfiles
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: modelData.active ? Theme.panel3 : Theme.panel
                    border.color: modelData.active ? Theme.skyBlue : Theme.borderSoft
                    border.width: modelData.active ? 2 : 1
                    radius: Theme.radius
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 7
                        Rectangle {
                            width: 34; height: 34
                            color: Theme.panel2
                            border.color: modelData.active ? Theme.skyBlue : Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius
                            Text { anchors.centerIn: parent; text: Theme.platformCode(modelData.id); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 8; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: modelData.category; color: modelData.active ? Theme.skyBlue : Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                    }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: cockpit.setActivePlatform(modelData.id) }
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
                color: Theme.panel
                border.color: Theme.border
                border.width: 1
                radius: Theme.radius

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: cockpit.rtl ? "المشهد التقني" : "TECHNICAL VIEW"; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                        Text { text: "DIGITAL TWIN  •  " + cockpit.twinNominalCount + " NOMINAL / " + cockpit.twinDegradedCount + " DEGRADED"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#0E1820"
                        border.color: Theme.skyBlue
                        border.width: 1
                        radius: Theme.radius
                        clip: true

                        AircraftSchematic {
                            anchors.fill: parent
                            anchors.margins: 18
                            platformId: cockpit.activePlatformId
                            subsystemRows: cockpit.twinRows
                            accent: Theme.skyBlue
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.margins: 10
                            width: 220
                            height: 62
                            color: Theme.panel
                            opacity: 0.94
                            border.color: Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 1
                                Text { text: cockpit.activePlatformName; color: Theme.platinum; font.pixelSize: 9; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: cockpit.activePlatformPropulsion; color: Theme.skyBlue; font.family: "Consolas"; font.pixelSize: 7; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: "PROFILE  " + cockpit.activePlatformId; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                            }
                        }

                        Rectangle {
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 10
                            width: 245
                            height: 72
                            color: Theme.panel
                            opacity: 0.94
                            border.color: readiness.state === "READY" ? Theme.radarGreen : Theme.amber
                            border.width: 1
                            radius: Theme.radius
                            GridLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                columns: 2
                                rowSpacing: 2
                                columnSpacing: 8
                                Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.muted; font.pixelSize: 6 }
                                Text { text: readiness.readiness + "%"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                                Text { text: cockpit.rtl ? "الطاقم" : "CREW"; color: Theme.muted; font.pixelSize: 6 }
                                Text { text: readiness.crewReady + "/" + readiness.crewRequired; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8 }
                                Text { text: cockpit.rtl ? "الفحص" : "INSPECTION"; color: Theme.muted; font.pixelSize: 6 }
                                Text { text: readiness.hoursToInspection + " h"; color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 8 }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 420
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 155
                    color: Theme.panel
                    border.color: Theme.skyBlue
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 4
                        Text { text: cockpit.rtl ? "بطاقة المنصة" : "PLATFORM CARD"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: profile.description || ""; color: Theme.silver; font.pixelSize: 7; Layout.fillWidth: true; wrapMode: Text.WordWrap; maximumLineCount: 3; elide: Text.ElideRight }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 4
                            rowSpacing: 2
                            columnSpacing: 6
                            Text { text: "SYS"; color: Theme.muted; font.pixelSize: 6 }
                            Text { text: String(profile.systemCount || 0); color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            Text { text: "CH"; color: Theme.muted; font.pixelSize: 6 }
                            Text { text: String(profile.channelCount || 0); color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            Text { text: "DX"; color: Theme.muted; font.pixelSize: 6 }
                            Text { text: String(profile.diagnosticRuleCount || 0); color: Theme.rfViolet; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            Text { text: "SCN"; color: Theme.muted; font.pixelSize: 6 }
                            Text { text: String(profile.scenarioCount || 0); color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    color: Theme.panel
                    border.color: Theme.radarGreen
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "عقد التوأم الرقمي" : "DIGITAL-TWIN NODES"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.twinRows
                            clip: true
                            spacing: 3
                            delegate: Rectangle {
                                required property var modelData
                                width: ListView.view.width
                                height: 34
                                color: Theme.panel2
                                border.color: Theme.stateColor(modelData.state)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 6
                                    Rectangle { width: 7; height: 7; radius: 3; color: Theme.stateColor(modelData.state) }
                                    Text { text: modelData.label || modelData.id; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: Math.round(Number(modelData.health)) + "%"; color: Theme.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: 7; font.bold: true }
                                    Text { text: modelData.state; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6; Layout.preferredWidth: 64 }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "حالة الاستعراض" : "STORYBOARD STATUS"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: "DIAGNOSTIC HEALTH  " + cockpit.diagnosticHealthScore + "%"; color: cockpit.diagnosticHealthScore >= 90 ? Theme.radarGreen : Theme.amber; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                        Text { text: "ACTIVE ALERTS  " + cockpit.activeAlertCount; color: cockpit.activeAlertCount === 0 ? Theme.radarGreen : Theme.warmOrange; font.family: "Consolas"; font.pixelSize: 8 }
                        Text { text: "TRAINING FAULTS  " + cockpit.activeTrainingFaultCount; color: cockpit.activeTrainingFaultCount === 0 ? Theme.silver : Theme.warmOrange; font.family: "Consolas"; font.pixelSize: 8 }
                        Item { Layout.fillHeight: true }
                        Text { text: cockpit.rtl ? "عرض هندسي/تدريبي — لا تحكم حي بالطائرة" : "ENGINEERING / TRAINING VIEW — NO LIVE AIRCRAFT CONTROL"; color: Theme.warmOrange; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap }
                    }
                }
            }
        }
    }
}
