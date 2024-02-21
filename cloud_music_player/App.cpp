#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include "httputils.h"
#include "musicmetadata.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<HttpUtils>("MyUtils",1,0,"HttpUtils");// 注册至qml中的模块
    qmlRegisterType<MusicMetadata>("MusicMetadata",1,0,"MusicMetadata");

    app.setWindowIcon(QIcon(":/images/format.ico"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
