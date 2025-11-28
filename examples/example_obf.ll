; ModuleID = 'example_obf.bc'
source_filename = "example.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.44.35221"

$sprintf = comdat any

$vsprintf = comdat any

$_snprintf = comdat any

$_vsnprintf = comdat any

$printf = comdat any

$_vsprintf_l = comdat any

$_vsnprintf_l = comdat any

$__local_stdio_printf_options = comdat any

$_vfprintf_l = comdat any

$"??_C@_07ODMBGAAE@foo?5?$CFi?6?$AA@" = comdat any

@"??_C@_07ODMBGAAE@foo?5?$CFi?6?$AA@" = linkonce_odr dso_local unnamed_addr constant [8 x i8] c"foo %i\0A\00", comdat, align 1, !dbg !0
@__local_stdio_printf_options._OptionsStorage = internal global i64 0, align 8, !dbg !7
@.str = private unnamed_addr constant [28 x i8] c"insert_stochastic_predicate\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [10 x i8] c"example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [1 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str, ptr @.str.1, i32 6, ptr null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @sprintf(ptr noundef %0, ptr noundef %1, ...) #0 comdat !dbg !27 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  store ptr %1, ptr %3, align 8
    #dbg_declare(ptr %3, !38, !DIExpression(), !39)
  store ptr %0, ptr %4, align 8
    #dbg_declare(ptr %4, !40, !DIExpression(), !41)
    #dbg_declare(ptr %5, !42, !DIExpression(), !43)
    #dbg_declare(ptr %6, !44, !DIExpression(), !47)
  call void @llvm.va_start.p0(ptr %6), !dbg !48
  %7 = load ptr, ptr %6, align 8, !dbg !49
  %8 = load ptr, ptr %3, align 8, !dbg !49
  %9 = load ptr, ptr %4, align 8, !dbg !49
  %10 = call i32 @_vsprintf_l(ptr noundef %9, ptr noundef %8, ptr noundef null, ptr noundef %7), !dbg !49
  store i32 %10, ptr %5, align 4, !dbg !49
  call void @llvm.va_end.p0(ptr %6), !dbg !50
  %11 = load i32, ptr %5, align 4, !dbg !51
  ret i32 %11, !dbg !51
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @vsprintf(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 comdat !dbg !52 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  store ptr %2, ptr %4, align 8
    #dbg_declare(ptr %4, !55, !DIExpression(), !56)
  store ptr %1, ptr %5, align 8
    #dbg_declare(ptr %5, !57, !DIExpression(), !58)
  store ptr %0, ptr %6, align 8
    #dbg_declare(ptr %6, !59, !DIExpression(), !60)
  %7 = load ptr, ptr %4, align 8, !dbg !61
  %8 = load ptr, ptr %5, align 8, !dbg !61
  %9 = load ptr, ptr %6, align 8, !dbg !61
  %10 = call i32 @_vsnprintf_l(ptr noundef %9, i64 noundef -1, ptr noundef %8, ptr noundef null, ptr noundef %7), !dbg !61
  ret i32 %10, !dbg !61
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_snprintf(ptr noundef %0, i64 noundef %1, ptr noundef %2, ...) #0 comdat !dbg !62 {
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  store ptr %2, ptr %4, align 8
    #dbg_declare(ptr %4, !66, !DIExpression(), !67)
  store i64 %1, ptr %5, align 8
    #dbg_declare(ptr %5, !68, !DIExpression(), !69)
  store ptr %0, ptr %6, align 8
    #dbg_declare(ptr %6, !70, !DIExpression(), !71)
    #dbg_declare(ptr %7, !72, !DIExpression(), !73)
    #dbg_declare(ptr %8, !74, !DIExpression(), !75)
  call void @llvm.va_start.p0(ptr %8), !dbg !76
  %9 = load ptr, ptr %8, align 8, !dbg !77
  %10 = load ptr, ptr %4, align 8, !dbg !77
  %11 = load i64, ptr %5, align 8, !dbg !77
  %12 = load ptr, ptr %6, align 8, !dbg !77
  %13 = call i32 @_vsnprintf(ptr noundef %12, i64 noundef %11, ptr noundef %10, ptr noundef %9), !dbg !77
  store i32 %13, ptr %7, align 4, !dbg !77
  call void @llvm.va_end.p0(ptr %8), !dbg !78
  %14 = load i32, ptr %7, align 4, !dbg !79
  ret i32 %14, !dbg !79
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsnprintf(ptr noundef %0, i64 noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat !dbg !80 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i64, align 8
  %8 = alloca ptr, align 8
  store ptr %3, ptr %5, align 8
    #dbg_declare(ptr %5, !83, !DIExpression(), !84)
  store ptr %2, ptr %6, align 8
    #dbg_declare(ptr %6, !85, !DIExpression(), !86)
  store i64 %1, ptr %7, align 8
    #dbg_declare(ptr %7, !87, !DIExpression(), !88)
  store ptr %0, ptr %8, align 8
    #dbg_declare(ptr %8, !89, !DIExpression(), !90)
  %9 = load ptr, ptr %5, align 8, !dbg !91
  %10 = load ptr, ptr %6, align 8, !dbg !91
  %11 = load i64, ptr %7, align 8, !dbg !91
  %12 = load ptr, ptr %8, align 8, !dbg !91
  %13 = call i32 @_vsnprintf_l(ptr noundef %12, i64 noundef %11, ptr noundef %10, ptr noundef null, ptr noundef %9), !dbg !91
  ret i32 %13, !dbg !91
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 noundef %0) #0 !dbg !92 {
  %oneMinusU = fsub double 0x10000000000000, 0x10000000000000
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
    #dbg_declare(ptr %2, !95, !DIExpression(), !96)
  %3 = load i32, ptr %2, align 4, !dbg !97
  %4 = call i32 (ptr, ...) @printf(ptr noundef @"??_C@_07ODMBGAAE@foo?5?$CFi?6?$AA@", i32 noundef %3), !dbg !97
  ret void, !dbg !98
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @printf(ptr noundef %0, ...) #0 comdat !dbg !99 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !102, !DIExpression(), !103)
    #dbg_declare(ptr %3, !104, !DIExpression(), !105)
    #dbg_declare(ptr %4, !106, !DIExpression(), !107)
  call void @llvm.va_start.p0(ptr %4), !dbg !108
  %5 = load ptr, ptr %4, align 8, !dbg !109
  %6 = load ptr, ptr %2, align 8, !dbg !109
  %7 = call ptr @__acrt_iob_func(i32 noundef 1), !dbg !109
  %8 = call i32 @_vfprintf_l(ptr noundef %7, ptr noundef %6, ptr noundef null, ptr noundef %5), !dbg !109
  store i32 %8, ptr %3, align 4, !dbg !109
  call void @llvm.va_end.p0(ptr %4), !dbg !110
  %9 = load i32, ptr %3, align 4, !dbg !111
  ret i32 %9, !dbg !111
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !112 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @foo(i32 noundef 123123), !dbg !115
  ret i32 0, !dbg !116
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #1

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsprintf_l(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat !dbg !117 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store ptr %3, ptr %5, align 8
    #dbg_declare(ptr %5, !133, !DIExpression(), !134)
  store ptr %2, ptr %6, align 8
    #dbg_declare(ptr %6, !135, !DIExpression(), !136)
  store ptr %1, ptr %7, align 8
    #dbg_declare(ptr %7, !137, !DIExpression(), !138)
  store ptr %0, ptr %8, align 8
    #dbg_declare(ptr %8, !139, !DIExpression(), !140)
  %9 = load ptr, ptr %5, align 8, !dbg !141
  %10 = load ptr, ptr %6, align 8, !dbg !141
  %11 = load ptr, ptr %7, align 8, !dbg !141
  %12 = load ptr, ptr %8, align 8, !dbg !141
  %13 = call i32 @_vsnprintf_l(ptr noundef %12, i64 noundef -1, ptr noundef %11, ptr noundef %10, ptr noundef %9), !dbg !141
  ret i32 %13, !dbg !141
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end.p0(ptr) #1

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsnprintf_l(ptr noundef %0, i64 noundef %1, ptr noundef %2, ptr noundef %3, ptr noundef %4) #0 comdat !dbg !142 {
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i64, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i32, align 4
  store ptr %4, ptr %6, align 8
    #dbg_declare(ptr %6, !145, !DIExpression(), !146)
  store ptr %3, ptr %7, align 8
    #dbg_declare(ptr %7, !147, !DIExpression(), !148)
  store ptr %2, ptr %8, align 8
    #dbg_declare(ptr %8, !149, !DIExpression(), !150)
  store i64 %1, ptr %9, align 8
    #dbg_declare(ptr %9, !151, !DIExpression(), !152)
  store ptr %0, ptr %10, align 8
    #dbg_declare(ptr %10, !153, !DIExpression(), !154)
    #dbg_declare(ptr %11, !155, !DIExpression(), !157)
  %12 = load ptr, ptr %6, align 8, !dbg !157
  %13 = load ptr, ptr %7, align 8, !dbg !157
  %14 = load ptr, ptr %8, align 8, !dbg !157
  %15 = load i64, ptr %9, align 8, !dbg !157
  %16 = load ptr, ptr %10, align 8, !dbg !157
  %17 = call ptr @__local_stdio_printf_options(), !dbg !157
  %18 = load i64, ptr %17, align 8, !dbg !157
  %19 = or i64 %18, 1, !dbg !157
  %20 = call i32 @__stdio_common_vsprintf(i64 noundef %19, ptr noundef %16, i64 noundef %15, ptr noundef %14, ptr noundef %13, ptr noundef %12), !dbg !157
  store i32 %20, ptr %11, align 4, !dbg !157
  %21 = load i32, ptr %11, align 4, !dbg !158
  %22 = icmp slt i32 %21, 0, !dbg !158
  br i1 %22, label %23, label %24, !dbg !158

23:                                               ; preds = %5
  br label %26, !dbg !158

24:                                               ; preds = %5
  %25 = load i32, ptr %11, align 4, !dbg !158
  br label %26, !dbg !158

26:                                               ; preds = %24, %23
  %27 = phi i32 [ -1, %23 ], [ %25, %24 ], !dbg !158
  ret i32 %27, !dbg !158
}

declare dso_local i32 @__stdio_common_vsprintf(i64 noundef, ptr noundef, i64 noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local ptr @__local_stdio_printf_options() #0 comdat !dbg !9 {
  ret ptr @__local_stdio_printf_options._OptionsStorage, !dbg !159
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vfprintf_l(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat !dbg !160 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store ptr %3, ptr %5, align 8
    #dbg_declare(ptr %5, !171, !DIExpression(), !172)
  store ptr %2, ptr %6, align 8
    #dbg_declare(ptr %6, !173, !DIExpression(), !174)
  store ptr %1, ptr %7, align 8
    #dbg_declare(ptr %7, !175, !DIExpression(), !176)
  store ptr %0, ptr %8, align 8
    #dbg_declare(ptr %8, !177, !DIExpression(), !178)
  %9 = load ptr, ptr %5, align 8, !dbg !179
  %10 = load ptr, ptr %6, align 8, !dbg !179
  %11 = load ptr, ptr %7, align 8, !dbg !179
  %12 = load ptr, ptr %8, align 8, !dbg !179
  %13 = call ptr @__local_stdio_printf_options(), !dbg !179
  %14 = load i64, ptr %13, align 8, !dbg !179
  %15 = call i32 @__stdio_common_vfprintf(i64 noundef %14, ptr noundef %12, ptr noundef %11, ptr noundef %10, ptr noundef %9), !dbg !179
  ret i32 %15, !dbg !179
}

declare dso_local ptr @__acrt_iob_func(i32 noundef) #2

declare dso_local i32 @__stdio_common_vfprintf(i64 noundef, ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

attributes #0 = { noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!15}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 8, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "example.c", directory: "C:\\Users\\sariaki\\Documents\\code\\py\\JuFo-2026\\examples", checksumkind: CSK_MD5, checksum: "6fd78dce024844d71dc778657bd5154e")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 8)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(name: "_OptionsStorage", scope: !9, file: !10, line: 91, type: !14, isLocal: true, isDefinition: true)
!9 = distinct !DISubprogram(name: "__local_stdio_printf_options", scope: !10, file: !10, line: 89, type: !11, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15)
!10 = !DIFile(filename: "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\ucrt\\corecrt_stdio_config.h", directory: "", checksumkind: CSK_MD5, checksum: "dacf907bda504afb0b64f53a242bdae6")
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!15 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "clang version 21.1.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !16, globals: !19, splitDebugInlining: false, nameTableKind: None)
!16 = !{!17}
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !18, line: 188, baseType: !14)
!18 = !DIFile(filename: "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\include\\vcruntime.h", directory: "", checksumkind: CSK_MD5, checksum: "52b0f67d23fb299eb670469dd77ef832")
!19 = !{!0, !7}
!20 = !{i32 2, !"CodeView", i32 1}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 2}
!23 = !{i32 8, !"PIC Level", i32 2}
!24 = !{i32 7, !"uwtable", i32 2}
!25 = !{i32 1, !"MaxTLSAlign", i32 65536}
!26 = !{!"clang version 21.1.0"}
!27 = distinct !DISubprogram(name: "sprintf", scope: !28, file: !28, line: 1764, type: !29, scopeLine: 1771, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!28 = !DIFile(filename: "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\ucrt\\stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "c1a1fbc43e7d45f0ea4ae539ddcffb19")
!29 = !DISubroutineType(types: !30)
!30 = !{!31, !32, !34, null}
!31 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!37 = !{}
!38 = !DILocalVariable(name: "_Format", arg: 2, scope: !27, file: !28, line: 1766, type: !34)
!39 = !DILocation(line: 1766, scope: !27)
!40 = !DILocalVariable(name: "_Buffer", arg: 1, scope: !27, file: !28, line: 1765, type: !32)
!41 = !DILocation(line: 1765, scope: !27)
!42 = !DILocalVariable(name: "_Result", scope: !27, file: !28, line: 1772, type: !31)
!43 = !DILocation(line: 1772, scope: !27)
!44 = !DILocalVariable(name: "_ArgList", scope: !27, file: !28, line: 1773, type: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "va_list", file: !46, line: 72, baseType: !33)
!46 = !DIFile(filename: "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.44.35207\\include\\vadefs.h", directory: "", checksumkind: CSK_MD5, checksum: "a4b8f96637d0704c82f39ecb6bde2ab4")
!47 = !DILocation(line: 1773, scope: !27)
!48 = !DILocation(line: 1774, scope: !27)
!49 = !DILocation(line: 1776, scope: !27)
!50 = !DILocation(line: 1778, scope: !27)
!51 = !DILocation(line: 1779, scope: !27)
!52 = distinct !DISubprogram(name: "vsprintf", scope: !28, file: !28, line: 1465, type: !53, scopeLine: 1473, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!53 = !DISubroutineType(types: !54)
!54 = !{!31, !32, !34, !45}
!55 = !DILocalVariable(name: "_ArgList", arg: 3, scope: !52, file: !28, line: 1468, type: !45)
!56 = !DILocation(line: 1468, scope: !52)
!57 = !DILocalVariable(name: "_Format", arg: 2, scope: !52, file: !28, line: 1467, type: !34)
!58 = !DILocation(line: 1467, scope: !52)
!59 = !DILocalVariable(name: "_Buffer", arg: 1, scope: !52, file: !28, line: 1466, type: !32)
!60 = !DILocation(line: 1466, scope: !52)
!61 = !DILocation(line: 1474, scope: !52)
!62 = distinct !DISubprogram(name: "_snprintf", scope: !28, file: !28, line: 1939, type: !63, scopeLine: 1947, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!63 = !DISubroutineType(types: !64)
!64 = !{!31, !32, !65, !34, null}
!65 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!66 = !DILocalVariable(name: "_Format", arg: 3, scope: !62, file: !28, line: 1942, type: !34)
!67 = !DILocation(line: 1942, scope: !62)
!68 = !DILocalVariable(name: "_BufferCount", arg: 2, scope: !62, file: !28, line: 1941, type: !65)
!69 = !DILocation(line: 1941, scope: !62)
!70 = !DILocalVariable(name: "_Buffer", arg: 1, scope: !62, file: !28, line: 1940, type: !32)
!71 = !DILocation(line: 1940, scope: !62)
!72 = !DILocalVariable(name: "_Result", scope: !62, file: !28, line: 1948, type: !31)
!73 = !DILocation(line: 1948, scope: !62)
!74 = !DILocalVariable(name: "_ArgList", scope: !62, file: !28, line: 1949, type: !45)
!75 = !DILocation(line: 1949, scope: !62)
!76 = !DILocation(line: 1950, scope: !62)
!77 = !DILocation(line: 1951, scope: !62)
!78 = !DILocation(line: 1952, scope: !62)
!79 = !DILocation(line: 1953, scope: !62)
!80 = distinct !DISubprogram(name: "_vsnprintf", scope: !28, file: !28, line: 1402, type: !81, scopeLine: 1411, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!81 = !DISubroutineType(types: !82)
!82 = !{!31, !32, !65, !34, !45}
!83 = !DILocalVariable(name: "_ArgList", arg: 4, scope: !80, file: !28, line: 1406, type: !45)
!84 = !DILocation(line: 1406, scope: !80)
!85 = !DILocalVariable(name: "_Format", arg: 3, scope: !80, file: !28, line: 1405, type: !34)
!86 = !DILocation(line: 1405, scope: !80)
!87 = !DILocalVariable(name: "_BufferCount", arg: 2, scope: !80, file: !28, line: 1404, type: !65)
!88 = !DILocation(line: 1404, scope: !80)
!89 = !DILocalVariable(name: "_Buffer", arg: 1, scope: !80, file: !28, line: 1403, type: !32)
!90 = !DILocation(line: 1403, scope: !80)
!91 = !DILocation(line: 1412, scope: !80)
!92 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 6, type: !93, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!93 = !DISubroutineType(types: !94)
!94 = !{null, !31}
!95 = !DILocalVariable(name: "x", arg: 1, scope: !92, file: !2, line: 6, type: !31)
!96 = !DILocation(line: 6, scope: !92)
!97 = !DILocation(line: 8, scope: !92)
!98 = !DILocation(line: 10, scope: !92)
!99 = distinct !DISubprogram(name: "printf", scope: !28, file: !28, line: 950, type: !100, scopeLine: 956, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!100 = !DISubroutineType(types: !101)
!101 = !{!31, !34, null}
!102 = !DILocalVariable(name: "_Format", arg: 1, scope: !99, file: !28, line: 951, type: !34)
!103 = !DILocation(line: 951, scope: !99)
!104 = !DILocalVariable(name: "_Result", scope: !99, file: !28, line: 957, type: !31)
!105 = !DILocation(line: 957, scope: !99)
!106 = !DILocalVariable(name: "_ArgList", scope: !99, file: !28, line: 958, type: !45)
!107 = !DILocation(line: 958, scope: !99)
!108 = !DILocation(line: 959, scope: !99)
!109 = !DILocation(line: 960, scope: !99)
!110 = !DILocation(line: 961, scope: !99)
!111 = !DILocation(line: 962, scope: !99)
!112 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 12, type: !113, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !15)
!113 = !DISubroutineType(types: !114)
!114 = !{!31}
!115 = !DILocation(line: 14, scope: !112)
!116 = !DILocation(line: 15, scope: !112)
!117 = distinct !DISubprogram(name: "_vsprintf_l", scope: !28, file: !28, line: 1449, type: !118, scopeLine: 1458, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!118 = !DISubroutineType(types: !119)
!119 = !{!31, !32, !34, !120, !45}
!120 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !121)
!121 = !DIDerivedType(tag: DW_TAG_typedef, name: "_locale_t", file: !122, line: 623, baseType: !123)
!122 = !DIFile(filename: "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\ucrt\\corecrt.h", directory: "", checksumkind: CSK_MD5, checksum: "93b3a419bcf351413b7b408357260994")
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_typedef, name: "__crt_locale_pointers", file: !122, line: 621, baseType: !125)
!125 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__crt_locale_pointers", file: !122, line: 617, size: 128, align: 64, elements: !126)
!126 = !{!127, !130}
!127 = !DIDerivedType(tag: DW_TAG_member, name: "locinfo", scope: !125, file: !122, line: 619, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !129, size: 64)
!129 = !DICompositeType(tag: DW_TAG_structure_type, name: "__crt_locale_data", file: !122, line: 619, flags: DIFlagFwdDecl)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "mbcinfo", scope: !125, file: !122, line: 620, baseType: !131, size: 64, offset: 64)
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !132, size: 64)
!132 = !DICompositeType(tag: DW_TAG_structure_type, name: "__crt_multibyte_data", file: !122, line: 620, flags: DIFlagFwdDecl)
!133 = !DILocalVariable(name: "_ArgList", arg: 4, scope: !117, file: !28, line: 1453, type: !45)
!134 = !DILocation(line: 1453, scope: !117)
!135 = !DILocalVariable(name: "_Locale", arg: 3, scope: !117, file: !28, line: 1452, type: !120)
!136 = !DILocation(line: 1452, scope: !117)
!137 = !DILocalVariable(name: "_Format", arg: 2, scope: !117, file: !28, line: 1451, type: !34)
!138 = !DILocation(line: 1451, scope: !117)
!139 = !DILocalVariable(name: "_Buffer", arg: 1, scope: !117, file: !28, line: 1450, type: !32)
!140 = !DILocation(line: 1450, scope: !117)
!141 = !DILocation(line: 1459, scope: !117)
!142 = distinct !DISubprogram(name: "_vsnprintf_l", scope: !28, file: !28, line: 1381, type: !143, scopeLine: 1391, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!143 = !DISubroutineType(types: !144)
!144 = !{!31, !32, !65, !34, !120, !45}
!145 = !DILocalVariable(name: "_ArgList", arg: 5, scope: !142, file: !28, line: 1386, type: !45)
!146 = !DILocation(line: 1386, scope: !142)
!147 = !DILocalVariable(name: "_Locale", arg: 4, scope: !142, file: !28, line: 1385, type: !120)
!148 = !DILocation(line: 1385, scope: !142)
!149 = !DILocalVariable(name: "_Format", arg: 3, scope: !142, file: !28, line: 1384, type: !34)
!150 = !DILocation(line: 1384, scope: !142)
!151 = !DILocalVariable(name: "_BufferCount", arg: 2, scope: !142, file: !28, line: 1383, type: !65)
!152 = !DILocation(line: 1383, scope: !142)
!153 = !DILocalVariable(name: "_Buffer", arg: 1, scope: !142, file: !28, line: 1382, type: !32)
!154 = !DILocation(line: 1382, scope: !142)
!155 = !DILocalVariable(name: "_Result", scope: !142, file: !28, line: 1392, type: !156)
!156 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !31)
!157 = !DILocation(line: 1392, scope: !142)
!158 = !DILocation(line: 1396, scope: !142)
!159 = !DILocation(line: 92, scope: !9)
!160 = distinct !DISubprogram(name: "_vfprintf_l", scope: !28, file: !28, line: 635, type: !161, scopeLine: 644, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !37)
!161 = !DISubroutineType(types: !162)
!162 = !{!31, !163, !34, !120, !45}
!163 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !164)
!164 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !165, size: 64)
!165 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !166, line: 31, baseType: !167)
!166 = !DIFile(filename: "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\ucrt\\corecrt_wstdio.h", directory: "", checksumkind: CSK_MD5, checksum: "bf50373b435d0afd0235dd3e05c4a277")
!167 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_iobuf", file: !166, line: 28, size: 64, align: 64, elements: !168)
!168 = !{!169}
!169 = !DIDerivedType(tag: DW_TAG_member, name: "_Placeholder", scope: !167, file: !166, line: 30, baseType: !170, size: 64)
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!171 = !DILocalVariable(name: "_ArgList", arg: 4, scope: !160, file: !28, line: 639, type: !45)
!172 = !DILocation(line: 639, scope: !160)
!173 = !DILocalVariable(name: "_Locale", arg: 3, scope: !160, file: !28, line: 638, type: !120)
!174 = !DILocation(line: 638, scope: !160)
!175 = !DILocalVariable(name: "_Format", arg: 2, scope: !160, file: !28, line: 637, type: !34)
!176 = !DILocation(line: 637, scope: !160)
!177 = !DILocalVariable(name: "_Stream", arg: 1, scope: !160, file: !28, line: 636, type: !163)
!178 = !DILocation(line: 636, scope: !160)
!179 = !DILocation(line: 645, scope: !160)
