pragma Singleton
import QtQuick

// Writable theme state — decouples the shared kit from any app-specific
// settings controller. Each host app binds these at startup, e.g.:
//
//   ThemeMode.mode = Qt.binding(() => SettingsController.theme)   // "light" | "dark"
//   ThemeMode.touch = true                                        // kiosk / finger input
//
// AppColors and AppTheme read from here only.
QtObject {
    // "light" or "dark".
    property string mode: "dark"

    // Enlarge touch targets (buttons, icon buttons) for finger input on kiosks.
    property bool touch: false
}
