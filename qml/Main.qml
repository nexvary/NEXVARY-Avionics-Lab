import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

ApplicationWindow {
    id: root
    width: 1680
    height: 1000
    minimumWidth: 1360
    minimumHeight: 800
    visible: true
    title: cockpit.text("app_title")
    color: Theme.bg
    property int selectedPage: 0
    property string workMode: "EXECUTIVE"

    onSelectedPageChanged: {
        if(root.selectedPage===0) root.workMode="EXECUTIVE"
        else if(root.selectedPage===5) root.workMode="ENGINEERING"
        else if(root.selectedPage===8) root.workMode="DIAGNOSTIC"
    }

    function setWorkMode(mode){
        root.workMode=mode
        if(mode==="EXECUTIVE") root.selectedPage=0
        else if(mode==="ENGINEERING") root.selectedPage=5
        else root.selectedPage=8
    }

    Timer { interval:250; running:true; repeat:true; onTriggered:cockpit.step() }

    RowLayout {
        anchors.fill: parent; spacing:0
        Rectangle {
            Layout.preferredWidth:208; Layout.fillHeight:true; color:"#040d13"; border.color:"#152832"; border.width:1; LayoutMirroring.enabled:false
            ColumnLayout { anchors.fill:parent; anchors.margins:10; spacing:4
                RowLayout { Layout.fillWidth:true; Layout.preferredHeight:84
                    NexvaryMark { Layout.preferredWidth:46; Layout.preferredHeight:46 }
                    ColumnLayout { Layout.fillWidth:true; spacing:1
                        Text { text:"NEXVARY"; color:Theme.gold; font.pixelSize:19; font.bold:true; font.letterSpacing:2.3 }
                        Text { text:"AVIONICS LAB"; color:Theme.silver; font.pixelSize:8; font.letterSpacing:2 }
                    }
                }
                Text { text:"OPERATIONS"; color:Theme.muted; font.pixelSize:8; font.bold:true; font.letterSpacing:1.2; leftPadding:5 }
                Repeater {
                    model:[
                        {"text":cockpit.text("mfd"),"icon":"dashboard"},
                        {"text":cockpit.text("systems"),"icon":"health"},
                        {"text":cockpit.text("sensors"),"icon":"sensors"},
                        {"text":cockpit.text("events"),"icon":"events"},
                        {"text":cockpit.text("replay"),"icon":"replay"},
                        {"text":cockpit.text("trends"),"icon":"trends"},
                        {"text":cockpit.text("digital_twin"),"icon":"twin"},
                        {"text":cockpit.text("fault_lab"),"icon":"fault"},
                        {"text":cockpit.rtl?"مركز التحقق":"Verification Center","icon":"verify"}
                    ]
                    delegate:SideNavButton { required property int index; required property var modelData; text:modelData.text; iconKind:modelData.icon; checked:root.selectedPage===index; Layout.fillWidth:true; onClicked:root.selectedPage=index }
                }
                Item { Layout.fillHeight:true }
                Rectangle { Layout.fillWidth:true; Layout.preferredHeight:72; color:"#06141b"; border.color:Theme.border; radius:Theme.radius
                    Column { anchors.centerIn:parent; spacing:3
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"TRAINING / VERIFICATION"; color:Theme.cyan; font.bold:true; font.pixelSize:9; font.letterSpacing:.5 }
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"SECURE • OFFLINE"; color:Theme.green; font.family:"Consolas"; font.pixelSize:8 }
                        Text { anchors.horizontalCenter:parent.horizontalCenter; text:"NO LIVE AIRCRAFT I/O"; color:Theme.muted; font.pixelSize:7 }
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth:true; Layout.fillHeight:true; spacing:0; LayoutMirroring.enabled:cockpit.rtl; LayoutMirroring.childrenInherit:true
            Rectangle {
                Layout.fillWidth:true; Layout.preferredHeight:88; color:"#051018"; border.color:"#21343e"; border.width:1
                RowLayout { anchors.fill:parent; anchors.margins:12; spacing:12
                    ColumnLayout { Layout.fillWidth:true; spacing:1
                        Text { text:cockpit.text("app_title"); color:Theme.gold; font.pixelSize:22; font.bold:true; horizontalAlignment:cockpit.rtl?Text.AlignRight:Text.AlignLeft; Layout.fillWidth:true }
                        Text { text:cockpit.text("training")+"  /  "+cockpit.scenario; color:Theme.green; font.pixelSize:10; font.bold:true; horizontalAlignment:cockpit.rtl?Text.AlignRight:Text.AlignLeft; Layout.fillWidth:true }
                    }
                    RowLayout { spacing:4
                        MinisterialButton { text:"EXEC"; checkable:true; checked:root.workMode==="EXECUTIVE"; implicitWidth:68; onClicked:root.setWorkMode("EXECUTIVE") }
                        MinisterialButton { text:"ENG"; checkable:true; checked:root.workMode==="ENGINEERING"; implicitWidth:68; accent:Theme.cyan; onClicked:root.setWorkMode("ENGINEERING") }
                        MinisterialButton { text:"DIAG"; checkable:true; checked:root.workMode==="DIAGNOSTIC"; implicitWidth:68; accent:Theme.amber; onClicked:root.setWorkMode("DIAGNOSTIC") }
                    }
                    ColumnLayout { spacing:1
                        Text { text:"MODE"; color:Theme.muted; font.pixelSize:8 }
                        Text { text:root.workMode; color:root.workMode==="EXECUTIVE"?Theme.gold:(root.workMode==="ENGINEERING"?Theme.cyan:Theme.amber); font.family:"Consolas"; font.pixelSize:10; font.bold:true }
                    }
                    ComboBox {
                        id:scenarioBox; model:cockpit.scenarios; Layout.preferredWidth:165
                        contentItem:Text{text:scenarioBox.displayText; color:Theme.text; verticalAlignment:Text.AlignVCenter; horizontalAlignment:Text.AlignHCenter; font.pixelSize:10; font.family:"Consolas"}
                        background:Rectangle{color:Theme.panel; radius:Theme.radius; border.color:Theme.border}
                        onActivated:cockpit.setScenario(currentText)
                    }
                    ColumnLayout { spacing:1
                        Text { text:"TICK "+cockpit.tick; color:Theme.silver; font.family:"Consolas"; font.pixelSize:11; font.bold:true }
                        Text { text:"BUILD 2.0 • STAGE 1100"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                    }
                    Rectangle { Layout.preferredWidth:190; Layout.preferredHeight:42; color:"#071713"; border.color:cockpit.activeAlertCount===0?Theme.green:Theme.amber; radius:Theme.radius
                        RowLayout{anchors.fill:parent;anchors.margins:8
                            Rectangle{width:8;height:8;radius:4;color:cockpit.activeAlertCount===0?Theme.green:Theme.amber}
                            ColumnLayout{Layout.fillWidth:true;spacing:0
                                Text{text:cockpit.activeAlertCount===0?"SYSTEMS NOMINAL":"ATTENTION REQUIRED";color:cockpit.activeAlertCount===0?Theme.green:Theme.amber;font.family:"Consolas";font.pixelSize:9;font.bold:true;elide:Text.ElideRight;Layout.fillWidth:true}
                                Text{text:"ALERTS "+cockpit.activeAlertCount; color:Theme.muted;font.family:"Consolas";font.pixelSize:7}
                            }
                        }
                    }
                    MinisterialButton { text:cockpit.text("language"); implicitWidth:78; onClicked:cockpit.setLanguage(cockpit.rtl?"en":"ar") }
                }
            }

            StackLayout {
                Layout.fillWidth:true; Layout.fillHeight:true; currentIndex:root.selectedPage
                ExecutiveDashboard{}
                SystemHealthPage{}
                SensorsPage{}
                EventsPage{}
                ReplayPage{}
                TrendsPage{}
                DigitalTwinPage{}
                FaultLabPage{}
                VerificationCenter{}
            }

            Rectangle { Layout.fillWidth:true; Layout.preferredHeight:28; color:"#030b10"; border.color:"#13252e"
                RowLayout { anchors.fill:parent; anchors.margins:6
                    Text { text:"NEXVARY AVIONICS LAB  /  AEROSPACE TRAINING PLATFORM"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:7 }
                    Item { Layout.fillWidth:true }
                    Text { text:cockpit.text("simulation_only"); color:Theme.muted; font.pixelSize:8 }
                    Item { Layout.fillWidth:true }
                    Text { text:"OFFLINE  •  RUNTIME EVIDENCE  •  SYNTHETIC DATA"; color:Theme.green; font.family:"Consolas"; font.pixelSize:7 }
                }
            }
        }
    }
}
