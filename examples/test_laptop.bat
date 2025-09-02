:: Compile to IR & bitcode
"C:\LLVM\bin\clang.exe" -O0 -S -emit-llvm ./example.c -o example.ll
"C:\LLVM\bin\clang.exe" -emit-llvm -c example.c -o example.bc

:: Run pass
"C:\LLVM\bin\opt.exe" ^
  -load-pass-plugin="C:\Users\paulr\Desktop\JuFo-2026\build\src\Release\Obfuscator.dll" ^
  -passes=obfuscator ^
  example.bc -o example_obf.bc

:: Dump the obfuscated IR
"C:\LLVM\bin\llvm-dis.exe" example_obf.bc -o example_obf.ll

:: Compile IR to Executable
"C:\LLVM\bin\clang.exe" example_obf.bc -o example.exe