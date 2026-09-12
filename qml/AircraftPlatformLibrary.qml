import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function currentProfile(){ for(var i=0;i<cockpit.platformProfiles.length;++i) if(cockpit.platformProfiles[i].id===cockpit.activePlatformId) return cockpit.platformProfiles[i]; return cockpit.platformProfiles.length?cockpit.platformProfiles[0]:({}) }

    ColumnLayout {
        anchors.fill:parent
        anchors.margins:10
        spacing:7

        Rectangle {
            Layout.fillWidth:true
            Layout.preferredHeight:78
            color:Theme.panel
            border.color:Theme.border
            radius:Theme.radius
            RowLayout {
                anchors.fill:parent; anchors.margins:10; spacing:10
                ColumnLayout {
                    Layout.fillWidth:true; spacing:0
                    Text { text:cockpit.rtl?"مكتبة منصات الطيران":"AIRCRAFT PLATFORM LIBRARY"; color:Theme.platinum; font.pixelSize:17; font.bold:true }
                    Text { text:cockpit.rtl?"ملفات تشغيل تدريبية متعددة المنصات مع قياسات وتوأم رقمي وتشخيص مستقل":"MULTI-PLATFORM RUNTIME PROFILES / TELEMETRY / DIGITAL TWIN / DIAGNOSTICS"; color:Theme.accent; font.pixelSize:8; font.bold:true }
                    Text { text:cockpit.rtl?"ملفات عامة للتدريب ولا تمثل بيانات مصنع أو طائرة تشغيلية":"GENERIC TRAINING PROFILES — NO OEM DATA / NO LIVE AIRCRAFT CONTROL"; color:Theme.muted; font.pixelSize:7 }
                }
                StatusCard { Layout.preferredWidth:135; Layout.fillHeight:true; title:"PROFILES"; value:String(cockpit.platformProfiles.length); subtitle:"RUNTIME TYPES"; iconText:"PL"; accent:Theme.accent }
                StatusCard { Layout.preferredWidth:175; Layout.fillHeight:true; title:"ACTIVE PROFILE"; value:Theme.platformCode(cockpit.activePlatformId); subtitle:cockpit.activePlatformCategory; iconText:"ID"; accent:Theme.green }
            }
        }

        RowLayout {
            Layout.fillWidth:true
            Layout.fillHeight:true
            spacing:7

            Rectangle {
                Layout.preferredWidth:315
                Layout.fillHeight:true
                color:Theme.panel
                border.color:Theme.border
                radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl?"ملفات التشغيل":"RUNTIME PROFILES"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }; Text { text:"4 TYPES"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 } }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    ListView {
                        Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.platformProfiles; clip:true; spacing:5
                        delegate: Rectangle {
                            required property var modelData
                            width:ListView.view.width; height:112
                            color:modelData.active?"#17252E":Theme.panel2
                            border.color:modelData.active?Theme.accent:Theme.border
                            radius:Theme.radius
                            MouseArea { anchors.fill:parent; onClicked:cockpit.setActivePlatform(modelData.id) }
                            RowLayout {
                                anchors.fill:parent; anchors.margins:8; spacing:8
                                Rectangle {
                                    Layout.preferredWidth:48; Layout.fillHeight:true; color:Theme.panel3; border.color:modelData.active?Theme.accent:Theme.border; radius:Theme.radius
                                    ColumnLayout { anchors.centerIn:parent; spacing:1; Text { text:Theme.platformCode(modelData.id); color:modelData.active?Theme.platinum:Theme.silver; font.family:"Consolas"; font.pixelSize:11; font.bold:true; Layout.alignment:Qt.AlignHCenter }; Text { text:modelData.active?"ACTIVE":"PROFILE"; color:modelData.active?Theme.green:Theme.muted; font.pixelSize:6; Layout.alignment:Qt.AlignHCenter } }
                                }
                                ColumnLayout {
                                    Layout.fillWidth:true; spacing:1
                                    Text { text:modelData.name; color:Theme.platinum; font.pixelSize:10; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:modelData.category; color:Theme.accent; font.family:"Consolas"; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Text { text:modelData.propulsion; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight }
                                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                                    Text { text:modelData.systemCount+" SYS  •  "+modelData.channelCount+" CH  •  "+modelData.diagnosticRuleCount+" RULES"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth:true
                Layout.fillHeight:true
                color:Theme.panel
                border.color:Theme.border
                radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout {
                        Layout.fillWidth:true
                        ColumnLayout { Layout.fillWidth:true; spacing:0; Text { text:page.currentProfile().name||"—"; color:Theme.platinum; font.pixelSize:16; font.bold:true }; Text { text:(page.currentProfile().category||"—")+"  /  "+(page.currentProfile().propulsion||"—"); color:Theme.accent; font.family:"Consolas"; font.pixelSize:7; font.bold:true } }
                        Rectangle { Layout.preferredWidth:140; Layout.preferredHeight:34; color:Theme.panel2; border.color:Theme.green; radius:Theme.radius; Text { anchors.centerIn:parent; text:"PROFILE ACTIVE"; color:Theme.green; font.family:"Consolas"; font.pixelSize:7; font.bold:true } }
                    }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    Item {
                        Layout.fillWidth:true; Layout.fillHeight:true
                        AircraftSchematic { anchors.centerIn:parent; width:Math.min(parent.width*.86,650); height:parent.height*.95; platformId:cockpit.activePlatformId; subsystemRows:cockpit.twinRows }
                    }
                    Rectangle {
                        Layout.fillWidth:true; Layout.preferredHeight:80; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout {
                            anchors.fill:parent; anchors.margins:7; spacing:2
                            Text { text:page.currentProfile().description||""; color:Theme.silver; font.pixelSize:7; Layout.fillWidth:true; wrapMode:Text.WordWrap; maximumLineCount:2; elide:Text.ElideRight }
                            RowLayout {
                                Layout.fillWidth:true
                                Text { text:"TWIN NODES  "+(page.currentProfile().twinNodeCount||0); color:Theme.accent; font.family:"Consolas"; font.pixelSize:6 }
                                Text { text:"FAULT PRESETS  "+(page.currentProfile().faultPresetCount||0); color:Theme.silver; font.family:"Consolas"; font.pixelSize:6 }
                                Item { Layout.fillWidth:true }
                                Text { text:"DX RULES  "+(page.currentProfile().diagnosticRuleCount||0); color:Theme.accent; font.family:"Consolas"; font.pixelSize:6 }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:335
                Layout.fillHeight:true
                color:Theme.panel
                border.color:Theme.border
                radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:5
                    Text { text:cockpit.rtl?"تعريف الملف الهندسي":"ENGINEERING PROFILE"; color:Theme.platinum; font.pixelSize:9; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }

                    Rectangle {
                        Layout.fillWidth:true; Layout.preferredHeight:155; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:3; Text { text:"SYSTEM SET"; color:Theme.accent; font.pixelSize:7; font.bold:true }; Repeater { model:page.currentProfile().systems||[]; delegate:RowLayout { required property var modelData; Layout.fillWidth:true; Rectangle { width:5;height:5;radius:2;color:Theme.green }; Text { text:modelData; color:Theme.silver; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight }; Text { text:"MON"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 } } } }
                    }

                    Rectangle {
                        Layout.fillWidth:true; Layout.preferredHeight:170; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout { anchors.fill:parent; anchors.margins:7; spacing:3; Text { text:"TELEMETRY DICTIONARY"; color:Theme.accent; font.pixelSize:7; font.bold:true }; Repeater { model:page.currentProfile().channels||[]; delegate:RowLayout { required property var modelData; Layout.fillWidth:true; Text { text:"CH"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }; Text { text:modelData; color:Theme.silver; font.family:"Consolas"; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight } } } }
                    }

                    Rectangle {
                        Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        ColumnLayout {
                            anchors.fill:parent; anchors.margins:7; spacing:3
                            Text { text:"DIAGNOSTIC / TRAINING SET"; color:Theme.accent; font.pixelSize:7; font.bold:true }
                            Repeater { model:page.currentProfile().diagnosticFamilies||[]; delegate:RowLayout { required property var modelData; Layout.fillWidth:true; Text { text:"DX"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:6; font.bold:true }; Text { text:modelData; color:Theme.silver; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight } } }
                            Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                            Repeater { model:page.currentProfile().trainingScenarios||[]; delegate:RowLayout { required property int index; required property var modelData; Layout.fillWidth:true; Text { text:"S"+(index+1); color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }; Text { text:modelData; color:Theme.silver; font.pixelSize:7; Layout.fillWidth:true; elide:Text.ElideRight } } }
                            Item { Layout.fillHeight:true }
                            Text { text:cockpit.rtl?"تغيير الملف يعيد تهيئة المحاكاة ويفصل سجل التشخيص":"PROFILE SWITCH RESETS SYNTHETIC SESSION AND ISOLATES DIAGNOSTIC HISTORY"; color:Theme.muted; font.pixelSize:6; wrapMode:Text.WordWrap; Layout.fillWidth:true }
                        }
                    }
                }
            }
        }
    }
}
