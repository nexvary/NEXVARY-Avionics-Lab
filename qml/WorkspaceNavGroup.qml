import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

ColumnLayout {
    id: root
    property string groupId: ""
    property string title: ""
    property color accent: Theme.accent
    property var entries: []
    property string selectedRoute: ""
    property bool rtl: false
    property bool initiallyExpanded: false
    property bool expanded: initiallyExpanded
    signal routeRequested(string routeId, int page, int workspace, string groupId)

    function containsRoute(routeId) {
        for (var i = 0; i < entries.length; ++i)
            if (entries[i].route === routeId) return true
        return false
    }

    onSelectedRouteChanged: {
        if (containsRoute(selectedRoute)) expanded = true
    }

    Component.onCompleted: {
        if (containsRoute(selectedRoute)) expanded = true
    }

    Layout.fillWidth: true
    spacing: 3

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 32
        radius: 5
        color: headerMouse.containsMouse ? Theme.panel2 : "transparent"
        border.color: root.expanded ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.42) : "transparent"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 8
            layoutDirection: root.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Rectangle {
                width: 4
                height: 16
                radius: 2
                color: root.accent
            }
            Text {
                Layout.fillWidth: true
                text: root.title
                color: root.expanded ? Theme.platinum : Theme.silver
                font.family: Theme.uiFont(root.rtl)
                font.pixelSize: Theme.navGroupPx
                font.bold: true
                font.letterSpacing: root.rtl ? 0 : 1.1
                horizontalAlignment: root.rtl ? Text.AlignRight : Text.AlignLeft
                elide: Text.ElideRight
            }
            Text {
                text: root.expanded ? "−" : "+"
                color: root.accent
                font.family: Theme.mono
                font.pixelSize: 15
                font.bold: true
            }
        }

        MouseArea {
            id: headerMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.expanded = !root.expanded
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 3
        visible: root.expanded

        Repeater {
            model: root.entries

            delegate: Button {
                id: navButton
                required property var modelData
                Layout.fillWidth: true
                implicitHeight: 40
                checkable: true
                checked: root.selectedRoute === modelData.route

                contentItem: RowLayout {
                    spacing: 9
                    layoutDirection: root.rtl ? Qt.RightToLeft : Qt.LeftToRight
                    NavIcon {
                        kind: modelData.icon
                        iconColor: navButton.checked ? root.accent : Theme.silver
                        Layout.preferredWidth: 19
                        Layout.preferredHeight: 19
                    }
                    Text {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: navButton.checked ? Theme.platinum : Theme.silver
                        font.family: Theme.uiFont(root.rtl)
                        font.pixelSize: Theme.navItemPx
                        font.bold: navButton.checked
                        horizontalAlignment: root.rtl ? Text.AlignRight : Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    Rectangle {
                        width: 7
                        height: 7
                        radius: 4
                        color: root.accent
                        visible: navButton.checked
                    }
                }

                background: Rectangle {
                    radius: 6
                    color: navButton.checked ? Theme.elevated : (navButton.hovered ? Theme.panel2 : "transparent")
                    border.color: navButton.checked ? root.accent : "transparent"
                    border.width: navButton.checked ? Theme.activeFrameWidth : 0
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: parent.radius + 2
                        color: "transparent"
                        border.color: Theme.goldGlow
                        border.width: 1
                        visible: navButton.checked
                    }
                    Rectangle {
                        width: 3
                        radius: 2
                        color: root.accent
                        visible: navButton.checked
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: root.rtl ? undefined : parent.left
                        anchors.right: root.rtl ? parent.right : undefined
                    }
                }

                onClicked: root.routeRequested(modelData.route, modelData.page, modelData.workspace, root.groupId)
            }
        }
    }
}
