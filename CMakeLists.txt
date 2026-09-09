cmake_minimum_required(VERSION 3.20)
project(NexvaryAvionicsLab VERSION 0.11.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(cmake/Dependencies.cmake)
option(NEXVARY_BUILD_QT_HMI "Build the Qt/QML cockpit training interface" OFF)

add_library(avionics_core
    src/core/EventLog.cpp
    src/core/SensorBus.cpp
    src/core/SystemHealth.cpp
    src/core/Watchdog.cpp
    src/core/AlertManager.cpp
    src/core/TelemetryRecorder.cpp
    src/core/TelemetryArchive.cpp
    src/sim/SimulationClock.cpp
    src/sim/FaultInjector.cpp
    src/sim/ScenarioEngine.cpp
    src/app/AvionicsLab.cpp
    src/app/ConsoleCockpit.cpp
    src/hmi/CockpitViewModel.cpp
    src/hmi/UiLocale.cpp
    src/io/SessionArchive.cpp
    src/report/LabReport.cpp
    src/config/RunProfile.cpp
)

target_include_directories(avionics_core PUBLIC src)
target_link_libraries(avionics_core PUBLIC nlohmann_json::nlohmann_json)

if(MSVC)
    target_compile_options(avionics_core PRIVATE /W4 /permissive-)
else()
    target_compile_options(avionics_core PRIVATE -Wall -Wextra -Wpedantic)
endif()

add_executable(nexvary_avionics_lab src/main.cpp)
target_link_libraries(nexvary_avionics_lab PRIVATE avionics_core CLI11::CLI11)

enable_testing()
foreach(test_name IN ITEMS core simulation alerts hmi locale archive session report profile)
    add_executable(${test_name}_tests tests/test_${test_name}.cpp)
    target_link_libraries(${test_name}_tests PRIVATE avionics_core)
    add_test(NAME ${test_name}_tests COMMAND ${test_name}_tests)
endforeach()

if(NEXVARY_BUILD_QT_HMI)
    find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)
    set(CMAKE_AUTOMOC ON)
    qt_add_executable(nexvary_avionics_hmi
        src/qt/main_qt.cpp
        src/qt/CockpitBridge.cpp
        src/qt/CockpitBridge.hpp
    )
    qt_add_resources(nexvary_avionics_hmi "qml_resources"
        PREFIX "/"
        FILES
            qml/Main.qml
            qml/InstrumentTile.qml
    )
    target_link_libraries(nexvary_avionics_hmi PRIVATE avionics_core Qt6::Quick Qt6::QuickControls2)
endif()
