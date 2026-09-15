#include "qt/CockpitBridge.hpp"

#include <QDateTime>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QSet>
#include <QStandardPaths>
#include <QUrl>
#include <QUrlQuery>
#include <QVariantMap>

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

QString cacheStatus(const AerodromeProviderCache& cache) {
    return QString::fromStdString(cache.statusText());
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

void CockpitBridge::initializeAerodromePersistence() {
    if (aerodromePersistenceInitialized_) return;
    aerodromePersistenceInitialized_ = true;

    QString basePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    if (basePath.isEmpty()) basePath = QDir::tempPath() + QStringLiteral("/NEXVARY-Avionics-Lab");
    publicAerodromeWeatherCachePath_ = QDir(basePath).filePath(QStringLiteral("public-metar-last-good.json"));
    licensedAerodromeConditionsCachePath_ = QDir(basePath).filePath(QStringLiteral("licensed-aerodrome-conditions-last-good.json"));
    const auto now = QDateTime::currentSecsSinceEpoch();

    if (QFileInfo::exists(publicAerodromeWeatherCachePath_)) {
        if (publicAerodromeWeatherCache_.restoreLastGood(publicAerodromeWeatherCachePath_.toStdString(), now)) {
            publicAerodromeWeather_ = publicAerodromeWeatherCache_.feed();
            aerodromeWeatherStatus_ = QStringLiteral("%1 / STARTUP RESTORE / %2 STATIONS")
                .arg(cacheStatus(publicAerodromeWeatherCache_))
                .arg(static_cast<qulonglong>(publicAerodromeWeather_.weatherCount()));
        } else {
            aerodromeWeatherStatus_ = QStringLiteral("PUBLIC METAR CACHE RESTORE FAILED / %1")
                .arg(cacheStatus(publicAerodromeWeatherCache_));
        }
    }

    if (QFileInfo::exists(licensedAerodromeConditionsCachePath_)) {
        if (licensedAerodromeConditionsCache_.restoreLastGood(licensedAerodromeConditionsCachePath_.toStdString(), now)) {
            licensedAerodromeConditions_ = licensedAerodromeConditionsCache_.feed();
            runwayConditionStatus_ = QStringLiteral("%1 / STARTUP RESTORE / %2 RUNWAYS")
                .arg(cacheStatus(licensedAerodromeConditionsCache_))
                .arg(static_cast<qulonglong>(licensedAerodromeConditions_.runwayCount()));
            if (publicAerodromeWeather_.weatherCount() == 0 && licensedAerodromeConditions_.weatherCount() > 0) {
                aerodromeWeatherStatus_ = QStringLiteral("LICENSED WEATHER CACHE FALLBACK / STARTUP RESTORE / %1 STATIONS")
                    .arg(static_cast<qulonglong>(licensedAerodromeConditions_.weatherCount()));
            }
        } else {
            runwayConditionStatus_ = QStringLiteral("LICENSED CONDITION CACHE RESTORE FAILED / %1")
                .arg(cacheStatus(licensedAerodromeConditionsCache_));
        }
    }
}

void CockpitBridge::fetchPublicAerodromeWeather(const QString& airportIdsCsv) {
    initializeAerodromePersistence();
    const auto ids = sanitizedStationIds(airportIdsCsv);
    if (ids.isEmpty()) {
        publicAerodromeWeatherCache_.noteRefreshFailure("valid 4-character ICAO station IDs required");
        aerodromeWeatherStatus_ = cacheStatus(publicAerodromeWeatherCache_);
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
    aerodromeWeatherStatus_ = publicAerodromeWeatherCache_.available()
        ? QStringLiteral("FETCHING PUBLIC METAR / LAST GOOD RETAINED UNTIL VERIFIED")
        : QStringLiteral("FETCHING PUBLIC METAR / %1 STATIONS").arg(ids.size());
    emit dataChanged();

    QNetworkReply* reply = publicFlightNetwork_->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            publicAerodromeWeatherCache_.noteRefreshFailure(
                QStringLiteral("network error: %1").arg(reply->errorString()).toStdString());
            aerodromeWeatherStatus_ = cacheStatus(publicAerodromeWeatherCache_);
            reply->deleteLater();
            emit dataChanged();
            return;
        }
        const QByteArray payload = reply->readAll();
        reply->deleteLater();
        if (payload.size() > kMaximumAerodromePayloadBytes) {
            publicAerodromeWeatherCache_.noteRefreshFailure("public METAR payload exceeds configured cache limit");
            aerodromeWeatherStatus_ = cacheStatus(publicAerodromeWeatherCache_);
            emit dataChanged();
            return;
        }

        const auto now = QDateTime::currentSecsSinceEpoch();
        if (!publicAerodromeWeatherCache_.refreshFromJson(payload.toStdString(), now)) {
            aerodromeWeatherStatus_ = cacheStatus(publicAerodromeWeatherCache_);
            emit dataChanged();
            return;
        }
        publicAerodromeWeather_ = publicAerodromeWeatherCache_.feed();
        if (!publicAerodromeWeatherCachePath_.isEmpty())
            publicAerodromeWeatherCache_.persistLastGood(publicAerodromeWeatherCachePath_.toStdString());
        aerodromeWeatherStatus_ = QStringLiteral("%1 / %2 STATIONS / READ ONLY")
            .arg(cacheStatus(publicAerodromeWeatherCache_))
            .arg(static_cast<qulonglong>(publicAerodromeWeather_.weatherCount()));
        emit dataChanged();
    });
}

