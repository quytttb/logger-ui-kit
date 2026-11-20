pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import LoggerKit.Theme

// Presentation from Data Logger's Monitor view. Hosts supply validity, status,
// thresholds and actions; this component doesn't interpret TT10 or alarm rules.
Rectangle {
    id: root

    property string name: ""
    property string unit: ""
    property string value: ""
    property string sensorType: ""
    property bool valid: false
    property bool digitalOn: false
    property string statusText: ""
    property color statusColor: AppColors.outlineVariant
    property color statusFill: AppColors.withAlpha(statusColor, 0.12)
    property string alarmText: ""
    property list<string> attachDiLabels: []
    property string limitText: ""
    property color valueColor: alarmText.length > 0 ? AppColors.error : AppColors.primaryText
    property Component footerAction: null
    property int frameWidth: digitalActive ? 2 : 1
    property bool filled: false
    property color fillColor: AppColors.monitorCardBg

    property bool compact: !ThemeMode.touch
    property real fontScale: 1.0

    readonly property bool input: sensorType === "DI"
    readonly property bool digital: input || sensorType === "DO"
    readonly property bool digitalActive: digital && valid && digitalOn
    readonly property color ioAccent: input ? IoColors.diActive : IoColors.doActive
    readonly property color ioStrong: input ? IoColors.diStrong : IoColors.doStrong
    readonly property string displayValue: !valid ? qsTr("—")
        : digital ? (digitalOn ? qsTr("ON") : qsTr("OFF")) : value

    // Preserve the kiosk Monitor typography at scale 1; desktop uses denser tokens.
    readonly property real nameSize: fontScale * (compact ? AppTypography.titleSmall.pixelSize : 28)
    readonly property real unitSize: fontScale * (compact ? AppTypography.bodySmall.pixelSize : 24)
    readonly property real valueSize: fontScale * (compact ? AppTypography.headlineSmall.pixelSize : 42)
    readonly property real badgeSize: fontScale * (compact ? AppTypography.labelSmall.pixelSize : 20)
    readonly property real pillSize: fontScale * (compact ? AppTypography.labelSmall.pixelSize : 18)

    implicitWidth: compact ? 208 : 228
    implicitHeight: Math.max(compact ? 128 : 160, content.implicitHeight + 2 * AppTheme.spacingSM)
    radius: AppTheme.cardRadius
    color: filled ? fillColor : AppColors.monitorCardBg
    border.color: AppColors.withAlpha(digital ? (digitalActive ? ioAccent : AppColors.outlineVariant)
                                             : statusColor, 0.65)
    border.width: filled ? 0 : frameWidth

    component Badge: Rectangle {
        id: badge

        property alias text: label.text
        property alias textColor: label.color

        implicitWidth: label.implicitWidth + 10
        implicitHeight: label.implicitHeight + AppTheme.spacingXS
        radius: AppTheme.radiusTiny
        border.width: 0

        Text {
            id: label
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.pixelSize: root.badgeSize
            font.bold: true
        }
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: AppTheme.spacingSM
        spacing: AppTheme.spacingXS

        RowLayout {
            Layout.fillWidth: true
            spacing: AppTheme.spacingS

            Rectangle {
                visible: root.digital
                implicitWidth: root.compact ? 32 : 44
                implicitHeight: root.compact ? 20 : 26
                radius: AppTheme.radiusTiny
                color: root.ioStrong

                Text {
                    anchors.centerIn: parent
                    text: root.input ? qsTr("DI") : qsTr("DO")
                    color: AppColors.onPrimary
                    font.pixelSize: root.pillSize
                    font.bold: true
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.name
                color: AppColors.primaryText
                elide: Text.ElideRight
                font.pixelSize: root.nameSize
                font.bold: true
            }

            Text {
                visible: !root.digital && root.unit.length > 0
                Layout.maximumWidth: 120
                text: root.unit
                color: AppColors.onSurfaceVariant
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight
                font.pixelSize: root.unitSize
                font.bold: true
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: root.digital ? digitalBody.implicitHeight : reading.implicitHeight

            Text {
                id: reading
                objectName: "sensorReading"
                visible: !root.digital
                width: parent.width
                anchors.centerIn: parent
                text: root.displayValue
                color: root.valueColor
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                font.family: AppTypography.monoFamily
                font.pixelSize: root.valueSize
                font.weight: Font.DemiBold
            }

            Column {
                id: digitalBody
                visible: root.digital
                anchors.centerIn: parent
                width: parent.width
                spacing: AppTheme.spacingXS

                Rectangle {
                    width: root.compact ? 40 : 56
                    height: width
                    radius: width / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.digitalActive ? (root.input ? IoColors.diOnBg : IoColors.doStrong)
                                              : IoColors.ioInactive
                    border.color: root.digitalActive ? root.ioAccent : IoColors.ioInactiveBorder
                    border.width: 3

                    Text {
                        objectName: "sensorIoValue"
                        anchors.centerIn: parent
                        text: root.displayValue
                        color: AppColors.onPrimary
                        font.pixelSize: root.fontScale
                            * (root.compact ? AppTypography.bodyMedium.pixelSize : 24)
                        font.bold: true
                    }
                }

                Text {
                    width: parent.width
                    text: root.input
                        ? (!root.valid ? qsTr("INPUT UNKNOWN") : root.digitalOn ? qsTr("INPUT ON") : qsTr("INPUT OFF"))
                        : (!root.valid ? qsTr("RELAY UNKNOWN") : root.digitalOn ? qsTr("RELAY ON") : qsTr("RELAY OFF"))
                    color: root.digitalActive ? root.ioAccent : AppColors.onSurfaceVariant
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    font.pixelSize: root.fontScale
                        * (root.compact ? AppTypography.labelSmall.pixelSize : 22)
                    font.bold: true
                }
            }
        }

        Text {
            objectName: "sensorLimit"
            visible: root.limitText.length > 0
            Layout.fillWidth: true
            text: root.limitText
            color: AppColors.onSurfaceVariant
            elide: Text.ElideRight
            font.pixelSize: root.badgeSize
        }

        Text {
            objectName: "sensorAttachedInputs"
            readonly property string summary: root.attachDiLabels.join(" · ")
            visible: summary.length > 0
            Layout.fillWidth: true
            text: summary
            color: AppColors.onSurfaceVariant
            elide: Text.ElideRight
            font.pixelSize: root.badgeSize
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: AppTheme.spacingXS

            Badge {
                objectName: "sensorStatus"
                visible: root.statusText.length > 0
                Layout.minimumWidth: 0
                text: root.statusText
                textColor: root.statusColor
                color: root.statusFill
            }

            Item { Layout.fillWidth: true }

            Loader {
                visible: item !== null
                sourceComponent: root.footerAction
            }

            Badge {
                objectName: "sensorAlarm"
                visible: root.alarmText.length > 0
                text: root.alarmText
                textColor: AppColors.error
                color: AppColors.withAlpha(AppColors.error, 0.20)
                border.color: AppColors.error
                border.width: 1
            }
        }
    }
}
