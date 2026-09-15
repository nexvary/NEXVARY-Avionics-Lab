import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
import "AirspaceData.js" as AirspaceData
import "AirspaceLocale.js" as AirspaceLocale

Item {
    id: page
    clip: true
    property string filterText: ""
    property string metarStations: "HEAX,HECA,HELX,HEGN,HESH,HESN"

    function classCount(code) {
        var count = 0
        for (var i = 0; i < AirspaceData.zones.length; ++i)
            if (AirspaceData.zones[i].classCode === code) count++
        return count
    }

    function matches(value) {
        if (!filterText || filterText.length === 0) return true
        return String(value).toLowerCase().indexOf(filterText.toLowerCase()) >= 0
    }

    function classColor(code) {
        if (code === "A") return Theme.royalGold
        if (code === "B") return Theme.rfViolet
        if (code === "C") return Theme.signalCyan
        if (code === "D") return Theme.warmOrange
        if (code === "E") return Theme.skyBlue
        if (code === "F") return Theme.amber
        return Theme.radarGreen
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 7
        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 76
            color: Theme.panel
            border.color: Theme.royalGold
            border.width: 1
            radius: Theme.radius

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12
                layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                Rectangle { width: 4; Layout.fillHeight: true; radius: 2; color: Theme.royalGold }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: cockpit.rtl ? "مركز البيانات الملاحية الجوية" : "AERONAUTICAL DATA HUB"
                        color: Theme.platinum
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.pageTitlePx
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                    Text {
                        text: cockpit.rtl ? "المجال الجوي • المطارات • METAR عام • حالة المدارج المرخصة • مصدر وتدقيق" : "AIRSPACE • AERODROMES • PUBLIC METAR • LICENSED RUNWAY CONDITIONS • PROVENANCE"
                        color: Theme.royalGold
                        font.family: Theme.uiFont(cockpit.rtl)
                        font.pixelSize: Theme.secondaryPx
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        horizontalAlignment: cockpit.rtl ? Text.AlignRight : Text.AlignLeft
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 265
                    Layout.preferredHeight: 48
                    color: Theme.panel2
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 7
                        spacing: 1
                        Text { text: "DATASET HEALTH  •  READ ONLY"; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                        Text { text: "SOURCE + LICENSE + FRESHNESS"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 86
            spacing: 7
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
            Repeater {
                model: [
                    {title: cockpit.rtl ? "قطاعات المجال" : "AIRSPACE ZONES", value: AirspaceData.zones.length, color: Theme.signalCyan, sub:"SYNTHETIC"},
                    {title: cockpit.rtl ? "مطارات مرجعية" : "AERODROMES", value: AirspaceData.airports.length, color: Theme.royalGold, sub:"INDEXED"},
                    {title: cockpit.rtl ? "محطات METAR" : "METAR STATIONS", value: cockpit.aerodromeWeatherCount, color: Theme.radarGreen, sub:"READ ONLY"},
                    {title: cockpit.rtl ? "تقارير المدارج" : "RUNWAY REPORTS", value: cockpit.runwayConditionCount, color: Theme.warmOrange, sub:"LICENSED"}
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 1
                        Text { text: modelData.title; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true }
                        Text { text: String(modelData.value); color: modelData.color; font.family: Theme.mono; font.pixelSize: 22; font.bold: true }
                        Text { text: modelData.sub; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 7
            layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 620
                color: Theme.panel
                border.color: Theme.border
                border.width: 1
                radius: Theme.radius

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 9
                    spacing: 6
                    RowLayout {
                        Layout.fillWidth: true
                        layoutDirection: cockpit.rtl ? Qt.RightToLeft : Qt.LeftToRight
                        Text { text: cockpit.rtl ? "كتالوج المجال الجوي" : "AIRSPACE CATALOG"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                        TextField {
                            id: searchBox
                            objectName: "aeronauticalDataFilter"
                            Layout.preferredWidth: 220
                            placeholderText: cockpit.rtl ? "بحث" : "FILTER"
                            color: Theme.platinum
                            placeholderTextColor: Theme.muted
                            font.family: Theme.uiFont(cockpit.rtl)
                            font.pixelSize: Theme.smallPx
                            background: Rectangle { color: Theme.panel2; border.color: searchBox.activeFocus ? Theme.royalGold : Theme.borderSoft; border.width: 1; radius: Theme.radius }
                            onTextChanged: page.filterText = text
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 52
                        spacing: 5
                        Repeater {
                            model: ["A","B","C","D","E","F","G"]
                            delegate: Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: Theme.panel2
                                border.color: page.classColor(modelData)
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 0
                                    Text { text: modelData; color: page.classColor(modelData); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: String(page.classCount(modelData)); color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.alignment: Qt.AlignHCenter }
                                }
                            }
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: AirspaceData.zones
                        clip: true
                        spacing: 4
                        delegate: Rectangle {
                            required property var modelData
                            width: ListView.view.width
                            height: page.matches(modelData.name) || page.matches(modelData.id) || page.matches(modelData.classCode) ? 70 : 0
                            visible: height > 0
                            color: Theme.panel2
                            border.color: page.classColor(modelData.classCode)
                            border.width: 1
                            radius: Theme.radius
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 7
                                spacing: 8
                                Rectangle {
                                    width: 34; height: 34; radius: 17
                                    color: Theme.panel3
                                    border.color: page.classColor(modelData.classCode)
                                    border.width: 1
                                    Text { anchors.centerIn: parent; text: modelData.classCode; color: page.classColor(modelData.classCode); font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 1
                                    Text { text: modelData.name; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.note; color: Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { text: modelData.floor + " → " + modelData.ceiling + "  •  " + (modelData.controlled ? AirspaceLocale.controlled(cockpit.language) : AirspaceLocale.uncontrolled(cockpit.language)); color: page.classColor(modelData.classCode); font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                                }
                                Rectangle {
                                    Layout.preferredWidth: 126
                                    Layout.preferredHeight: 36
                                    color: Theme.panel3
                                    border.color: Theme.borderSoft
                                    border.width: 1
                                    radius: Theme.radius
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 4
                                        spacing: 0
                                        Text { text: modelData.id; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                                        Text { text: modelData.controlled ? "CONTROLLED" : "ADVISORY"; color: modelData.controlled ? Theme.radarGreen : Theme.amber; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 445
                Layout.minimumWidth: 405
                Layout.maximumWidth: 475
                Layout.fillHeight: true
                spacing: 7

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "طقس المطارات العام" : "PUBLIC AERODROME WEATHER"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.sectionPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: "METAR"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                        }
                        Text { text: cockpit.aerodromeWeatherSource; color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: cockpit.aerodromeWeatherStatus; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Button {
                                objectName: "refreshPublicMetarButton"
                                Layout.fillWidth: true
                                Layout.preferredHeight: 34
                                text: cockpit.rtl ? "تحديث METAR العام" : "REFRESH PUBLIC METAR"
                                onClicked: cockpit.fetchPublicAerodromeWeather(page.metarStations)
                                contentItem: Text { text: parent.text; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                background: Rectangle { color: Theme.panel2; border.color: Theme.royalGold; border.width: 1; radius: Theme.radius }
                            }
                            Button {
                                Layout.preferredWidth: 72
                                Layout.preferredHeight: 34
                                text: "CLEAR"
                                onClicked: cockpit.clearAerodromeConditions()
                                contentItem: Text { text: parent.text; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                background: Rectangle { color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 210
                    color: Theme.panel
                    border.color: Theme.border
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "ملاحظات METAR" : "METAR OBSERVATIONS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.aerodromeWeatherCount); color: Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                        }
                        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.aerodromeWeatherCount > 0 ? cockpit.aerodromeWeatherRows : AirspaceData.airports
                            clip: true
                            spacing: 4
                            delegate: Rectangle {
                                required property var modelData
                                width: ListView.view.width
                                height: cockpit.aerodromeWeatherCount > 0 ? 82 : 52
                                color: Theme.panel2
                                border.color: Theme.borderSoft
                                border.width: 1
                                radius: Theme.radius
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 2
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Text { text: modelData.icao || modelData.code || "—"; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.preferredWidth: 62 }
                                        Text { text: modelData.flightCategory || modelData.name || "AWAITING PUBLIC METAR"; color: cockpit.aerodromeWeatherCount > 0 ? Theme.radarGreen : Theme.silver; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true; elide: Text.ElideRight }
                                        Text { text: modelData.cacheState || "STATIC"; color: modelData.cacheState === "STALE" ? Theme.amber : Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                                    }
                                    Text { visible: cockpit.aerodromeWeatherCount > 0; text: "WIND " + Math.round(Number(modelData.windDirectionDegrees || 0)) + "° / " + Math.round(Number(modelData.windSpeedKnots || 0)) + " kt  •  VIS " + Number(modelData.visibilityStatuteMiles || 0).toFixed(1) + " sm"; color: Theme.silver; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                    Text { visible: cockpit.aerodromeWeatherCount > 0; text: modelData.rawMetar || "NO RAW METAR"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 208
                    color: Theme.panel
                    border.color: Theme.royalGold
                    border.width: 1
                    radius: Theme.radius
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: 5
                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: cockpit.rtl ? "حالة المدارج المرخصة" : "LICENSED RUNWAY CONDITIONS"; color: Theme.platinum; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true; Layout.fillWidth: true }
                            Text { text: String(cockpit.runwayConditionCount); color: Theme.warmOrange; font.family: Theme.mono; font.pixelSize: Theme.secondaryPx; font.bold: true }
                        }
                        TextField {
                            id: conditionUrl
                            objectName: "licensedRunwayConditionUrl"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 34
                            placeholderText: cockpit.rtl ? "رابط HTTPS لمصدر حالة المدارج المرخص" : "LICENSED HTTPS RUNWAY CONDITION SOURCE"
                            color: Theme.platinum
                            placeholderTextColor: Theme.muted
                            font.family: Theme.mono
                            font.pixelSize: Theme.smallPx
                            selectByMouse: true
                            background: Rectangle { color: Theme.panel2; border.color: conditionUrl.activeFocus ? Theme.royalGold : Theme.border; border.width: 1; radius: Theme.radius }
                        }
                        Button {
                            objectName: "fetchLicensedRunwayConditionsButton"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 32
                            text: cockpit.rtl ? "جلب حالة المدارج" : "FETCH LICENSED CONDITIONS"
                            enabled: conditionUrl.text.trim().length > 0
                            onClicked: cockpit.fetchLicensedAerodromeConditions(conditionUrl.text)
                            contentItem: Text { text: parent.text; color: parent.enabled ? Theme.platinum : Theme.muted; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                            background: Rectangle { color: Theme.panel2; border.color: parent.enabled ? Theme.royalGold : Theme.border; border.width: 1; radius: Theme.radius }
                        }
                        Text { text: cockpit.runwayConditionSource; color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: cockpit.runwayConditionStatus; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            model: cockpit.runwayConditionRows
                            clip: true
                            spacing: 3
                            delegate: RowLayout {
                                required property var modelData
                                width: ListView.view.width
                                spacing: 6
                                Text { text: modelData.icao + " / " + modelData.runway; color: Theme.platinum; font.family: Theme.mono; font.pixelSize: Theme.smallPx; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.closed ? "CLOSED" : (modelData.state || "OPEN"); color: modelData.closed ? Theme.red : Theme.radarGreen; font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true }
                                Text { text: modelData.cacheState || "—"; color: modelData.cacheState === "STALE" ? Theme.amber : Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            color: Theme.panel
            border.color: Theme.border
            border.width: 1
            radius: Theme.radius
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 10
                Rectangle { width: 8; height: 8; radius: 4; color: Theme.radarGreen }
                Text { text: cockpit.rtl ? "METAR عام للوعي فقط • بيانات المجال التدريبي ليست خريطة ملاحية رسمية" : "PUBLIC METAR FOR AWARENESS • TRAINING AIRSPACE IS NOT AN OFFICIAL NAVIGATION CHART"; color: Theme.radarGreen; font.family: Theme.uiFont(cockpit.rtl); font.pixelSize: Theme.smallPx; font.bold: true; Layout.fillWidth: true }
                Text { text: "PROVENANCE • LICENSE • FRESHNESS • READ ONLY"; color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.smallPx }
            }
        }
    }
}
