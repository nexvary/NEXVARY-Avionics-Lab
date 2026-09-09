import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 1440; height: 900; visible: true; color: "#05090b"
    title: "NEXVARY AVIONICS LAB — TRAINING COCKPIT"
    property bool rtl: false
    property int pageIndex: 0
    LayoutMirroring.enabled: rtl; LayoutMirroring.childrenInherit: true

    header: Rectangle { height: 72; color: "#081216"; border.color: "#39ff88"; border.width: 1
        RowLayout { anchors.fill: parent; anchors.margins: 16
            ColumnLayout { Layout.fillWidth: true
                Label { text: "NEXVARY AVIONICS LAB"; color: "#d8e1e6"; font.pixelSize: 25; font.bold: true }
                Label { text: root.rtl ? "مختبر تدريب ومحاكاة — بيانات اصطناعية" : "TRAINING / SIMULATION — SYNTHETIC TELEMETRY"; color: "#39ff88" }
            }
            Label { text: cockpitBridge.clockText; color: "#39ff88"; font.pixelSize: 20 }
            Button { text: root.rtl ? "EN" : "AR"; onClicked: root.rtl = !root.rtl }
        }
    }

    RowLayout { anchors.fill: parent; anchors.margins: 18; spacing: 16
        Rectangle { Layout.preferredWidth: 220; Layout.fillHeight: true; color: "#071014"; border.color: "#445158"
            ColumnLayout { anchors.fill: parent; anchors.margins: 12; spacing: 8
                Repeater { model: root.rtl ? ["الشاشة الرئيسية","صحة الأنظمة","الحساسات","سجل الأحداث","مختبر الإعادة"] : ["PRIMARY MFD","SYSTEM HEALTH","SENSORS","EVENT LOG","REPLAY LAB"]
                    delegate: Button { required property int index; required property string modelData; text: modelData; Layout.fillWidth: true; Layout.preferredHeight: 52; onClicked: root.pageIndex = index }
                }
                Item { Layout.fillHeight: true }
                Label { text: root.rtl ? "لا توجد واجهة تحكم بطائرة حقيقية" : "NO LIVE AIRCRAFT I/O"; color: "#ffcc45"; wrapMode: Text.WordWrap; Layout.fillWidth: true }
            }
        }
        ColumnLayout { Layout.fillWidth: true; Layout.fillHeight: true; spacing: 14
            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 70; color: "#0a1518"; border.color: cockpitBridge.hasAlerts ? "#ffb020" : "#39ff88"
                Label { anchors.centerIn: parent; text: cockpitBridge.annunciatorText; color: cockpitBridge.hasAlerts ? "#ffb020" : "#39ff88"; font.pixelSize: 20; font.bold: true }
            }
            StackLayout { currentIndex: root.pageIndex; Layout.fillWidth: true; Layout.fillHeight: true
                GridLayout { columns: 4; rowSpacing: 12; columnSpacing: 12
                    Repeater { model: cockpitBridge.tiles
                        delegate: Rectangle { required property var modelData; Layout.fillWidth: true; Layout.fillHeight: true; Layout.minimumHeight: 150; color: "#081216"; border.width: 1; border.color: modelData.state === "NOMINAL" ? "#39ff88" : "#ff5a5f"
                            Column { anchors.centerIn: parent; spacing: 12
                                Label { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.label; color: "#8fa5ae" }
                                Label { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.value; color: modelData.state === "NOMINAL" ? "#d8e1e6" : "#ff5a5f"; font.pixelSize: 28; font.bold: true }
                                Label { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.state; color: modelData.state === "NOMINAL" ? "#39ff88" : "#ff5a5f" }
                            }
                        }
                    }
                }
                PagePlaceholder { heading: root.rtl ? "صحة الأنظمة" : "SYSTEM HEALTH"; detail: cockpitBridge.hasAlerts ? cockpitBridge.annunciatorText : (root.rtl ? "جميع الأنظمة الاسمية" : "ALL SYSTEMS NOMINAL") }
                PagePlaceholder { heading: root.rtl ? "الحساسات" : "SENSORS"; detail: root.rtl ? "قنوات المحاكاة الاصطناعية متصلة" : "SYNTHETIC SIMULATION CHANNELS CONNECTED" }
                PagePlaceholder { heading: root.rtl ? "سجل الأحداث" : "EVENT LOG"; detail: root.rtl ? "عرض تدريبي — الربط التفصيلي في المرحلة التالية" : "TRAINING VIEW — DETAILED BINDING IN NEXT GATE" }
                PagePlaceholder { heading: root.rtl ? "مختبر الإعادة" : "REPLAY LAB"; detail: root.rtl ? "مسجل القياسات الحتمي جاهز" : "DETERMINISTIC TELEMETRY RECORDER READY" }
            }
            RowLayout { Layout.fillWidth: true
                Label { text: cockpitBridge.scenarioText; color: "#7fdcff"; Layout.fillWidth: true }
                Button { text: root.rtl ? "رجوع" : "BACK"; enabled: root.pageIndex > 0; onClicked: root.pageIndex = Math.max(0, root.pageIndex - 1) }
                Button { text: root.rtl ? "إعادة ضبط" : "RESET"; onClicked: cockpitBridge.resetLab() }
            }
        }
    }
    component PagePlaceholder: Rectangle { property string heading; property string detail; color: "#081216"; border.color: "#445158"
        Column { anchors.centerIn: parent; spacing: 18
            Label { anchors.horizontalCenter: parent.horizontalCenter; text: heading; color: "#d8e1e6"; font.pixelSize: 30; font.bold: true }
            Label { anchors.horizontalCenter: parent.horizontalCenter; text: detail; color: "#39ff88"; font.pixelSize: 16 }
        }
    }
}
