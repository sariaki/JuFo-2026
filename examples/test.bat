:: Compile to IR
clang -O0 -S -emit-llvm -c ./example.c -o example.ll

:: Run pass
:: "C:\LLVM\bin\opt.exe" -load-pass-plugin "C:\Users\sariaki\Documents\code\py\JuFo-2026\obfuscator-pass\build\skeleton\Release\SkeletonPass.dll" -passes="Skeleton pass" ./example.ll
:: clang -fpass-plugin="C:\Users\sariaki\Documents\code\py\JuFo-2026\obfuscator-pass\build\skeleton\Release\SkeletonPass.dll" example.cpp
"C:\LLVM\bin\opt.exe" -load-pass-plugin="C:\Users\sariaki\Documents\code\py\JuFo-2026\obfuscator-pass\build\skeleton\Release\SkeletonPass.dll" -passes=stoch-opaque -S example.ll -o example_obf.ll