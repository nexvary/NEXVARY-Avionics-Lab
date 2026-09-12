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
#include <QQuickWindow>
#include <QTimer>

namespace {
QIcon makeAvionicsIcon() {
    QPixmap pixmap(128, 128);
    pixmap.fill(Qt::transparent);
    QPainter p(&pixmap);
    p.setRenderHint(QPainter::Antialiasing, true);

    const QColor navy("#0C1319");
    const QColor gunmetal("#2E3945");
    const QColor gold("#D6B15E");
    const QColor blue("#6A88A0");
    const QColor silver("#D9D7D4");
    const QColor green("#6FA58D");

    p.setPen(QPen(gold, 4));
    p.setBrush(navy);
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
    p.setBrush(blue);
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

    const int screenshotIndex = arguments.indexOf(QStringLiteral("--screenshot"));
    if (screenshotIndex >= 0) {
        for (int i = 0; i < 80; ++i) cockpit.step();
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("cockpit"), &cockpit);
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty()) return 2;

    QObject* root = engine.rootObjects().constFirst();
    auto* window = qobject_cast<QQuickWindow*>(root);
    if (!window) return 6;

    const int pageIndex = arguments.indexOf(QStringLiteral("--page"));
    if (pageIndex >= 0 && pageIndex + 1 < arguments.size()) {
        bool ok = false;
        const int page = arguments.at(pageIndex + 1).toInt(&ok);
        if (ok && page >= 0 && page <= 14) root->setProperty("selectedPage", page);
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

    if (arguments.contains(QStringLiteral("--navigation-smoke"))) {
        auto* qmlContext = QQmlEngine::contextForObject(root);
        if (!qmlContext) return 8;
        QQmlExpression navigationTest(
            qmlContext,
            root,
            QStringLiteral("navigationHistory=[]; selectedPage=0; navigateTo(12); var opened=(selectedPage===12 && navigationHistory.length===1); goBack(); opened && selectedPage===0 && navigationHistory.length===0")
        );
        const QVariant result = navigationTest.evaluate();
        if (navigationTest.hasError() || !result.toBool()) return 9;
        return 0;
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
