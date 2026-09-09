cmake_minimum_required(VERSION 3.20)
project(NexvaryAvionicsLab VERSION 0.6.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(avionics_core
    src/core/EventLog.cpp
    src/core/SensorBus.cpp
    src/core/SystemHealth.cpp
    src/core/Watchdog.cpp
    src/core/AlertManager.cpp
    src/core/TelemetryRecorder.cpp
    src/sim/SimulationClock.cpp
    src/sim/FaultInjector.cpp
    src/sim/ScenarioEngine.cpp
    src/app/AvionicsLab.cpp
    src/app/ConsoleCockpit.cpp
    src/hmi/CockpitViewModel.cpp
)

target_include_directories(avionics_core PUBLIC src)

if(MSVC)
    target_compile_options(avionics_core PRIVATE /W4 /permissive-)
else()
    target_compile_options(avionics_core PRIVATE -Wall -Wextra -Wpedantic)
endif()

add_executable(nexvary_avionics_lab src/main.cpp)
target_link_libraries(nexvary_avionics_lab PRIVATE avionics_core)

enable_testing()
foreach(test_name IN ITEMS core simulation alerts hmi)
    add_executable(${test_name}_tests tests/test_${test_name}.cpp)
    target_link_libraries(${test_name}_tests PRIVATE avionics_core)
    add_test(NAME ${test_name}_tests COMMAND ${test_name}_tests)
endforeach()
