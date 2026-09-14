import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    clip: true

    function readinessColor(value) {
        var v = Number(value)
        if (v >= 90) return Theme.radarGreen
        if (v >= 75) return Theme.amber
        return Theme.red
    }

    function stateColor(state) {
        var s = String(state || "").toUpperCase()
        if (s.indexOf("READY") >= 0 || s.indexOf("NOMINAL") >= 0 ||
                s.indexOf("AVAILABLE") >= 0 || s.indexOf("CURRENT") >= 0) return Theme.radarGreen
        if (s.indexOf("HOLD") >= 0 || s.indexOf("DUE") >= 0 ||
                s.indexOf("REVIEW") >= 0 || s.indexOf("LIMIT") >= 0) return Theme.amber
        if (s.indexOf("CRITICAL") >= 0 || s.indexOf("FAULT") >= 0 ||
                s.indexOf("GROUND") >= 0) return Theme.red
        return Theme.signalCyan
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 96
            color: Theme.shell
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius

            Rectangle {
                width: 4
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: cockpit.rtl ? undefined : parent.left
                anchors.right: cockpit.rtl ? parent.right : undefined
                color: Theme.royalGold
                radius: 2
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 18
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                spacing: 16
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 440
                    spacing: 3

                    Text {
                        text: cockpit.rtl ? "موجز قيادة القوة الجوية" : "AIR FORCE COMMAND OVERVIEW"
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.titlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl
                              ? "الصورة الجوية المشتركة  •  الجاهزية  •  القواعد  •  الإدامة  •  التدريب"
                              : "COMMON AIR PICTURE  •  READINESS  •  AIRFIELDS  •  SUSTAINMENT  •  TRAINING"
                        color: Theme.royalGold
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.secondaryPx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: cockpit.rtl
                              ? "وعي وإدارة وتحليل وتدريب — لا توجد وظائف تحكم حي أو اشتباك"
                              : "AWARENESS / MANAGEMENT / ANALYSIS / TRAINING — NO LIVE CONTROL OR ENGAGEMENT"
                        color: Theme.silver
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.smallPx
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }

                RowLayout {
                    spacing: 0
                    layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                    Repeater {
                        model: [
                            {label: cockpit.rtl ? "جاهزية القوة" : "FORCE READY",
                             value: cockpit.forceFleetReadinessPercent + "%",
                             color: page.readinessColor(cockpit.forceFleetReadinessPercent)},
                            {label: cockpit.rtl ? "جاهزية الطاقم" : "CREW READY",
                             value: cockpit.forceCrewReadinessPercent + "%",
                             color: page.readinessColor(cockpit.forceCrewReadinessPercent)},
                            {label: cockpit.rtl ? "المنصات" : "PLATFORMS",
                             value: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount,
                             color: Theme.signalCyan},
                            {label: cockpit.rtl ? "المسارات الحية" : "LIVE TRACKS",
                             value: String(cockpit.airOperationsTrackCount + cockpit.publicFlightTrackCount),
                             color: Theme.rfViolet}
                        ]

                        delegate: Item {
                            required property var modelData
                            Layout.preferredWidth: 118
                            Layout.preferredHeight: 68

                            Rectangle {
                                width: 1
                                height: 44
                                anchors.left: cockpit.rtl ? undefined : parent.left
                                anchors.right: cockpit.rtl ? parent.right : undefined
                                anchors.verticalCenter: parent.verticalCenter
                                color: Theme.borderSoft
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 4
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.value
                                    color: modelData.color
                                    font.family: Theme.mono
                                    font.pixelSize: 19
                                    font.bold: true
                                }
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.label
                                    color: Theme.silver
                                    font.family: Theme.uiFont(cockpit.rtl)
                                    font.pixelSize: Theme.smallPx
                                    font.bold: true
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            id: commandBody
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 760
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            spacing: 10
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                            Rectangle {
                                width: 4
                                height: 25
                                radius: 2
                                color: Theme.signalCyan
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0
                                Text {
                                    text: cockpit.rtl ? "الصورة الجوية المشتركة" : "COMMON AIR PICTURE"
                                    color: Theme.platinum
                                    font.family: Theme.uiFont(cockpit.rtl)
                                    font.pixelSize: Theme.sectionPx
                                    font.bold: true
                                    Layout.fillWidth: true
                                    horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                }
                                Text {
                                    text: cockpit.rtl
                                          ? "ADS-B عام  •  AEGIS  •  قواعد  •  قطاعات  •  طقس  •  مسارات"
                                          : "PUBLIC ADS-B  •  AEGIS  •  BASES  •  SECTORS  •  WEATHER  •  ROUTES"
                                    color: Theme.silver
                                    font.family: Theme.uiFont(cockpit.rtl)
                                    font.pixelSize: Theme.smallPx
                                    Layout.fillWidth: true
                                    horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                }
                            }

                            RowLayout {
                                spacing: 8
                                Repeater {
                                    model: [
                                        {label:"ADS-B", value:String(cockpit.publicFlightTrackCount), color:Theme.signalCyan},
                                        {label:"AEGIS", value:String(cockpit.airOperationsTrackCount), color:Theme.rfViolet},
                                        {label:cockpit.rtl ? "الطقس" : "WX", value:String(cockpit.forceWeatherConstraintCount), color:cockpit.forceWeatherConstraintCount > 0 ? Theme.amber : Theme.radarGreen}
                                    ]
                                    delegate: RowLayout {
                                        required property var modelData
                                        spacing: 4
                                        Rectangle { width: 7; height: 7; radius: 4; color: modelData.color }
                                        Text { text: modelData.label; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                        Text { text: modelData.value; color: modelData.color; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                    }
                                }
                            }
                        }

                        StrategicAirMap {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            publicTracks: cockpit.publicFlightTracks
                            aegisTracks: cockpit.airOperationsTracks
                            bases: cockpit.forceBases
                            rtl: cockpit.rtl
                            showTrackRoster: false
                            showTitleOverlay: false
                            showDataBadge: true
                            showBaseLabels: false
                            showRadar: true
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 138
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 7

                        RowLayout {
                            Layout.fillWidth: true
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                            Text {
                                text: cockpit.rtl ? "القواعد والمطارات" : "BASES & AIRFIELDS"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.sectionPx
                                font.bold: true
                                Layout.fillWidth: true
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                            Text {
                                text: cockpit.forceAvailableBaseCount + "/" + cockpit.forceBases.length + "  " + (cockpit.rtl ? "متاحة" : "AVAILABLE")
                                color: Theme.radarGreen
                                font.family: Theme.mono
                                font.pixelSize: Theme.secondaryPx
                                font.bold: true
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 8
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                            Repeater {
                                model: cockpit.forceBases
                                delegate: Rectangle {
                                    required property int index
                                    required property var modelData
                                    visible: index < 3
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: index % 2 ? Theme.panel2 : Theme.shell
                                    border.color: Theme.borderSoft
                                    border.width: 1
                                    radius: 6

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 9
                                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                                        Rectangle {
                                            width: 34
                                            height: 34
                                            radius: 17
                                            color: Theme.panel3
                                            border.color: page.readinessColor(modelData.supportPercent)
                                            border.width: 1
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✦"
                                                color: page.readinessColor(modelData.supportPercent)
                                                font.pixelSize: 16
                                                font.bold: true
                                            }
                                        }

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 3
                                            Text {
                                                text: modelData.name
                                                color: Theme.platinum
                                                font.family: Theme.uiFont(cockpit.rtl)
                                                font.pixelSize: Theme.bodyPx
                                                font.bold: true
                                                Layout.fillWidth: true
                                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                                elide: Text.ElideRight
                                            }
                                            Text {
                                                text: (modelData.runway || "RWY") + "  •  " + (modelData.weather || "WX NOMINAL")
                                                color: Theme.silver
                                                font.family: Theme.uiFont(cockpit.rtl)
                                                font.pixelSize: Theme.smallPx
                                                Layout.fillWidth: true
                                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                                elide: Text.ElideRight
                                            }
                                            Rectangle {
                                                Layout.fillWidth: true
                                                height: 6
                                                radius: 3
                                                color: Theme.panel3
                                                Rectangle {
                                                    width: parent.width * Number(modelData.supportPercent || 0) / 100
                                                    height: parent.height
                                                    radius: 3
                                                    color: page.readinessColor(modelData.supportPercent)
                                                }
                                            }
                                        }
                                        Text {
                                            text: Number(modelData.supportPercent || 0) + "%"
                                            color: page.readinessColor(modelData.supportPercent)
                                            font.family: Theme.mono
                                            font.pixelSize: 15
                                            font.bold: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: Math.max(410, Math.min(510, commandBody.width * 0.31))
                Layout.minimumWidth: 390
                Layout.maximumWidth: 530
                Layout.fillHeight: true
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 158
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 11
                        spacing: 14
                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                        Item {
                            Layout.preferredWidth: 122
                            Layout.fillHeight: true

                            Canvas {
                                id: readinessDial
                                anchors.centerIn: parent
                                width: 112
                                height: 112
                                property real score: Number(cockpit.forceFleetReadinessPercent)
                                onScoreChanged: requestPaint()
                                onPaint: {
                                    var c = getContext("2d")
                                    c.reset()
                                    var cx = width / 2
                                    var cy = height / 2
                                    var r = width * .39
                                    c.lineWidth = 8
                                    c.strokeStyle = Theme.panel3
                                    c.beginPath(); c.arc(cx, cy, r, 0, Math.PI * 2); c.stroke()
                                    c.lineCap = "round"
                                    c.strokeStyle = page.readinessColor(score)
                                    c.beginPath(); c.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + Math.PI * 2 * score / 100); c.stroke()
                                    c.lineWidth = 1
                                    c.strokeStyle = Theme.border
                                    c.beginPath(); c.arc(cx, cy, r + 9, 0, Math.PI * 2); c.stroke()
                                }
                            }
                            Column {
                                anchors.centerIn: parent
                                spacing: 0
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: cockpit.forceFleetReadinessPercent + "%"
                                    color: page.readinessColor(cockpit.forceFleetReadinessPercent)
                                    font.family: Theme.mono
                                    font.pixelSize: 23
                                    font.bold: true
                                }
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: cockpit.rtl ? "الجاهزية" : "READINESS"
                                    color: Theme.silver
                                    font.family: Theme.uiFont(cockpit.rtl)
                                    font.pixelSize: Theme.smallPx
                                    font.bold: true
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 5

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: cockpit.rtl ? "حالة القوة" : "FORCE POSTURE"
                                    color: Theme.platinum
                                    font.family: Theme.uiFont(cockpit.rtl)
                                    font.pixelSize: Theme.sectionPx
                                    font.bold: true
                                    Layout.fillWidth: true
                                }
                                Rectangle { width: 8; height: 8; radius: 4; color: Theme.radarGreen }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            GridLayout {
                                Layout.fillWidth: true
                                columns: 2
                                rowSpacing: 6
                                columnSpacing: 8
                                Text { text: cockpit.rtl ? "المنصات الجاهزة" : "READY PLATFORMS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                Text { text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                                Text { text: cockpit.rtl ? "جاهزية الأطقم" : "CREW READINESS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                Text { text: cockpit.forceCrewReadinessPercent + "%"; color: page.readinessColor(cockpit.forceCrewReadinessPercent); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                                Text { text: cockpit.rtl ? "القواعد المتاحة" : "AVAILABLE BASES"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx }
                                Text { text: String(cockpit.forceAvailableBaseCount); color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 250
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    clip: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 7

                        RowLayout {
                            Layout.fillWidth: true
                            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                            Text {
                                text: cockpit.rtl ? "جاهزية الأسراب" : "SQUADRON READINESS"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.sectionPx
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: cockpit.forceReadyPlatformCount + "/" + cockpit.forceAssignedPlatformCount
                                color: page.readinessColor(cockpit.forceFleetReadinessPercent)
                                font.family: Theme.mono
                                font.pixelSize: Theme.secondaryPx
                                font.bold: true
                            }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 2
                            model: cockpit.forceSquadrons

                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 70
                                color: index % 2 ? Theme.panel2 : "transparent"

                                Rectangle {
                                    width: 3
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.left: cockpit.rtl ? undefined : parent.left
                                    anchors.right: cockpit.rtl ? parent.right : undefined
                                    color: page.stateColor(modelData.state)
                                }

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 7
                                    anchors.bottomMargin: 7
                                    spacing: 4

                                    RowLayout {
                                        Layout.fillWidth: true
                                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                        Text {
                                            text: modelData.name
                                            color: Theme.platinum
                                            font.family: Theme.uiFont(cockpit.rtl)
                                            font.pixelSize: Theme.bodyPx
                                            font.bold: true
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            text: modelData.ready + "/" + modelData.assigned
                                            color: page.stateColor(modelData.state)
                                            font.family: Theme.mono
                                            font.pixelSize: Theme.secondaryPx
                                            font.bold: true
                                        }
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                        Text {
                                            text: modelData.platform
                                            color: Theme.signalCyan
                                            font.family: Theme.uiFont(cockpit.rtl)
                                            font.pixelSize: Theme.smallPx
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            text: (cockpit.rtl ? "طاقم " : "CREW ") + modelData.crewReady + "/" + modelData.crewRequired
                                            color: Theme.silver
                                            font.family: Theme.uiFont(cockpit.rtl)
                                            font.pixelSize: Theme.smallPx
                                        }
                                    }
                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 5
                                        radius: 3
                                        color: Theme.panel3
                                        Rectangle {
                                            width: parent.width * Math.min(1, Number(modelData.ready || 0) / Math.max(1, Number(modelData.assigned || 1)))
                                            height: parent.height
                                            radius: 3
                                            color: page.stateColor(modelData.state)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 174
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    clip: true

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 12
                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 5

                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: cockpit.rtl ? "الصيانة والإدامة" : "MAINTENANCE"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                                Text { text: String(cockpit.forceOpenMaintenanceCount); color: Theme.amber; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                spacing: 2
                                model: cockpit.forceMaintenancePlanRows
                                delegate: RowLayout {
                                    required property var modelData
                                    width: ListView.view.width
                                    height: 29
                                    spacing: 7
                                    Text { text: modelData.priority; color: modelData.priority === "P2" ? Theme.red : Theme.amber; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.preferredWidth: 26 }
                                    Text { text: modelData.platform + " / " + modelData.item; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.due; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                                }
                            }
                        }

                        Rectangle { width: 1; Layout.fillHeight: true; color: Theme.borderSoft }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 5

                            RowLayout {
                                Layout.fillWidth: true
                                Text { text: cockpit.rtl ? "التدريب" : "TRAINING"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                                Text { text: cockpit.forceTrainingRows.length + " " + (cockpit.rtl ? "مجدول" : "SCHEDULED"); color: Theme.rfViolet; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                spacing: 2
                                model: cockpit.forceTrainingRows
                                delegate: RowLayout {
                                    required property var modelData
                                    width: ListView.view.width
                                    height: 29
                                    spacing: 7
                                    Text { text: modelData.time; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.preferredWidth: 45 }
                                    Text { text: modelData.group + " / " + modelData.item; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Rectangle { width: 7; height: 7; radius: 4; color: page.stateColor(modelData.status) }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 92
                    color: Theme.panel
                    border.color: cockpit.airOperationsIncidentCount > 0 ? Theme.amber : Theme.border
                    border.width: 1
                    radius: Theme.radius

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 11
                        spacing: 12
                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

                        Rectangle {
                            width: 42
                            height: 42
                            radius: 21
                            color: cockpit.airOperationsIncidentCount > 0 ? "#2A1D0B" : Theme.panel3
                            border.color: cockpit.airOperationsIncidentCount > 0 ? Theme.amber : Theme.radarGreen
                            border.width: 1
                            Text {
                                anchors.centerIn: parent
                                text: String(cockpit.airOperationsIncidentCount)
                                color: cockpit.airOperationsIncidentCount > 0 ? Theme.amber : Theme.radarGreen
                                font.family: Theme.mono
                                font.pixelSize: 18
                                font.bold: true
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3
                            Text {
                                text: cockpit.rtl ? "التنبيهات والحوادث" : "ALERTS & INCIDENTS"
                                color: Theme.platinum
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.sectionPx
                                font.bold: true
                                Layout.fillWidth: true
                            }
                            Text {
                                text: cockpit.airOperationsIncidentCount > 0
                                      ? (cockpit.rtl ? "توجد عناصر مفتوحة للمراجعة داخل مساحة الحوادث" : "OPEN ITEMS REQUIRE REVIEW IN THE INCIDENT WORKSPACE")
                                      : (cockpit.rtl ? "لا توجد حوادث حرجة مفتوحة" : "NO CRITICAL INCIDENTS OPEN")
                                color: cockpit.airOperationsIncidentCount > 0 ? Theme.amber : Theme.radarGreen
                                font.family: Theme.uiFont(cockpit.rtl)
                                font.pixelSize: Theme.smallPx
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }
                        Column {
                            spacing: 2
                            Text { text: cockpit.rtl ? "حالة التغذية" : "FEED STATUS"; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
                            Text { text: cockpit.publicFlightFeedStatus; color: Theme.signalCyan; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                        }
                    }
                }
            }
        }
    }
}
