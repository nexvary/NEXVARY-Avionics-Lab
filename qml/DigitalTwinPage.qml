import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme
Item {
    RowLayout { anchors.fill:parent; anchors.margins:18; spacing:14
        Rectangle { Layout.fillWidth:true; Layout.fillHeight:true; radius:12; color:Theme.panel; border.color:Theme.gold
            ColumnLayout { anchors.fill:parent; anchors.margins:16
                Text { text:cockpit.text("digital_twin_aircraft"); color:Theme.gold; font.pixelSize:24; font.bold:true }
                Item { Layout.fillWidth:true; Layout.fillHeight:true
                    AircraftSchematic { anchors.centerIn:parent; width:parent.width*.7; height:parent.height*.86 }
                }
            }
        }
        GridLayout { Layout.preferredWidth:560; Layout.fillHeight:true; columns:1; rowSpacing:10
            Repeater { model:cockpit.twinRows
                delegate: Rectangle { required property var modelData; Layout.fillWidth:true; Layout.fillHeight:true; radius:10; color:Theme.panel; border.width:2; border.color:Theme.stateColor(modelData.state)
                    RowLayout { anchors.fill:parent; anchors.margins:16
                        ColumnLayout { Layout.fillWidth:true
                            Text { text:modelData.label; color:Theme.gold; font.pixelSize:18; font.bold:true }
                            Text { text:modelData.state; color:Theme.stateColor(modelData.state); font.pixelSize:22; font.bold:true }
                        }
                        ColumnLayout { Layout.preferredWidth:230
                            ProgressBar { Layout.fillWidth:true; from:0; to:100; value:modelData.health }
                            Text { text:cockpit.text("health")+": "+Number(modelData.health).toFixed(0)+"%   •   "+cockpit.text("issues")+": "+modelData.issues; color:Theme.text }
                        }
                    }
                }
            }
        }
    }
}
