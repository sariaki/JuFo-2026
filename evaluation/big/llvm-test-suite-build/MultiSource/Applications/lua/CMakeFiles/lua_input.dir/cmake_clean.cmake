file(REMOVE_RECURSE
  "generate_inputs.sh"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/lua_input.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
