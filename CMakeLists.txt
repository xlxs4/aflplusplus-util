# Change accordingly.
cmake_minimum_required(VERSION 3.13)
project(aflplusplus)

set(CMAKE_CXX_STANDARD 17)

if(${INSTRUMENT})
  # To not mess with other CMake evokations, e.g. for building the codebase with coverage support.
  set(INSTRUMENT OFF CACHE BOOL "Use AFL compiler?")
  # Check for unsupported combinations
  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    # Are we using the special AFL instrumented compiler?
    string(REGEX MATCH "afl-clang-lto\\+\\+$" AFL ${CMAKE_CXX_COMPILER})
  else()
    message(FATAL_ERROR "You should use the AFL-instrumented compiler (with LTO)")
  endif()
endif()

include_directories(../inc
        ../lib/example-lib/include
        ../lib/example-lib2)

add_library(afl OBJECT STATIC
        ../src/example-src.cpp
        ../lib/example-lib3/example-src2.cpp)

add_executable(aflplusplus tests/ToTest.cpp
        $<TARGET_OBJECTS:afl>)