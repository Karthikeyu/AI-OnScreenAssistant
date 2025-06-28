#if defined(_WIN32) || defined(_WIN64)
#define _WIN32_WINNT 0x0A00
#include <windows.h>
#endif


#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include<QTimer>
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

    // Find the main app window by object name
    const auto rootList = engine.rootObjects();
    //qDebug() << "Root object count:" << rootList.size();

    QObject *mainRoot = !rootList.isEmpty() ? rootList.first(): nullptr;
   // qDebug() << "mainRoot is null?" << (mainRoot == nullptr);

// qDebug() << "helllo";
    if (mainRoot) {
        QQuickWindow *mainWindow = qobject_cast<QQuickWindow *>(mainRoot);
       //  qDebug() << "helllo";
        if (mainWindow) {
            //qDebug() << "helllo";
            QTimer::singleShot(0, mainWindow, [mainWindow]() {
#ifdef Q_OS_WIN
                HWND hwnd = (HWND) mainWindow->winId();
                BOOL success = SetWindowDisplayAffinity(hwnd, WDA_EXCLUDEFROMCAPTURE);
                qDebug() << "Display Affinity result:" << success;
               // qDebug() << "helllo";
#endif
            });
        }
    }




    return app.exec();
}
