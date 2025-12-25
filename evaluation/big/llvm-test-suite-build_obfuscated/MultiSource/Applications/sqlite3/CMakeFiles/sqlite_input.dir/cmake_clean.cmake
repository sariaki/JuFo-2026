file(REMOVE_RECURSE
  "test15.sql"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/sqlite_input.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
