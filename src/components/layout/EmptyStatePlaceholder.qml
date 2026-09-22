pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

import LoggerKit.Theme

// Centered empty / waiting state: icon above, message below.
// Forward inner content size so the placeholder also works inside
// layouts that rely on implicit size (e.g. a ColumnLayout child with
// only Layout.fillWidth) instead of collapsing to height 0.
Item {
    id: root

    property string message: ""
    property string iconName: "informationOutline"
    property int    iconSize: 48

    implicitWidth: innerLayout.implicitWidth
    implicitHeight: innerLayout.implicitHeight

    ColumnLayout {
        id: innerLayout
        anchors.centerIn: parent
        width: Math.min(root.width > 0 ? root.width * 0.85 : 320, 400)
        spacing: 12

        UiIcon {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: root.iconSize
            Layout.preferredHeight: root.iconSize
            name: root.iconName
            size: root.iconSize
            iconColor: AppColors.emptyStateIcon
        }

        Label {
            Layout.fillWidth: true
            text: root.message
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font: AppTypography.bodyMedium
            color: AppColors.textSoft
        }
    }
}
