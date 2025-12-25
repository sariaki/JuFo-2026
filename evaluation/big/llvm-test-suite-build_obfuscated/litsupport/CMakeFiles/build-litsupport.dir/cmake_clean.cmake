file(REMOVE_RECURSE
  "../lit.cfg"
  "CMakeFiles/build-litsupport"
  "__init__.py"
  "modules/__init__.py"
  "modules/codesize.py"
  "modules/compiletime.py"
  "modules/hash.py"
  "modules/hpmcount.py"
  "modules/microbenchmark.py"
  "modules/perf.py"
  "modules/profilegen.py"
  "modules/remote.py"
  "modules/run.py"
  "modules/run_under.py"
  "modules/stats.py"
  "modules/timeit.py"
  "shellcommand.py"
  "test.py"
  "testfile.py"
  "testplan.py"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/build-litsupport.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
