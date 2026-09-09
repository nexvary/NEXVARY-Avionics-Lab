import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

ApplicationWindow {
    id: root
    width: 1600
    height: 980
    minimumWidth: 1280
    minimumHeight: 760
    visible: true
    title: cockpit.text("app_title")
    color: Theme.bg
    property int selectedPage: 0

    Timer { interval:250; running:true; repeat:true; onTriggered:cockpit.step() }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 196
            Layout.fillHeight: true
            color: "#051018"
            border.color: "#172b35"
            border.width: 1
            LayoutMirroring.enabled: false

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 7

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 104
                    NexvaryMark { Layout.preferredWidth: 52; Layout.preferredHeight: 52 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Text { text:"NEXVARY"; color:Theme.gold; font.pixelSize:21; font.bold:true; font.letterSpacing:2 }
                        Text { text:"AVIONICS LAB"; color:Theme.silver; font.pixelSize:9; font.letterSpacing:2 }
                    }
                }

                Repeater {
                    model: [
                        {"text":cockpit.text("mfd"),"icon":"dashboard"},
                        {"text":cockpit.text("systems"),"icon":"health"},
                        {"text":cockpit.text("sensors"),"icon":"sensors"},
                        {"text":cockpit.text("events"),"icon":"events"},
                        {"text":cockpit.text("replay"),"icon":"replay"},
                        {"text":cockpit.text("trends"),"icon":"trends"},
                        {"text":cockpit.text("digital_twin"),"icon":"twin"},
                        {"text":cockpit.text("fault_lab"),"icon":"fault"}
                    ]
                    delegate: SideNavButton {
                        required property int index
                        required property var modelData
                        text: modelData.text
                        iconKind: modelData.icon
                        checked: root.selectedPage === index
                        Layout.fillWidth: true
                        onClicked: root.selectedPage = index
                    }
                }

                Item { Layout.fillHeight:true }

                Rectangle {
                    Layout.fillWidth:true; Layout.preferredHeight:96; radius:8; color:"#07141c"; border.color:Theme.border
                    Column { anchors.centerIn:parent; spacing:4
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"TRAINING PLATFORM"; color:Theme.cyan; font.bold:true; font.pixelSize:11 }
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"SIMULATION • VERIFICATION"; color:Theme.muted; font.pixelSize:9 }
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"SECURE • OFFLINE"; color:Theme.green; font.pixelSize:9 }
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            LayoutMirroring.enabled: cockpit.rtl
            LayoutMirroring.childrenInherit: true

            Rectangle {
                Layout.fillWidth:true
                Layout.preferredHeight:96
                color:"#061119"
                border.color:"#223944"
                border.width:1

                RowLayout {
                    anchors.fill:parent
                    anchors.margins:18
                    spacing:18

                    ColumnLayout {
                        Layout.fillWidth:true; spacing:2
                        Text { text:cockpit.text("app_title"); color:Theme.gold; font.pixelSize:25; font.bold:true; horizontalAlignment:cockpit.rtl?Text.AlignRight:Text.AlignLeft; Layout.fillWidth:true }
                        Text { text:cockpit.text("training")+"  |  "+cockpit.scenario; color:Theme.green; font.pixelSize:13; font.bold:true; horizontalAlignment:cockpit.rtl?Text.AlignRight:Text.AlignLeft; Layout.fillWidth:true }
                    }

                    ColumnLayout {
                        Text { text:cockpit.text("scenario"); color:Theme.muted; font.pixelSize:10 }
                        ComboBox {
                            id: scenarioBox
                            model: cockpit.scenarios
                            Layout.preferredWidth: 185
                            contentItem: Text { text:scenarioBox.displayText; color:Theme.text; verticalAlignment:Text.AlignVCenter; horizontalAlignment:Text.AlignHCenter; font.pixelSize:12 }
                            background: Rectangle { color:Theme.panel; radius:6; border.color:Theme.border }
                            onActivated: cockpit.setScenario(currentText)
                        }
                    }

                    ColumnLayout {
                        Text { text:cockpit.text("tick")+": "+cockpit.tick; color:Theme.silver; font.pixelSize:14; font.bold:true }
                        Text { text:"BUILD 1.4 • STAGE 900"; color:Theme.muted; font.pixelSize:9 }
                    }

                    Rectangle {
                        Layout.preferredWidth:220; Layout.preferredHeight:52; radius:8; color:"#071a16"; border.color:cockpit.activeAlertCount===0?Theme.green:Theme.amber
                        RowLayout { anchors.fill:parent; anchors.margins:11
                            Text { text:"●"; color:cockpit.activeAlertCount===0?Theme.green:Theme.amber; font.pixelSize:21 }
                            ColumnLayout { Layout.fillWidth:true
                                Text { text:cockpit.activeAlertCount===0?cockpit.text("systems_nominal"):cockpit.activeAlertCount+" "+cockpit.text("active_alerts"); color:cockpit.activeAlertCount===0?Theme.green:Theme.amber; font.bold:true; font.pixelSize:11; elide:Text.ElideRight; Layout.fillWidth:true }
                                Text { text:cockpit.activeAlertCount===0?"ALL SYSTEMS NOMINAL":"ATTENTION REQUIRED"; color:Theme.muted; font.pixelSize:8 }
                            }
                        }
                    }

                    MinisterialButton { text:cockpit.text("language"); implicitWidth:100; onClicked:cockpit.setLanguage(cockpit.rtl?"en":"ar") }
                }
            }

            StackLayout {
                Layout.fillWidth:true
                Layout.fillHeight:true
                currentIndex:root.selectedPage
                ExecutiveDashboard { }
                SystemHealthPage { }
                SensorsPage { }
                EventsPage { }
                ReplayPage { }
                TrendsPage { }
                DigitalTwinPage { }
                FaultLabPage { }
            }

            Rectangle {
                Layout.fillWidth:true; Layout.preferredHeight:34; color:"#041018"; border.color:"#142832"
                RowLayout { anchors.fill:parent; anchors.margins:8
                    Text { text:"NEXVARY AVIONICS LAB"; color:Theme.muted; font.pixelSize:9 }
                    Item { Layout.fillWidth:true }
                    Text { text:cockpit.text("simulation_only"); color:Theme.muted; font.pixelSize:9 }
                    Item { Layout.fillWidth:true }
                    Text { text:"SECURE  |  OFFLINE MODE  ●"; color:Theme.green; font.pixelSize:9 }
                }
            }
        }
    }
}
