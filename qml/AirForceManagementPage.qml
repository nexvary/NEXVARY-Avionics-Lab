import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirForceManagementLocale.js" as ForceLocale

Item {
    id: page
    clip: true

    property var baseRows: [
        {name:"TRAINING BASE ALPHA", runway:"AVAILABLE", weather:"VMC", support:"92%", note:"Primary engineering training hub"},
        {name:"TRAINING BASE BRAVO", runway:"AVAILABLE", weather:"VMC", support:"86%", note:"Maintenance and systems training"},
        {name:"COASTAL TRAINING FIELD", runway:"REVIEW", weather:"WIND", support:"81%", note:"Weather-limited synthetic schedule"}
    ]
    property var squadronRows: [
        {name:"TRAINING WING 01", platform:"GENERIC JET", assigned:8, ready:7, state:"READY"},
        {name:"TRAINING WING 02", platform:"TURBOPROP", assigned:6, ready:5, state:"READY"},
        {name:"TRAINING WING 03", platform:"ROTORCRAFT", assigned:5, ready:4, state:"LIMITED"},
        {name:"TRAINING WING 04", platform:"UAV LAB", assigned:7, ready:6, state:"READY"}
    ]
    property var trainingRows: [
        {time:"08:00", group:"WING 01", item:"Simulator systems familiarization", status:"CONFIRMED"},
        {time:"10:30", group:"WING 02", item:"Telemetry replay and trend analysis", status:"CONFIRMED"},
        {time:"13:00", group:"WING 03", item:"Fault Lab diagnostic exercise", status:"PLANNED"},
        {time:"15:30", group:"WING 04", item:"Digital Twin verification session", status:"PLANNED"}
    ]
    property var maintenanceRows: [
        {priority:"P2", platform:"JET-101", item:"Hydraulic evidence review", due:"14 h"},
        {priority:"P2", platform:"JET-103", item:"Sensor calibration follow-up", due:"18 h"},
        {priority:"P3", platform:"TRB-201", item:"Scheduled systems inspection", due:"21 h"},
        {priority:"P3", platform:"UAV-402", item:"Telemetry archive integrity check", due:"26 h"}
    ]
    property var crewRows: [
        {role:"Training crews", ready:"18 / 20", score:90},
        {role:"Engineering teams", ready:"11 / 12", score:92},
        {role:"Maintenance teams", ready:"14 / 16", score:88},
        {role:"Simulation controllers", ready:"8 / 8", score:100}
    ]
    property var reportRows: [
        {title:"Executive readiness brief", status:"READY", stamp:"TODAY"},
        {title:"Maintenance risk summary", status:"READY", stamp:"TODAY"},
        {title:"Training throughput report", status:"DRAFT", stamp:"WEEK"},
        {title:"Fleet availability trend", status:"READY", stamp:"30 DAYS"}
    ]

    function stateColor(state) {
        var s = String(state || "").toUpperCase()
        if (s === "READY" || s === "AVAILABLE" || s === "CONFIRMED" || s === "VMC") return Theme.green
        if (s === "LIMITED" || s === "REVIEW" || s === "WIND" || s === "PLANNED" || s === "DRAFT") return Theme.amber
        return Theme.accent
    }
    function scoreColor(value) {
        if (value >= 90) return Theme.green
        if (value >= 80) return Theme.gold
        return Theme.amber
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: Theme.panel
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1
                    Text {
                        text: ForceLocale.title(cockpit.language)
                        color: Theme.platinum
                        font.pixelSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Text {
                        text: ForceLocale.subtitle(cockpit.language)
                        color: Theme.accent
                        font.pixelSize: 8
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 320
                    Layout.fillHeight: true
                    color: Theme.panel2
                    border.color: Theme.green
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 1
                        Text { text: cockpit.rtl ? "صورة إدارة القوة" : "FORCE MANAGEMENT PICTURE"; color: Theme.silver; font.pixelSize: 7; font.bold: true }
                        Text { text: cockpit.readinessFleetPercent + "%  FLEET  /  92%  CREW"; color: Theme.green; font.family: "Consolas"; font.pixelSize: 11; font.bold: true }
                        Text { text: "OFFLINE • SYNTHETIC • TRAINING"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 78
            columns: 6
            columnSpacing: 6
            Repeater {
                model: [
                    {k: cockpit.rtl ? "القواعد" : "BASES", v:"3", s:"2 AVAILABLE", c:Theme.accent},
                    {k: cockpit.rtl ? "الأسراب" : "SQUADRONS", v:"4", s:"26 ASSIGNED", c:Theme.platinum},
                    {k: cockpit.rtl ? "جاهزية الأسطول" : "FLEET READY", v:cockpit.readinessFleetPercent + "%", s:cockpit.readinessReadyCount + " READY", c:scoreColor(cockpit.readinessFleetPercent)},
                    {k: cockpit.rtl ? "جاهزية الأطقم" : "CREW READY", v:"92%", s:"51 / 56", c:Theme.green},
                    {k: cockpit.rtl ? "جلسات التدريب" : "TRAINING", v:"4", s:"TODAY", c:Theme.gold},
                    {k: cockpit.rtl ? "قيود الطقس" : "WX LIMITS", v:"1", s:"REVIEW", c:Theme.amber}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: modelData.c
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 0
                        Text { text: modelData.k; color: Theme.silver; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        Text { text: modelData.v; color: modelData.c; font.family: "Consolas"; font.pixelSize: 16; font.bold: true }
                        Text { text: modelData.s; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 6 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            ColumnLayout {
                Layout.preferredWidth: Math.max(500, page.width * 0.34)
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 255
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.bases(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: page.baseRows
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: page.stateColor(modelData.runway)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 6
                                    Rectangle { width: 4; Layout.fillHeight: true; color: page.stateColor(modelData.runway) }
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 0
                                        Text { text: modelData.name; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.note; color: Theme.muted; font.pixelSize: 6; Layout.fillWidth: true; elide: Text.ElideRight }
                                    }
                                    ColumnLayout {
                                        Layout.preferredWidth: 108
                                        spacing: 0
                                        Text { text: modelData.runway; color: page.stateColor(modelData.runway); font.family: "Consolas"; font.pixelSize: 6; font.bold: true }
                                        Text { text: modelData.weather + "  •  SUP " + modelData.support; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 6 }
                                    }
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
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.weather(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 94
                            columns: 3
                            columnSpacing: 5
                            Repeater {
                                model: [
                                    {k:"VISIBILITY",v:"10+ km",c:Theme.green},
                                    {k:"WIND",v:"18 kt",c:Theme.amber},
                                    {k:"CEILING",v:"8,000 ft",c:Theme.green}
                                ]
                                delegate: Rectangle {
                                    required property var modelData
                                    Layout.fillWidth: true; Layout.fillHeight: true
                                    color: Theme.panel2; border.color: modelData.c; border.width: 1; radius: Theme.radius
                                    ColumnLayout { anchors.fill: parent; anchors.margins: 6; Text { text:modelData.k; color:Theme.muted; font.pixelSize:6 }; Text { text:modelData.v; color:modelData.c; font.family:"Consolas"; font.pixelSize:11; font.bold:true } }
                                }
                            }
                        }
                        Text { text: cockpit.rtl ? "حالة تدريبية: قاعدة ساحلية واحدة تتطلب مراجعة الرياح قبل جدولة الجلسات." : "Training picture: one coastal field requires wind review before scheduling sessions."; color: Theme.silver; font.pixelSize: 7; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                        Item { Layout.fillHeight: true }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 54
                            color: Theme.panel2
                            border.color: Theme.gold
                            border.width: 1
                            radius: Theme.radius
                            ColumnLayout { anchors.fill: parent; anchors.margins: 7; Text { text: ForceLocale.planning(cockpit.language); color: Theme.gold; font.pixelSize: 7; font.bold: true }; Text { text: cockpit.rtl ? "إعادة توزيع جلسة تدريب واحدة فقط؛ لا توجد قيود على أعمال المختبر الهندسية." : "Re-plan one training slot only; engineering lab activity remains available."; color: Theme.silver; font.pixelSize: 6; wrapMode: Text.WordWrap; Layout.fillWidth: true } }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 275
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.squadrons(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        Repeater {
                            model: page.squadronRows
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: page.stateColor(modelData.state)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 6; spacing: 6
                                    Rectangle { width:4; Layout.fillHeight:true; color:page.stateColor(modelData.state) }
                                    ColumnLayout { Layout.preferredWidth:150; spacing:0; Text { text:modelData.name; color:Theme.platinum; font.pixelSize:7; font.bold:true }; Text { text:modelData.platform; color:Theme.muted; font.pixelSize:6 } }
                                    ColumnLayout { Layout.fillWidth:true; spacing:2; RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl ? "الجاهزية" : "READINESS"; color:Theme.muted; font.pixelSize:6; Layout.fillWidth:true }; Text { text:modelData.ready + " / " + modelData.assigned; color:page.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:7; font.bold:true } }; Rectangle { Layout.fillWidth:true; height:6; color:Theme.panel3; radius:3; Rectangle { width:parent.width * modelData.ready / modelData.assigned; height:parent.height; color:page.stateColor(modelData.state); radius:3 } } }
                                    Text { text:modelData.state; color:page.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:6; font.bold:true }
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
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        Text { text: ForceLocale.training(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 3
                            model: page.trainingRows
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: 54
                                color: index % 2 ? Theme.panel2 : Theme.panel3
                                border.color: page.stateColor(modelData.status)
                                border.width: 1
                                radius: Theme.radius
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 6; spacing: 7
                                    Text { text:modelData.time; color:Theme.gold; font.family:"Consolas"; font.pixelSize:7; font.bold:true; Layout.preferredWidth:45 }
                                    Text { text:modelData.group; color:Theme.accent; font.family:"Consolas"; font.pixelSize:6; font.bold:true; Layout.preferredWidth:72 }
                                    Text { text:modelData.item; color:Theme.silver; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:modelData.status; color:page.stateColor(modelData.status); font.family:"Consolas"; font.pixelSize:6; font.bold:true }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 410
                Layout.fillHeight: true
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 195
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 8; spacing: 4
                        Text { text: ForceLocale.crew(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                        Repeater {
                            model: page.crewRows
                            delegate: RowLayout {
                                required property var modelData
                                Layout.fillWidth: true
                                spacing: 6
                                Text { text:modelData.role; color:Theme.silver; font.pixelSize:6; Layout.preferredWidth:130; elide:Text.ElideRight }
                                Rectangle { Layout.fillWidth:true; height:7; color:Theme.panel2; radius:3; Rectangle { width:parent.width * modelData.score / 100; height:parent.height; radius:3; color:page.scoreColor(modelData.score) } }
                                Text { text:modelData.ready; color:page.scoreColor(modelData.score); font.family:"Consolas"; font.pixelSize:6; font.bold:true; Layout.preferredWidth:48 }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 235
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 8; spacing: 4
                        Text { text: ForceLocale.maintenance(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                        Repeater {
                            model: page.maintenanceRows
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth:true; Layout.fillHeight:true
                                color:Theme.panel2; border.color:modelData.priority === "P2" ? Theme.amber : Theme.borderSoft; border.width:1; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:5; spacing:5; Text { text:modelData.priority; color:modelData.priority === "P2" ? Theme.amber : Theme.accent; font.family:"Consolas"; font.pixelSize:6; font.bold:true }; ColumnLayout { Layout.fillWidth:true; spacing:0; Text { text:modelData.platform + " / " + modelData.item; color:Theme.silver; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight }; Text { text:modelData.due; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 } } }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent; anchors.margins: 8; spacing: 4
                        Text { text: ForceLocale.reports(cockpit.language); color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                        Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                        Repeater {
                            model: page.reportRows
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth:true; Layout.fillHeight:true
                                color:Theme.panel2; border.color:page.stateColor(modelData.status); border.width:1; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:5; spacing:5; ColumnLayout { Layout.fillWidth:true; spacing:0; Text { text:modelData.title; color:Theme.silver; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight }; Text { text:modelData.stamp; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 } }; Text { text:modelData.status; color:page.stateColor(modelData.status); font.family:"Consolas"; font.pixelSize:6; font.bold:true } }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            color: Theme.panel2
            border.color: Theme.green
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 7
                Text { text:"AIRSPACE"; color:Theme.accent; font.pixelSize:6; font.bold:true }
                Text { text:"→"; color:Theme.silver }
                Text { text:"FLEET READINESS"; color:Theme.platinum; font.pixelSize:6; font.bold:true }
                Text { text:"→"; color:Theme.silver }
                Text { text:"CREW / TRAINING / MAINTENANCE"; color:Theme.gold; font.pixelSize:6; font.bold:true }
                Item { Layout.fillWidth:true }
                Text { text:ForceLocale.boundary(cockpit.language); color:Theme.green; font.pixelSize:6; font.bold:true; elide:Text.ElideRight; Layout.maximumWidth:parent.width * 0.48 }
            }
        }
    }
}
