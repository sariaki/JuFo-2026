cmake_minimum_required(VERSION 3.20)
project(Obfuscator)

# Load LLVM Config
find_package(LLVM REQUIRED CONFIG)
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

# Set strict compiler flags matching LLVM
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# Gather sources
# GLOB_RECURSE returns absolute paths
file(GLOB_RECURSE OBFUSCATOR_SOURCES 
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp" 
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp"
)

# Make IDEs (VS) mirror folder structure
# Base the tree starting from the 'src' directory
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/src" FILES ${OBFUSCATOR_SOURCES})

# Create the Plugin
# add_llvm_pass_plugin automatically creates a MODULE library and prevents static linking issues
add_llvm_pass_plugin(Obfuscator ${OBFUSCATOR_SOURCES})
