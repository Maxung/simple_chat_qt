cmake_minimum_required(VERSION 3.16)

project(simple_chat_qt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Svg QuickControls2)


qt_add_executable(appsimple_chat_qt
    main.cpp
)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

set_source_files_properties(ui/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appsimple_chat_qt
    URI simple_chat_qt
    VERSION 1.0
    QML_FILES
        ui/Theme.qml
        ui/Main.qml
        ui/Prompt.qml
        ui/chat/ChatView.qml
    RESOURCES
        icons/arrow-up.svg
        QML_FILES ui/chat/ChatMessage.qml
    SOURCES
        openaiclient.h
        openaiclient.cpp
        chatmodel.h
        chatmodel.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appsimple_chat_qt PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appsimple_chat_qt
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appsimple_chat_qt
    PRIVATE Qt6::Quick Qt6::Svg Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appsimple_chat_qt
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
