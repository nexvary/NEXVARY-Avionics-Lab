import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
Item {
    ColumnLayout { anchors.fill:parent; anchors.margins:18; spacing:10
        RowLayout { Layout.fillWidth:true
            Text { text:cockpit.text("trends"); color:Theme.gold; font.pixelSize:24; font.bold:true; Layout.fillWidth:true }
            Text { text:cockpit.text("window"); color:Theme.muted }
            ComboBox {
                id:w
                model:[20,60,120,0]
                currentIndex:1
                Layout.preferredWidth:110
                onActivated: cockpit.setTrendWindow(Number(currentText))
                contentItem: Text {
                    text:w.displayText
                    color:Theme.text
                    verticalAlignment:Text.AlignVCenter
                    horizontalAlignment:Text.AlignHCenter
                }
                background: Rectangle { color:Theme.panel; radius:6; border.color:Theme.border }
            }
        }
        Rectangle { Layout.fillWidth:true; Layout.preferredHeight:245; radius:10; color:Theme.panel; border.color:Theme.border
            PerformancePanel { anchors.fill:parent }
        }
        ListView { Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.trendRows; clip:true; spacing:6
            delegate: Rectangle { required property var modelData; width:ListView.view.width; height:62; radius:7; color:Theme.panel; border.color:modelData.quality>=99?Theme.green:(modelData.quality>=90?Theme.amber:Theme.red)
                RowLayout { anchors.fill:parent; anchors.margins:10
                    Text { text:modelData.label; color:Theme.gold; Layout.fillWidth:true; font.bold:true }
                    Text { text:"LATEST "+Number(modelData.latest).toFixed(2); color:Theme.cyan; Layout.preferredWidth:130 }
                    Text { text:"MEAN "+Number(modelData.mean).toFixed(2); color:Theme.text; Layout.preferredWidth:130 }
                    Text { text:"MIN "+Number(modelData.minimum).toFixed(2); color:Theme.text; Layout.preferredWidth:110 }
                    Text { text:"MAX "+Number(modelData.maximum).toFixed(2); color:Theme.text; Layout.preferredWidth:110 }
                    Text { text:Number(modelData.quality).toFixed(1)+"%"; color:modelData.quality>=99?Theme.green:Theme.amber; Layout.preferredWidth:80; font.bold:true }
                }
            }
        }
    }
}
