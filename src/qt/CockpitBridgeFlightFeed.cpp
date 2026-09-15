#include "qt/CockpitBridge.hpp"

#include <QDateTime>
#include <QDir>
#include <QFileInfo>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QStandardPaths>
#include <QUrl>
#include <QVariantMap>
#include <algorithm>
#include <cmath>
#include <limits>

namespace nexvary::avionics {
namespace {
constexpr int kRfBins = 64;
constexpr double kRfStartMhz = 100.0;
constexpr double kRfStepMhz = 6.25;
constexpr qint64 kMaximumFeedPayloadBytes = 2 * 1024 * 1024;
constexpr qint64 kMaximumEnrichmentPayloadBytes = 4 * 1024 * 1024;

// Synthetic, receive-only spectrum used for UI/training. It performs no RF transmission,
// demodulation, identification, jamming or active control.
double rfLevelFor(qulonglong tick, double frequencyMhz) {
    const double phase = static_cast<double>(tick % 1200) * 0.025;
    double level = -96.0 + 2.5 * std::sin(frequencyMhz * 0.083 + phase);
    const auto peak = [frequencyMhz](double center, double width, double gain) {
        const double x = (frequencyMhz - center) / width;
        return gain * std::exp(-(x * x));
    };
    level += peak(156.0, 10.0, 30.0);
    level += peak(237.0, 16.0, 22.0);
    level += peak(356.0, 13.0, 27.0);
    return std::min(level, -36.0);
}

bool validHttpsUrl(const QString& urlText, QUrl& url) {
    url = QUrl(urlText.trimmed());
    return url.isValid() && !url.host().isEmpty() &&
           url.scheme().compare(QStringLiteral("https"), Qt::CaseInsensitive) == 0;
}
}

QVariantList CockpitBridge::publicFlightTracks() const {
    QVariantList rows;
    for (const auto& track : publicFlightFeed_.snapshot().tracks) {
        QVariantMap row;
        const auto putString = [&row](const char* key, const std::string& value) {
            if (!value.empty()) row[QString::fromLatin1(key)] = QString::fromStdString(value);
        };
        const auto putNumber = [&row](const char* key, const std::optional<double>& value) {
            if (value) row[QString::fromLatin1(key)] = *value;
        };
        const auto putInteger = [&row](const char* key, const std::optional<long long>& value) {
            if (value) row[QString::fromLatin1(key)] = QVariant::fromValue<qlonglong>(*value);
        };
        row[QStringLiteral("icao24")] = QString::fromStdString(track.icao24);
        putString("callsign", track.callsign);
        putString("country", track.country);
        putString("flightNumber", track.flightNumber);
        putString("aircraftTypeCode", track.aircraftTypeCode);
        putString("registration", track.registration);
        putString("aircraftModel", track.aircraftModel);
        putString("manufacturer", track.manufacturer);
        putString("serialNumber", track.serialNumber);
        putString("operatorName", track.operatorName);
        putString("marketingOperator", track.marketingOperator);
        putString("operatorIcao", track.operatorIcao);
        putString("operatorIata", track.operatorIata);
        putString("originAirportIcao", track.originAirportIcao);
        putString("originAirportIata", track.originAirportIata);
        putString("destinationAirportIcao", track.destinationAirportIcao);
        putString("destinationAirportIata", track.destinationAirportIata);
        putString("route", track.route);
        putString("scheduledDeparture", track.scheduledDeparture);
        putString("estimatedArrival", track.estimatedArrival);
        putString("aircraftFamily", track.aircraftFamily);
        putString("variant", track.variant);
        putString("engineType", track.engineType);
        putString("yearBuilt", track.yearBuilt);
        putString("registrationStatus", track.registrationStatus);
        putString("registrationCountry", track.registrationCountry);
        putString("telemetrySource", track.telemetrySource);
        putString("metadataSource", track.metadataSource);
        putString("routeSource", track.routeSource);
        putString("metadataLicense", track.metadataLicense);
        putString("metadataSourceUrl", track.metadataSourceUrl);
        putString("routeLicense", track.routeLicense);
        putString("routeSourceUrl", track.routeSourceUrl);
        putString("enrichmentCacheState", track.enrichmentCacheState);
        putString("positionSource", track.positionSource);
        putString("squawk", track.squawk);
        row[QStringLiteral("latitude")] = track.latitude;
        row[QStringLiteral("longitude")] = track.longitude;
        putNumber("altitudeMeters", track.altitudeMeters);
        putNumber("geometricAltitudeMeters", track.geometricAltitudeMeters);
        putNumber("velocityMetersPerSecond", track.velocityMetersPerSecond);
        putNumber("trueAirspeedMetersPerSecond", track.trueAirspeedMetersPerSecond);
        putNumber("headingDegrees", track.headingDegrees);
        putNumber("verticalRateMetersPerSecond", track.verticalRateMetersPerSecond);
        putNumber("signalQualityPercent", track.signalQualityPercent);
        putInteger("lastContactEpoch", track.lastContactEpoch);
        putInteger("dataAgeSeconds", track.dataAgeSeconds);
        putInteger("enrichmentCachedAtEpoch", track.enrichmentCachedAtEpoch);
        putInteger("enrichmentExpiresAtEpoch", track.enrichmentExpiresAtEpoch);
        if (track.category > 0) row[QStringLiteral("category")] = track.category;
        row[QStringLiteral("onGround")] = track.onGround;
        rows.push_back(row);
    }
    return rows;
}

QString CockpitBridge::publicFlightFeedSource() const {
    return QString::fromStdString(publicFlightFeed_.snapshot().source);
}

QString CockpitBridge::publicFlightFeedStatus() const { return publicFlightFeedStatus_; }

int CockpitBridge::publicFlightTrackCount() const noexcept {
    return static_cast<int>(publicFlightFeed_.trackCount());
}

QString CockpitBridge::publicFlightEnrichmentProvider() const {
    const auto& name = publicFlightEnrichment_.provider().name;
    return name.empty() ? QStringLiteral("NONE") : QString::fromStdString(name);
}

QString CockpitBridge::publicFlightEnrichmentStatus() const { return publicFlightEnrichmentStatus_; }
QString CockpitBridge::publicFlightHistoryStatus() const { return publicFlightHistoryStatus_; }

QVariantList CockpitBridge::publicFlightHistory(const QString& icao24, int minutes) {
    initializePublicFlightPersistence();
    const auto now = QDateTime::currentSecsSinceEpoch();
    QVariantList rows;
    for (const auto& point : publicFlightHistory_.window(icao24.toStdString(), minutes, now)) {
        QVariantMap row;
        row[QStringLiteral("observedEpoch")] = QVariant::fromValue<qlonglong>(point.observedEpoch);
        row[QStringLiteral("latitude")] = point.latitude;
        row[QStringLiteral("longitude")] = point.longitude;
        if (point.altitudeMeters) row[QStringLiteral("altitudeMeters")] = *point.altitudeMeters;
        if (point.velocityMetersPerSecond) row[QStringLiteral("velocityMetersPerSecond")] = *point.velocityMetersPerSecond;
        if (point.headingDegrees) row[QStringLiteral("headingDegrees")] = *point.headingDegrees;
        if (!point.telemetrySource.empty()) row[QStringLiteral("telemetrySource")] = QString::fromStdString(point.telemetrySource);
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::rfSpectrumBins() const {
    QVariantList bins;
    bins.reserve(kRfBins);
    for (int i = 0; i < kRfBins; ++i) {
        const double frequency = kRfStartMhz + static_cast<double>(i) * kRfStepMhz;
        QVariantMap bin;
        bin[QStringLiteral("frequencyMhz")] = frequency;
        bin[QStringLiteral("levelDbm")] = rfLevelFor(snapshot_.tick, frequency);
        bins.push_back(bin);
    }
    return bins;
}

QString CockpitBridge::rfSpectrumMode() const { return QStringLiteral("PASSIVE / SYNTHETIC"); }

double CockpitBridge::rfPeakFrequencyMhz() const noexcept {
    double bestFrequency = kRfStartMhz;
    double bestLevel = -std::numeric_limits<double>::infinity();
    for (int i = 0; i < kRfBins; ++i) {
        const double frequency = kRfStartMhz + static_cast<double>(i) * kRfStepMhz;
        const double level = rfLevelFor(snapshot_.tick, frequency);
        if (level > bestLevel) {
            bestLevel = level;
            bestFrequency = frequency;
        }
    }
    return bestFrequency;
}

double CockpitBridge::rfPeakLevelDbm() const noexcept {
    double bestLevel = -std::numeric_limits<double>::infinity();
    for (int i = 0; i < kRfBins; ++i) {
        const double frequency = kRfStartMhz + static_cast<double>(i) * kRfStepMhz;
        bestLevel = std::max(bestLevel, rfLevelFor(snapshot_.tick, frequency));
    }
    return bestLevel;
}

void CockpitBridge::initializePublicFlightPersistence() {
    if (publicFlightPersistenceInitialized_) return;
    publicFlightPersistenceInitialized_ = true;

    QString basePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    if (basePath.isEmpty()) basePath = QDir::tempPath() + QStringLiteral("/NEXVARY-Avionics-Lab");
    publicFlightHistoryPath_ = QDir(basePath).filePath(QStringLiteral("public-flight-history.json"));

    if (QFileInfo::exists(publicFlightHistoryPath_)) {
        try {
            publicFlightHistory_ = PublicFlightHistoryStore::fromFile(publicFlightHistoryPath_.toStdString());
            publicFlightHistoryStatus_ = QStringLiteral("HISTORY LOADED / %1 POINTS / %2 MIN RETENTION")
                .arg(static_cast<qulonglong>(publicFlightHistory_.totalPointCount()))
                .arg(publicFlightHistory_.retentionMinutes());
            return;
        } catch (const std::exception& error) {
            publicFlightHistoryStatus_ = QStringLiteral("HISTORY LOAD ERROR / %1").arg(QString::fromUtf8(error.what()));
        }
    } else {
        publicFlightHistoryStatus_ = QStringLiteral("HISTORY READY / 60 MIN RETENTION");
    }
}

void CockpitBridge::savePublicFlightHistory() {
    if (publicFlightHistoryPath_.isEmpty()) return;
    try {
        publicFlightHistory_.save(publicFlightHistoryPath_.toStdString());
        publicFlightHistoryStatus_ = QStringLiteral("HISTORY PERSISTED / %1 POINTS / %2 MIN RETENTION")
            .arg(static_cast<qulonglong>(publicFlightHistory_.totalPointCount()))
            .arg(publicFlightHistory_.retentionMinutes());
    } catch (const std::exception& error) {
        publicFlightHistoryStatus_ = QStringLiteral("HISTORY WRITE ERROR / %1").arg(QString::fromUtf8(error.what()));
    }
}

void CockpitBridge::applyPublicFlightEnrichmentAndRecord() {
    initializePublicFlightPersistence();
    const auto now = QDateTime::currentSecsSinceEpoch();
    auto snapshot = publicFlightFeed_.snapshot();
    std::size_t applied = 0;
    if (!publicFlightEnrichment_.empty()) applied = publicFlightEnrichment_.apply(snapshot, now);
    publicFlightFeed_ = PublicFlightFeed(std::move(snapshot));
    publicFlightHistory_.record(publicFlightFeed_.snapshot(), now);
    savePublicFlightHistory();
    if (!publicFlightEnrichment_.empty()) {
        publicFlightEnrichmentStatus_ = QStringLiteral("%1 / %2 TRACKS ENRICHED / PROVENANCE ATTACHED")
            .arg(static_cast<qulonglong>(applied))
            .arg(publicFlightTrackCount());
    }
}

bool CockpitBridge::loadPublicFlightFeedFile(const QString& path) {
    try {
        publicFlightFeed_ = PublicFlightFeed::fromFile(path.toStdString());
        applyPublicFlightEnrichmentAndRecord();
        publicFlightFeedStatus_ = QStringLiteral("PUBLIC FEED IMPORTED / READ-ONLY AWARENESS");
        emit dataChanged();
        return true;
    } catch (const std::exception& error) {
        publicFlightFeedStatus_ = QStringLiteral("IMPORT REJECTED: %1").arg(QString::fromUtf8(error.what()));
        emit dataChanged();
        return false;
    }
}

void CockpitBridge::fetchPublicFlightFeed(const QString& urlText) {
    QUrl url;
    if (!validHttpsUrl(urlText, url)) {
        publicFlightFeedStatus_ = QStringLiteral("URL REJECTED / HTTPS READ-ONLY FEED REQUIRED");
        emit dataChanged();
        return;
    }

    if (!publicFlightNetwork_) publicFlightNetwork_ = new QNetworkAccessManager(this);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("NEXVARY-Avionics-Lab/3.5 read-only-public-awareness"));
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);

    publicFlightFeedStatus_ = QStringLiteral("FETCHING AUTHORIZED HTTPS TRACK FEED");
    emit dataChanged();

    QNetworkReply* reply = publicFlightNetwork_->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            publicFlightFeedStatus_ = QStringLiteral("FEED ERROR: %1").arg(reply->errorString());
            reply->deleteLater();
            emit dataChanged();
            return;
        }

