# Reusable QML components — module URI LoggerKit.Components
# Shared by central_logger + data-logger. Material controls + one C++ singleton
# (ClipboardService). No app-specific domain logic here.
#
# Subfolders (filesystem only; types stay on LoggerKit.Components):
#   shell/   — buttons, icons
#   layout/  — panes, empty states, notifications, date picker
#   table/   — data table chrome
#   chart/   — Qt Graphs wrappers
#   status/  — generic StatusChip

set_source_files_properties(shell/MaterialIcons.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(layout/AppNotifier.qml  PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(logger_ui_kit_components
    URI LoggerKit.Components
    VERSION ${LOGGERKIT_QML_MODULE_VERSION}
    STATIC
    SOURCES
        ClipboardService.h
        ClipboardService.cpp
    QML_FILES
        # shell
        shell/AppButton.qml
        shell/UiIcon.qml
        shell/MaterialIcons.qml
        # layout
        layout/ElevatedPane.qml
        layout/EmptyStatePlaceholder.qml
        layout/TableContentStack.qml
        layout/AppScrollBar.qml
        layout/AppNotifier.qml
        layout/AppToastHost.qml
        layout/MessageDetailDialog.qml
        layout/DateField.qml
        layout/DatePickerPopup.qml
        # table
        table/AppTableView.qml
        table/TableHeaderCell.qml
        table/TableCellBackground.qml
        # chart
        chart/ChartGraphsTheme.qml
        chart/ChartGraphsView.qml
        chart/ChartLinePointMarker.qml
        # status
        status/StatusChip.qml
    RESOURCES
        ../../resources/fonts/MaterialSymbols/MaterialSymbolsOutlined.ttf
        ../../resources/icons/brand_4m_technologies_blue.svg
    DEPENDENCIES
        LoggerKit.Theme
        QtQuick
        QtGraphs
)

target_link_libraries(logger_ui_kit_components PRIVATE Qt6::Gui)

add_library(LoggerKit::components ALIAS logger_ui_kit_components)
