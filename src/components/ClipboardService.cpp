#include "ClipboardService.h"

#include <QClipboard>
#include <QFileInfo>
#include <QGuiApplication>
#include <QJSEngine>
#include <QQmlEngine>

namespace LoggerKit::Components {

ClipboardService *ClipboardService::create(QQmlEngine *engine, QJSEngine *)
{
    static ClipboardService *instance = new ClipboardService();
    engine->setObjectOwnership(instance, QQmlEngine::CppOwnership);
    return instance;
}

QString ClipboardService::fileBaseName(const QString &path)
{
    return QFileInfo(path).fileName();
}

bool ClipboardService::copyToClipboard(const QString &text)
{
    if (text.isEmpty())
        return false;
    if (QClipboard *cb = QGuiApplication::clipboard())
        cb->setText(text);
    return true;
}

} // namespace LoggerKit::Components
