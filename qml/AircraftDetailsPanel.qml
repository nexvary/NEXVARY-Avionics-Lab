import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme

Rectangle {
    id: root
    objectName: "aircraftDetailsPanel"
    property var track: ({})
    property bool rtl: false
    signal closeRequested()

    color: "#080808"
    border.color: Theme.royalGold
    border.width: Theme.activeFrameWidth
    radius: Theme.radius

    function value(key) {
        var v = track ? track[key] : undefined
        return v === undefined || v === null || String(v).trim() === "" ? "N/A" : String(v)
    }
    function numberValue(key, decimals, suffix) {
        var v = track ? track[key] : undefined
        if (v === undefined || v === null || isNaN(Number(v))) return "N/A"
        return Number(v).toFixed(decimals) + suffix
    }
    function routeLabel() {
        if (value("route") !== "N/A") return value("route")
        var origin = value("originAirportIata") !== "N/A" ? value("originAirportIata") : value("originAirportIcao")
        var destination = value("destinationAirportIata") !== "N/A" ? value("destinationAirportIata") : value("destinationAirportIcao")
        return origin !== "N/A" || destination !== "N/A" ? origin + " → " + destination : "N/A"
    }
    function qualityState() {
        var source = value("telemetrySource").toUpperCase()
        if (source.indexOf("DEMO") >= 0 || source.indexOf("SYNTHETIC") >= 0) return rtl ? "بيانات تدريبية" : "SIMULATION DATA"
        var age = Number(track ? track.dataAgeSeconds : NaN)
        if (!isFinite(age)) return rtl ? "حداثة غير معروفة" : "FRESHNESS UNKNOWN"
        if (age <= 15) return rtl ? "حديث" : "RECENT"
        if (age <= 60) return rtl ? "متأخر" : "DELAYED"
        return rtl ? "قديم" : "STALE"
    }
    function sections() {
        return [
            {titleEn:"IDENTIFICATION", titleAr:"التعريف", rows:[
                {en:"Callsign", ar:"نداء الرحلة", value:value("callsign")},
                {en:"Flight", ar:"رقم الرحلة", value:value("flightNumber")},
                {en:"Registration", ar:"التسجيل", value:value("registration")},
                {en:"ICAO24 / HEX", ar:"رمز ICAO24 / HEX", value:value("icao24").toUpperCase()},
                {en:"ICAO Type", ar:"نوع ICAO", value:value("aircraftTypeCode")}
            ]},
            {titleEn:"OPERATOR", titleAr:"المشغّل", rows:[
                {en:"Operator", ar:"اسم المشغّل", value:value("operatorName")},
                {en:"Marketing operator", ar:"المشغّل التجاري", value:value("marketingOperator")},
                {en:"ICAO / IATA", ar:"ICAO / IATA", value:value("operatorIcao") + " / " + value("operatorIata")},
                {en:"Registration country", ar:"دولة التسجيل", value:value("registrationCountry") !== "N/A" ? value("registrationCountry") : value("country")}
            ]},
            {titleEn:"FLIGHT", titleAr:"الرحلة", rows:[
                {en:"Route", ar:"المسار", value:routeLabel()},
                {en:"Scheduled departure", ar:"الإقلاع المجدول", value:value("scheduledDeparture")},
                {en:"Estimated arrival", ar:"الوصول المتوقع", value:value("estimatedArrival")}
            ]},
            {titleEn:"CURRENT TELEMETRY", titleAr:"القياسات الحالية", rows:[
                {en:"Position", ar:"الموقع", value:numberValue("latitude", 4, "°") + "  /  " + numberValue("longitude", 4, "°")},
                {en:"Barometric altitude", ar:"الارتفاع الضغطي", value:numberValue("altitudeMeters", 0, " m")},
                {en:"Geometric altitude", ar:"الارتفاع الهندسي", value:numberValue("geometricAltitudeMeters", 0, " m")},
                {en:"Ground speed", ar:"السرعة الأرضية", value:numberValue("velocityMetersPerSecond", 1, " m/s")},
                {en:"True airspeed", ar:"السرعة الجوية الحقيقية", value:numberValue("trueAirspeedMetersPerSecond", 1, " m/s")},
                {en:"Track", ar:"الاتجاه", value:numberValue("headingDegrees", 0, "°")},
                {en:"Vertical rate", ar:"معدل الصعود/الهبوط", value:numberValue("verticalRateMetersPerSecond", 1, " m/s")},
                {en:"Squawk", ar:"رمز Squawk", value:value("squawk")},
                {en:"Data age", ar:"عمر البيانات", value:numberValue("dataAgeSeconds", 0, " s")}
            ]},
            {titleEn:"AIRCRAFT INFORMATION", titleAr:"معلومات الطائرة", rows:[
                {en:"Manufacturer", ar:"المصنّع", value:value("manufacturer")},
                {en:"Model", ar:"الطراز", value:value("aircraftModel")},
                {en:"Family / variant", ar:"العائلة / النسخة", value:value("aircraftFamily") + " / " + value("variant")},
                {en:"Engine", ar:"المحرك", value:value("engineType")},
                {en:"Serial / year", ar:"الرقم التسلسلي / السنة", value:value("serialNumber") + " / " + value("yearBuilt")},
                {en:"Registration state", ar:"حالة التسجيل", value:value("registrationStatus")}
            ]},
            {titleEn:"PROVENANCE & CACHE", titleAr:"المصدر والترخيص والتخزين", rows:[
                {en:"Live telemetry", ar:"القياسات الحية", value:value("telemetrySource")},
                {en:"Aircraft metadata", ar:"بيانات الطائرة", value:value("metadataSource")},
                {en:"Metadata license", ar:"ترخيص بيانات الطائرة", value:value("metadataLicense")},
                {en:"Route metadata", ar:"بيانات المسار", value:value("routeSource")},
                {en:"Route license", ar:"ترخيص بيانات المسار", value:value("routeLicense")},
                {en:"Enrichment cache", ar:"حالة التخزين المؤقت", value:value("enrichmentCacheState")},
                {en:"Position mode", ar:"نمط الموقع", value:value("positionSource")},
                {en:"Signal quality", ar:"جودة الإشارة", value:numberValue("signalQualityPercent", 0, "%")}
            ]}
        ]
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            layoutDirection: root.rtl ? Qt.RightToLeft : Qt.LeftToRight
            Rectangle { width: 4; Layout.preferredHeight: 44; radius: 2; color: Theme.royalGold }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Text {
                    text: root.value("callsign") !== "N/A" ? root.value("callsign") : root.value("icao24").toUpperCase()
                    color: Theme.platinum; font.family: Theme.uiFont(root.rtl); font.pixelSize: 19; font.bold: true
                    Layout.fillWidth: true; horizontalAlignment: root.rtl ? Text.AlignRight : Text.AlignLeft
                }
                Text {
                    text: root.value("aircraftTypeCode") + "  •  " + root.value("registration")
                    color: Theme.royalGold; font.family: Theme.mono; font.pixelSize: Theme.smallPx
                    Layout.fillWidth: true; horizontalAlignment: root.rtl ? Text.AlignRight : Text.AlignLeft
                }
            }
            Button {
                Layout.preferredWidth: 74; Layout.preferredHeight: 36
                text: root.rtl ? "إغلاق" : "CLOSE"
                onClicked: root.closeRequested()
                contentItem: Text { text: parent.text; color: Theme.platinum; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                background: Rectangle { color: Theme.panel2; border.color: Theme.border; border.width: 1; radius: Theme.radius }
            }
            Rectangle {
                Layout.preferredWidth: 118; Layout.preferredHeight: 32; radius: Theme.radius
                color: "#111111"; border.color: root.qualityState() === "STALE" || root.qualityState() === "قديم" ? Theme.amber : Theme.radarGreen; border.width: 1
                Text { anchors.centerIn: parent; text: root.qualityState(); color: parent.border.color; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx; font.bold: true }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.royalGold; opacity: .8 }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ColumnLayout {
                width: Math.max(0, parent.width - 12)
                spacing: 7
                Repeater {
                    model: root.sections()
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: sectionContent.implicitHeight + 18
                        color: "#111111"
                        border.color: Theme.borderSoft
                        border.width: 1
                        radius: Theme.radius

                        ColumnLayout {
                            id: sectionContent
                            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
                            anchors.margins: 9
                            spacing: 4
                            Text {
                                text: root.rtl ? modelData.titleAr : modelData.titleEn
                                color: Theme.royalGold; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.secondaryPx; font.bold: true
                                Layout.fillWidth: true; horizontalAlignment: root.rtl ? Text.AlignRight : Text.AlignLeft
                            }
                            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.borderSoft }
                            Repeater {
                                model: modelData.rows
                                delegate: RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    layoutDirection: root.rtl ? Qt.RightToLeft : Qt.LeftToRight
                                    spacing: 8
                                    Text {
                                        text: root.rtl ? modelData.ar : modelData.en
                                        color: Theme.muted; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx
                                        Layout.preferredWidth: 142; horizontalAlignment: root.rtl ? Text.AlignRight : Text.AlignLeft
                                    }
                                    Text {
                                        text: modelData.value
                                        color: modelData.value === "N/A" || String(modelData.value).indexOf("N/A / N/A") >= 0 ? Theme.muted : Theme.platinum
                                        font.family: Theme.mono; font.pixelSize: Theme.smallPx; font.bold: true
                                        Layout.fillWidth: true; horizontalAlignment: root.rtl ? Text.AlignLeft : Text.AlignRight
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Text {
            text: root.rtl ? "مصادر عامة/مرخصة • توعية سلبية • دون تحكم بالطائرة" : "PUBLIC/LICENSED SOURCES • PASSIVE AWARENESS • NO AIRCRAFT CONTROL"
            color: Theme.radarGreen; font.family: Theme.uiFont(root.rtl); font.pixelSize: Theme.smallPx; font.bold: true
            Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter
        }
    }
}
