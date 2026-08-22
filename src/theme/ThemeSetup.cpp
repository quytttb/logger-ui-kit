#include "ThemeSetup.h"

#include <QQuickStyle>
#include <QString>

namespace LoggerKit::Theme {

void applyQuickControlsStyle()
{
    QQuickStyle::setStyle(QString::fromUtf8(kQuickControlsStyle));
}

} // namespace LoggerKit::Theme
