#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QTranslator>
#include <QLocale>
#include <QQmlContext>
#include "LanguageManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Gán icon app
    app.setWindowIcon(QIcon("assets/icons/favicon.ico"));

    // Tạo đối tượng quản lý ngôn ngữ
    LanguageManager languageManager;

    // Load ngôn ngữ mặc định dựa trên hệ thống
    QTranslator translator;
    QString locale = QLocale::system().name(); // "vi_VN", "en_US"
    locale = "vi_VN";
    languageManager.setCurrentLanguage(locale);

    // Đưa Translator vào QML
    engine.rootContext()->setContextProperty("currentLanguage", locale);
    engine.rootContext()->setContextProperty("languageManager", &languageManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("MediaPlayer", "Main");

    return app.exec();
}
