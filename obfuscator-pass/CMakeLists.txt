cmake_minimum_required(VERSION 3.14)
project(Obfuscator)

# TODO: Linux support

set(CMAKE_CXX_STANDARD 20)

# Force static CRT /MT
if(MSVC)
  # Use the CMake-controlled symbolic name for /MT
  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded" CACHE STRING "MSVC runtime library" FORCE)
endif()

# TODO: Download this for Windows (https://github.com/llvm/llvm-project/releases)
set(LLVM_DIR "C:/LLVM/lib/cmake/llvm"
    CACHE PATH "Path to LLVM’s CMake configuration (LLVMConfig.cmake)" FORCE)

# Load LLVMConfig.cmake. If this fails, consider setting `LLVM_DIR` to point
# to your LLVM installation's `lib/cmake/llvm` directory
find_package(LLVM REQUIRED CONFIG)

# TODO: Maybe use precompiled header for LLVM?

# Include the part of LLVM's CMake libraries that defines `add_llvm_pass_plugin`
include(AddLLVM)

include(FetchContent)
#FetchContent_Declare(
#  eigen
#  GIT_REPOSITORY https://gitlab.com/libeigen/eigen.git
#  GIT_TAG 3.4.0
#)
#FetchContent_MakeAvailable(eigen)

#FetchContent_Declare(
#  nlopt
#  GIT_REPOSITORY https://github.com/stevengj/nlopt.git
#  GIT_TAG v2.10.0
#)
#
#set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build NLopt static" FORCE)
#set(NLOPT_BUILD_PYTHON OFF CACHE BOOL "Disable python build" FORCE)
#set(NLOPT_BUILD_OCTAVE OFF CACHE BOOL "Disable octave build" FORCE)
#set(NLOPT_BUILD_MATLAB OFF CACHE BOOL "Disable matlab build" FORCE)
#set(NLOPT_BUILD_EXAMPLES OFF CACHE BOOL "Disable examples" FORCE)
#set(NLOPT_LUKSAN OFF CACHE BOOL "Do not build Luksan LGPL parts" FORCE)
#
#FetchContent_MakeAvailable(nlopt)
#
## Extra safety: if a target named 'nlopt' exists, ensure it compiles with /MT (applies to the target created by NLopt)
#if(MSVC AND TARGET nlopt)
#  target_compile_options(nlopt PRIVATE $<$<CONFIG:Debug>:/MTd> $<$<NOT:$<CONFIG:Debug>>:/MT>)
#endif()

# Our pass lives in this subdirectory.
add_subdirectory(src)