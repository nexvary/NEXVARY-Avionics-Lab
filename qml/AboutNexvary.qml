import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Item {
    id: page
    LayoutMirroring.enabled: cockpit.rtl
    LayoutMirroring.childrenInherit: true

    property var socialLinks: [
        {"label": "Website", "value": "https://nexvary.com/", "url": "https://nexvary.com/"},
        {"label": "Facebook", "value": "facebook.com/share/14p9krEn5ij", "url": "https://www.facebook.com/share/14p9krEn5ij/"},
        {"label": "Email", "value": "info@nexvary.com", "url": "mailto:info@nexvary.com"},
        {"label": "YouTube", "value": "youtube.com/@NexvaryInc", "url": "https://www.youtube.com/@NexvaryInc"},
        {"label": "X", "value": "x.com/Nexvary", "url": "https://x.com/Nexvary"}
    ]

    Flickable {
        anchors.fill: parent
        clip: true
        contentWidth: width
        contentHeight: body.implicitHeight + 44
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

        ColumnLayout {
            id: body
            x: 24
            y: 22
            width: parent.width - 48
            spacing: 14

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 156
                color: Theme.panel
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 22

                    Rectangle {
                        Layout.preferredWidth: 112
                        Layout.preferredHeight: 112
                        color: Theme.shell
                        border.color: Theme.gold
                        border.width: 1
                        radius: 8
                        NexvaryMark { anchors.centerIn: parent; width: 82; height: 82 }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        Text {
                            text: cockpit.text("about_us")
                            color: Theme.platinum
                            font.pixelSize: 28
                            font.bold: true
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "NEXVARY • EXECUTIVE TECHNOLOGY & ENGINEERING"
                            color: Theme.gold
                            font.pixelSize: 11
                            font.bold: true
                            font.letterSpacing: 1.0
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            Layout.fillWidth: true
                        }
                        Text {
                            text: cockpit.text("about_nexvary_intro")
                            color: Theme.silver
                            font.pixelSize: 13
                            wrapMode: Text.WordWrap
                            lineHeight: 1.25
                            horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: width >= 1180 ? 2 : 1
                columnSpacing: 14
                rowSpacing: 14

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    color: Theme.panel2
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8
                        Text { text: cockpit.rtl ? "مهمتنا" : "MISSION"; color: Theme.accent; font.pixelSize: 12; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        Text { text: cockpit.text("about_nexvary_mission"); color: Theme.platinum; font.pixelSize: 14; font.bold: true; wrapMode: Text.WordWrap; lineHeight: 1.25; Layout.fillWidth: true; Layout.fillHeight: true; verticalAlignment: Text.AlignVCenter; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    color: Theme.panel2
                    border.color: Theme.border
                    border.width: Theme.frameWidth
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8
                        Text { text: cockpit.rtl ? "حدود الاستخدام الآمن" : "SAFE USE BOUNDARY"; color: Theme.green; font.pixelSize: 12; font.bold: true; Layout.fillWidth: true; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                        Text { text: cockpit.text("about_nexvary_safety"); color: Theme.platinum; font.pixelSize: 14; font.bold: true; wrapMode: Text.WordWrap; lineHeight: 1.25; Layout.fillWidth: true; Layout.fillHeight: true; verticalAlignment: Text.AlignVCenter; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: socialColumn.implicitHeight + 34
                color: Theme.panel
                border.color: Theme.gold
                border.width: 1
                radius: Theme.radius

                ColumnLayout {
                    id: socialColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 17
                    spacing: 8

                    Text {
                        text: cockpit.text("social_links")
                        color: Theme.gold
                        font.pixelSize: 16
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "الروابط الرسمية — اضغط على أي رابط لفتحه" : "Official links — select any row to open it"
                        color: Theme.muted
                        font.pixelSize: 9
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }

                    Repeater {
                        model: page.socialLinks
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 44
                            color: linkMouse.containsMouse ? Theme.panel3 : Theme.panel2
                            border.color: linkMouse.containsMouse ? Theme.accent : Theme.borderSoft
                            border.width: 1
                            radius: Theme.radius

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 12
                                Text { text: modelData.label; color: Theme.accent; font.pixelSize: 11; font.bold: true; Layout.preferredWidth: 105 }
                                Text { text: modelData.value; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 10; Layout.fillWidth: true; elide: Text.ElideRight; horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft }
                                Text { text: cockpit.rtl ? "فتح ◀" : "OPEN ▶"; color: Theme.gold; font.pixelSize: 9; font.bold: true }
                            }
                            MouseArea {
                                id: linkMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Qt.openUrlExternally(modelData.url)
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                color: Theme.shell
                border.color: Theme.border
                border.width: Theme.frameWidth
                radius: Theme.radius
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    Text { text: "NEXVARY AVIONICS LAB"; color: Theme.platinum; font.pixelSize: 12; font.bold: true }
                    Item { Layout.fillWidth: true }
                    Text { text: "OFFLINE • SYNTHETIC • TRAINING • VERIFICATION"; color: Theme.green; font.family: "Consolas"; font.pixelSize: 9; font.bold: true }
                }
            }
        }
    }
}
