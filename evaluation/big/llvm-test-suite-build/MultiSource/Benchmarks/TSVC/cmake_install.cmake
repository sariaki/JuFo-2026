# Install script for directory: /home/paul/Documents/JuFo-2026/evaluation/big/llvm-test-suite/MultiSource/Benchmarks/TSVC

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/llvm-objdump-18")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/ControlFlow-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/ControlFlow-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/ControlLoops-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/ControlLoops-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/CrossingThresholds-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/CrossingThresholds-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Equivalencing-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Equivalencing-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Expansion-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Expansion-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/GlobalDataFlow-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/GlobalDataFlow-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/IndirectAddressing-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/IndirectAddressing-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/InductionVariable-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/InductionVariable-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/LinearDependence-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/LinearDependence-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/LoopRerolling-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/LoopRerolling-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/LoopRestructuring-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/LoopRestructuring-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/NodeSplitting-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/NodeSplitting-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Packing-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Packing-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Recurrences-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Recurrences-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Reductions-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Reductions-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Searching-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Searching-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/StatementReordering-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/StatementReordering-flt/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Symbolics-dbl/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/TSVC/Symbolics-flt/cmake_install.cmake")

endif()

