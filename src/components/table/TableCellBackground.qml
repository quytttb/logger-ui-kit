pragma ComponentBehavior: Bound

import QtQuick

import LoggerKit.Theme

// M3 table cell background: row divider (no zebra — avoids corner bleed on
// rounded panes). Kiosk is touch-only: no hover highlight; selection is drawn
// by the caller (selected fill + accent bar). cellHovered kept for API
// compatibility — always pass false.
Rectangle {
    required property bool cellHovered

    anchors.fill: parent
    color: cellHovered ? AppColors.hoverFill : "transparent"

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: AppColors.outlineVariant
    }
}
