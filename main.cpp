#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include"GroqAPI.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Enables transparency support
    QQuickWindow::setDefaultAlphaBuffer(true);


    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    GroqApi groq;
    engine.rootContext()->setContextProperty("groq", &groq);
    engine.loadFromModule("AIOnScreenAssistant", "Main");


    return app.exec();
}