        const QByteArray payload = reply->readAll();
        reply->deleteLater();
        if (payload.size() > kMaximumFeedPayloadBytes) {
            publicFlightFeedStatus_ = QStringLiteral("FEED REJECTED / PAYLOAD TOO LARGE");
            emit dataChanged();
            return;
        }

        try {
            publicFlightFeed_ = PublicFlightFeed::fromJson(payload.toStdString());
            applyPublicFlightEnrichmentAndRecord();
            publicFlightFeedStatus_ = QStringLiteral("HTTPS FEED ACTIVE / READ-ONLY AWARENESS");
        } catch (const std::exception& error) {
            publicFlightFeedStatus_ = QStringLiteral("FEED PARSE ERROR: %1").arg(QString::fromUtf8(error.what()));
        }
        emit dataChanged();
    });
}

void CockpitBridge::resetPublicFlightDemo() {
    publicFlightFeed_ = PublicFlightFeed::demo();
    applyPublicFlightEnrichmentAndRecord();
    publicFlightFeedStatus_ = QStringLiteral("DEMO / SYNTHETIC PUBLIC-FEED READY");
    emit dataChanged();
}

bool CockpitBridge::loadPublicFlightEnrichmentFile(const QString& path) {
    try {
        publicFlightEnrichment_ = PublicFlightEnrichmentCache::fromFile(path.toStdString());
        applyPublicFlightEnrichmentAndRecord();
        const auto& provider = publicFlightEnrichment_.provider();
        publicFlightEnrichmentStatus_ = QStringLiteral("LICENSED ENRICHMENT LOADED / %1 / %2 RECORDS")
            .arg(QString::fromStdString(provider.name))
            .arg(static_cast<qulonglong>(publicFlightEnrichment_.size()));
        emit dataChanged();
        return true;
    } catch (const std::exception& error) {
        publicFlightEnrichmentStatus_ = QStringLiteral("ENRICHMENT REJECTED: %1").arg(QString::fromUtf8(error.what()));
        emit dataChanged();
        return false;
    }
}

