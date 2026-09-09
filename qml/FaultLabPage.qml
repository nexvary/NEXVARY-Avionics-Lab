import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme
Item {
    ColumnLayout { anchors.fill:parent; anchors.margins:18; spacing:14
        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:82; radius:10; color:"#0a151a"; border.color:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.green
            RowLayout { anchors.fill:parent; anchors.margins:16
                NavIcon { kind:"fault"; iconColor:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.green; Layout.preferredWidth:30; Layout.preferredHeight:30 }
                ColumnLayout { Layout.fillWidth:true
                    Text { text:cockpit.text("fault_lab"); color:Theme.gold; font.pixelSize:20; font.bold:true }
                    Text { text:cockpit.text("fault_lab_notice"); color:Theme.text; wrapMode:Text.Wrap; Layout.fillWidth:true }
                }
                Text { text:cockpit.activeTrainingFaultCount+" "+cockpit.text("active_training_faults"); color:cockpit.activeTrainingFaultCount>0?Theme.amber:Theme.green; font.bold:true }
                MinisterialButton { text:cockpit.text("clear_faults"); enabled:cockpit.activeTrainingFaultCount>0; onClicked:cockpit.clearTrainingFaults() }
            }
        }
        GridLayout { Layout.fillWidth:true; Layout.preferredHeight:250; columns:3; columnSpacing:12; rowSpacing:12
            Repeater { model:cockpit.presentationFaultPresets
                delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; radius:10; color:Theme.panel; border.color:modelData.active?Theme.amber:Theme.border; border.width:modelData.active?2:1
                    ColumnLayout { anchors.fill:parent; anchors.margins:16; spacing:8
                        Text { text:modelData.label; color:Theme.gold; font.pixelSize:18; font.bold:true; wrapMode:Text.Wrap; Layout.fillWidth:true }
                        Text { text:modelData.detail; color:Theme.text; wrapMode:Text.Wrap; Layout.fillWidth:true; Layout.fillHeight:true }
                        Text { text:modelData.sensor+"  •  "+modelData.mode; color:Theme.cyan; font.pixelSize:11 }
                        MinisterialButton { Layout.fillWidth:true; text:modelData.active?cockpit.text("active"):cockpit.text("apply_fault"); checked:modelData.active; enabled:!modelData.active; onClicked:cockpit.applyTrainingFault(modelData.id) }
                    }
                }
            }
        }
        Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; radius:10; color:Theme.panel; border.color:Theme.border
            ColumnLayout { anchors.fill:parent; anchors.margins:14
                Text { text:cockpit.text("recent_events"); color:Theme.gold; font.bold:true; font.pixelSize:16 }
                ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.eventRows; clip:true; spacing:4
                    delegate: Rectangle { required property var modelData; width:ListView.view.width; height:38; color:index%2?"#07141b":"#091820"
                        RowLayout { anchors.fill:parent; anchors.margins:7
                            Text { text:modelData.severity; color:Theme.amber; Layout.preferredWidth:70 }
                            Text { text:modelData.source; color:Theme.cyan; Layout.preferredWidth:110 }
                            Text { text:modelData.message; color:Theme.text; Layout.fillWidth:true; elide:Text.ElideRight }
                        }
                    }
                }
            }
        }
    }
}
