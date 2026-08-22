# logger-ui-kit — shared Material 3 QML UI kit for central_logger + data-logger.
#
# Added to each host app as a git submodule and pulled in via add_subdirectory().
# The host sets LOGGERKIT_QML_MODULE_VERSION (defaults to 1.0) and calls
# find_package(Qt6 ...) beforehand. Builds as STATIC QML modules:
#   LoggerKit.Theme       (AppColors / AppTheme / AppTypography / ThemeMode + ThemeSetup)
#   LoggerKit.Components   (AppButton, AppNotifier, tables, charts, StatusChip, …)
#
# Standalone build (for qmllint / iteration) is supported via the guard below.

cmake_minimum_required(VERSION 3.16)

if(NOT DEFINED PROJECT_NAME)
    project(logger_ui_kit VERSION 1.0.0 LANGUAGES CXX)
    set(LOGGERKIT_STANDALONE TRUE)
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

# QML module URI version — host may override before add_subdirectory().
if(NOT DEFINED LOGGERKIT_QML_MODULE_VERSION)
    set(LOGGERKIT_QML_MODULE_VERSION 1.0)
endif()

if(LOGGERKIT_STANDALONE)
    find_package(Qt6 6.11 REQUIRED COMPONENTS
        Quick
        QuickControls2
        Qml
        Gui
        Graphs
    )
    qt_standard_project_setup(REQUIRES 6.11)
    qt_policy(SET QTP0004 NEW)

    set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}" CACHE PATH
        "QML build-tree root; qt_add_qml_module appends URI path segments")
endif()

add_subdirectory(src/theme)
add_subdirectory(src/components)

if(LOGGERKIT_STANDALONE)
    # Aggregate qmllint across every module in the kit.
    add_custom_target(qmllint)
    foreach(_module IN ITEMS logger_ui_kit_theme logger_ui_kit_components)
        if(TARGET "${_module}_qmllint")
            add_dependencies(qmllint "${_module}_qmllint")
        endif()
    endforeach()
endif()
