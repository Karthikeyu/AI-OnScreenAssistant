cmake_minimum_required(VERSION 3.16)

project(AIOnScreenAssistant VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Widgets)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appAIOnScreenAssistant
    main.cpp
  #  Resources.qrc        # ✅ add here directly
)

qt_add_qml_module(appAIOnScreenAssistant
    URI AIOnScreenAssistant
    VERSION 1.0
    QML_FILES
        Main.qml
        OverlayWindow.qml
        ControlPanel.qml
        ResultSection.qml
    SOURCES
        GroqAPI.h
        GroqAPI.cpp
    RESOURCES
        Resources.qrc
)

if(WIN32)
    set(APP_ICON_RESOURCE_WINDOWS "${CMAKE_CURRENT_SOURCE_DIR}/app_icon.rc")
    target_sources(appAIOnScreenAssistant PRIVATE ${APP_ICON_RESOURCE_WINDOWS})
endif()

set_target_properties(appAIOnScreenAssistant PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appAIOnScreenAssistant
    PRIVATE Qt6::Quick Qt6::Widgets
)
