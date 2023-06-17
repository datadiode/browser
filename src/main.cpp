/*
 * Copyright 2008 Aaron Dewes <aaron.dewes@web.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA  02110-1301  USA
 */

#include "browserapplication.h"
#include "browsermainwindow.h"
#include "tabwidget.h"

#ifdef Q_OS_WIN

class SingleInstance : public QWidget
{
    HANDLE handle;
public:
    bool reuse()
    {
        handle = CreateEventW(NULL, FALSE, FALSE, SINGLE_INSTANCE_GUID);
        if (handle != NULL && GetLastError() == ERROR_ALREADY_EXISTS) {
            QStringList args = QCoreApplication::arguments();
            if (HWND const hwnd = FindWindowW(NULL, SINGLE_INSTANCE_GUID)) {
                if (args.count() > 1) {
                    QString url = BrowserApplication::parseArgumentUrl(args.last());
                    COPYDATASTRUCT const cds = { 0, url.count() * sizeof(QChar), url.data() };
                    DWORD_PTR dwResult;
                    SendMessageTimeout(hwnd, WM_COPYDATA, 0, reinterpret_cast<LPARAM>(&cds), SMTO_NORMAL, 5000, &dwResult);
                }
                SetForegroundWindow(hwnd);
            }
            return true;
        }
        SetWindowTextW(reinterpret_cast<HWND>(winId()), SINGLE_INSTANCE_GUID);
        return false;
    }
    bool nativeEvent(const QByteArray &eventType, void *message, long *result)
    {
        MSG *const msg = static_cast<MSG *>(message);
        if (msg->message == WM_COPYDATA) {
            COPYDATASTRUCT *const cds = reinterpret_cast<COPYDATASTRUCT *>(msg->lParam);
            QString const url(static_cast<QChar *>(cds->lpData), cds->cbData / sizeof(QChar));
            QSettings settings;
            settings.beginGroup(QLatin1String("tabs"));
            TabWidget::OpenUrlIn tab = TabWidget::OpenUrlIn(settings.value(QLatin1String("openLinksFromAppsIn"), TabWidget::NewSelectedTab).toInt());
            settings.endGroup();
            BrowserApplication::instance()->mainWindow()->tabWidget()->loadString(url, tab);
        } else if (msg->message == WM_APP_RECOVER) {
            DestroyWindow(reinterpret_cast<HWND>(winId()));
            CloseHandle(handle);
            QString path = QCoreApplication::applicationFilePath();
            QStringList args;
            args.append(QLatin1String("endorphin://recover"));
            QProcess::startDetached(path, args);
            ::exit(3);
        }
        return false;
    }
};

#endif

void qtMessageHandler(QtMsgType, const QMessageLogContext &, const QString &msg)
{
    puts(msg.toUtf8().data());
}

int main(int argc, char **argv)
{
    Q_INIT_RESOURCE(htmls);
    Q_INIT_RESOURCE(data);
#ifdef Q_WS_X11
    QApplication::setGraphicsSystem(QString::fromLatin1("raster"));
#endif
    BrowserApplication application(argc, argv);
    qInstallMessageHandler(qtMessageHandler);
#ifdef Q_OS_WIN
    SingleInstance singleInstance;
    if (singleInstance.reuse())
        return 0;
#endif
    QFont font = QGuiApplication::font();
    font.setFamily("Segoe UI");
    font.setPointSize(14);
    application.setFont(font, "QMenu");
    application.setFont(font, "QMenuBar");
    font.setPointSize(12);
    application.setFont(font, "QTabBar");
    application.setAutoSipEnabled(true);
    application.newMainWindow();
    return application.exec();
}

