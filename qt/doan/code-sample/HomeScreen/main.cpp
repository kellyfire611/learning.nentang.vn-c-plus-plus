#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "App/Media/player.h"
#include "App/Media/playlistmodel.h"
#include "App/Climate/climatemodel.h"
#include "applicationsmodel.h"
#include "xmlreader.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    ApplicationsModel appsModel;
    XmlReader xmlReader("applications.xml", appsModel);
    engine.rootContext()->setContextProperty("appsModel", &appsModel);

    Player player;
    engine.rootContext()->setContextProperty("playlistModel", player.m_playlistModel);
    engine.rootContext()->setContextProperty("mediaPlayer", player.m_player);
    engine.rootContext()->setContextProperty("player", &player);

    ClimateModel climate;
    engine.rootContext()->setContextProperty("climateModel", &climate);

    const QUrl url(QStringLiteral("qrc:/Qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);

    // Notify signal to QML for reading data from D-Bus
    emit climate.dataChanged();

    return app.exec();
}
