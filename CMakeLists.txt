project(Endorphin)
cmake_minimum_required(VERSION 3.12)

if(DEFINED QT_MOC_EXECUTABLE)
	add_executable(Qt5::moc IMPORTED)
	set_target_properties(Qt5::moc PROPERTIES IMPORTED_LOCATION ${QT_MOC_EXECUTABLE})
endif()
set(CMAKE_AUTOMOC ON)

if(DEFINED QT_RCC_EXECUTABLE)
	add_executable(Qt5::rcc IMPORTED)
	set_target_properties(Qt5::rcc PROPERTIES IMPORTED_LOCATION ${QT_RCC_EXECUTABLE})
endif()
set(CMAKE_AUTORCC ON)

if(DEFINED QT_UIC_EXECUTABLE)
	add_executable(Qt5::uic IMPORTED)
	set_target_properties(Qt5::uic PROPERTIES IMPORTED_LOCATION ${QT_UIC_EXECUTABLE})
endif()
set(CMAKE_AUTOUIC ON)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
add_definitions(-W3)

add_subdirectory(src)
# add_subdirectory(tools)
