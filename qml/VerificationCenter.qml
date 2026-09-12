import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    function validSensors(){ var n=0; for(var i=0;i<cockpit.sensorRows.length;++i) if(cockpit.sensorRows[i].valid)++n; return n }
    function checks(){ return [
        {"name":cockpit.rtl?"سلامة القياسات":"TELEMETRY VALIDITY","pass":page.validSensors()===cockpit.sensorCount&&cockpit.sensorCount>0,"evidence":page.validSensors()+" / "+cockpit.sensorCount+" VALID","code":"TEL"},
        {"name":cockpit.rtl?"اتساق التوأم الرقمي":"DIGITAL TWIN CONSISTENCY","pass":cockpit.twinFaultCount===0,"evidence":"FAULTS "+cockpit.twinFaultCount+" / DEG "+cockpit.twinDegradedCount,"code":"TWN"},
        {"name":cockpit.rtl?"حالة التنبيهات":"ALERT STATE","pass":cockpit.activeAlertCount===0,"evidence":"ACTIVE "+cockpit.activeAlertCount,"code":"ALT"},
        {"name":cockpit.rtl?"مسجل الجلسة":"SESSION RECORDER","pass":cockpit.recordedFrames>10,"evidence":"FRAMES "+cockpit.recordedFrames,"code":"REC"},
        {"name":cockpit.rtl?"تشغيل السيناريو":"SCENARIO PIPELINE","pass":cockpit.tick>0,"evidence":"TICK "+cockpit.tick+" / "+cockpit.scenario,"code":"SCN"},
        {"name":cockpit.rtl?"حالة مختبر الأعطال":"FAULT LAB STATE","pass":cockpit.activeTrainingFaultCount===0,"evidence":"ACTIVE "+cockpit.activeTrainingFaultCount,"code":"FLT"}
    ] }
    function passCount(){ var a=checks(),n=0; for(var i=0;i<a.length;++i)if(a[i].pass)++n; return n }
    function ratio(){ return Math.round(passCount()*100/6) }

    ColumnLayout {
        anchors.fill:parent; anchors.margins:10; spacing:7

        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:78; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
            RowLayout {
                anchors.fill:parent; anchors.margins:9; spacing:7
                ColumnLayout {
                    Layout.fillWidth:true; spacing:0
                    Text { text:cockpit.rtl?"مركز التحقق وضمان التشغيل":"VERIFICATION & RUNTIME ASSURANCE CENTER"; color:Theme.platinum; font.pixelSize:16; font.bold:true }
                    Text { text:cockpit.activePlatformName.toUpperCase()+"  /  TRACEABLE EVIDENCE CHAIN"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:8; font.bold:true }
                    Text { text:cockpit.rtl?"أدلة تشغيل للمحاكاة والتدريب — ليست شهادة اعتماد طيران":"SIMULATION / TRAINING ASSURANCE EVIDENCE — NOT AIRWORTHINESS CERTIFICATION"; color:Theme.muted; font.pixelSize:7 }
                }
                StatusCard { Layout.preferredWidth:140; Layout.fillHeight:true; title:"GATES"; value:passCount()+" / 6"; subtitle:"RUNTIME CHECKS"; iconText:"G"; accent:passCount()===6?Theme.green:Theme.amber }
                StatusCard { Layout.preferredWidth:140; Layout.fillHeight:true; title:"SCORE"; value:ratio()+"%"; subtitle:passCount()===6?"ASSURED":"REVIEW"; iconText:"V"; accent:passCount()===6?Theme.green:Theme.amber }
                StatusCard { Layout.preferredWidth:150; Layout.fillHeight:true; title:"EVIDENCE"; value:String(cockpit.recordedFrames); subtitle:cockpit.eventCount+" EVENTS"; iconText:"E"; accent:Theme.accent }
            }
        }

        RowLayout {
            Layout.fillWidth:true; Layout.fillHeight:true; spacing:7

            Rectangle {
                Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:5
                    RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl?"بوابات ضمان التشغيل":"RUNTIME ASSURANCE GATES"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }; Text { text:"6 GATES / LIVE"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 } }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    GridLayout {
                        Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:6; rowSpacing:6
                        Repeater {
                            model:checks()
                            delegate:Rectangle {
                                required property int index; required property var modelData
                                Layout.fillWidth:true; Layout.fillHeight:true; color:index%2?Theme.panel2:Theme.panel; border.color:modelData.pass?Theme.border:Theme.amber; radius:Theme.radius
                                RowLayout {
                                    anchors.fill:parent; anchors.margins:8; spacing:7
                                    Rectangle { width:40; height:40; color:Theme.panel3; border.color:modelData.pass?Theme.accent:Theme.amber; radius:Theme.radius; Text { anchors.centerIn:parent; text:modelData.code; color:modelData.pass?Theme.platinum:Theme.amber; font.family:"Consolas"; font.pixelSize:8; font.bold:true } }
                                    ColumnLayout {
                                        Layout.fillWidth:true; spacing:2
                                        Text { text:modelData.name; color:Theme.platinum; font.pixelSize:8; font.bold:true; Layout.fillWidth:true; elide:Text.ElideRight }
                                        Text { text:modelData.evidence; color:Theme.silver; font.family:"Consolas"; font.pixelSize:7 }
                                        Rectangle { Layout.fillWidth:true; height:3; color:Theme.borderSoft; Rectangle { width:modelData.pass?parent.width:parent.width*.35; height:parent.height; color:modelData.pass?Theme.accent:Theme.amber } }
                                    }
                                    ColumnLayout { spacing:0; Text { text:modelData.pass?"PASS":"CHECK"; color:modelData.pass?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:7; font.bold:true }; Text { text:modelData.pass?"100%":"OPEN"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 } }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth:510; Layout.fillHeight:true; color:Theme.panel; border.color:Theme.border; radius:Theme.radius
                ColumnLayout {
                    anchors.fill:parent; anchors.margins:8; spacing:4
                    RowLayout { Layout.fillWidth:true; Text { text:cockpit.rtl?"سلسلة الأدلة":"EVIDENCE CHAIN"; color:Theme.platinum; font.pixelSize:9; font.bold:true; Layout.fillWidth:true }; Text { text:page.validSensors()+" / "+cockpit.sensorCount+" VALID"; color:Theme.accent; font.family:"Consolas"; font.pixelSize:7 } }
                    Rectangle { Layout.fillWidth:true; height:1; color:Theme.borderSoft }
                    Rectangle {
                        Layout.fillWidth:true; Layout.preferredHeight:48; color:Theme.panel2; border.color:Theme.border; radius:Theme.radius
                        RowLayout { anchors.fill:parent; anchors.margins:7; Text { text:"SCENARIO"; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6 }; Text { text:"→"; color:Theme.accent }; Text { text:"TELEMETRY"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:6 }; Text { text:"→"; color:Theme.accent }; Text { text:"HEALTH"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:6 }; Text { text:"→"; color:Theme.accent }; Text { text:"DIAGNOSTIC"; color:Theme.silver; font.family:"Consolas"; font.pixelSize:6 }; Text { text:"→"; color:Theme.accent }; Text { text:"REPORT"; color:Theme.platinum; font.family:"Consolas"; font.pixelSize:6; font.bold:true } }
                    }
                    Text { text:"CHANNEL EVIDENCE"; color:Theme.silver; font.pixelSize:7; font.bold:true }
                    GridLayout {
                        Layout.fillWidth:true; Layout.fillHeight:true; columns:2; columnSpacing:4; rowSpacing:4
                        Repeater {
                            model:cockpit.sensorRows
                            delegate:Rectangle {
                                required property var modelData
                                Layout.fillWidth:true; Layout.fillHeight:true; Layout.minimumHeight:38; color:Theme.panel2; border.color:Theme.borderSoft; radius:Theme.radius
                                RowLayout { anchors.fill:parent; anchors.margins:5; Rectangle { width:3; height:20; color:modelData.valid?Theme.accent:Theme.red }; ColumnLayout { Layout.fillWidth:true; spacing:0; Text { text:modelData.id; color:Theme.muted; font.family:"Consolas"; font.pixelSize:6; Layout.fillWidth:true; elide:Text.ElideRight }; Text { text:Number(modelData.value).toFixed(1)+" "+modelData.unit; color:modelData.valid?Theme.platinum:Theme.red; font.family:"Consolas"; font.pixelSize:8; font.bold:true } }; Text { text:modelData.valid?"PASS":"FAIL"; color:modelData.valid?Theme.green:Theme.red; font.family:"Consolas"; font.pixelSize:6 } }
                            }
                        }
                    }
                    Text { text:"RECENT EVIDENCE EVENTS"; color:Theme.silver; font.pixelSize:7; font.bold:true }
                    ListView {
                        Layout.fillWidth:true; Layout.preferredHeight:96; model:cockpit.eventRows; clip:true; spacing:1
                        delegate:Rectangle {
                            required property int index; required property var modelData
                            width:ListView.view.width; height:28; color:index%2?Theme.panel2:Theme.panel
                            RowLayout { anchors.fill:parent; anchors.margins:4; Text { text:modelData.time; color:Theme.muted; Layout.preferredWidth:66; font.family:"Consolas"; font.pixelSize:6 }; Text { text:modelData.source; color:Theme.accent; Layout.preferredWidth:50; font.family:"Consolas"; font.pixelSize:6 }; Text { text:modelData.message; color:Theme.silver; Layout.fillWidth:true; elide:Text.ElideRight; font.pixelSize:6 } }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth:true; Layout.preferredHeight:80; color:Theme.panel; border.color:passCount()===6?Theme.accent:Theme.amber; radius:Theme.radius
            RowLayout {
                anchors.fill:parent; anchors.margins:8; spacing:6
                Repeater {
                    model:[
                        {"k":"PROFILE","v":Theme.platformCode(cockpit.activePlatformId)},
                        {"k":"VALID CH","v":validSensors()+"/"+cockpit.sensorCount},
                        {"k":"TWIN","v":cockpit.twinFaultCount===0?"SYNC":"FAULT"},
                        {"k":"ALERTS","v":String(cockpit.activeAlertCount)},
                        {"k":"FRAMES","v":String(cockpit.recordedFrames)},
                        {"k":"DX SCORE","v":String(cockpit.diagnosticHealthScore)}
                    ]
                    delegate:Rectangle {
                        required property var modelData
                        Layout.fillWidth:true; Layout.fillHeight:true; color:Theme.panel2; border.color:Theme.borderSoft; radius:Theme.radius
                        ColumnLayout { anchors.centerIn:parent; spacing:1; Text { text:modelData.k; color:Theme.muted; font.pixelSize:6; Layout.alignment:Qt.AlignHCenter }; Text { text:modelData.v; color:Theme.platinum; font.family:"Consolas"; font.pixelSize:11; font.bold:true; Layout.alignment:Qt.AlignHCenter } }
                    }
                }
                Rectangle { width:1; Layout.fillHeight:true; color:Theme.borderSoft }
                ColumnLayout { Layout.preferredWidth:170; spacing:1; Text { text:passCount()===6?"ASSURANCE SATISFIED":"REVIEW REQUIRED"; color:passCount()===6?Theme.green:Theme.amber; font.family:"Consolas"; font.pixelSize:7; font.bold:true }; Text { text:"TRAINING EVIDENCE ONLY"; color:Theme.muted; font.pixelSize:6 } }
            }
        }
    }
}
