cmake_minimum_required(VERSION 3.12)
project(Obfuscator)

# TODO: Linux support

set(CMAKE_CXX_STANDARD 20)
# TODO: Download this for Windows (https://github.com/llvm/llvm-project/releases)
set(LLVM_DIR "C:/LLVM/lib/cmake/llvm"
    CACHE PATH "Path to LLVM’s CMake configuration (LLVMConfig.cmake)" FORCE)

# Load LLVMConfig.cmake. If this fails, consider setting `LLVM_DIR` to point
# to your LLVM installation's `lib/cmake/llvm` directory
find_package(LLVM REQUIRED CONFIG)

# Include the part of LLVM's CMake libraries that defines `add_llvm_pass_plugin`
include(AddLLVM)

# Use LLVM's preprocessor definitions, include directories, and library search paths
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

# Our pass lives in this subdirectory.
add_subdirectory(src)