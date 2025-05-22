#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "App/Media/player.h"
#include "App/Media/playlistmodel.h"
#include "App/Climate/climatemodel.h"
#include "applicationsmodel.h"
#include "xmlreader.h"
#include <QDebug>

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    qDebug() << "Khoi tao chuong trinh";
    ApplicationsModel appsModel;
    Player player;
    ClimateModel climateModel;

    XmlReader xmlReader(":/applications.xml", appsModel);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appsModel", &appsModel);
    engine.rootContext()->setContextProperty("player", &player);
    engine.rootContext()->setContextProperty("playlistModel", player.m_playlistModel);
    engine.rootContext()->setContextProperty("mediaPlayer", player.mediaPlayer());
    engine.rootContext()->setContextProperty("climateModel", &climateModel);

    const QUrl url(QStringLiteral("qrc:/Qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);

    // Notify signal to QML for reading data from D-Bus
    emit climateModel.dataChanged();

    return app.exec();
}
