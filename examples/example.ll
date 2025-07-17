; ModuleID = './example.cpp'
source_filename = "./example.cpp"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.36.32535"

$printf = comdat any

$_vfprintf_l = comdat any

$__local_stdio_printf_options = comdat any

$"??_C@_04PFIOAJMN@foo?6?$AA@" = comdat any

$"?_OptionsStorage@?1??__local_stdio_printf_options@@9@4_KA" = comdat any

@"??_C@_04PFIOAJMN@foo?6?$AA@" = linkonce_odr dso_local unnamed_addr constant [5 x i8] c"foo\0A\00", comdat, align 1, !dbg !0
@"?_OptionsStorage@?1??__local_stdio_printf_options@@9@4_KA" = linkonce_odr dso_local global i64 0, comdat, align 8, !dbg !8

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @"?foo@@YAXXZ"() #0 !dbg !27 {
  %1 = call i32 (ptr, ...) @printf(ptr noundef @"??_C@_04PFIOAJMN@foo?6?$AA@"), !dbg !30
  ret void, !dbg !31
}

; Function Attrs: mustprogress noinline optnone uwtable
define linkonce_odr dso_local i32 @printf(ptr noundef %0, ...) #0 comdat !dbg !32 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !40, !DIExpression(), !41)
    #dbg_declare(ptr %3, !42, !DIExpression(), !43)
    #dbg_declare(ptr %4, !44, !DIExpression(), !48)
  call void @llvm.va_start.p0(ptr %4), !dbg !49
  %5 = load ptr, ptr %4, align 8, !dbg !50
  %6 = load ptr, ptr %2, align 8, !dbg !50
  %7 = call ptr @__acrt_iob_func(i32 noundef 1), !dbg !50
  %8 = call i32 @_vfprintf_l(ptr noundef %7, ptr noundef %6, ptr noundef null, ptr noundef %5), !dbg !50
  store i32 %8, ptr %3, align 4, !dbg !50
  call void @llvm.va_end.p0(ptr %4), !dbg !51
  %9 = load i32, ptr %3, align 4, !dbg !52
  ret i32 %9, !dbg !52
}

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #1 !dbg !53 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @"?foo@@YAXXZ"(), !dbg !56
  ret i32 0, !dbg !57
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #2

; Function Attrs: mustprogress noinline optnone uwtable
define linkonce_odr dso_local i32 @_vfprintf_l(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat !dbg !58 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store ptr %3, ptr %5, align 8
    #dbg_declare(ptr %5, !72, !DIExpression(), !73)
  store ptr %2, ptr %6, align 8
    #dbg_declare(ptr %6, !74, !DIExpression(), !75)
  store ptr %1, ptr %7, align 8
    #dbg_declare(ptr %7, !76, !DIExpression(), !77)
  store ptr %0, ptr %8, align 8
    #dbg_declare(ptr %8, !78, !DIExpression(), !79)
  %9 = load ptr, ptr %5, align 8, !dbg !80
  %10 = load ptr, ptr %6, align 8, !dbg !80
  %11 = load ptr, ptr %7, align 8, !dbg !80
  %12 = load ptr, ptr %8, align 8, !dbg !80
  %13 = call ptr @__local_stdio_printf_options(), !dbg !80
  %14 = load i64, ptr %13, align 8, !dbg !80
  %15 = call i32 @__stdio_common_vfprintf(i64 noundef %14, ptr noundef %12, ptr noundef %11, ptr noundef %10, ptr noundef %9), !dbg !80
  ret i32 %15, !dbg !80
}

declare dso_local ptr @__acrt_iob_func(i32 noundef) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end.p0(ptr) #2

declare dso_local i32 @__stdio_common_vfprintf(i64 noundef, ptr noundef, ptr noundef, ptr noundef, ptr noundef) #3

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local ptr @__local_stdio_printf_options() #4 comdat !dbg !10 {
  ret ptr @"?_OptionsStorage@?1??__local_stdio_printf_options@@9@4_KA", !dbg !81
}

