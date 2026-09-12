#include "qt/CockpitBridge.hpp"
#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>
#include <QGuiApplication>
#include <QImage>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QTimer>

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);
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
        if (ok && page >= 0 && page <= 12) root->setProperty("selectedPage", page);
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
