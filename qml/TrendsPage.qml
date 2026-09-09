import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function colorFor(i){ return [Theme.cyan,Theme.gold,Theme.green,"#b98cff"][i%4] }

    ColumnLayout {
        anchors.fill:parent; anchors.margins:12; spacing:8
        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:58; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout { anchors.fill:parent; anchors.margins:10
                ColumnLayout { Layout.fillWidth:true; spacing:1
                    Text { text:cockpit.rtl?"منضدة تحليل القياسات":"TELEMETRY WORKBENCH"; color:Theme.gold; font.pixelSize:18; font.bold:true }
                    Text { text:cockpit.rtl?"عرض حي ومتزامن مع الإعادة والأحداث":"LIVE / REPLAY-SYNCHRONIZED ENGINEERING DATA"; color:Theme.muted; font.pixelSize:9; font.letterSpacing:.5 }
                }
                Text { text:"WINDOW"; color:Theme.muted; font.pixelSize:9 }
                ComboBox {
                    id:w; model:[20,60,120,0]; currentIndex:1; Layout.preferredWidth:100
                    onActivated: cockpit.setTrendWindow(Number(currentText))
                    contentItem:Text{text:w.displayText; color:Theme.text; verticalAlignment:Text.AlignVCenter; horizontalAlignment:Text.AlignHCenter; font.family:"Consolas"}
                    background:Rectangle{color:Theme.panel2; radius:Theme.radius; border.color:Theme.border}
                }
                Text { text:"FRAMES "+cockpit.recordedFrames; color:Theme.cyan; font.family:"Consolas"; font.pixelSize:11 }
            }
        }

        RowLayout { Layout.fillWidth:true; Layout.fillHeight:true; spacing:8
            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:5
                    RowLayout { Layout.fillWidth:true
                        Text { text:"MULTI-CHANNEL TREND"; color:Theme.silver; font.pixelSize:10; font.bold:true; Layout.fillWidth:true; font.letterSpacing:.6 }
                        Repeater { model:cockpit.performanceSeries
                            delegate: RowLayout { required property int index; required property var modelData; spacing:4
                                Rectangle { width:10; height:2; color:page.colorFor(index) }
                                Text { text:modelData.label; color:Theme.muted; font.pixelSize:8 }
                            }
                        }
                    }
                    TelemetryPlot { Layout.fillWidth:true; Layout.fillHeight:true; series:cockpit.performanceSeries }
                    RowLayout { Layout.fillWidth:true
                        Text { text:"T-"+cockpit.trendWindow; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                        Item { Layout.fillWidth:true }
                        Text { text:"CURSOR / LIVE"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:8 }
                        Item { Layout.fillWidth:true }
                        Text { text:"T0"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:455; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout { anchors.fill:parent; anchors.margins:9; spacing:4
                    RowLayout { Layout.fillWidth:true
                        Text { text:cockpit.rtl?"قنوات القياس":"CHANNEL MATRIX"; color:Theme.gold; font.pixelSize:13; font.bold:true; Layout.fillWidth:true }
                        Text { text:"QUALITY"; color:Theme.muted; font.pixelSize:8 }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.border }
                    ListView {
                        Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.trendRows; clip:true; spacing:1
                        delegate: Rectangle {
                            required property int index; required property var modelData
                            width:ListView.view.width; height:50; color:index%2?"#071219":"#09171e"
                            RowLayout { anchors.fill:parent; anchors.margins:7; spacing:7
                                Rectangle { width:3; height:28; color:modelData.quality>=99?Theme.green:(modelData.quality>=90?Theme.amber:Theme.red) }
                                ColumnLayout { Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.label; color:Theme.text; font.pixelSize:9; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:"MIN "+Number(modelData.minimum).toFixed(2)+"  AVG "+Number(modelData.mean).toFixed(2)+"  MAX "+Number(modelData.maximum).toFixed(2); color:Theme.muted; font.family:"Consolas"; font.pixelSize:8 }
                                }
                                ColumnLayout { Layout.preferredWidth:92; spacing:0
                                    Text { text:Number(modelData.latest).toFixed(2); color:Theme.cyan; font.family:"Consolas"; font.pixelSize:13; font.bold:true; Layout.alignment:Qt.AlignRight }
                                    Text { text:Number(modelData.quality).toFixed(1)+"%"; color:modelData.quality>=99?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:9; Layout.alignment:Qt.AlignRight }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
