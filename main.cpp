#include <windows.h>
#include <shobjidl.h>  // For SetCurrentProcessExplicitAppUserModelID
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
#include <QFile>

#include "GroqAPI.h"

HWND g_hotkeyHwnd = nullptr;
QSystemTrayIcon* trayIcon = nullptr;  // Global pointer

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
                        if (mainWnd->isVisible()) {
                            qDebug() << "🙈 Hiding main window...";
                            mainWnd->hide();
                            trayIcon->hide();  // Force refresh
                            trayIcon->show();
                            trayIcon->showMessage(
                                "AI Assistant Running",
                                "App is minimized to tray. Press Shift+Q to reopen.",
                                QSystemTrayIcon::Information, 4000);
                        } else {
                            qDebug() << "👁️ Showing main window...";
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

#ifdef Q_OS_WIN
    // Important: Set AppUserModelID to make Windows treat the app as stable/known
    SetCurrentProcessExplicitAppUserModelID(L"com.busa.AIOnScreenAssistant");
#endif

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

    // --- Tray Icon Setup ---
    trayIcon = new QSystemTrayIcon(&app);
    QIcon trayAppIcon = QIcon(":/icons/app_icon.png");

    trayIcon->setIcon(trayAppIcon); // Set before show()
    trayIcon->setToolTip("AI On-Screen Assistant");
    trayIcon->setVisible(true);     // Call after icon is set

    //app.setWindowIcon(trayAppIcon);
    //mainWnd->setIcon(trayAppIcon);

    // --- Tray Menu ---
    QMenu *trayMenu = new QMenu();
    QAction *quitAction = trayMenu->addAction("Quit");
    QObject::connect(quitAction, &QAction::triggered, &app, &QCoreApplication::quit);
    trayIcon->setContextMenu(trayMenu);

    // --- Click to toggle window ---
    QObject::connect(trayIcon, &QSystemTrayIcon::activated, [mainWnd]() {
        if (mainWnd->isVisible()) {
            mainWnd->hide();
            trayIcon->hide();
            trayIcon->show();
            trayIcon->showMessage("AI Assistant Running",
                                  "App is minimized to tray. Press Shift+Q to reopen.",
                                  QSystemTrayIcon::Information, 3000);
        } else {
            mainWnd->show();
            mainWnd->raise();
            mainWnd->requestActivate();
        }
    });

    ShutdownHelper shutdown;
    engine.rootContext()->setContextProperty("shutdown", &shutdown);

    registerHotkeyThread(mainWnd);  // ✅ Launch background thread

    QObject::connect(&app, &QCoreApplication::aboutToQuit, []() {
        UnregisterHotKey(g_hotkeyHwnd, 1);
        if (trayIcon) trayIcon->hide();
    });

    return app.exec();
}

#include "main.moc"
