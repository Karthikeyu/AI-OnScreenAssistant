#include <windows.h>
#include <QGuiApplication>
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QPointer>
#include <QTimer>
#include <QDebug>
#include <thread>
#include <QObject>
#include <QSystemTrayIcon>
#include <QMenu>
#include <QAction>
#include <QApplication>

#include "GroqAPI.h"

HWND g_hotkeyHwnd = nullptr;

class ShutdownHelper : public QObject {
    Q_OBJECT
public slots:
    void shutdownApp() {
        qDebug() << "💥 Quit requested from QML";
        PostQuitMessage(0);  // cleanly exit GetMessage loop
        QCoreApplication::quit();
    }
};



void registerHotkeyThread(QPointer<QQuickWindow> mainWnd) {
    std::thread([mainWnd]() {
        HWND hwnd = GetConsoleWindow();  // Dummy window
        g_hotkeyHwnd = hwnd;
        if (!RegisterHotKey(hwnd, 1, MOD_SHIFT, 0x51)) {
            qDebug() << "❌ Failed to register hotkey:" << GetLastError();
            return;
        }

        qDebug() << "✅ Hotkey registered (Shift+Q)";

        MSG msg;
        while (GetMessage(&msg, nullptr, 0, 0)) {
            if (msg.message == WM_HOTKEY && msg.wParam == 1) {
                qDebug() << "🔥 Hotkey received in thread";
                QMetaObject::invokeMethod(QCoreApplication::instance(), [mainWnd]() {
                    if (mainWnd && !mainWnd.isNull()) {
                        qDebug() << "🎯 Showing window via thread callback";
                        if(mainWnd->isVisible())
                        {
                            mainWnd->hide();
                        }else
                        {
                            mainWnd->show();
                            mainWnd->raise();
                            mainWnd->requestActivate();

                        }

                    }
                }, Qt::QueuedConnection);
            }
        }
    }).detach();
}

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQuickWindow::setDefaultAlphaBuffer(true);

    QQmlApplicationEngine engine;
    GroqApi groq;
    engine.rootContext()->setContextProperty("groq", &groq);
    engine.loadFromModule("AIOnScreenAssistant", "Main");

    const auto roots = engine.rootObjects();
    if (roots.isEmpty()) return -1;

    QPointer<QQuickWindow> mainWnd = qobject_cast<QQuickWindow *>(roots.first());
    if (!mainWnd) return -1;

#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(mainWnd->winId());
    SetWindowDisplayAffinity(hwnd, WDA_EXCLUDEFROMCAPTURE);
#endif

    // Tray icon setup
    QSystemTrayIcon *trayIcon = new QSystemTrayIcon(QIcon(":/icons/app_icon.png"), &app);
    trayIcon->setIcon(QIcon(":/icons/app_icon.png"));
    mainWnd->setIcon(QIcon(":/icons/app_icon.png"));
    trayIcon->setVisible(true);

    // Optional: context menu
    QMenu *trayMenu = new QMenu();
    QAction *quitAction = trayMenu->addAction("Quit");
    QObject::connect(quitAction, &QAction::triggered, &app, &QCoreApplication::quit);

    trayIcon->setContextMenu(trayMenu);
    trayIcon->setToolTip("AI On-Screen Assistant");
    trayIcon->show();
    trayIcon->showMessage("AI Assistant", "Application minimized to tray.");

    // Optional: toggle window on tray icon click
    QObject::connect(trayIcon, &QSystemTrayIcon::activated, [mainWnd](QSystemTrayIcon::ActivationReason reason) {
        if (reason == QSystemTrayIcon::Trigger) { // single click
            if (mainWnd->isVisible())
                mainWnd->hide();
            else
                mainWnd->show();
        }
    });

    ShutdownHelper shutdown;
    engine.rootContext()->setContextProperty("shutdown", &shutdown);

    registerHotkeyThread(mainWnd);  // ✅ Launch background thread


    QObject::connect(&app, &QCoreApplication::aboutToQuit, []() {
        UnregisterHotKey(nullptr, 1);
    });


    return app.exec();
}

#include "main.moc"

