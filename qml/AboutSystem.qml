import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page

    property var featureCards: [
        {"code":"DT", "en":"DIGITAL TWIN", "ar":"التوأم الرقمي", "descEn":"Platform-specific synthetic system model with health, topology and state correlation.", "descAr":"نموذج رقمي صناعي خاص بكل منصة يربط الحالة والصحة والطوبولوجيا الهندسية."},
        {"code":"TM", "en":"TELEMETRY + REPLAY", "ar":"القياسات وإعادة التشغيل", "descEn":"Time-correlated telemetry capture, trend analysis, archive and deterministic replay.", "descAr":"تسجيل القياسات زمنيًا وتحليل الاتجاهات وحفظ الجلسات وإعادة تشغيلها بصورة حتمية."},
        {"code":"FL", "en":"FAULT LAB", "ar":"مختبر الأعطال", "descEn":"Controlled synthetic fault injection with recovery and verification workflows.", "descAr":"إدخال أعطال تدريبية صناعية بصورة محكومة مع الاستعادة والتحقق بعد الإصلاح."},
        {"code":"DX", "en":"DIAGNOSTIC INTELLIGENCE", "ar":"الذكاء التشخيصي", "descEn":"Evidence correlation, confidence scoring, priority ranking and root-cause guidance.", "descAr":"ربط الأدلة ودرجة الثقة وترتيب الأولوية وتوجيه تحليل السبب الجذري."},
        {"code":"VR", "en":"VERIFICATION CENTER", "ar":"مركز التحقق", "descEn":"Release, evidence, recovery and session-integrity verification in one workspace.", "descAr":"التحقق من الإصدار والأدلة والاستعادة وسلامة الجلسة داخل مساحة عمل واحدة."},
        {"code":"PL", "en":"MULTI-PLATFORM LIBRARY", "ar":"مكتبة متعددة المنصات", "descEn":"Generic Jet, Turboprop, Helicopter and UAV profiles share one engineering framework.", "descAr":"ملفات تدريبية للطائرة النفاثة والتوربينية والمروحية والطائرة غير المأهولة على محرك هندسي واحد."},
        {"code":"EV", "en":"EVIDENCE CHAIN", "ar":"سلسلة الأدلة", "descEn":"Events, findings, history, recurrence and report fingerprints remain traceable.", "descAr":"ربط الأحداث والنتائج والتاريخ والتكرار وبصمة التقرير داخل سلسلة قابلة للمراجعة."},
        {"code":"RP", "en":"ENGINEERING REPORTING", "ar":"التقارير الهندسية", "descEn":"Structured diagnostic output for technical review, comparison and case follow-up.", "descAr":"مخرجات تشخيص منظمة للمراجعة الفنية والمقارنة ومتابعة الحالة الهندسية."}
    ]

    property var comparisonCards: [
        {"titleEn":"TRADITIONAL FLIGHT SIMULATOR", "titleAr":"محاكي طيران تقليدي", "bodyEn":"Primarily focuses on pilot interaction, flight dynamics and cockpit experience.", "bodyAr":"يركز أساسًا على تجربة الطيار وديناميكا الطيران والتفاعل مع قمرة القيادة."},
        {"titleEn":"MAINTENANCE / DIAGNOSTIC TOOL", "titleAr":"أداة صيانة أو تشخيص", "bodyEn":"Usually focuses on fault codes, maintenance procedures or one equipment family.", "bodyAr":"تركز عادة على أكواد الأعطال وإجراءات الصيانة أو عائلة محددة من المعدات."},
        {"titleEn":"DIGITAL-TWIN / DATA TOOL", "titleAr":"أداة توأم رقمي أو بيانات", "bodyEn":"Often focuses on modelling or analytics without an integrated fault-to-verification workflow.", "bodyAr":"تركز غالبًا على النمذجة أو التحليل دون دورة متكاملة من العطل حتى التحقق."},
        {"titleEn":"NEXVARY AVIONICS LAB", "titleAr":"NEXVARY Avionics Lab", "bodyEn":"Combines synthetic simulation, platform profiles, telemetry, fault injection, diagnostics, evidence, replay and verification in one engineering workflow.", "bodyAr":"يجمع المحاكاة الصناعية وملفات المنصات والقياسات وحقن الأعطال والتشخيص والأدلة وإعادة التشغيل والتحقق في دورة هندسية واحدة."}
    ]

    property var workflow: [
        {"en":"SIMULATE", "ar":"المحاكاة"},
        {"en":"DETECT", "ar":"الاكتشاف"},
        {"en":"DIAGNOSE", "ar":"التشخيص"},
        {"en":"RANK", "ar":"ترتيب الأسباب"},
        {"en":"ISOLATE", "ar":"العزل"},
        {"en":"RECOVER", "ar":"الاستعادة"},
        {"en":"VERIFY", "ar":"التحقق"},
        {"en":"REPORT", "ar":"التقرير"}
    ]

    property var executiveMessages: [
        {
            "number":"01",
            "titleEn":"WHAT IS THE SYSTEM?",
            "titleAr":"ما النظام؟",
            "bodyEn":"A multi-platform digital engineering laboratory that simulates systems, sensors and data flows in a safe training and analysis environment.",
            "bodyAr":"مختبر هندسي رقمي متعدد المنصات يحاكي الأنظمة والحساسات وتدفقات البيانات داخل بيئة آمنة للتدريب والتحليل.",
            "noteEn":"UNDERSTAND THE PLATFORM BEFORE, DURING AND AFTER A FAULT.",
            "noteAr":"فهم المنظومة قبل العطل وأثناءه وبعده."
        },
        {
            "number":"02",
            "titleEn":"WHY IS IT DIFFERENT?",
            "titleAr":"لماذا يختلف؟",
            "bodyEn":"It unifies digital twin, telemetry, fault injection, diagnostics, evidence, recovery and verification in one engineering workflow.",
            "bodyAr":"يجمع التوأم الرقمي والقياسات وحقن الأعطال والتشخيص والأدلة والاستعادة والتحقق في دورة هندسية واحدة.",
            "noteEn":"ONE WORKFLOW — NOT A COLLECTION OF DISCONNECTED TOOLS.",
            "noteAr":"دورة واحدة بدل مجموعة أدوات منفصلة."
        },
        {
            "number":"03",
            "titleEn":"WHAT VALUE DOES IT DELIVER?",
            "titleAr":"ما القيمة التي يقدمها؟",
            "bodyEn":"It turns synthetic scenarios into traceable engineering decisions, shortening the path from anomaly to explanation, recovery and verification.",
            "bodyAr":"يحوّل السيناريو الصناعي إلى قرار هندسي قابل للتتبع، ويختصر الطريق من اكتشاف الخلل إلى تفسيره واستعادته والتحقق منه.",
            "noteEn":"FASTER TRAINING • CLEARER ANALYSIS • REVIEWABLE EVIDENCE.",
            "noteAr":"تدريب أسرع • تحليل أوضح • أدلة قابلة للمراجعة."
        }
    ]

    Flickable {
        id: flick
        anchors.fill: parent
        clip: true
        contentWidth: width
        contentHeight: content.implicitHeight + 20
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: content
            x: 10
            y: 10
            width: flick.width - 20
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 132
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 16

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3

                        Text {
                            text: cockpit.rtl ? "عن النظام" : "ABOUT SYSTEM"
                            color: Theme.platinum
                            font.pixelSize: 30
                            font.bold: true
                            Layout.fillWidth: true
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        }
                        Text {
                            text: cockpit.rtl ? "ثلاث إجابات تنفيذية للعرض الوزاري" : "THREE EXECUTIVE ANSWERS FOR MINISTERIAL PRESENTATION"
                            color: Theme.accent
                            font.pixelSize: 12
                            font.bold: true
                            font.letterSpacing: 0.7
                            Layout.fillWidth: true
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        }
                        Text {
                            text: cockpit.rtl ? "ما النظام؟ لماذا يختلف؟ وما القيمة التي يقدمها؟" : "WHAT IS IT?  •  WHY IS IT DIFFERENT?  •  WHAT VALUE DOES IT DELIVER?"
                            color: Theme.silver
                            font.pixelSize: 13
                            font.bold: true
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 285
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: Theme.border
                        border.width: Theme.frameWidth
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 2
                            Text { text: "MINISTERIAL BRIEF"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                            Text { text: cockpit.activePlatformName.toUpperCase(); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                            Text { text: "v3.2.0 / STAGE 1720"; color: Theme.silver; font.family: "Consolas"; font.pixelSize: 8 }
                            Text { text: "EXECUTIVE READABILITY PASS"; color: Theme.amber; font.pixelSize: 8; font.bold: true }
                            Item { Layout.fillHeight: true }
                            Text { text: "TRAINING / SIMULATION"; color: Theme.green; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                            Text { text: "NO LIVE AIRCRAFT CONTROL"; color: Theme.muted; font.pixelSize: 7 }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 252
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Repeater {
                        model: page.executiveMessages
                        delegate: Rectangle {
                            required property int index
                            required property var modelData
                            property color cardAccent: index === 0 ? Theme.accent : (index === 1 ? Theme.green : Theme.amber)

                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Theme.panel2
                            border.color: cardAccent
                            border.width: Theme.frameWidth
                            radius: Theme.radius

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 13
                                spacing: 7

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 9
                                    Text {
                                        text: modelData.number
                                        color: cardAccent
                                        font.family: "Consolas"
                                        font.pixelSize: 23
                                        font.bold: true
                                    }
                                    Text {
                                        text: cockpit.rtl ? modelData.titleAr : modelData.titleEn
                                        color: Theme.platinum
                                        font.pixelSize: 17
                                        font.bold: true
                                        Layout.fillWidth: true
                                        wrapMode: Text.WordWrap
                                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                    }
                                }

                                Rectangle { Layout.fillWidth: true; height: 1; color: cardAccent; opacity: 0.85 }

                                Text {
                                    text: cockpit.rtl ? modelData.bodyAr : modelData.bodyEn
                                    color: Theme.platinum
                                    font.pixelSize: 14
                                    font.bold: true
                                    lineHeight: 1.12
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    wrapMode: Text.WordWrap
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 38
                                    color: Theme.panel3
                                    border.color: Theme.borderSoft
                                    border.width: Theme.frameWidth
                                    radius: Theme.radius
                                    Text {
                                        anchors.fill: parent
                                        anchors.margins: 7
                                        text: cockpit.rtl ? modelData.noteAr : modelData.noteEn
                                        color: cardAccent
                                        font.pixelSize: 9
                                        font.bold: true
                                        wrapMode: Text.WordWrap
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Text {
                text: cockpit.rtl ? "المميزات الرئيسية" : "KEY CAPABILITIES"
                color: Theme.platinum
                font.pixelSize: 14
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 270
                columns: 4
                columnSpacing: 7
                rowSpacing: 7

                Repeater {
                    model: page.featureCards
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.panel
                        border.color: Theme.border
                        border.width: Theme.frameWidth
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 9
                            spacing: 4
                            RowLayout {
                                Layout.fillWidth: true
                                Rectangle {
                                    width: 34
                                    height: 26
                                    color: Theme.panel3
                                    border.color: Theme.accent
                                    border.width: Theme.frameWidth
                                    radius: Theme.radius
                                    Text { anchors.centerIn: parent; text: modelData.code; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 8; font.bold: true }
                                }
                                Text {
                                    text: cockpit.rtl ? modelData.ar : modelData.en
                                    color: Theme.platinum
                                    font.pixelSize: 9
                                    font.bold: true
                                    Layout.fillWidth: true
                                    horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                                    wrapMode: Text.WordWrap
                                }
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Text {
                                text: cockpit.rtl ? modelData.descAr : modelData.descEn
                                color: Theme.silver
                                font.pixelSize: 8
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignTop
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                        }
                    }
                }
            }

            Text {
                text: cockpit.rtl ? "ما الذي يميزه عن الحلول المشابهة؟" : "WHAT MAKES THE ENGINEERING APPROACH DIFFERENT?"
                color: Theme.platinum
                font.pixelSize: 12
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 205
                columns: 4
                columnSpacing: 7
                rowSpacing: 7

                Repeater {
                    model: page.comparisonCards
                    delegate: Rectangle {
                        required property int index
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: index === 3 ? "#15242D" : Theme.panel
                        border.color: index === 3 ? Theme.accent : Theme.border
                        border.width: Theme.frameWidth
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 5
                            Text {
                                text: cockpit.rtl ? modelData.titleAr : modelData.titleEn
                                color: index === 3 ? Theme.accent : Theme.platinum
                                font.pixelSize: 9
                                font.bold: true
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: index === 3 ? Theme.accent : Theme.borderSoft; opacity: 0.8 }
                            Text {
                                text: cockpit.rtl ? modelData.bodyAr : modelData.bodyEn
                                color: Theme.silver
                                font.pixelSize: 8
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignTop
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 168
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 6

                    Text { text: cockpit.rtl ? "دورة العمل التشخيصية" : "DIAGNOSTIC WORKFLOW"; color: Theme.platinum; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 4

                        Repeater {
                            model: page.workflow
                            delegate: Rectangle {
                                required property int index
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: Theme.border
                                border.width: Theme.frameWidth
                                radius: Theme.radius

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 3
                                    Text { text: String(index + 1); color: Theme.accent; font.family: "Consolas"; font.pixelSize: 13; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: cockpit.rtl ? modelData.ar : modelData.en; color: Theme.platinum; font.pixelSize: 7; font.bold: true; Layout.alignment: Qt.AlignHCenter; horizontalAlignment: Text.AlignHCenter }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 205
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: Theme.border
                        border.width: Theme.frameWidth
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 9
                            spacing: 4
                            Text { text: cockpit.rtl ? "المنصات التدريبية المدعومة" : "SUPPORTED GENERIC TRAINING PROFILES"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: cockpit.platformProfiles
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Rectangle { width: 32; height: 22; color: Theme.panel3; border.color: Theme.accent; border.width: Theme.frameWidth; Text { anchors.centerIn: parent; text: Theme.platformCode(modelData.id); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 7; font.bold: true } }
                                    Text { text: modelData.name; color: Theme.silver; font.pixelSize: 8; Layout.fillWidth: true }
                                    Text { text: modelData.systemCount + " SYS / " + modelData.channelCount + " CH"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 7 }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 410
                        Layout.fillHeight: true
                        color: Theme.panel2
                        border.color: Theme.border
                        border.width: Theme.frameWidth
                        radius: Theme.radius

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 4
                            Text { text: cockpit.rtl ? "حدود الاستخدام" : "USAGE BOUNDARY"; color: Theme.platinum; font.pixelSize: 10; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Text {
                                text: cockpit.rtl ? "النظام مخصص للتدريب والمحاكاة والتحليل والتحقق الهندسي باستخدام بيانات صناعية. أكواد التشخيص NEXVARY تدريبية وليست أكواد مصنع أو اعتماد صلاحية طيران. لا توجد واجهة تحكم بطائرة حقيقية أو مسار أسلحة أو تشغيل حي." : "The system is intended for training, simulation, analysis and engineering verification using synthetic data. NEXVARY diagnostic codes are training codes, not OEM or airworthiness codes. There is no live-aircraft control interface, weapons path or operational control channel."
                                color: Theme.silver
                                font.pixelSize: 8
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignTop
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                            Text { text: cockpit.rtl ? "هذا الفصل الواضح بين التدريب والتشغيل الحقيقي جزء من تصميم السلامة للمنصة." : "This explicit separation between training and real operation is part of the platform safety design."; color: Theme.accent; font.pixelSize: 7; font.bold: true; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        }
                    }
                }
            }
        }
    }
}
