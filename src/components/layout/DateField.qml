pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import LoggerKit.Components
import LoggerKit.Theme

// Read-only date field (dd/MM/yyyy) — opens DatePickerPopup anchored below the input.
Item {
    id: root

    property alias text: field.text
    property date date: parseDate(field.text)
    readonly property alias pickerPopup: picker
    property var initialDate: new Date()
    property string placeholderText: ""

    implicitWidth: field.implicitWidth
    implicitHeight: field.implicitHeight

    Accessible.role: Accessible.Button
    Accessible.name: qsTr("Choose date")

    // TapHandler đặt trên root (bao cả icon schedule) — tap đúng icon
    // lịch vẫn mở picker; không steal scroll/gesture, đúng cho kiosk touch.
    TapHandler {
        onTapped: root.openPicker()
    }
    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    function formatDate(d) {
        const dd = String(d.getDate()).padStart(2, "0")
        const mm = String(d.getMonth() + 1).padStart(2, "0")
        const yyyy = d.getFullYear()
        return dd + "/" + mm + "/" + yyyy
    }

    function parseDate(s) {
        const parts = String(s || "").split("/")
        if (parts.length !== 3)
            return new Date(NaN)
        const day = parseInt(parts[0], 10)
        const month = parseInt(parts[1], 10) - 1
        const year = parseInt(parts[2], 10)
        return new Date(year, month, day)
    }

    function openPicker() {
        const parsed = parseDate(field.text)
        picker.selectedDate = isNaN(parsed.getTime()) ? initialDate : parsed

        const gap = 4
        const mapped = field.mapToItem(Overlay.overlay, 0, field.height + gap)
        picker.width = Math.max(340, field.width)
        // Clamp vào overlay để popup không tràn màn kiosk 1024x600.
        const ov = Overlay.overlay
        picker.x = Math.max(0, Math.min(mapped.x, ov.width - picker.width))
        picker.y = Math.max(0, Math.min(mapped.y, ov.height - picker.height))
        picker.open()
    }

    Component.onCompleted: {
        if (!field.text.length)
            field.text = formatDate(initialDate)
    }

    DatePickerPopup {
        id: picker
        parent: Overlay.overlay
        onDatePicked: d => { field.text = root.formatDate(d) }
    }

    TextField {
        id: field
        anchors.fill: parent
        readOnly: true
        Material.containerStyle: Material.Outlined
        Material.theme: AppTheme.materialTheme
        font: AppTypography.bodyMedium
        placeholderText: root.placeholderText
        horizontalAlignment: Text.AlignHCenter
        leftPadding: 8
        rightPadding: 32

        Keys.onReturnPressed: root.openPicker()
        Keys.onSpacePressed: root.openPicker()
    }

    UiIcon {
        name: "schedule"
        size: AppTheme.iconSizeSm
        iconColor: AppColors.iconSubtle
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
    }
}
