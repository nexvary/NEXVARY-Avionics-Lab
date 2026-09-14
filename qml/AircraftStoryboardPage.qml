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
            Layout.minimumHeight: 72
            Layout.maximumHeight: 72
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text { text: cockpit.rtl ? "الاستعراض البصري للطائرة" : "AIRCRAFT ENGINEERING VIEW"; color: Theme.platinum; font.pixelSize: Theme.pageTitlePx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    Text { text: cockpit.rtl ? "عرض تقني للمنصة والأنظمة والجاهزية والتوأم الرقمي في شاشة واحدة" : "AIRFRAME, SYSTEM HEALTH, READINESS AND DIGITAL-TWIN STATUS IN ONE ENGINEERING WORKSPACE"; color: Theme.skyBlue; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
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
                        Text { text: cockpit.activePlatformName; color: Theme.royalGold; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                        Text { text: cockpit.activePlatformCategory + "  •  " + cockpit.activePlatformPropulsion; color: Theme.muted; font.family: "Consolas"; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            Layout.minimumHeight: 56
            Layout.maximumHeight: 56
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
                            Text { anchors.centerIn: parent; text: Theme.platformCode(modelData.id); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text { text: modelData.name; color: Theme.platinum; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                            Text { text: modelData.category; color: modelData.active ? Theme.skyBlue : Theme.muted; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
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
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

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
                        Text { text: cockpit.rtl ? "المشهد التقني" : "TECHNICAL VIEW"; color: Theme.platinum; font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                        Text { text: "DIGITAL TWIN  •  " + cockpit.twinNominalCount + " NOMINAL / " + cockpit.twinDegradedCount + " DEGRADED"; color: Theme.radarGreen; font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#111111"
                        border.color: Theme.border
                        border.width: 1
                        radius: Theme.radius
                        clip: true

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.shell
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: 4
                                clip: true

                                AircraftSchematic {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    platformId: cockpit.activePlatformId
                                    subsystemRows: cockpit.twinRows
                                    accent: Theme.skyBlue
                                }

                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.margins: 10
                                    width: 230
                                    height: 58
                                    color: "#EC111111"
                                    border.color: Theme.border
                                    radius: 4
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 7
                                        spacing: 1
                                        Text { text: cockpit.rtl ? "المنظر العلوي" : "TOP VIEW / SYSTEM OVERLAY"; color: Theme.skyBlue; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true }
                                        Text { text: cockpit.activePlatformName + "  •  " + cockpit.activePlatformId; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                }

                                Rectangle {
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 10
                                    width: 250
                                    height: 76
                                    color: "#EC111111"
                                    border.color: readiness.state === "READY" ? Theme.radarGreen : Theme.royalGold
                                    radius: 4
                                    GridLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        columns: 2
                                        Text { text: cockpit.rtl ? "الجاهزية" : "READINESS"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                        Text { text: readiness.readiness + "%"; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                                        Text { text: cockpit.rtl ? "الطاقم" : "CREW"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                        Text { text: readiness.crewReady + "/" + readiness.crewRequired; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx }
                                        Text { text: cockpit.rtl ? "الفحص" : "INSPECTION"; color: Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                        Text { text: readiness.hoursToInspection + " h"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 390
                                Layout.minimumWidth: 390
                                Layout.maximumWidth: 390
                                Layout.fillHeight: true
                                color: Theme.shell
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: 4
                                clip: true

                                AircraftSideProfile {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    platformId: cockpit.activePlatformId
                                    subsystemRows: cockpit.twinRows
                                    accent: Theme.signalCyan
                                }

                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 10
                                    height: 72
                                    color: "#EC111111"
                                    border.color: Theme.borderSoft
                                    radius: 4
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 7
                                        spacing: 1
                                        Text { text: cockpit.activePlatformPropulsion; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: "DIGITAL TWIN  " + cockpit.twinNominalCount + " NOMINAL  •  DX " + cockpit.diagnosticHealthScore + "%"; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: readiness.state + "  •  " + readiness.hoursToInspection + " h TO INSPECTION"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 420
                Layout.minimumWidth: 420
                Layout.maximumWidth: 420
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 155
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 4
                        Text { text: cockpit.rtl ? "بطاقة المنصة" : "PLATFORM CARD"; color: Theme.platinum; font.pixelSize: Theme.sectionPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: profile.description || ""; color: Theme.silver; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; wrapMode: Text.WordWrap; maximumLineCount: 3; elide: Text.ElideRight }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 4
                            rowSpacing: 2
                            columnSpacing: 6
                            Text { text: "SYS"; color: Theme.muted; font.pixelSize: Theme.smallPx }
                            Text { text: String(profile.systemCount || 0); color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
                            Text { text: "CH"; color: Theme.muted; font.pixelSize: Theme.smallPx }
                            Text { text: String(profile.channelCount || 0); color: Theme.signalCyan; font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
                            Text { text: "DX"; color: Theme.muted; font.pixelSize: Theme.smallPx }
                            Text { text: String(profile.diagnosticRuleCount || 0); color: Theme.rfViolet; font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
                            Text { text: "SCN"; color: Theme.muted; font.pixelSize: Theme.smallPx }
                            Text { text: String(profile.scenarioCount || 0); color: Theme.royalGold; font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        Text { text: cockpit.rtl ? "عقد التوأم الرقمي" : "DIGITAL-TWIN NODES"; color: Theme.platinum; font.pixelSize: Theme.sectionPx; font.bold: true }
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
                                    Text { text: modelData.label || modelData.id; color: Theme.platinum; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: Math.round(Number(modelData.health)) + "%"; color: Theme.stateColor(modelData.state); font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
                                    Text { text: modelData.state; color: Theme.muted; font.family: "Consolas"; font.pixelSize: Theme.smallPx; Layout.preferredWidth: 64 }
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
                        Text { text: cockpit.rtl ? "حالة الاستعراض" : "ENGINEERING STATUS"; color: Theme.platinum; font.pixelSize: Theme.sectionPx; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Text { text: "DIAGNOSTIC HEALTH  " + cockpit.diagnosticHealthScore + "%"; color: cockpit.diagnosticHealthScore >= 90 ? Theme.radarGreen : Theme.amber; font.family: "Consolas"; font.pixelSize: Theme.smallPx; font.bold: true }
                        Text { text: "ACTIVE ALERTS  " + cockpit.activeAlertCount; color: cockpit.activeAlertCount === 0 ? Theme.radarGreen : Theme.warmOrange; font.family: "Consolas"; font.pixelSize: Theme.smallPx }
                        Text { text: "TRAINING FAULTS  " + cockpit.activeTrainingFaultCount; color: cockpit.activeTrainingFaultCount === 0 ? Theme.silver : Theme.warmOrange; font.family: "Consolas"; font.pixelSize: Theme.smallPx }
                        Item { Layout.fillHeight: true }
                        Text { text: cockpit.rtl ? "عرض هندسي/تدريبي — لا تحكم حي بالطائرة" : "ENGINEERING / TRAINING VIEW — NO LIVE AIRCRAFT CONTROL"; color: Theme.warmOrange; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap }
                    }
                }
            }
        }
    }
}
