cmake_minimum_required(VERSION 3.12)

# Gather sources
file(GLOB_RECURSE
  SOURCES_REL
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
  *.cpp *.hpp
)

# Build absolute paths for the build
list(TRANSFORM
  SOURCES_REL
  PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
  OUTPUT_VARIABLE OBFUSCATOR_SOURCES
)

# Make VS mirror folder structure
source_group(
    TREE ${CMAKE_CURRENT_SOURCE_DIR}
    FILES ${OBFUSCATOR_SOURCES}
  )

# Declare plugin as a dynamic library
add_library(Obfuscator MODULE
  ${OBFUSCATOR_SOURCES}
)

if(MSVC)
  target_compile_options(Obfuscator PRIVATE
    $<$<CONFIG:Release>:/MT>
    $<$<CONFIG:Debug>:/MT> # NOTE: LLVM is compiled as Release on my machine
  )
endif()

# Make DLL/so have no "lib" prefix
set_target_properties(Obfuscator PROPERTIES
  PREFIX ""
  OUTPUT_NAME "Obfuscator"
  WINDOWS_EXPORT_ALL_SYMBOLS ON
)

# Hook up to LLVM
find_package(LLVM REQUIRED CONFIG)
target_include_directories(Obfuscator PRIVATE ${LLVM_INCLUDE_DIRS})
target_link_libraries(Obfuscator PRIVATE LLVMCore LLVMSupport)
llvm_update_compile_flags(Obfuscator)