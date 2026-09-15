#include "qt/CockpitBridge.hpp"

#include <QDateTime>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QUrlQuery>
#include <QVariantMap>
#include <QSet>

namespace nexvary::avionics {
namespace {
constexpr qint64 kMaximumAerodromePayloadBytes = 2 * 1024 * 1024;
constexpr int kMaximumStationIdsPerRequest = 20;

bool validHttpsUrl(const QString& urlText, QUrl& url) {
    url = QUrl(urlText.trimmed());
    return url.isValid() && !url.host().isEmpty() &&
           url.scheme().compare(QStringLiteral("https"), Qt::CaseInsensitive) == 0;
}

QStringList sanitizedStationIds(const QString& csv) {
    QStringList result;
    QSet<QString> seen;
    const auto raw = csv.split(',', Qt::SkipEmptyParts);
    for (const auto& item : raw) {
        const auto id = item.trimmed().toUpper();
        if (id.size() != 4) continue;
        bool valid = true;
        for (const auto ch : id) {
            if (!ch.isLetterOrNumber()) {
                valid = false;
                break;
            }
        }
        if (!valid || seen.contains(id)) continue;
        seen.insert(id);
        result.push_back(id);
        if (result.size() >= kMaximumStationIdsPerRequest) break;
    }
    return result;
}

QVariantMap weatherRow(const AerodromeWeatherObservation& item,
                       const AerodromeConditionProviderInfo& provider) {
    QVariantMap row;
    row[QStringLiteral("icao")] = QString::fromStdString(item.airportIcao);
    row[QStringLiteral("iata")] = QString::fromStdString(item.airportIata);
    row[QStringLiteral("name")] = QString::fromStdString(item.airportName);
    row[QStringLiteral("observedAt")] = QString::fromStdString(item.observedAt);
    row[QStringLiteral("rawMetar")] = QString::fromStdString(item.rawMetar);
    row[QStringLiteral("flightCategory")] = QString::fromStdString(item.flightCategory);
    row[QStringLiteral("weather")] = QString::fromStdString(item.weatherPhenomena);
    row[QStringLiteral("skyCover")] = QString::fromStdString(item.skyCover);
    row[QStringLiteral("cacheState")] = QString::fromStdString(item.cacheState);
    row[QStringLiteral("source")] = QString::fromStdString(provider.name);
    row[QStringLiteral("license")] = QString::fromStdString(provider.license);
    row[QStringLiteral("sourceUrl")] = QString::fromStdString(provider.sourceUrl);
    if (item.observedAtEpoch) row[QStringLiteral("observedAtEpoch")] = QVariant::fromValue<qlonglong>(*item.observedAtEpoch);
    if (item.windDirectionDegrees) row[QStringLiteral("windDirectionDegrees")] = *item.windDirectionDegrees;
    if (item.windSpeedKnots) row[QStringLiteral("windSpeedKnots")] = *item.windSpeedKnots;
    if (item.windGustKnots) row[QStringLiteral("windGustKnots")] = *item.windGustKnots;
    if (item.visibilityStatuteMiles) row[QStringLiteral("visibilityStatuteMiles")] = *item.visibilityStatuteMiles;
    if (item.ceilingFeet) row[QStringLiteral("ceilingFeet")] = *item.ceilingFeet;
    if (item.temperatureCelsius) row[QStringLiteral("temperatureCelsius")] = *item.temperatureCelsius;
    if (item.dewpointCelsius) row[QStringLiteral("dewpointCelsius")] = *item.dewpointCelsius;
    if (item.altimeterInHg) row[QStringLiteral("altimeterInHg")] = *item.altimeterInHg;
    if (item.cachedAtEpoch) row[QStringLiteral("cachedAtEpoch")] = QVariant::fromValue<qlonglong>(*item.cachedAtEpoch);
    if (item.expiresAtEpoch) row[QStringLiteral("expiresAtEpoch")] = QVariant::fromValue<qlonglong>(*item.expiresAtEpoch);
    return row;
}

QVariantMap runwayRow(const RunwayConditionObservation& item,
                      const AerodromeConditionProviderInfo& provider) {
    QVariantMap row;
    row[QStringLiteral("icao")] = QString::fromStdString(item.airportIcao);
    row[QStringLiteral("runway")] = QString::fromStdString(item.runway);
    row[QStringLiteral("state")] = QString::fromStdString(item.state);
    row[QStringLiteral("surface")] = QString::fromStdString(item.surface);
    row[QStringLiteral("brakingAction")] = QString::fromStdString(item.brakingAction);
    row[QStringLiteral("contamination")] = QString::fromStdString(item.contamination);
    row[QStringLiteral("observedAt")] = QString::fromStdString(item.observedAt);
    row[QStringLiteral("cacheState")] = QString::fromStdString(item.cacheState);
    row[QStringLiteral("closed")] = item.closed;
    row[QStringLiteral("source")] = QString::fromStdString(provider.name);
    row[QStringLiteral("license")] = QString::fromStdString(provider.license);
    row[QStringLiteral("sourceUrl")] = QString::fromStdString(provider.sourceUrl);
    if (item.observedAtEpoch) row[QStringLiteral("observedAtEpoch")] = QVariant::fromValue<qlonglong>(*item.observedAtEpoch);
    if (item.runwayConditionCode) row[QStringLiteral("runwayConditionCode")] = *item.runwayConditionCode;
    if (item.frictionCoefficient) row[QStringLiteral("frictionCoefficient")] = *item.frictionCoefficient;
    if (item.cachedAtEpoch) row[QStringLiteral("cachedAtEpoch")] = QVariant::fromValue<qlonglong>(*item.cachedAtEpoch);
    if (item.expiresAtEpoch) row[QStringLiteral("expiresAtEpoch")] = QVariant::fromValue<qlonglong>(*item.expiresAtEpoch);
    return row;
}
}

QVariantList CockpitBridge::aerodromeWeatherRows() const {
    QVariantList rows;
    QSet<QString> seen;
    const auto append = [&](const AerodromeConditionFeed& feed) {
        const auto& provider = feed.provider();
        for (const auto& item : feed.snapshot().weather) {
            const auto key = QString::fromStdString(item.airportIcao).toUpper();
            if (key.isEmpty() || seen.contains(key)) continue;
            seen.insert(key);
            rows.push_back(weatherRow(item, provider));
        }
    };
    append(publicAerodromeWeather_);
    append(licensedAerodromeConditions_);
    return rows;
}

QVariantList CockpitBridge::runwayConditionRows() const {
    QVariantList rows;
    const auto& provider = licensedAerodromeConditions_.provider();
    for (const auto& item : licensedAerodromeConditions_.snapshot().runways) {
        rows.push_back(runwayRow(item, provider));
    }
    return rows;
}

QString CockpitBridge::aerodromeWeatherSource() const {
    if (publicAerodromeWeather_.weatherCount() > 0)
        return QString::fromStdString(publicAerodromeWeather_.provider().name);
    if (licensedAerodromeConditions_.weatherCount() > 0)
        return QString::fromStdString(licensedAerodromeConditions_.provider().name);
    return QStringLiteral("NONE");
}

QString CockpitBridge::aerodromeWeatherStatus() const { return aerodromeWeatherStatus_; }

QString CockpitBridge::runwayConditionSource() const {
    if (licensedAerodromeConditions_.runwayCount() == 0) return QStringLiteral("NONE");
    return QString::fromStdString(licensedAerodromeConditions_.provider().name);
}

QString CockpitBridge::runwayConditionStatus() const { return runwayConditionStatus_; }

int CockpitBridge::aerodromeWeatherCount() const noexcept {
    QSet<QString> airports;
    for (const auto& item : publicAerodromeWeather_.snapshot().weather)
        airports.insert(QString::fromStdString(item.airportIcao).toUpper());
    for (const auto& item : licensedAerodromeConditions_.snapshot().weather)
        airports.insert(QString::fromStdString(item.airportIcao).toUpper());
    return airports.size();
}

int CockpitBridge::runwayConditionCount() const noexcept {
    return static_cast<int>(licensedAerodromeConditions_.runwayCount());
}

void CockpitBridge::fetchPublicAerodromeWeather(const QString& airportIdsCsv) {
    const auto ids = sanitizedStationIds(airportIdsCsv);
    if (ids.isEmpty()) {
        aerodromeWeatherStatus_ = QStringLiteral("METAR REQUEST REJECTED / VALID 4-CHAR ICAO IDS REQUIRED");
        emit dataChanged();
        return;
    }

    if (!publicFlightNetwork_) publicFlightNetwork_ = new QNetworkAccessManager(this);
    QUrl url(QStringLiteral("https://aviationweather.gov/api/data/metar"));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("ids"), ids.join(','));
    query.addQueryItem(QStringLiteral("format"), QStringLiteral("json"));
    url.setQuery(query);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader,
                      QStringLiteral("NEXVARY-Avionics-Lab/3.5 public-metar-read-only"));
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute,
                         QNetworkRequest::NoLessSafeRedirectPolicy);
    aerodromeWeatherStatus_ = QStringLiteral("FETCHING PUBLIC METAR / %1 STATIONS").arg(ids.size());
    emit dataChanged();

    QNetworkReply* reply = publicFlightNetwork_->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            aerodromeWeatherStatus_ = QStringLiteral("METAR ERROR: %1").arg(reply->errorString());
            reply->deleteLater();
            emit dataChanged();
            return;
        }
        const QByteArray payload = reply->readAll();
        reply->deleteLater();
        if (payload.size() > kMaximumAerodromePayloadBytes) {
            aerodromeWeatherStatus_ = QStringLiteral("METAR REJECTED / PAYLOAD TOO LARGE");
            emit dataChanged();
            return;
        }
        try {
            publicAerodromeWeather_ = AerodromeConditionFeed::fromAviationWeatherMetarJson(
                payload.toStdString(), QDateTime::currentSecsSinceEpoch());
            aerodromeWeatherStatus_ = QStringLiteral("PUBLIC METAR ACTIVE / %1 STATIONS / READ ONLY")
                .arg(aerodromeWeatherCount());
        } catch (const std::exception& error) {
            aerodromeWeatherStatus_ = QStringLiteral("METAR PARSE ERROR: %1").arg(QString::fromUtf8(error.what()));
        }
        emit dataChanged();
    });
}

