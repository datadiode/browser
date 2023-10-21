project(Endorphin)
cmake_minimum_required(VERSION 3.12)

set(QT_MOC_EXECUTABLE "C:/Qt/Qt5.5.1/msvc2013_32/bin/moc.exe")
add_executable(Qt5::moc IMPORTED)
set_target_properties(Qt5::moc PROPERTIES IMPORTED_LOCATION ${QT_MOC_EXECUTABLE})
set(CMAKE_AUTOMOC ON)

set(QT_RCC_EXECUTABLE "C:/Qt/Qt5.5.1/msvc2013_32/bin/rcc.exe")
add_executable(Qt5::rcc IMPORTED)
set_target_properties(Qt5::rcc PROPERTIES IMPORTED_LOCATION ${QT_RCC_EXECUTABLE})
set(CMAKE_AUTORCC ON)

set(QT_UIC_EXECUTABLE "C:/Qt/Qt5.5.1/msvc2013_32/bin/uic.exe")
add_executable(Qt5::uic IMPORTED)
set_target_properties(Qt5::uic PROPERTIES IMPORTED_LOCATION ${QT_UIC_EXECUTABLE})
set(CMAKE_AUTOUIC ON)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
add_definitions(-W3)

add_subdirectory(src)
# add_subdirectory(tools)
