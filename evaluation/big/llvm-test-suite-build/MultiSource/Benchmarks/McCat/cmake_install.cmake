# Install script for directory: /home/paul/Documents/JuFo-2026/evaluation/big/llvm-test-suite/MultiSource/Benchmarks/McCat

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
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/01-qbsort/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/03-testtrie/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/04-bisect/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/05-eks/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/08-main/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/09-vor/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/12-IOtest/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/17-bintr/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/18-imp/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/MultiSource/Benchmarks/McCat/15-trie/cmake_install.cmake")

endif()

