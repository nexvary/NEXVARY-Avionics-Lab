#include "qt/CockpitBridge.hpp"
#include <QColor>
#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>
#include <QGuiApplication>
#include <QIcon>
#include <QImage>
#include <QPainter>
#include <QPixmap>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlExpression>
#include <QQuickItem>
#include <QQuickWindow>
#include <QTimer>
#include <QVariantMap>
#include <algorithm>
#include <cmath>

namespace {
QIcon makeAvionicsIcon() {
    QPixmap pixmap(128, 128);
    pixmap.fill(Qt::transparent);
    QPainter p(&pixmap);
    p.setRenderHint(QPainter::Antialiasing, true);

    const QColor deepBlack("#000000");
    const QColor gunmetal("#1A1A1A");
    const QColor gold("#D4AF37");
    const QColor silver("#F2F2F2");
    const QColor green("#6FA58D");

    p.setPen(QPen(gold, 4));
    p.setBrush(deepBlack);
    p.drawRoundedRect(QRectF(5, 5, 118, 118), 18, 18);
    p.setPen(QPen(gunmetal, 2));
    p.setBrush(Qt::NoBrush);
    p.drawRoundedRect(QRectF(12, 12, 104, 104), 13, 13);

    QPolygonF aircraft;
    aircraft << QPointF(64, 19) << QPointF(71, 49) << QPointF(99, 64)
             << QPointF(73, 61) << QPointF(70, 91) << QPointF(82, 103)
             << QPointF(64, 96) << QPointF(46, 103) << QPointF(58, 91)
             << QPointF(55, 61) << QPointF(29, 64) << QPointF(57, 49);
    p.setPen(Qt::NoPen);
    p.setBrush(gold);
    p.drawPolygon(aircraft);

    p.setPen(QPen(silver, 2));
    p.drawLine(QPointF(25, 79), QPointF(49, 79));
    p.drawLine(QPointF(79, 79), QPointF(103, 79));
    p.drawLine(QPointF(34, 91), QPointF(51, 91));
    p.drawLine(QPointF(77, 91), QPointF(94, 91));
    p.setBrush(green);
    p.setPen(Qt::NoPen);
    for (const QPointF point : {QPointF(24,79), QPointF(104,79), QPointF(33,91), QPointF(95,91)})
        p.drawEllipse(point, 3.5, 3.5);

    p.setPen(QPen(gold, 3));
    p.setBrush(Qt::NoBrush);
    p.drawArc(QRectF(24, 22, 80, 80), 25 * 16, 130 * 16);
    p.drawArc(QRectF(24, 22, 80, 80), 205 * 16, 130 * 16);
    p.end();
    return QIcon(pixmap);
}
}

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);
    QGuiApplication::setWindowIcon(makeAvionicsIcon());
    nexvary::avionics::CockpitBridge cockpit;

    const QStringList arguments = QCoreApplication::arguments();

    const int languageIndex = arguments.indexOf(QStringLiteral("--language"));
    if (languageIndex >= 0 && languageIndex + 1 < arguments.size()) {
        cockpit.setLanguage(arguments.at(languageIndex + 1));
    }

    const int profileIndex = arguments.indexOf(QStringLiteral("--aircraft-profile"));
    if (profileIndex >= 0 && profileIndex + 1 < arguments.size()) {
        cockpit.setActivePlatform(arguments.at(profileIndex + 1));
    }

    int airOpsWorkspace = 0;
    const int airOpsWorkspaceIndex = arguments.indexOf(QStringLiteral("--air-ops-workspace"));
    if (airOpsWorkspaceIndex >= 0 && airOpsWorkspaceIndex + 1 < arguments.size()) {
        bool ok = false;
        const int value = arguments.at(airOpsWorkspaceIndex + 1).toInt(&ok);
        if (ok && value >= 0 && value <= 7) airOpsWorkspace = value;
    }

    int forceWorkspace = 0;
    const int forceWorkspaceIndex = arguments.indexOf(QStringLiteral("--force-workspace"));
    if (forceWorkspaceIndex >= 0 && forceWorkspaceIndex + 1 < arguments.size()) {
        bool ok = false;
        const int value = arguments.at(forceWorkspaceIndex + 1).toInt(&ok);
        if (ok && value >= 0 && value <= 5) forceWorkspace = value;
    }

    int cuasSection = 0;
    const int cuasSectionIndex = arguments.indexOf(QStringLiteral("--cuas-section"));
    if (cuasSectionIndex >= 0 && cuasSectionIndex + 1 < arguments.size()) {
        bool ok = false;
        const int value = arguments.at(cuasSectionIndex + 1).toInt(&ok);
        if (ok && value >= 0 && value <= 3) cuasSection = value;
    }

    int systemWorkspace = 0;
    const int systemWorkspaceIndex = arguments.indexOf(QStringLiteral("--system-workspace"));
    if (systemWorkspaceIndex >= 0 && systemWorkspaceIndex + 1 < arguments.size()) {
        bool ok = false;
        const int value = arguments.at(systemWorkspaceIndex + 1).toInt(&ok);
        if (ok && value >= 0 && value <= 2) systemWorkspace = value;
    }

    const int screenshotIndex = arguments.indexOf(QStringLiteral("--screenshot"));
    if (screenshotIndex >= 0) {
        for (int i = 0; i < 80; ++i) cockpit.step();
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("cockpit"), &cockpit);
    engine.rootContext()->setContextProperty(QStringLiteral("airOpsWorkspace"), airOpsWorkspace);
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty()) return 2;

    QObject* root = engine.rootObjects().constFirst();
    auto* window = qobject_cast<QQuickWindow*>(root);
    if (!window) return 6;

    const int pageIndex = arguments.indexOf(QStringLiteral("--page"));
    if (pageIndex >= 0 && pageIndex + 1 < arguments.size()) {
        bool ok = false;
        const int page = arguments.at(pageIndex + 1).toInt(&ok);
        if (ok && page >= 0 && page <= 16) {
            auto* qmlContext = QQmlEngine::contextForObject(root);
            if (!qmlContext) return 8;
            QQmlExpression initialView(
                qmlContext,
                root,
                QStringLiteral("initializeView(%1, %2, %3, %4, %5)").arg(page).arg(airOpsWorkspace).arg(forceWorkspace).arg(cuasSection).arg(systemWorkspace)
            );
            initialView.evaluate();
            if (initialView.hasError()) return 10;

            if (arguments.contains(QStringLiteral("--smoke"))) {
                QString expectedView = QStringLiteral("selectedPage === %1").arg(page);
                if (page == 11) {
                    const int expectedWorkspace = airOpsWorkspace == 6
                        ? 60 + cuasSection
                        : airOpsWorkspace;
                    expectedView += QStringLiteral(" && currentWorkspace() === %1")
                        .arg(expectedWorkspace);
                } else if (page == 12) {
                    expectedView += QStringLiteral(" && currentWorkspace() === %1")
                        .arg(forceWorkspace);
                } else if (page == 16) {
                    expectedView += QStringLiteral(" && currentWorkspace() === %1")
                        .arg(systemWorkspace);
                }

                QQmlExpression initialViewTest(qmlContext, root, expectedView);
                const QVariant viewResult = initialViewTest.evaluate();
                if (initialViewTest.hasError() || !viewResult.toBool()) return 12;
            }
        }
    }

    int requestedWidth = window->width();
    int requestedHeight = window->height();
    const int widthIndex = arguments.indexOf(QStringLiteral("--width"));
    if (widthIndex >= 0 && widthIndex + 1 < arguments.size()) {
        bool ok = false;
        const int value = arguments.at(widthIndex + 1).toInt(&ok);
        if (ok && value >= 1360 && value <= 7680) requestedWidth = value;
    }
    const int heightIndex = arguments.indexOf(QStringLiteral("--height"));
    if (heightIndex >= 0 && heightIndex + 1 < arguments.size()) {
        bool ok = false;
        const int value = arguments.at(heightIndex + 1).toInt(&ok);
        if (ok && value >= 800 && value <= 4320) requestedHeight = value;
    }
    window->resize(requestedWidth, requestedHeight);

    const bool flightPopupView = arguments.contains(QStringLiteral("--flight-popup-view")) ||
        arguments.contains(QStringLiteral("--flight-popup-layout-smoke"));
    if (flightPopupView) {
        QObject* trackingPage = root->findChild<QObject*>(QStringLiteral("flightTrackingPage"));
        if (!trackingPage) return 16;
        trackingPage->setProperty("detailsOpen", false);
        QCoreApplication::processEvents();
    }

    if (arguments.contains(QStringLiteral("--navigation-smoke"))) {
        auto* qmlContext = QQmlEngine::contextForObject(root);
        if (!qmlContext) return 8;
        QQmlExpression navigationTest(
            qmlContext,
            root,
            QStringLiteral("navigationHistory=[]; initializeView(0,0,0,0,0); navigateRoute('space-domain',11,7,'air-operations'); var spaceOpened=(selectedPage===11 && selectedRoute==='space-domain' && currentWorkspace()===7 && navigationHistory.length===1); navigateRoute('maintenance',12,5,'force-management'); var forceOpened=(selectedPage===12 && selectedRoute==='maintenance' && currentWorkspace()===5 && navigationHistory.length===2); navigateRoute('cuas-incidents',11,62,'cuas'); var cuasOpened=(selectedPage===11 && selectedRoute==='cuas-incidents' && currentWorkspace()===62 && navigationHistory.length===3); goBack(); var forceRestored=(selectedPage===12 && selectedRoute==='maintenance' && currentWorkspace()===5); goBack(); var spaceRestored=(selectedPage===11 && selectedRoute==='space-domain' && currentWorkspace()===7); goBack(); spaceOpened && forceOpened && cuasOpened && forceRestored && spaceRestored && selectedPage===0 && selectedRoute==='overview' && currentWorkspace()===0 && navigationHistory.length===0")
        );
        const QVariant result = navigationTest.evaluate();
        if (navigationTest.hasError() || !result.toBool()) return 9;
        return 0;
    }

    if (arguments.contains(QStringLiteral("--rtl-smoke"))) {
        QCoreApplication::processEvents();
        return root->property("rtlLayoutVerified").toBool() ? 0 : 11;
    }

    if (arguments.contains(QStringLiteral("--radar-motion-smoke"))) {
        QObject* tacticalPlot = root->findChild<QObject*>(QStringLiteral("cuasTacticalPlot"));
        if (!tacticalPlot) return 13;
        const QVariantList tracks = tacticalPlot->property("tracks").toList();
        const double rangeKm = tacticalPlot->property("rangeKm").toDouble();
        const int selectedTrackIndex = tacticalPlot->property("selectedTrackIndex").toInt();
        if (tracks.size() < 3 || std::abs(rangeKm - 25.0) > 0.01 ||
            selectedTrackIndex < 0 || selectedTrackIndex >= tracks.size()) return 13;
        const double initialAngle = tacticalPlot->property("sweepAngle").toDouble();
        QTimer::singleShot(450, &app, [tacticalPlot, initialAngle]() {
            const double currentAngle = tacticalPlot->property("sweepAngle").toDouble();
            QCoreApplication::exit(std::abs(currentAngle - initialAngle) > 0.02 ? 0 : 13);
        });
        return app.exec();
    }

    if (arguments.contains(QStringLiteral("--orbit-motion-smoke"))) {
        QObject* orbitalPlot = root->findChild<QObject*>(QStringLiteral("orbitalSituationPlot"));
        if (!orbitalPlot) return 14;
        const double initialPhase = orbitalPlot->property("orbitalPhase").toDouble();
        QTimer::singleShot(450, &app, [orbitalPlot, initialPhase]() {
            const double currentPhase = orbitalPlot->property("orbitalPhase").toDouble();
            QCoreApplication::exit(std::abs(currentPhase - initialPhase) > 0.002 ? 0 : 14);
        });
        return app.exec();
    }

    if (arguments.contains(QStringLiteral("--aircraft-details-smoke"))) {
        QCoreApplication::processEvents();
        QObject* detailsPanel = root->findChild<QObject*>(QStringLiteral("aircraftDetailsPanel"));
        QObject* searchField = root->findChild<QObject*>(QStringLiteral("aircraftSearchField"));
        if (!detailsPanel || !searchField || !detailsPanel->property("visible").toBool()) return 15;
        const QVariantMap track = detailsPanel->property("track").toMap();
        if (track.value(QStringLiteral("icao24")).toString().isEmpty()) return 15;
        if (track.value(QStringLiteral("telemetrySource")).toString().isEmpty()) return 15;
        return 0;
    }

    if (arguments.contains(QStringLiteral("--flight-popup-layout-smoke"))) {
        QTimer::singleShot(120, &app, [root]() {
            auto* popup = root->findChild<QQuickItem*>(QStringLiteral("selectedAircraftPopup"));
            auto* dataBadge = root->findChild<QQuickItem*>(QStringLiteral("airMapDataBadge"));
            auto* toolbar = root->findChild<QQuickItem*>(QStringLiteral("airMapLayerToolbar"));
            if (!popup || !dataBadge || !toolbar || !popup->isVisible()) {
                QCoreApplication::exit(16);
                return;
            }
            const qreal popupBottom = popup->mapToScene(QPointF(0.0, popup->height())).y();
            const qreal protectedTop = std::min(
                dataBadge->mapToScene(QPointF(0.0, 0.0)).y(),
                toolbar->mapToScene(QPointF(0.0, 0.0)).y()
            );
            QCoreApplication::exit(popupBottom + 1.0 < protectedTop ? 0 : 16);
        });
        return app.exec();
    }

    if (screenshotIndex >= 0) {
        if (screenshotIndex + 1 >= arguments.size()) return 5;
        const QString outputPath = arguments.at(screenshotIndex + 1);
        QDir().mkpath(QFileInfo(outputPath).absolutePath());
        QTimer::singleShot(1000, &app, [window, outputPath]() {
            const QImage image = window->grabWindow();
            if (image.isNull() || !image.save(outputPath)) {
                QCoreApplication::exit(7);
                return;
            }
            QCoreApplication::quit();
        });
    } else if (arguments.contains(QStringLiteral("--smoke"))) {
        QTimer::singleShot(200, &app, &QCoreApplication::quit);
    }
    return app.exec();
}
