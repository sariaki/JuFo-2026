cmake_minimum_required(VERSION 3.12)
project(SkeletonPassPlugin)

# Gather sources
file(GLOB_RECURSE
  SOURCES_REL
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
  *.cpp *.h
)

# Build absolute paths for the build
list(TRANSFORM
  SOURCES_REL
  PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
  OUTPUT_VARIABLE SKELETON_SOURCES
)

# Let VS group files
set(SRC_FILES)
set(HDR_FILES)
foreach(f IN LISTS SOURCES_REL)
  if(f MATCHES "\\.cpp$")
    list(APPEND SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/${f}")
  elseif(f MATCHES "\\.h$")
    list(APPEND HDR_FILES "${CMAKE_CURRENT_SOURCE_DIR}/${f}")
  endif()
endforeach()

source_group("Source Files" FILES ${SRC_FILES})
source_group("Header Files" FILES ${HDR_FILES})

# Declare plugin as a dynamic library
add_library(SkeletonPass MODULE
  ${SRC_FILES}
  ${HDR_FILES}
)

if(MSVC)
  target_compile_options(SkeletonPass PRIVATE
    $<$<CONFIG:Release>:/MT>
    $<$<CONFIG:Debug>:/MTd>
  )
endif()

# Make DLL/so have no "lib" prefix
set_target_properties(SkeletonPass PROPERTIES
  PREFIX ""
  OUTPUT_NAME "SkeletonPass"
  WINDOWS_EXPORT_ALL_SYMBOLS ON
)

# Hook up to LLVM
find_package(LLVM REQUIRED CONFIG)
target_include_directories(SkeletonPass PRIVATE ${LLVM_INCLUDE_DIRS})
target_link_libraries(SkeletonPass PRIVATE LLVMCore LLVMSupport)
llvm_update_compile_flags(SkeletonPass)