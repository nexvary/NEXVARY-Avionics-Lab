import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page

    property var featureCards: [
        {"code":"CP", "en":"COMMON AIR PICTURE", "ar":"الصورة الجوية المشتركة", "descEn":"Geographic air picture combining public ADS-B, AEGIS awareness, bases, airspace, routes and weather constraints.", "descAr":"صورة جوية جغرافية تجمع ADS-B العام ووعي AEGIS والقواعد والمجال الجوي والمسارات وقيود الطقس."},
        {"code":"FR", "en":"FORCE READINESS", "ar":"جاهزية القوة", "descEn":"Fleet, squadron, crew and training readiness with assignment, availability and constraint context.", "descAr":"جاهزية الأسطول والأسراب والأطقم والتدريب مع سياق التكليف والتوافر والقيود."},
        {"code":"AO", "en":"AIR OPERATIONS", "ar":"العمليات الجوية", "descEn":"Airspace, public flight tracking, route analysis, aeronautical data and incident review workspaces.", "descAr":"مساحات للمجال الجوي وتتبع الرحلات العامة وتحليل المسارات والبيانات الملاحية ومراجعة الحوادث."},
        {"code":"MS", "en":"MAINTENANCE + SUSTAINMENT", "ar":"الصيانة والإدامة", "descEn":"Open work, due inspections, platform priority and maintenance planning tied to readiness impact.", "descAr":"أعمال الصيانة المفتوحة والفحوص المستحقة وأولوية المنصة والتخطيط المرتبط بأثر الجاهزية."},
        {"code":"CU", "en":"C-UAS AWARENESS", "ar":"الوعي المضاد للمسيّرات", "descEn":"Passive detection, classification, confidence, geofence, evidence, incident and coordination views.", "descAr":"عرض سلبي للاكتشاف والتصنيف والثقة والسياج الجغرافي والأدلة والحوادث والتنسيق."},
        {"code":"SD", "en":"SPACE DOMAIN", "ar":"المجال الفضائي", "descEn":"Public orbital elements, replay and synthetic training providers for space-domain awareness and analysis.", "descAr":"عناصر مدارية عامة ومصادر إعادة تشغيل وتدريب صناعي للوعي والتحليل في المجال الفضائي."},
        {"code":"DT", "en":"DIGITAL ENGINEERING", "ar":"الهندسة الرقمية", "descEn":"Aircraft visual system, digital twins, telemetry, diagnostics, fault lab, replay, trends and verification.", "descAr":"نظام بصري للطائرات وتوأم رقمي وقياسات وتشخيص ومختبر أعطال وإعادة تشغيل واتجاهات وتحقق."},
        {"code":"GV", "en":"DATA GOVERNANCE", "ar":"حوكمة البيانات", "descEn":"Provider source, mode, health, freshness, audit evidence and reporting remain visible and traceable.", "descAr":"يبقى مصدر المزود ونمطه وصحته وحداثته وأدلة التدقيق والتقارير واضحة وقابلة للتتبع."}
    ]

    property var comparisonCards: [
        {"titleEn":"STANDALONE FLIGHT TRACKER", "titleAr":"متعقب رحلات مستقل", "bodyEn":"Shows aircraft movement, but normally lacks readiness, maintenance, training, engineering and governance context.", "bodyAr":"يعرض حركة الطائرات، لكنه يفتقر عادة إلى سياق الجاهزية والصيانة والتدريب والهندسة والحوكمة."},
        {"titleEn":"FORCE / MRO INFORMATION TOOL", "titleAr":"أداة قوة أو صيانة", "bodyEn":"Manages assets or work orders, but rarely connects them to one common air and operational picture.", "bodyAr":"يدير الأصول أو أوامر العمل، لكنه نادرًا ما يربطها بصورة جوية وتشغيلية مشتركة واحدة."},
        {"titleEn":"ENGINEERING LAB", "titleAr":"مختبر هندسي", "bodyEn":"Explains platform systems and faults, but does not usually include command-level force and airspace management.", "bodyAr":"يفسر أنظمة المنصة وأعطالها، لكنه لا يشمل عادة إدارة القوة والمجال الجوي على مستوى القيادة."},
        {"titleEn":"NEXVARY INTEGRATED PLATFORM", "titleAr":"منصة NEXVARY المتكاملة", "bodyEn":"Connects command overview, air and space awareness, force readiness, sustainment, training and digital engineering through governed provider architecture.", "bodyAr":"تربط نظرة القيادة والوعي الجوي والفضائي وجاهزية القوة والإدامة والتدريب والهندسة الرقمية عبر معمارية مزودات محكومة."}
    ]

    property var workflow: [
        {"en":"OBSERVE", "ar":"الرصد"},
        {"en":"CORRELATE", "ar":"الربط"},
        {"en":"ASSESS", "ar":"التقييم"},
        {"en":"PRIORITIZE", "ar":"الأولوية"},
        {"en":"COORDINATE", "ar":"التنسيق"},
        {"en":"TRAIN", "ar":"التدريب"},
        {"en":"MAINTAIN", "ar":"الصيانة"},
        {"en":"VERIFY", "ar":"التحقق"}
    ]

    property var executiveMessages: [
        {
            "number":"01",
            "titleEn":"WHAT IS THE SYSTEM?",
            "titleAr":"ما النظام؟",
            "bodyEn":"An integrated air-force management platform for command overview, air and space awareness, force readiness, bases, sustainment, training and avionics engineering.",
            "bodyAr":"منصة متكاملة لإدارة القوة الجوية تجمع نظرة القيادة والوعي الجوي والفضائي وجاهزية القوة والقواعد والإدامة والتدريب وهندسة إلكترونيات الطيران.",
            "noteEn":"ONE GOVERNED PICTURE FROM COMMAND READINESS TO ENGINEERING EVIDENCE.",
            "noteAr":"صورة محكومة واحدة من جاهزية القيادة حتى الأدلة الهندسية."
        },
        {
            "number":"02",
            "titleEn":"WHY IS IT DIFFERENT?",
            "titleAr":"لماذا يختلف؟",
            "bodyEn":"It connects public, replay and synthetic providers to the common air picture, readiness decisions, maintenance, incident review and digital-twin verification.",
            "bodyAr":"تربط المصادر العامة وإعادة التشغيل والبيانات الصناعية بالصورة الجوية وقرارات الجاهزية والصيانة ومراجعة الحوادث والتحقق بالتوأم الرقمي.",
            "noteEn":"SOURCE, MODE, HEALTH, FRESHNESS AND EVIDENCE STAY VISIBLE.",
            "noteAr":"يبقى المصدر والنمط والصحة والحداثة والأدلة ظاهرة."
        },
        {
            "number":"03",
            "titleEn":"WHAT VALUE DOES IT DELIVER?",
            "titleAr":"ما القيمة التي يقدمها؟",
            "bodyEn":"It supports faster executive briefing, clearer readiness priorities, coordinated training and sustainment, and traceable operational and engineering review.",
            "bodyAr":"تدعم إحاطة تنفيذية أسرع وأولويات جاهزية أوضح وتنسيق التدريب والإدامة ومراجعة تشغيلية وهندسية قابلة للتتبع.",
            "noteEn":"AWARENESS • MANAGEMENT • TRAINING • MAINTENANCE • ANALYSIS.",
            "noteAr":"وعي • إدارة • تدريب • صيانة • تحليل."
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
                            text: cockpit.rtl ? "منصة إدارة ووعي وجاهزية وهندسة للقوة الجوية" : "AIR-FORCE MANAGEMENT • AWARENESS • READINESS • ENGINEERING"
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
                            Text { text: "MINISTERIAL BRIEF"; color: Theme.platinum; font.pixelSize: Theme.secondaryPx; font.bold: true }
                            Text { text: cockpit.activePlatformName.toUpperCase(); color: Theme.accent; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                            Text { text: "v3.5.0 / STAGE 1980"; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                            Text { text: "INTEGRATED PLATFORM BRIEF"; color: Theme.amber; font.pixelSize: Theme.smallPx; font.bold: true }
                            Item { Layout.fillHeight: true }
                            Text { text: "AWARENESS / MANAGEMENT / TRAINING"; color: Theme.green; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                            Text { text: "NO ENGAGEMENT OR LIVE CONTROL"; color: Theme.muted; font.pixelSize: Theme.smallPx }
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
                            border.color: Theme.border
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
                                        font.pixelSize: 10
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
                                    Text { anchors.centerIn: parent; text: modelData.code; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 10; font.bold: true }
                                }
                                Text {
                                    text: cockpit.rtl ? modelData.ar : modelData.en
                                    color: Theme.platinum
                                    font.pixelSize: 10
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
                                font.pixelSize: 10
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
                text: cockpit.rtl ? "ما الذي يميز المنصة المتكاملة؟" : "WHAT MAKES THE INTEGRATED PLATFORM DIFFERENT?"
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
                        color: index === 3 ? "#151515" : Theme.panel
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
                                font.pixelSize: 10
                                font.bold: true
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: index === 3 ? Theme.accent : Theme.borderSoft; opacity: 0.8 }
                            Text {
                                text: cockpit.rtl ? modelData.bodyAr : modelData.bodyEn
                                color: Theme.silver
                                font.pixelSize: 10
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

                    Text { text: cockpit.rtl ? "دورة القرار والمراجعة" : "DECISION AND REVIEW WORKFLOW"; color: Theme.platinum; font.pixelSize: 13; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
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
                                    Text { text: cockpit.rtl ? modelData.ar : modelData.en; color: Theme.platinum; font.pixelSize: 10; font.bold: true; Layout.alignment: Qt.AlignHCenter; horizontalAlignment: Text.AlignHCenter }
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
                                    Rectangle { width: 32; height: 22; color: Theme.panel3; border.color: Theme.accent; border.width: Theme.frameWidth; Text { anchors.centerIn: parent; text: Theme.platformCode(modelData.id); color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 10; font.bold: true } }
                                    Text { text: modelData.name; color: Theme.silver; font.pixelSize: 10; Layout.fillWidth: true }
                                    Text { text: modelData.systemCount + " SYS / " + modelData.channelCount + " CH"; color: Theme.muted; font.family: "Consolas"; font.pixelSize: 10 }
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
                                text: cockpit.rtl ? "المنصة مخصصة للوعي والإدارة والتدريب والمحاكاة والتشخيص والجاهزية والصيانة والتحليل. يمكنها عرض بيانات طيران ومدارات عامة بصورة سلبية مع إظهار المصدر والحداثة. لا توفر تحكمًا حيًا بالطائرات أو اشتباكًا ذاتيًا أو تخصيص أسلحة أو تحكمًا بالتشويش أو الانتحال أو الاستيلاء." : "The platform is intended for awareness, management, training, simulation, diagnostics, readiness, maintenance and analysis. It may display public flight and orbital data passively with visible provenance and freshness. It provides no live-aircraft control, autonomous engagement, weapons assignment, jammer control, spoofing or takeover."
                                color: Theme.silver
                                font.pixelSize: 10
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignTop
                                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                            Text { text: cockpit.rtl ? "حدود الاستخدام المقروءة ومصدر كل معلومة جزء من حوكمة وسلامة المنصة." : "Visible usage boundaries and provenance for every information source are part of platform governance and safety."; color: Theme.accent; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        }
                    }
                }
            }
        }
    }
}
