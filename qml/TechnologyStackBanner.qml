import QtQuick
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: banner
    implicitHeight: 74
    color: Theme.shell
    border.color: Theme.gold
    border.width: 1
    radius: Theme.radius
    LayoutMirroring.enabled: cockpit.rtl
    LayoutMirroring.childrenInherit: true

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        spacing: 16

        ColumnLayout {
            Layout.preferredWidth: 235
            spacing: 2
            Text {
                text: cockpit.text("programming_languages")
                color: Theme.gold
                font.pixelSize: 11
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
            }
            Text {
                text: "C++20  •  QML  •  JavaScript  •  Python"
                color: Theme.platinum
                font.family: "Consolas"
                font.pixelSize: 10
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
            }
        }

        Rectangle { width: 1; Layout.fillHeight: true; color: Theme.borderSoft }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: cockpit.text("technology_stack")
                color: Theme.accent
                font.pixelSize: 11
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
            }
            Text {
                text: "Qt 6 / Qt Quick  •  CMake  •  JSON  •  GitHub Actions  •  ASan / UBSan  •  Inno Setup"
                color: Theme.silver
                font.family: "Consolas"
                font.pixelSize: 9
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
            }
        }

        Rectangle {
            Layout.preferredWidth: 164
            Layout.fillHeight: true
            color: Theme.panel2
            border.color: Theme.border
            border.width: Theme.frameWidth
            radius: Theme.radius
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 1
                Text { text: "DESKTOP / LARGE DISPLAY"; color: Theme.green; font.pixelSize: 8; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                Text { text: "1360 → 2560+"; color: Theme.platinum; font.family: "Consolas"; font.pixelSize: 10; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            }
        }
    }
}
