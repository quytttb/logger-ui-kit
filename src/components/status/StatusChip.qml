import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import LoggerKit.Components
import LoggerKit.Theme

// Generic chip. Two modes:
//   indicator  — set `label` (+ indicatorActive/colors): pill with a status dot.
//   status     — leave `label` empty and set `chipText` + fill/border/text colors
//                (and optional `statusIconName`). Domain logic (operational status,
//                attach-DI type, …) lives in the host and feeds these properties.
Item {
    id: root

    // Indicator mode
    property string label: ""
    property bool indicatorActive: false
    property color indicatorActiveColor: AppColors.success
    property color indicatorInactiveColor: AppColors.outline

    // Status mode (host-computed)
    property string chipText: ""
    property string statusIconName: ""
    property color chipFill:      AppColors.withAlpha(AppColors.onSurfaceVariant, 0.18)
    property color chipBorder:    AppColors.outline
    property color chipTextColor: AppColors.onSurfaceVariant

    readonly property bool indicatorMode: label.length > 0

    readonly property string displayText: indicatorMode ? label : chipText
    readonly property color displayFill: indicatorMode ? "transparent" : chipFill
    readonly property color displayBorder: indicatorMode
        ? (indicatorActive ? indicatorActiveColor : indicatorInactiveColor)
        : chipBorder
    readonly property color displayTextColor: indicatorMode
        ? (indicatorActive ? indicatorActiveColor : indicatorInactiveColor)
        : chipTextColor

    readonly property bool hasContent: indicatorMode || displayText.length > 0
    readonly property int chipHeight: indicatorMode ? 30 : 24

    implicitHeight: hasContent ? chipHeight : 0
    implicitWidth: hasContent ? chipBox.width : 0
    visible: hasContent

    Rectangle {
        id: chipBox
        anchors.verticalCenter: parent.verticalCenter
        height: root.chipHeight
        width: chipContent.implicitWidth + (root.indicatorMode ? 28 : 24)
        radius: root.indicatorMode ? height / 2 : AppTheme.chipRadius
        color: root.displayFill
        border.width: 1
        border.color: root.displayBorder

        RowLayout {
            id: chipContent
            anchors.centerIn: parent
            spacing: root.indicatorMode ? 6 : 2

            Rectangle {
                visible: root.indicatorMode
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                radius: width / 2
                color: root.indicatorActive ? root.indicatorActiveColor
                                            : root.indicatorInactiveColor
            }

            UiIcon {
                visible: !root.indicatorMode && root.statusIconName.length > 0
                Layout.alignment: Qt.AlignVCenter
                name: root.statusIconName
                size: AppTheme.iconSizeSm
                iconColor: root.displayTextColor
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                text: root.displayText
                font: AppTypography.labelSmall
                color: root.displayTextColor
                elide: Text.ElideNone
                maximumLineCount: 1
            }
        }
    }
}
