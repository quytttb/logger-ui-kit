pragma ComponentBehavior: Bound

import QtTest

import LoggerKit.Components

// Smoke tests for the AppNotifier singleton state machine.
TestCase {
    name: "AppNotifierTests"

    function init() {
        AppNotifier.dismiss()
        AppNotifier.suppressed = false
    }

    function test_show_setsToastState() {
        AppNotifier.show("Saved", "success", { detailText: "row 12", contextId: 7 })
        verify(AppNotifier.toastVisible)
        compare(AppNotifier.toastSummary, "Saved")
        compare(AppNotifier.toastSemantic, "success")
        compare(AppNotifier.pendingDetailText, "row 12")
        compare(AppNotifier.pendingDetailTitle, "Saved")
        compare(AppNotifier.pendingDetailContextId, 7)
    }

    function test_dismiss_hidesToast() {
        AppNotifier.show("x")
        verify(AppNotifier.toastVisible)
        AppNotifier.dismiss()
        verify(!AppNotifier.toastVisible)
    }

    function test_suppressed_ignoresShow() {
        AppNotifier.suppressed = true
        AppNotifier.show("nope")
        verify(!AppNotifier.toastVisible)
    }

    function test_openDetail_emitsSignalWithPayload() {
        let got = null
        AppNotifier.detailRequested.connect((t, b, id) => { got = [t, b, id] })

        AppNotifier.openDetail("T", "B", 42)
        compare(got[0], "T")
        compare(got[1], "B")
        compare(got[2], 42)

        got = null
        AppNotifier.openDetail("OnlyTitle")
        compare(got[0], "OnlyTitle")
        compare(got[1], "")
        compare(got[2], -1)
    }

    function test_show_defaults() {
        AppNotifier.show("m")
        compare(AppNotifier.toastSemantic, "info")
        compare(AppNotifier.toastDurationMs, 5000)
        compare(AppNotifier.pendingCopyPath, "")
        compare(AppNotifier.pendingDetailContextId, -1)

        AppNotifier.show("m", "info", { copyPath: "/tmp/x.log" })
        compare(AppNotifier.pendingCopyPath, "/tmp/x.log")

        AppNotifier.show("m", "info", { durationMs: 900 })
        compare(AppNotifier.toastDurationMs, 900)
    }
}
