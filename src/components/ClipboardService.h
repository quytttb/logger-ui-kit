#pragma once

#include <QObject>
#include <QString>
#include <QtQmlIntegration/qqmlintegration.h>

class QJSEngine;
class QQmlEngine;

namespace LoggerKit::Components {

/// Clipboard + file-path helper exposed to QML (LoggerKit.Components.ClipboardService).
/// Backs AppToastHost "Copy path" and any view that copies text to the clipboard.
class ClipboardService : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    static ClipboardService *create(QQmlEngine *, QJSEngine *);

    /// Copies @p text to the system clipboard. Returns false when @p text is empty.
    Q_INVOKABLE static bool copyToClipboard(const QString &text);

    /// File name (basename) of a full path — for compact "saved: <name>" messages.
    Q_INVOKABLE static QString fileBaseName(const QString &path);

private:
    explicit ClipboardService(QObject *parent = nullptr) : QObject(parent) {}
};

} // namespace LoggerKit::Components
