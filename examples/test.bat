:: Compile to IR
clang -O0 -S -emit-llvm -c ./example.c -o example.ll

:: Run pass
"C:\LLVM\bin\opt.exe" -load-pass-plugin="C:\Users\sariaki\Documents\code\py\JuFo-2026\obfuscator-pass\build\src\Release\Obfuscator.dll" -passes=obfuscator -S example.ll -o example_obf.ll

:: Compile IR to Executable
clang ./example_obf.ll