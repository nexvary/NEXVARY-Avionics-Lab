#include "qt/CockpitBridge.hpp"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
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
}

QVariantList CockpitBridge::publicFlightTracks() const {
    QVariantList rows;
    for (const auto& track : publicFlightFeed_.snapshot().tracks) {
        QVariantMap row;
        row[QStringLiteral("icao24")] = QString::fromStdString(track.icao24);
        row[QStringLiteral("callsign")] = QString::fromStdString(track.callsign);
        row[QStringLiteral("country")] = QString::fromStdString(track.country);
        row[QStringLiteral("latitude")] = track.latitude;
        row[QStringLiteral("longitude")] = track.longitude;
        row[QStringLiteral("altitudeMeters")] = track.altitudeMeters;
        row[QStringLiteral("velocityMetersPerSecond")] = track.velocityMetersPerSecond;
        row[QStringLiteral("headingDegrees")] = track.headingDegrees;
        row[QStringLiteral("onGround")] = track.onGround;
        rows.push_back(row);
    }
    return rows;
}

QString CockpitBridge::publicFlightFeedSource() const {
    return QString::fromStdString(publicFlightFeed_.snapshot().source);
}

QString CockpitBridge::publicFlightFeedStatus() const {
    return publicFlightFeedStatus_;
}

int CockpitBridge::publicFlightTrackCount() const noexcept {
    return static_cast<int>(publicFlightFeed_.trackCount());
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

QString CockpitBridge::rfSpectrumMode() const {
    return QStringLiteral("PASSIVE / SYNTHETIC");
}

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

bool CockpitBridge::loadPublicFlightFeedFile(const QString& path) {
    try {
        publicFlightFeed_ = PublicFlightFeed::fromFile(path.toStdString());
        publicFlightFeedStatus_ = QStringLiteral("PUBLIC FEED IMPORTED / AWARENESS ONLY");
        emit dataChanged();
        return true;
    } catch (const std::exception& error) {
        publicFlightFeedStatus_ = QStringLiteral("IMPORT REJECTED: %1").arg(QString::fromUtf8(error.what()));
        emit dataChanged();
        return false;
    }
}

void CockpitBridge::fetchPublicFlightFeed(const QString& urlText) {
    const QUrl url(urlText);
    if (!url.isValid() || url.scheme().compare(QStringLiteral("https"), Qt::CaseInsensitive) != 0) {
        publicFlightFeedStatus_ = QStringLiteral("URL REJECTED / HTTPS PUBLIC FEED REQUIRED");
        emit dataChanged();
        return;
    }

    if (!publicFlightNetwork_) publicFlightNetwork_ = new QNetworkAccessManager(this);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader, QStringLiteral("NEXVARY-Avionics-Lab/3.2 public-awareness-feed"));
    request.setAttribute(QNetworkRequest::RedirectPolicyAttribute, QNetworkRequest::NoLessSafeRedirectPolicy);

    publicFlightFeedStatus_ = QStringLiteral("FETCHING PUBLIC HTTPS FEED");
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
        if (payload.size() > 2 * 1024 * 1024) {
            publicFlightFeedStatus_ = QStringLiteral("FEED REJECTED / PAYLOAD TOO LARGE");
            emit dataChanged();
            return;
        }

        try {
            publicFlightFeed_ = PublicFlightFeed::fromJson(payload.toStdString());
            publicFlightFeedStatus_ = QStringLiteral("PUBLIC FEED LIVE / AWARENESS ONLY");
        } catch (const std::exception& error) {
            publicFlightFeedStatus_ = QStringLiteral("FEED PARSE ERROR: %1").arg(QString::fromUtf8(error.what()));
        }
        emit dataChanged();
    });
}

void CockpitBridge::resetPublicFlightDemo() {
    publicFlightFeed_ = PublicFlightFeed::demo();
    publicFlightFeedStatus_ = QStringLiteral("DEMO / PUBLIC-FEED READY");
    emit dataChanged();
}

} // namespace nexvary::avionics