void CockpitBridge::fetchPublicFlightEnrichment(const QString& urlText) {
    QUrl url;
    if (!validHttpsUrl(urlText, url)) {
        publicFlightEnrichmentStatus_ = QStringLiteral("URL REJECTED / HTTPS LICENSED PROVIDER REQUIRED");
        emit dataChanged();
        return;
    }
    if (!publicFlightNetwork_) publicFlightNetwork_ = new QNetworkAccessManager(this);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("NEXVARY-Avionics-Lab/3.5 read-only-enrichment"));
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);
    publicFlightEnrichmentStatus_ = QStringLiteral("FETCHING LICENSED READ-ONLY ENRICHMENT");
    emit dataChanged();

    QNetworkReply* reply = publicFlightNetwork_->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() != QNetworkReply::NoError) {
            publicFlightEnrichmentStatus_ = QStringLiteral("ENRICHMENT ERROR: %1").arg(reply->errorString());
            reply->deleteLater();
            emit dataChanged();
            return;
        }
        const QByteArray payload = reply->readAll();
        reply->deleteLater();
        if (payload.size() > kMaximumEnrichmentPayloadBytes) {
            publicFlightEnrichmentStatus_ = QStringLiteral("ENRICHMENT REJECTED / PAYLOAD TOO LARGE");
            emit dataChanged();
            return;
        }
        try {
            publicFlightEnrichment_ = PublicFlightEnrichmentCache::fromJson(payload.toStdString());
            applyPublicFlightEnrichmentAndRecord();
            const auto& provider = publicFlightEnrichment_.provider();
            publicFlightEnrichmentStatus_ = QStringLiteral("LICENSED HTTPS ENRICHMENT ACTIVE / %1 / %2 RECORDS")
                .arg(QString::fromStdString(provider.name))
                .arg(static_cast<qulonglong>(publicFlightEnrichment_.size()));
        } catch (const std::exception& error) {
            publicFlightEnrichmentStatus_ = QStringLiteral("ENRICHMENT PARSE ERROR: %1").arg(QString::fromUtf8(error.what()));
        }
        emit dataChanged();
    });
}

} // namespace nexvary::avionics
