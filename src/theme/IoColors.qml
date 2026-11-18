pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick

// Shared digital input and relay indicator colors, lifted from Data Logger.
QtObject {
    readonly property color diStrong:         "#1E88E5"
    readonly property color diActive:         "#42A5F5"
    readonly property color diOnBg:           "#1565C0"
    readonly property color diTint:           "#103010"
    readonly property color doStrong:         "#C62828"
    readonly property color doActive:         "#EF5350"
    readonly property color doTint:           "#301010"
    readonly property color ioInactive:       "#616161"
    readonly property color ioInactiveBorder: "#9E9E9E"
    readonly property color ioFallback:       "#888888"
}
