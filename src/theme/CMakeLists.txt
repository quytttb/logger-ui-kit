# UI theme — QML singletons + C++ Quick Controls bootstrap.

set_source_files_properties(ThemeMode.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(AppColors.qml           PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(AppTheme.qml            PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(AppTypography.qml       PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(logger_ui_kit_theme
    URI LoggerKit.Theme
    VERSION ${LOGGERKIT_QML_MODULE_VERSION}
    STATIC
    QML_FILES
        ThemeMode.qml
        AppColors.qml
        AppTheme.qml
        AppTypography.qml
)

add_library(logger_ui_kit_theme_setup STATIC
    ThemeSetup.cpp
)
target_include_directories(logger_ui_kit_theme_setup PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(logger_ui_kit_theme_setup PUBLIC Qt6::QuickControls2)

add_library(LoggerKit::theme ALIAS logger_ui_kit_theme)
add_library(LoggerKit::theme_setup ALIAS logger_ui_kit_theme_setup)
