cmake_minimum_required(VERSION 3.20)
project(NexvaryAvionicsLab VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(avionics_core
    src/core/EventLog.cpp
    src/core/SensorBus.cpp
    src/core/SystemHealth.cpp
    src/core/Watchdog.cpp
)

target_include_directories(avionics_core PUBLIC src)

add_executable(nexvary_avionics_lab src/main.cpp)
target_link_libraries(nexvary_avionics_lab PRIVATE avionics_core)

enable_testing()
add_executable(core_tests tests/test_core.cpp)
target_link_libraries(core_tests PRIVATE avionics_core)
add_test(NAME core_tests COMMAND core_tests)