bool CockpitBridge::loadAerodromeConditionFile(const QString& path) {
    try {
        licensedAerodromeConditions_ = AerodromeConditionFeed::fromFile(
            path.toStdString(), QDateTime::currentSecsSinceEpoch());
        const auto& provider = licensedAerodromeConditions_.provider();
        runwayConditionStatus_ = QStringLiteral("LICENSED CONDITIONS LOADED / %1 / %2 RUNWAYS")
            .arg(QString::fromStdString(provider.name))
            .arg(runwayConditionCount());
        if (licensedAerodromeConditions_.weatherCount() > 0 && publicAerodromeWeather_.weatherCount() == 0) {
            aerodromeWeatherStatus_ = QStringLiteral("LICENSED WEATHER LOADED / %1 STATIONS")
                .arg(aerodromeWeatherCount());
        }
        emit dataChanged();
        return true;
    } catch (const std::exception& error) {
        runwayConditionStatus_ = QStringLiteral("CONDITION IMPORT REJECTED: %1").arg(QString::fromUtf8(error.what()));
        emit dataChanged();
        return false;
    }
}

void CockpitBridge::fetchLicensedAerodromeConditions(const QString& urlText) {
    QUrl url;
    if (!validHttpsUrl(urlText, url)) {
        runwayConditionStatus_ = QStringLiteral("URL REJECTED / HTTPS LICENSED CONDITION SOURCE REQUIRED");
        emit dataChanged();
        return;
    }
    if (!publicFlightNetwork_) publicFlightNetwork_ = new QNetworkAccessManager(this);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader,
                      QStringLiteral("NEXVARY-Avionics-Lab/3.5 runway-condition-read-only"));
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute,
                         QNetworkRequest::NoLessSafeRedirectPolicy);
    runwayConditionStatus_ = QStringLiteral("FETCHING LICENSED AERODROME CONDITIONS");
    emit dataChanged();

    QNetworkReply* reply = publicFlightNetwork_->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            runwayConditionStatus_ = QStringLiteral("CONDITION ERROR: %1").arg(reply->errorString());
            reply->deleteLater();
            emit dataChanged();
            return;
        }
        const QByteArray payload = reply->readAll();
        reply->deleteLater();
        if (payload.size() > kMaximumAerodromePayloadBytes) {
            runwayConditionStatus_ = QStringLiteral("CONDITION REJECTED / PAYLOAD TOO LARGE");
            emit dataChanged();
            return;
        }
        try {
            licensedAerodromeConditions_ = AerodromeConditionFeed::fromJson(
                payload.toStdString(), QDateTime::currentSecsSinceEpoch());
            runwayConditionStatus_ = QStringLiteral("LICENSED CONDITIONS ACTIVE / %1 / %2 RUNWAYS")
                .arg(QString::fromStdString(licensedAerodromeConditions_.provider().name))
                .arg(runwayConditionCount());
            if (licensedAerodromeConditions_.weatherCount() > 0 && publicAerodromeWeather_.weatherCount() == 0) {
                aerodromeWeatherStatus_ = QStringLiteral("LICENSED WEATHER ACTIVE / %1 STATIONS")
                    .arg(aerodromeWeatherCount());
            }
        } catch (const std::exception& error) {
            runwayConditionStatus_ = QStringLiteral("CONDITION PARSE ERROR: %1").arg(QString::fromUtf8(error.what()));
        }
        emit dataChanged();
    });
}

void CockpitBridge::clearAerodromeConditions() {
    publicAerodromeWeather_ = AerodromeConditionFeed{};
    licensedAerodromeConditions_ = AerodromeConditionFeed{};
    aerodromeWeatherStatus_ = QStringLiteral("PUBLIC METAR NOT LOADED");
    runwayConditionStatus_ = QStringLiteral("NO LICENSED RUNWAY CONDITION SOURCE");
    emit dataChanged();
}

} // namespace nexvary::avionics
