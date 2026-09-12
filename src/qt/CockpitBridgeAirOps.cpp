#include "qt/CockpitBridge.hpp"

#include <QUrl>
#include <QVariantMap>
#include <filesystem>

namespace nexvary::avionics {

QVariantList CockpitBridge::airOperationsTracks() const {
    QVariantList rows;
    for (const auto& track : airOperations_.snapshot().tracks) {
        QVariantMap row;
        row["trackId"] = QString::fromStdString(track.trackId);
        row["classification"] = QString::fromStdString(track.classification);
        row["latitude"] = track.latitude;
        row["longitude"] = track.longitude;
        row["altitudeMeters"] = track.altitudeMeters;
        row["speedMetersPerSecond"] = track.speedMetersPerSecond ? *track.speedMetersPerSecond : 0.0;
        row["headingDegrees"] = track.headingDegrees ? *track.headingDegrees : 0.0;
        row["confidence"] = track.confidence;
        row["threatLevel"] = QString::fromStdString(track.threatLevel);
        row["threatScore"] = track.threatScore;
        row["insideProtectedZone"] = track.insideProtectedZone;
        row["zoneName"] = QString::fromStdString(track.zoneName);
        QStringList sensors;
        for (const auto& sensor : track.sensors) {
            sensors.push_back(QString::fromStdString(sensor));
        }
        row["sensors"] = sensors;
        rows.push_back(row);
    }
    return rows;
}

QVariantList CockpitBridge::airOperationsIncidents() const {
    QVariantList rows;
    for (const auto& incident : airOperations_.snapshot().incidents) {
        QVariantMap row;
        row["incidentId"] = QString::fromStdString(incident.incidentId);
        row["trackId"] = QString::fromStdString(incident.trackId);
        row["peakThreatLevel"] = QString::fromStdString(incident.peakThreatLevel);
        row["peakScore"] = incident.peakScore;
        row["summary"] = QString::fromStdString(incident.summary);
        row["status"] = QString::fromStdString(incident.status);
        rows.push_back(row);
    }
    return rows;
}

QString CockpitBridge::airOperationsSource() const {
    return QString::fromStdString(airOperations_.snapshot().source);
}

QString CockpitBridge::airOperationsMode() const {
    return QString::fromStdString(airOperations_.snapshot().mode);
}

QString CockpitBridge::airOperationsStatus() const {
    return airOperationsStatus_;
}

int CockpitBridge::airOperationsTrackCount() const noexcept {
    return static_cast<int>(airOperations_.snapshot().summary.trackCount);
}

int CockpitBridge::airOperationsIncidentCount() const noexcept {
    return static_cast<int>(airOperations_.snapshot().summary.incidentCount);
}

int CockpitBridge::airOperationsHighCount() const noexcept {
    return static_cast<int>(airOperations_.snapshot().summary.highOrAboveCount);
}

qulonglong CockpitBridge::airOperationsObservationCount() const noexcept {
    return static_cast<qulonglong>(airOperations_.snapshot().summary.observations);
}

bool CockpitBridge::loadAirOperationsReplay(const QString& path) {
    try {
        const QUrl url(path);
        const QString localPath = url.isLocalFile() ? url.toLocalFile() : path;
        airOperations_ = AirOperationsIntegration::fromFile(std::filesystem::path(localPath.toStdString()));
        airOperationsStatus_ = QStringLiteral("REPLAY IMPORTED / AWARENESS ONLY");
        emit dataChanged();
        return true;
    } catch (const std::exception& error) {
        airOperationsStatus_ = QStringLiteral("IMPORT REJECTED: ") + QString::fromUtf8(error.what());
        emit dataChanged();
        return false;
    }
}

void CockpitBridge::resetAirOperationsDemo() {
    airOperations_ = AirOperationsIntegration::demo();
    airOperationsStatus_ = QStringLiteral("DEMO / REPLAY READY");
    emit dataChanged();
}

} // namespace nexvary::avionics
