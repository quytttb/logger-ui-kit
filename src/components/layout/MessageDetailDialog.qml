pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material

import LoggerKit.Components
import LoggerKit.Theme

// Generic modal dialog for full error / info messages.
// Opened via AppNotifier.openDetail() → host Main.qml → showMessage().
//
// Footer:
//   "Close" — always present; optional context action when contextId >= 0
//   and not hidden. Host wires `contextActionText` + `contextActionRequested`.
Dialog {
    id: root

    property string detailTitle:    ""
    property string detailBody:     ""
    property int    detailContextId: -1
    /// When true, footer hides the context action (e.g. already on that context's view).
    property bool   hideContextAction: false
    /// Label for the context action button (empty = no button even when contextId >= 0).
    property string contextActionText: ""

    signal contextActionRequested(int contextId)

    function showMessage(title, body, contextId, hideContextAction) {
        root.detailTitle     = title  || ""
        root.detailBody      = body   || ""
        root.detailContextId = (contextId !== undefined && contextId >= 0) ? contextId : -1
        root.hideContextAction = hideContextAction === true
        root.open()
    }

    title: root.detailTitle
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    standardButtons: Dialog.NoButton

    width: parent
        ? Math.min(parent.width - 48, AppTheme.dialogMaxWidth)
        : AppTheme.dialogMaxWidth
    anchors.centerIn: parent

    Material.roundedScale: Material.ExtraLargeScale

    contentItem: ScrollView {
        id: scrollView
        clip: true
        implicitHeight: Math.min(bodyText.implicitHeight + 8, 320)

        TextArea {
            id: bodyText
            text: root.detailBody
            readOnly: true
            selectByMouse: true
            wrapMode: Text.WordWrap
            font: AppTypography.bodyMedium
            color: AppColors.primaryText
            background: null
            padding: 0
            topPadding: 0
            bottomPadding: 0
        }
    }

    footer: DialogButtonBox {
        spacing: 8

        AppButton {
            kind: AppButton.Tonal
            text: root.contextActionText
            visible: root.detailContextId >= 0
                     && !root.hideContextAction
                     && root.contextActionText.length > 0
            DialogButtonBox.buttonRole: DialogButtonBox.ActionRole
            onClicked: {
                root.close()
                root.contextActionRequested(root.detailContextId)
            }
        }

        AppButton {
            kind: AppButton.Text
            text: qsTr("Close")
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            onClicked: root.close()
        }
    }
}
