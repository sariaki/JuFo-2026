# Install script for directory: /home/paul/Documents/JuFo-2026/evaluation/big/llvm-test-suite/External

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
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/CUDA/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/HIP/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/HMMER/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/HeCBench/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/Nurbs/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/Povray/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/SPEC/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/dav1d/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/ffmpeg/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/skidmarks10/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/sollve_vv/cmake_install.cmake")
  include("/home/paul/Documents/JuFo-2026/evaluation/big/build/External/smoke/cmake_install.cmake")

endif()