attributes #0 = { mustprogress noinline optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind willreturn }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!16}
!llvm.linker.options = !{!19}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 5, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "./example.cpp", directory: "C:\\Users\\sariaki\\Documents\\code\\py\\JuFo-2026\\examples", checksumkind: CSK_MD5, checksum: "e314b59772d4c0503deb0b1963d519f2")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 40, elements: !6)
!4 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !5)
!5 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!6 = !{!7}
!7 = !DISubrange(count: 5)
!8 = !DIGlobalVariableExpression(var: !9, expr: !DIExpression())
!9 = distinct !DIGlobalVariable(name: "_OptionsStorage", scope: !10, file: !11, line: 91, type: !15, isLocal: false, isDefinition: true)
!10 = distinct !DISubprogram(name: "__local_stdio_printf_options", scope: !11, file: !11, line: 89, type: !12, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16)
!11 = !DIFile(filename: "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.22621.0\\ucrt\\corecrt_stdio_config.h", directory: "", checksumkind: CSK_MD5, checksum: "dacf907bda504afb0b64f53a242bdae6")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!16 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !17, producer: "clang version 20.1.4", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !18, splitDebugInlining: false, nameTableKind: None)
!17 = !DIFile(filename: "example.cpp", directory: "C:\\Users\\sariaki\\Documents\\code\\py\\JuFo-2026\\examples", checksumkind: CSK_MD5, checksum: "e314b59772d4c0503deb0b1963d519f2")
!18 = !{!0, !8}
!19 = !{!"/FAILIFMISMATCH:\22_CRT_STDIO_ISO_WIDE_SPECIFIERS=0\22"}
!20 = !{i32 2, !"CodeView", i32 1}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 2}
!23 = !{i32 8, !"PIC Level", i32 2}
!24 = !{i32 7, !"uwtable", i32 2}
!25 = !{i32 1, !"MaxTLSAlign", i32 65536}
!26 = !{!"clang version 20.1.4"}
!27 = distinct !DISubprogram(name: "foo", linkageName: "?foo@@YAXXZ", scope: !2, file: !2, line: 3, type: !28, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16)
!28 = !DISubroutineType(types: !29)
!29 = !{null}
!30 = !DILocation(line: 5, scope: !27)
!31 = !DILocation(line: 6, scope: !27)
!32 = distinct !DISubprogram(name: "printf", scope: !33, file: !33, line: 950, type: !34, scopeLine: 956, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !39)
!33 = !DIFile(filename: "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.22621.0\\ucrt\\stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "c1a1fbc43e7d45f0ea4ae539ddcffb19")
!34 = !DISubroutineType(types: !35)
!35 = !{!36, !37, null}
!36 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!37 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!39 = !{}
!40 = !DILocalVariable(name: "_Format", arg: 1, scope: !32, file: !33, line: 951, type: !37)
!41 = !DILocation(line: 951, scope: !32)
!42 = !DILocalVariable(name: "_Result", scope: !32, file: !33, line: 957, type: !36)
!43 = !DILocation(line: 957, scope: !32)
!44 = !DILocalVariable(name: "_ArgList", scope: !32, file: !33, line: 958, type: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "va_list", file: !46, line: 72, baseType: !47)
!46 = !DIFile(filename: "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.36.32532\\include\\vadefs.h", directory: "", checksumkind: CSK_MD5, checksum: "a4b8f96637d0704c82f39ecb6bde2ab4")
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!48 = !DILocation(line: 958, scope: !32)
!49 = !DILocation(line: 959, scope: !32)
!50 = !DILocation(line: 960, scope: !32)
!51 = !DILocation(line: 961, scope: !32)
!52 = !DILocation(line: 962, scope: !32)
!53 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 8, type: !54, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16)
!54 = !DISubroutineType(types: !55)
!55 = !{!36}
!56 = !DILocation(line: 10, scope: !53)
!57 = !DILocation(line: 11, scope: !53)
!58 = distinct !DISubprogram(name: "_vfprintf_l", scope: !33, file: !33, line: 635, type: !59, scopeLine: 644, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !16, retainedNodes: !39)
!59 = !DISubroutineType(types: !60)
!60 = !{!36, !61, !37, !66, !45}
!61 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !62)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !64, line: 31, baseType: !65)
!64 = !DIFile(filename: "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.22621.0\\ucrt\\corecrt_wstdio.h", directory: "", checksumkind: CSK_MD5, checksum: "bf50373b435d0afd0235dd3e05c4a277")
!65 = !DICompositeType(tag: DW_TAG_structure_type, name: "_iobuf", file: !64, line: 28, size: 64, flags: DIFlagFwdDecl, identifier: ".?AU_iobuf@@")
!66 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !67)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "_locale_t", file: !68, line: 623, baseType: !69)
!68 = !DIFile(filename: "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.22621.0\\ucrt\\corecrt.h", directory: "", checksumkind: CSK_MD5, checksum: "4ce81db8e96f94c79f8dce86dd46b97f")
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "__crt_locale_pointers", file: !68, line: 621, baseType: !71)
!71 = !DICompositeType(tag: DW_TAG_structure_type, name: "__crt_locale_pointers", file: !68, line: 617, size: 128, flags: DIFlagFwdDecl, identifier: ".?AU__crt_locale_pointers@@")
!72 = !DILocalVariable(name: "_ArgList", arg: 4, scope: !58, file: !33, line: 639, type: !45)
!73 = !DILocation(line: 639, scope: !58)
!74 = !DILocalVariable(name: "_Locale", arg: 3, scope: !58, file: !33, line: 638, type: !66)
!75 = !DILocation(line: 638, scope: !58)
!76 = !DILocalVariable(name: "_Format", arg: 2, scope: !58, file: !33, line: 637, type: !37)
!77 = !DILocation(line: 637, scope: !58)
!78 = !DILocalVariable(name: "_Stream", arg: 1, scope: !58, file: !33, line: 636, type: !61)
!79 = !DILocation(line: 636, scope: !58)
!80 = !DILocation(line: 645, scope: !58)
!81 = !DILocation(line: 92, scope: !10)
