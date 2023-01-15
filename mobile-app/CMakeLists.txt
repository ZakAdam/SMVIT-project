cmake_minimum_required(VERSION 3.16)

project(SMVIT-project VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (ANDROID)
    include(D:\\projects\\android_openssl-master\\CMakeLists.txt)
endif()

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appSMVIT-project
    main.cpp
    fileupload.h fileupload.cpp
)

qt_add_qml_module(appSMVIT-project
    URI SMVIT-project
    VERSION 1.0
    QML_FILES main.qml
    RESOURCES
        "colors.svg"
        "color-icons.png"
)

set_target_properties(appSMVIT-project PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSMVIT-project
    PRIVATE Qt6::Quick)
    #OpenSSL::SSL
    #OpenSSL::Crypto)

install(TARGETS appSMVIT-project
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

set_property(TARGET appSMVIT-project PROPERTY QT_ANDROID_EXTRA_LIBS
    D:\\projects\\android_openssl-master\\latest\\arm\\libcrypto_1_1.so
    D:\\projects\\android_openssl-master\\latest\\arm\\libssl_1_1.so)
