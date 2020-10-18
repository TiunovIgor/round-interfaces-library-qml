#include <QGuiApplication>
#include <QCoreApplication>
#include <QQmlApplicationEngine>
#include <QtWebView>
//#include <QtWebEngine/QtWebEngine>
#include <QtQuick/QQuickView>
#include <QQmlContext>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    int id = QFontDatabase::addApplicationFont(":/fonts/OpenSans-Regular.ttf");
    QString family = QFontDatabase::applicationFontFamilies(id).at(0);
    QFont openSans(family);
    app.setFont(openSans);

    QtWebView::initialize();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    engine.rootContext()->setContextProperty("workingDirectory", QUrl::fromLocalFile(app.applicationDirPath()));

    return app.exec();
}