bool CockpitBridge::loadAerodromeConditionFile(const QString& path) {
    initializeAerodromePersistence();
    const auto now = QDateTime::currentSecsSinceEpoch();
    if (!licensedAerodromeConditionsCache_.refreshFromFile(path.toStdString(), now)) {
        runwayConditionStatus_ = cacheStatus(licensedAerodromeConditionsCache_);
        emit dataChanged();
        return false;
    }

    licensedAerodromeConditions_ = licensedAerodromeConditionsCache_.feed();
    if (!licensedAerodromeConditionsCachePath_.isEmpty())
        licensedAerodromeConditionsCache_.persistLastGood(licensedAerodromeConditionsCachePath_.toStdString());
    runwayConditionStatus_ = QStringLiteral("%1 / %2 RUNWAYS")
        .arg(cacheStatus(licensedAerodromeConditionsCache_))
        .arg(runwayConditionCount());
    if (licensedAerodromeConditions_.weatherCount() > 0 && publicAerodromeWeather_.weatherCount() == 0) {
        aerodromeWeatherStatus_ = QStringLiteral("LICENSED WEATHER ACTIVE / %1 STATIONS / %2")
            .arg(aerodromeWeatherCount())
            .arg(QString::fromStdString(licensedAerodromeConditions_.provider().name));
    }
    emit dataChanged();
    return true;
}

void CockpitBridge::fetchLicensedAerodromeConditions(const QString& urlText) {
    initializeAerodromePersistence();
    QUrl url;
    if (!validHttpsUrl(urlText, url)) {
        licensedAerodromeConditionsCache_.noteRefreshFailure("HTTPS licensed condition source required");
        runwayConditionStatus_ = cacheStatus(licensedAerodromeConditionsCache_);
        emit dataChanged();
        return;
    }
    if (!publicFlightNetwork_) publicFlightNetwork_ = new QNetworkAccessManager(this);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader,
                      QStringLiteral("NEXVARY-Avionics-Lab/3.5 runway-condition-read-only"));
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute,
                         QNetworkRequest::NoLessSafeRedirectPolicy);
    runwayConditionStatus_ = licensedAerodromeConditionsCache_.available()
        ? QStringLiteral("FETCHING LICENSED AERODROME CONDITIONS / LAST GOOD RETAINED UNTIL VERIFIED")
        : QStringLiteral("FETCHING LICENSED AERODROME CONDITIONS");
    emit dataChanged();

    QNetworkReply* reply = publicFlightNetwork_->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            licensedAerodromeConditionsCache_.noteRefreshFailure(
                QStringLiteral("network error: %1").arg(reply->errorString()).toStdString());
            runwayConditionStatus_ = cacheStatus(licensedAerodromeConditionsCache_);
            reply->deleteLater();
            emit dataChanged();
            return;
        }
        const QByteArray payload = reply->readAll();
        reply->deleteLater();
        if (payload.size() > kMaximumAerodromePayloadBytes) {
            licensedAerodromeConditionsCache_.noteRefreshFailure("licensed condition payload exceeds configured cache limit");
            runwayConditionStatus_ = cacheStatus(licensedAerodromeConditionsCache_);
            emit dataChanged();
            return;
        }

        const auto now = QDateTime::currentSecsSinceEpoch();
        if (!licensedAerodromeConditionsCache_.refreshFromJson(payload.toStdString(), now)) {
            runwayConditionStatus_ = cacheStatus(licensedAerodromeConditionsCache_);
            emit dataChanged();
            return;
        }
        licensedAerodromeConditions_ = licensedAerodromeConditionsCache_.feed();
        if (!licensedAerodromeConditionsCachePath_.isEmpty())
            licensedAerodromeConditionsCache_.persistLastGood(licensedAerodromeConditionsCachePath_.toStdString());
        runwayConditionStatus_ = QStringLiteral("%1 / %2 RUNWAYS")
            .arg(cacheStatus(licensedAerodromeConditionsCache_))
            .arg(runwayConditionCount());
        if (licensedAerodromeConditions_.weatherCount() > 0 && publicAerodromeWeather_.weatherCount() == 0) {
            aerodromeWeatherStatus_ = QStringLiteral("LICENSED WEATHER ACTIVE / %1 STATIONS")
                .arg(aerodromeWeatherCount());
        }
        emit dataChanged();
    });
}

void CockpitBridge::clearAerodromeConditions() {
    initializeAerodromePersistence();
    publicAerodromeWeather_ = AerodromeConditionFeed{};
    licensedAerodromeConditions_ = AerodromeConditionFeed{};
    publicAerodromeWeatherCache_.clear();
    licensedAerodromeConditionsCache_.clear();
    if (!publicAerodromeWeatherCachePath_.isEmpty()) QFile::remove(publicAerodromeWeatherCachePath_);
    if (!licensedAerodromeConditionsCachePath_.isEmpty()) QFile::remove(licensedAerodromeConditionsCachePath_);
    aerodromeWeatherStatus_ = QStringLiteral("PUBLIC METAR NOT LOADED");
    runwayConditionStatus_ = QStringLiteral("NO LICENSED RUNWAY CONDITION SOURCE");
    emit dataChanged();
}

} // namespace nexvary::avionics
