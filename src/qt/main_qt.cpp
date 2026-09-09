#include "qt/CockpitBridge.hpp"
#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);
    nexvary::avionics::CockpitBridge cockpit;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("cockpit"), &cockpit);
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty()) return 2;

    if (QCoreApplication::arguments().contains(QStringLiteral("--smoke"))) {
        QTimer::singleShot(200, &app, &QCoreApplication::quit);
    }
    return app.exec();
}
