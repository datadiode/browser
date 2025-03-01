/*
 * Copyright 2007-2008 Aaron Dewes <aaron.dewes@web.de>
 * Copyright 2008 Matvey Kozhev <sikon@ubuntu.com>
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

#include "aboutdialog.h"

#include <qdialogbuttonbox.h>
#include <qfile.h>
#include <qlabel.h>
#include <qlayout.h>
#include <qtextedit.h>
#include <qtextstream.h>

#include <qtwebkitversion.h>
#include <qwebkitglobal.h>

#ifdef Q_OS_WIN
#include <windows.h>
#include "VersionData.h"
static QString qWolfSSLVersion()
{
    QString version;
    if (HMODULE const h = GetModuleHandleW(L"wolfssl.dll"))
        if (CVersionData const *const pvd = CVersionData::Load(h)->Find(L"StringFileInfo")->First()->Find(L"ProductVersion"))
            version = QString::fromUtf16(reinterpret_cast<const ushort *>(pvd->Data()));
    return version;
}
#else
typedef QString qWolfSSLVersion;
#endif

AboutDialog::AboutDialog(QWidget *parent)
    : QDialog(parent)
{
    setupUi(this);
    setWindowTitle(tr("About %1").arg(qApp->applicationName()));
    logo->setPixmap(qApp->windowIcon().pixmap(128, 128));
    name->setText(qApp->applicationName());
    version->setText(qApp->applicationVersion());
    QStringList versions;
    versions += tr("WebKit version: %1").arg(qWebKitVersion());
    versions += tr("wolfSSL version: %1").arg(qWolfSSLVersion());
    static char16_t const separator[] = { 0x20, 0x2022, 0x20 };
    webkitVersion->setText(versions.join(QString::fromUtf16(separator)));
    connect(authorsButton, SIGNAL(clicked()),
            this, SLOT(authorsButtonClicked()));
    connect(licenseButton, SIGNAL(clicked()),
            this, SLOT(licenseButtonClicked()));
}

void AboutDialog::displayFile(const QString &fileName, const QString &title)
{
    QDialog dialog(this);
    QVBoxLayout layout(&dialog);
    QTextEdit textEdit(&dialog);
    QDialogButtonBox buttonBox(QDialogButtonBox::Close, Qt::Horizontal, &dialog);

    textEdit.setLayoutDirection(Qt::LeftToRight);

    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly))
        return;

    QTextStream stream(&file);
    stream.setCodec("UTF-8");
    QString text = stream.readAll();
    // this is done to force the content of the text editor to be LTR, and monospaced.
    textEdit.setHtml(QString(QLatin1String("<pre>%1</pre>")).arg(text));

    textEdit.setReadOnly(true);
    connect(&buttonBox, SIGNAL(rejected()), &dialog, SLOT(close()));
    buttonBox.setCenterButtons(true);
    layout.addWidget(&textEdit);
    layout.addWidget(&buttonBox);
    layout.setMargin(6);

    dialog.setLayout(&layout);
    dialog.setWindowTitle(title);
    dialog.setWindowFlags(Qt::Sheet);
    dialog.resize(600, 350);
    dialog.exec();
}

void AboutDialog::authorsButtonClicked()
{
    displayFile(QLatin1String(":AUTHORS"), tr("Authors"));
}

void AboutDialog::licenseButtonClicked()
{
    displayFile(QLatin1String(":LICENSE.GPL2"), tr("License"));
}

