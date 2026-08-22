pragma Singleton
import QtQuick

// Central singleton for application-level toast and detail-dialog notifications.
//
// AppNotifier.show(summary, semantic, options?)
//   options: { detailText, detailTitle, copyPath, contextId, durationMs }
//   copyPath set → toast tap copies that path to the clipboard
//   contextId    → opaque id passed back via detailRequested (e.g. a logger id);
//                  hosts that don't need it simply ignore it (-1 = none)
QtObject {
    id: root

    property string toastSummary:  ""
    property string toastSemantic: "info"
    property bool   toastVisible:  false
    property int    toastDurationMs: 5000

    property string pendingCopyPath: ""

    property string pendingDetailText:     ""
    property string pendingDetailTitle:    ""
    property int    pendingDetailContextId: -1

    property bool suppressed: false

    function show(summary, semantic, options) {
        if (suppressed) return
        toastSummary   = summary  || ""
        toastSemantic  = semantic || "info"
        toastDurationMs = (options && options.durationMs > 0) ? options.durationMs : 5000
        pendingCopyPath = (options && options.copyPath) ? options.copyPath : ""
        pendingDetailText    = (options && options.detailText)  ? options.detailText  : ""
        pendingDetailTitle   = (options && options.detailTitle) ? options.detailTitle : (summary || "")
        pendingDetailContextId = (options && options.contextId !== undefined && options.contextId >= 0)
                                 ? options.contextId : -1
        toastVisible = true
    }

    function dismiss() {
        toastVisible = false
    }

    function openDetail(title, body, contextId) {
        root.detailRequested(title || "", body || "",
                             (contextId !== undefined && contextId >= 0) ? contextId : -1)
    }

    signal detailRequested(string title, string body, int contextId)
}
