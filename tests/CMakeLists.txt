# QML smoke tests (Qt Quick Test) — only when the kit is built standalone.
if(NOT LOGGERKIT_STANDALONE)
    return()
endif()

find_package(Qt6 6.11 REQUIRED COMPONENTS QuickTest)

qt_add_executable(kit_qml_tests main.cpp)
target_link_libraries(kit_qml_tests PRIVATE
    Qt6::QuickTest
    logger_ui_kit_themeplugin
    logger_ui_kit_componentsplugin
)
# Bake the STATIC QML module plugins into the test binary so imports resolve.
qt_import_qml_plugins(kit_qml_tests)

add_test(NAME kit_qml_tests
    COMMAND kit_qml_tests
        -input ${CMAKE_CURRENT_SOURCE_DIR}/qml
        -platform offscreen
)
