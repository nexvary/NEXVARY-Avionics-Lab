import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function observed(){ return cockpit.activeAlertCount>0 || cockpit.twinFaultCount>0 || cockpit.twinDegradedCount>0 }
    function recovered(){ return cockpit.activeTrainingFaultCount===0 && cockpit.eventCount>1 }
    function verified(){ return page.recovered() && cockpit.activeAlertCount===0 && cockpit.twinFaultCount===0 }

    ColumnLayout {
        anchors.fill:parent; anchors.margins:10; spacing:7

        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:76; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout {
                anchors.fill:parent; anchors.margins:9; spacing:8
                Rectangle { width:42; height:42; color:Theme.panel3; border.color:Theme.accent; radius:Theme.radius; NavIcon { anchors.centerIn:parent; width:24; height:24; kind:"fault"; iconColor:Theme.platinum } }
                ColumnLayout {
                    Layout.fillWidth:true; spacing:0
                    Text { text:cockpit.rtl?"منصة اختبار الأعطال والاستجابة":"FAULT INJECTION & RESPONSE WORKBENCH"; color:Theme.platinum; font.pixelSize:16; font.bold:true }
                    Text { text:cockpit.activePlatformName.toUpperCase()+"  /  CONTROLLED SYNTHETIC FAULT CAMPAIGN"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                    Text { text:cockpit.rtl?"تجهيز • حقن • ملاحظة • استعادة • تحقق — دون مسار تحكم حقيقي":"ARM / INJECT / OBSERVE / RECOVER / VERIFY — NO LIVE HARDWARE COMMAND PATH"; color:Theme.muted; font.pixelSize:7 }
                }
                StatusCard { Layout.preferredWidth:135; Layout.fillHeight:true; title:"ACTIVE"; value:String(cockpit.activeTrainingFaultCount); subtitle:"TRAINING FAULTS"; iconText:"FLT"; accent:cockpit.activeTrainingFaultCount?Theme.amber:Theme.green }
                StatusCard { Layout.preferredWidth:135; Layout.fillHeight:true; title:"TWIN STATE"; value:cockpit.twinFaultCount?"FAULT":"SYNC"; subtitle:cockpit.twinDegradedCount+" DEGRADED"; iconText:"TWN"; accent:cockpit.twinFaultCount?Theme.red:Theme.accent }
                MinisterialButton { text:cockpit.text("clear_faults"); enabled:cockpit.activeTrainingFaultCount>0; accent:Theme.amber; implicitWidth:120; onClicked:cockpit.clearTrainingFaults() }
            }
        }

        GridLayout {
            Layout.fillWidth:true; Layout.preferredHeight:56; columns:5; columnSpacing:5
            Repeater {
                model:[
                    {"n":"01","t":"ARM","ok":true},
                    {"n":"02","t":"INJECT","ok":cockpit.activeTrainingFaultCount>0},
                    {"n":"03","t":"OBSERVE","ok":page.observed()},
                    {"n":"04","t":"RECOVER","ok":page.recovered()},
                    {"n":"05","t":"VERIFY","ok":page.verified()}
                ]
                delegate:Rectangle {
                    required property var modelData
                    Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel2; border.color:modelData.ok?Theme.accent:Theme.border; radius:Theme.radius
                    RowLayout {
                        anchors.fill:parent; anchors.margins:6
                        Text { text:modelData.n; color:modelData.ok?Theme.accent:Theme.muted; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                        Rectangle { width:1; Layout.fillHeight:true; color:Theme.borderSoft }
                        ColumnLayout { Layout.fillWidth:true; spacing:0; Text { text:modelData.t; color:modelData.ok?Theme.platinum:Theme.silver; font.family:"Consolas"; font.pixelSize:8; font.bold:true }; Text { text:modelData.ok?"COMPLETE":"WAITING"; color:modelData.ok?Theme.green:Theme.muted; font.family:"Consolas"; font.pixelSize:6 } }
                        Rectangle { width:7; height:7; radius:3; color:modelData.ok?Theme.green:Theme.muted }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth:true; Layout.fillHeight:true; spacing:7

            Rectangle {
                Layout.preferredWidth:330; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl?"مكتبة شروط الاختبار":"TEST CONDITION LIBRARY"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }; Text { text:cockpit.presentationFaultPresets.length+" PRESETS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 } }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    ListView {
                        Layout.fillWidth:true; Layout.fillHeight:true; model:cockpit.presentationFaultPresets; clip:true; spacing:4
                        delegate:Rectangle {
                            required property int index; required property var modelData
                            width:ListView.view.width; height:88; color:index%2?Theme.panel2:Theme.panel; border.color:modelData.active?Theme.amber:Theme.border; radius:Theme.radius
                            ColumnLayout {
                                anchors.fill:parent; anchors.margins:6; spacing:2
                                RowLayout { Layout.fillWidth:true; Rectangle { width:3; height:24; color:modelData.active?Theme.amber:Theme.accent }; ColumnLayout { Layout.fillWidth:true; spacing:0; Text { text:modelData.label.toUpperCase(); color:Theme.platinum; font.pixelSize:7; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }; Text { text:modelData.sensor+" / "+modelData.mode; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 } }; Text { text:modelData.active?"INJECTED":"READY"; color:modelData.active?Theme.amber:Theme.silver; font.family:"Consolas"; font.pixelSize:6; font.bold:true } }
                                MinisterialButton { Layout.fillWidth:true; implicitHeight:25; text:modelData.active?cockpit.text("active"):cockpit.text("apply_fault"); enabled:!modelData.active; checked:modelData.active; accent:Theme.accent; onClicked:cockpit.applyTrainingFault(modelData.id) }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl?"الأدلة والاستجابة الزمنية":"LIVE EVIDENCE & RESPONSE"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }; Text { text:"EVENTS "+cockpit.eventCount+" / FRAMES "+cockpit.recordedFrames; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 } }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    GridLayout {
                        Layout.fillWidth:true; Layout.preferredHeight:62; columns:4; columnSpacing:4
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"ALERTS"; value:String(cockpit.activeAlertCount); accent:cockpit.activeAlertCount?Theme.amber:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"TWIN FAULTS"; value:String(cockpit.twinFaultCount); accent:cockpit.twinFaultCount?Theme.red:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"DEGRADED"; value:String(cockpit.twinDegradedCount); accent:cockpit.twinDegradedCount?Theme.amber:Theme.accent }
                        MetricBox { Layout.fillWidth:true; Layout.fillHeight:true; label:"DX SCORE"; value:String(cockpit.diagnosticHealthScore); accent:Theme.accent }
                    }
                    Text { text:"EVENT TIMELINE / CORRELATION"; color:Theme.silver; font.pixelSize:7; font.bold:true }
                    ListView {
                        Layout.fillWidth:true; Layout.preferredHeight:115; model:cockpit.eventRows; clip:true; spacing:1
                        delegate:Rectangle {
                            required property int index; required property var modelData
                            width:ListView.view.width; height:28; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:4; Text { text:modelData.time; color:Theme.muted; Layout.preferredWidth:66; font.family:"Consolas"; font.pixelSize:6 }; Text { text:modelData.severity; color:modelData.severity==="FAULT"?Theme.red:(modelData.severity==="WARN"?Theme.amber:Theme.silver); Layout.preferredWidth:44; font.family:"Consolas"; font.pixelSize:6; font.bold:true }; Text { text:modelData.source; color:Theme.accent; Layout.preferredWidth:52; font.family:"Consolas"; font.pixelSize:6 }; Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:6 } }
                        }
                    }
                    RowLayout { Layout.fillWidth:true; Text { text:"LIVE RESPONSE CHANNELS"; color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true }; Text { text:cockpit.sensorCount+" CHANNELS"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 } }
                    GridLayout {
                        Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:4; rowSpacing:4
                        Repeater {
                            model:cockpit.sensorRows
                            delegate:Rectangle {
                                required property var modelData
                                Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:38; color:Theme.panel2; border.color:Theme.borderSoft; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:5; Rectangle { width:3; height:20; color:modelData.valid?Theme.accent:Theme.red }; ColumnLayout { Layout.fillWidth:true; spacing:0; Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight }; Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.platinum:Theme.red; font.family:"Consolas"; font.pixelSize:8; font.bold:true } }; Text { text:modelData.valid?"VALID":"FAULT"; color:modelData.valid?Theme.silver:Theme.red; font.family:"Consolas"; font.pixelSize:6 } }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:290; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    Text { text:cockpit.rtl?"مصفوفة استجابة الأنظمة":"SYSTEM RESPONSE MATRIX"; color:Theme.platinum; font.pixelSize:9; font.bold:true }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    Repeater {
                        model:cockpit.twinRows
                        delegate:Rectangle {
                            required property int index; required property var modelData
                            Layout.fillWidth:true; Layout.minimumHeight:47; Layout.preferredHeight:47; color:index%2?Theme.panel2:Theme.panel; border.color:Theme.borderSoft; radius:Theme.radius
                            RowLayout { anchors.fill:parent; anchors.margins:5; Rectangle { width:3; height:24; color:Theme.stateColor(modelData.state) }; ColumnLayout { Layout.fillWidth:true; spacing:0; Text { text:modelData.label; color:Theme.platinum; font.pixelSize:7; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }; Text { text:"CH "+modelData.valid+"/"+modelData.expected+" / ISS "+modelData.issues; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 } }; Text { text:Number(modelData.health).toFixed(0)+"%"; color:Theme.stateColor(modelData.state); font.family:"Consolas"; font.pixelSize:8; font.bold:true } }
                        }
                    }
                    Item { Layout.fillHeight:true }
                    Rectangle {
                        Layout.fillWidth:true; Layout.preferredHeight:122; color:Theme.panel2; border.color:page.verified()?Theme.green:Theme.border; radius:Theme.radius
                        ColumnLayout {
                            anchors.fill:parent; anchors.margins:7; spacing:3
                            Text { text:"RECOVERY / RELEASE CRITERIA"; color:Theme.platinum; font.pixelSize:7; font.bold:true }
                            Repeater { model:[{"t":"0 ACTIVE FAULTS","ok":cockpit.activeTrainingFaultCount===0},{"t":"0 TWIN FAULTS","ok":cockpit.twinFaultCount===0},{"t":"0 ALERTS","ok":cockpit.activeAlertCount===0},{"t":"EVIDENCE RECORDED","ok":cockpit.recordedFrames>0}]; delegate:RowLayout { required property var modelData; Layout.fillWidth:true; Rectangle { width:6;height:6;radius:3;color:modelData.ok?Theme.green:Theme.muted }; Text { text:modelData.t; color:modelData.ok?Theme.silver:Theme.muted; font.family:"Consolas"; font.pixelSize:6; Layout.fillWidth:true } } }
                            Item { Layout.fillHeight:true }
                            Text { text:page.verified()?"VERIFIED / RECOVERED":"PROTOCOL IN PROGRESS"; color:page.verified()?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:7; font.bold:true }
                        }
                    }
                }
            }
        }
    }
}
