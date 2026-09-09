import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 1440
    height: 900
    visible: true
    title: cockpit.text("app_title")
    color: "#03070a"

    property int selectedPage: 0

    function t(key) {
        const languageDependency = cockpit.language
        return cockpit.text(key)
    }

    LayoutMirroring.enabled: cockpit.rtl
    LayoutMirroring.childrenInherit: true

    Timer {
        interval: 250
        running: true
        repeat: true
        onTriggered: cockpit.step()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 12

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
            radius: 9
            color: "#071014"
            border.width: 1
            border.color: "#52646d"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 16

                ColumnLayout {
                    Layout.fillWidth: true
                    Text {
                        text: root.t("app_title")
                        color: "#f1c75b"
                        font.pixelSize: 25
                        font.bold: true
                    }
                    Text {
                        text: root.t("training") + " | " + cockpit.scenario
                        color: "#39ff9b"
                        font.pixelSize: 13
                    }
                }

                Text {
                    text: root.t("tick") + ": " + cockpit.tick
                    color: "#d4e2e7"
                    font.pixelSize: 16
                }

                ComboBox {
                    model: cockpit.scenarios
                    Layout.preferredWidth: 190
                    onActivated: cockpit.setScenario(currentText)
                }

                Button {
                    text: root.t("language")
                    onClicked: cockpit.setLanguage(cockpit.rtl ? "en" : "ar")
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Button { text: root.t("mfd"); checkable: true; checked: root.selectedPage === 0; onClicked: root.selectedPage = 0 }
            Button { text: root.t("systems"); checkable: true; checked: root.selectedPage === 1; onClicked: root.selectedPage = 1 }
            Button { text: root.t("sensors"); checkable: true; checked: root.selectedPage === 2; onClicked: root.selectedPage = 2 }
            Button { text: root.t("events"); checkable: true; checked: root.selectedPage === 3; onClicked: root.selectedPage = 3 }
            Button { text: root.t("replay"); checkable: true; checked: root.selectedPage === 4; onClicked: root.selectedPage = 4 }
            Button { text: root.t("trends"); checkable: true; checked: root.selectedPage === 5; onClicked: root.selectedPage = 5 }

            Item { Layout.fillWidth: true }

            Button {
                text: root.t("back")
                enabled: root.selectedPage > 0
                onClicked: root.selectedPage = Math.max(0, root.selectedPage - 1)
            }
            Button { text: root.t("reset"); onClicked: cockpit.resetLab() }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.selectedPage

            Item {
                GridLayout {
                    anchors.fill: parent
                    columns: 4
                    columnSpacing: 12
                    rowSpacing: 12
                    Repeater {
                        model: cockpit.tiles
                        delegate: InstrumentTile {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            tileLabel: modelData.label
                            tileValue: modelData.value
                            tileState: modelData.state
                        }
                    }
                }
            }

            Item {
                GridLayout {
                    anchors.centerIn: parent
                    columns: 2
                    columnSpacing: 18
                    rowSpacing: 18
                    Repeater {
                        model: [
                            { "label": root.t("active_alerts"), "value": cockpit.activeAlertCount },
                            { "label": root.t("recorded_frames"), "value": cockpit.recordedFrames },
                            { "label": root.t("sensor_count"), "value": cockpit.sensorCount },
                            { "label": root.t("event_count"), "value": cockpit.eventCount }
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            width: 280
                            height: 150
                            radius: 8
                            color: "#071014"
                            border.width: 1
                            border.color: modelData.value === 0 ? "#39ff9b" : "#52646d"
                            Column {
                                anchors.centerIn: parent
                                spacing: 12
                                Text { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.label; color: "#8fa5ae" }
                                Text { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.value; color: "#f1c75b"; font.pixelSize: 34; font.bold: true }
                            }
                        }
                    }
                }
            }

            Item {
                ListView {
                    anchors.fill: parent
                    spacing: 6
                    clip: true
                    model: cockpit.sensorRows
                    delegate: Rectangle {
                        required property var modelData
                        width: ListView.view.width
                        height: 58
                        color: "#081216"
                        border.width: 1
                        border.color: modelData.valid ? "#39ff9b" : "#ff5a5f"
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            Text { text: modelData.label; color: "#d4e2e7"; Layout.fillWidth: true }
                            Text { text: Number(modelData.value).toFixed(2) + " " + modelData.unit; color: modelData.valid ? "#39ff9b" : "#ff5a5f"; font.bold: true }
                        }
                    }
                }
            }

            Item {
                ListView {
                    anchors.fill: parent
                    spacing: 6
                    clip: true
                    model: cockpit.eventRows
                    delegate: Rectangle {
                        required property var modelData
                        width: ListView.view.width
                        height: 64
                        color: "#081216"
                        border.width: 1
                        border.color: modelData.severity === "FAULT" ? "#ff5a5f" : (modelData.severity === "WARN" ? "#ffb000" : "#52646d")
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            Text { text: modelData.severity; color: "#f1c75b"; Layout.preferredWidth: 80 }
                            Text { text: modelData.source; color: "#7fdcff"; Layout.preferredWidth: 120 }
                            Text { text: modelData.message; color: "#d4e2e7"; Layout.fillWidth: true; wrapMode: Text.Wrap }
                        }
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 14
                    RowLayout {
                        Layout.fillWidth: true
                        Button {
                            text: cockpit.replayMode ? root.t("exit_replay") : root.t("enter_replay")
                            onClicked: cockpit.setReplayMode(!cockpit.replayMode)
                        }
                        Text { text: cockpit.replayIndex + " / " + cockpit.replayMaximum; color: "#d4e2e7"; Layout.fillWidth: true }
                        Slider {
                            from: 0
                            to: Math.max(1, cockpit.replayMaximum)
                            value: cockpit.replayIndex
                            enabled: cockpit.replayMode && cockpit.replayMaximum > 0
                            Layout.preferredWidth: 500
                            onMoved: cockpit.seekReplay(Math.round(value))
                        }
                    }
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 4
                        columnSpacing: 12
                        rowSpacing: 12
                        Repeater {
                            model: cockpit.tiles
                            delegate: InstrumentTile {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                tileLabel: modelData.label
                                tileValue: modelData.value
                                tileState: modelData.state
                            }
                        }
                    }
                }
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: root.t("window")
                            color: "#f1c75b"
                            font.bold: true
                        }
                        ComboBox {
                            id: trendWindowSelector
                            model: ["20", "60", "120", "ALL"]
                            currentIndex: 1
                            Layout.preferredWidth: 130
                            onActivated: {
                                const values = [20, 60, 120, 0]
                                cockpit.setTrendWindow(values[currentIndex])
                            }
                        }
                        Text {
                            text: cockpit.trendWindow === 0 ? "ALL" : cockpit.trendWindow
                            color: "#7fdcff"
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: cockpit.recordedFrames + " " + root.t("recorded_frames")
                            color: "#8fa5ae"
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        color: "#071014"
                        border.width: 1
                        border.color: "#52646d"
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            Text { text: root.t("sensors"); color: "#f1c75b"; Layout.fillWidth: true }
                            Text { text: root.t("latest"); color: "#8fa5ae"; Layout.preferredWidth: 115 }
                            Text { text: root.t("mean"); color: "#8fa5ae"; Layout.preferredWidth: 115 }
                            Text { text: root.t("minimum"); color: "#8fa5ae"; Layout.preferredWidth: 100 }
                            Text { text: root.t("maximum"); color: "#8fa5ae"; Layout.preferredWidth: 100 }
                            Text { text: root.t("delta"); color: "#8fa5ae"; Layout.preferredWidth: 100 }
                            Text { text: root.t("slope"); color: "#8fa5ae"; Layout.preferredWidth: 110 }
                            Text { text: root.t("quality"); color: "#8fa5ae"; Layout.preferredWidth: 120 }
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 6
                        clip: true
                        model: cockpit.trendRows
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: 62
                            color: "#081216"
                            border.width: 1
                            border.color: modelData.quality >= 99.9 ? "#39ff9b" : (modelData.quality >= 90 ? "#ffb000" : "#ff5a5f")
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                Text { text: modelData.label; color: "#d4e2e7"; Layout.fillWidth: true; font.bold: true }
                                Text { text: Number(modelData.latest).toFixed(2) + " " + modelData.unit; color: "#7fdcff"; Layout.preferredWidth: 115 }
                                Text { text: Number(modelData.mean).toFixed(2); color: "#d4e2e7"; Layout.preferredWidth: 115 }
                                Text { text: Number(modelData.minimum).toFixed(2); color: "#d4e2e7"; Layout.preferredWidth: 100 }
                                Text { text: Number(modelData.maximum).toFixed(2); color: "#d4e2e7"; Layout.preferredWidth: 100 }
                                Text { text: Number(modelData.delta).toFixed(2); color: Math.abs(modelData.delta) > 0.001 ? "#f1c75b" : "#8fa5ae"; Layout.preferredWidth: 100 }
                                Text { text: Number(modelData.slope).toFixed(3); color: "#d4e2e7"; Layout.preferredWidth: 110 }
                                Text { text: Number(modelData.quality).toFixed(1) + "%"; color: modelData.quality >= 99.9 ? "#39ff9b" : (modelData.quality >= 90 ? "#ffb000" : "#ff5a5f"); Layout.preferredWidth: 120; font.bold: true }
                            }
                        }
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            text: root.t("simulation_only")
            color: "#748990"
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
