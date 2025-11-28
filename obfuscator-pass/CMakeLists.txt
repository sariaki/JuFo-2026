cmake_minimum_required(VERSION 3.14)
project(Obfuscator)

# TODO: Linux support

set(CMAKE_CXX_STANDARD 20)

# TODO: Download this for Windows (https://github.com/llvm/llvm-project/releases)

# Load LLVMConfig.cmake. If this fails, consider setting `LLVM_DIR` to point
# to your LLVM installation's `lib/cmake/llvm` directory
find_package(LLVM REQUIRED CONFIG)

# TODO: Maybe use precompiled header for LLVM?

# Include the part of LLVM's CMake libraries that defines `add_llvm_pass_plugin`
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

# Our pass lives in this subdirectory.
add_subdirectory(src)