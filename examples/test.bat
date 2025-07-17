:: Compile to IR
clang -O0 -g -S -emit-llvm ./example.cpp

:: Run pass
:: "C:\LLVM\bin\opt.exe" -load-pass-plugin "C:\Users\sariaki\Documents\code\py\JuFo-2026\obfuscator-pass\build\skeleton\Release\SkeletonPass.dll" -passes="Skeleton pass" ./example.ll
clang -fpass-plugin="C:\Users\sariaki\Documents\code\py\JuFo-2026\obfuscator-pass\build\skeleton\Release\SkeletonPass.dll" example.cpp