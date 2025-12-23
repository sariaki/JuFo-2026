; ModuleID = './example.c'
source_filename = "./example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"foo %lu\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [8 x i8] c"bar %i\0A\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [4 x i8] c"POP\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [12 x i8] c"./example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @bar, ptr @.str.2, ptr @.str.3, i32 33, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.2, ptr @.str.3, i32 22, ptr null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @rand_uint64() #0 !dbg !29 {
  %1 = alloca i64, align 8
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !32, metadata !DIExpression()), !dbg !33
  store i64 0, ptr %1, align 8, !dbg !33
  call void @llvm.dbg.declare(metadata ptr %2, metadata !34, metadata !DIExpression()), !dbg !37
  store i32 0, ptr %2, align 4, !dbg !37
  br label %3, !dbg !38

3:                                                ; preds = %12, %0
  %4 = load i32, ptr %2, align 4, !dbg !39
  %5 = icmp slt i32 %4, 64, !dbg !41
  br i1 %5, label %6, label %15, !dbg !42

6:                                                ; preds = %3
  %7 = load i64, ptr %1, align 8, !dbg !43
  %8 = mul i64 %7, 2147483648, !dbg !45
  %9 = call i32 @rand() #4, !dbg !46
  %10 = sext i32 %9 to i64, !dbg !46
  %11 = add i64 %8, %10, !dbg !47
  store i64 %11, ptr %1, align 8, !dbg !48
  br label %12, !dbg !49

12:                                               ; preds = %6
  %13 = load i32, ptr %2, align 4, !dbg !50
  %14 = add nsw i32 %13, 15, !dbg !50
  store i32 %14, ptr %2, align 4, !dbg !50
  br label %3, !dbg !51, !llvm.loop !52

15:                                               ; preds = %3
  %16 = load i64, ptr %1, align 8, !dbg !55
  ret i64 %16, !dbg !56
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i32 @rand() #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @wrapper() #0 !dbg !57 {
  %1 = call i64 @rand_uint64(), !dbg !58
  ret i64 %1, !dbg !59
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i64 noundef %0) #0 !dbg !60 {
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i64 %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !63, metadata !DIExpression()), !dbg !64
  %7 = load i64, ptr %2, align 8, !dbg !65
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %7), !dbg !66
  call void @llvm.dbg.declare(metadata ptr %3, metadata !67, metadata !DIExpression()), !dbg !69
  store volatile i32 1, ptr %3, align 4, !dbg !69
  call void @llvm.dbg.declare(metadata ptr %4, metadata !70, metadata !DIExpression()), !dbg !71
  store volatile i32 2, ptr %4, align 4, !dbg !71
  call void @llvm.dbg.declare(metadata ptr %5, metadata !72, metadata !DIExpression()), !dbg !73
  %9 = load volatile i32, ptr %3, align 4, !dbg !74
  %10 = load volatile i32, ptr %4, align 4, !dbg !75
  %11 = srem i32 %9, %10, !dbg !76
  store volatile i32 %11, ptr %5, align 4, !dbg !73
  call void @llvm.dbg.declare(metadata ptr %6, metadata !77, metadata !DIExpression()), !dbg !78
  %12 = load volatile i32, ptr %5, align 4, !dbg !79
  %13 = load volatile i32, ptr %4, align 4, !dbg !80
  %14 = load volatile i32, ptr %3, align 4, !dbg !81
  %15 = mul nsw i32 %13, %14, !dbg !82
  %16 = add nsw i32 %12, %15, !dbg !83
  store volatile i32 %16, ptr %6, align 4, !dbg !78
  ret void, !dbg !84
}

declare i32 @printf(ptr noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar(i32 noundef %0) #0 !dbg !85 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !88, metadata !DIExpression()), !dbg !89
  call void @llvm.dbg.declare(metadata ptr %3, metadata !90, metadata !DIExpression()), !dbg !91
  %4 = load i32, ptr %2, align 4, !dbg !92
  %5 = add nsw i32 %4, 1, !dbg !93
  store i32 %5, ptr %3, align 4, !dbg !91
  %6 = load i32, ptr %3, align 4, !dbg !94
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %6), !dbg !95
  %8 = load i32, ptr %3, align 4, !dbg !96
  ret i32 %8, !dbg !97
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !98 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i64 @wrapper(), !dbg !101
  call void @foo(i64 noundef %2), !dbg !102
  ret i32 0, !dbg !103
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!12}
!llvm.module.flags = !{!21, !22, !23, !24, !25, !26, !27}
!llvm.ident = !{!28}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 24, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "./example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "3ea44ddee13b2ab84b687f7fca1ff579")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 9)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 36, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 8)
!12 = distinct !DICompileUnit(language: DW_LANG_C11, file: !13, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !14, globals: !20, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "3ea44ddee13b2ab84b687f7fca1ff579")
!14 = !{!15}
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !16, line: 27, baseType: !17)
!16 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "256fcabbefa27ca8cf5e6d37525e6e16")
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !18, line: 45, baseType: !19)
!18 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "e1865d9fe29fe1b5ced550b7ba458f9e")
!19 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!20 = !{!0, !7}
!21 = !{i32 7, !"Dwarf Version", i32 5}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 4}
!24 = !{i32 8, !"PIC Level", i32 2}
!25 = !{i32 7, !"PIE Level", i32 2}
!26 = !{i32 7, !"uwtable", i32 2}
!27 = !{i32 7, !"frame-pointer", i32 2}
!28 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!29 = distinct !DISubprogram(name: "rand_uint64", scope: !2, file: !2, line: 10, type: !30, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !31)
!30 = !DISubroutineType(types: !14)
!31 = !{}
!32 = !DILocalVariable(name: "r", scope: !29, file: !2, line: 11, type: !15)
!33 = !DILocation(line: 11, column: 12, scope: !29)
!34 = !DILocalVariable(name: "i", scope: !35, file: !2, line: 12, type: !36)
!35 = distinct !DILexicalBlock(scope: !29, file: !2, line: 12, column: 3)
!36 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!37 = !DILocation(line: 12, column: 12, scope: !35)
!38 = !DILocation(line: 12, column: 8, scope: !35)
!39 = !DILocation(line: 12, column: 17, scope: !40)
!40 = distinct !DILexicalBlock(scope: !35, file: !2, line: 12, column: 3)
!41 = !DILocation(line: 12, column: 18, scope: !40)
!42 = !DILocation(line: 12, column: 3, scope: !35)
!43 = !DILocation(line: 13, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !40, file: !2, line: 12, column: 39)
!45 = !DILocation(line: 13, column: 10, scope: !44)
!46 = !DILocation(line: 13, column: 38, scope: !44)
!47 = !DILocation(line: 13, column: 36, scope: !44)
!48 = !DILocation(line: 13, column: 7, scope: !44)
!49 = !DILocation(line: 14, column: 3, scope: !44)
!50 = !DILocation(line: 12, column: 25, scope: !40)
!51 = !DILocation(line: 12, column: 3, scope: !40)
!52 = distinct !{!52, !42, !53, !54}
!53 = !DILocation(line: 14, column: 3, scope: !35)
!54 = !{!"llvm.loop.mustprogress"}
!55 = !DILocation(line: 15, column: 10, scope: !29)
!56 = !DILocation(line: 15, column: 3, scope: !29)
!57 = distinct !DISubprogram(name: "wrapper", scope: !2, file: !2, line: 18, type: !30, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12)
!58 = !DILocation(line: 19, column: 10, scope: !57)
!59 = !DILocation(line: 19, column: 3, scope: !57)
!60 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 22, type: !61, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !31)
!61 = !DISubroutineType(types: !62)
!62 = !{null, !15}
!63 = !DILocalVariable(name: "x", arg: 1, scope: !60, file: !2, line: 22, type: !15)
!64 = !DILocation(line: 22, column: 29, scope: !60)
!65 = !DILocation(line: 24, column: 23, scope: !60)
!66 = !DILocation(line: 24, column: 3, scope: !60)
!67 = !DILocalVariable(name: "a", scope: !60, file: !2, line: 26, type: !68)
!68 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !36)
!69 = !DILocation(line: 26, column: 16, scope: !60)
!70 = !DILocalVariable(name: "b", scope: !60, file: !2, line: 27, type: !68)
!71 = !DILocation(line: 27, column: 16, scope: !60)
!72 = !DILocalVariable(name: "c", scope: !60, file: !2, line: 28, type: !68)
!73 = !DILocation(line: 28, column: 16, scope: !60)
!74 = !DILocation(line: 28, column: 20, scope: !60)
!75 = !DILocation(line: 28, column: 24, scope: !60)
!76 = !DILocation(line: 28, column: 22, scope: !60)
!77 = !DILocalVariable(name: "d", scope: !60, file: !2, line: 29, type: !68)
!78 = !DILocation(line: 29, column: 16, scope: !60)
!79 = !DILocation(line: 29, column: 20, scope: !60)
!80 = !DILocation(line: 29, column: 24, scope: !60)
!81 = !DILocation(line: 29, column: 28, scope: !60)
!82 = !DILocation(line: 29, column: 26, scope: !60)
!83 = !DILocation(line: 29, column: 22, scope: !60)
!84 = !DILocation(line: 31, column: 1, scope: !60)
!85 = distinct !DISubprogram(name: "bar", scope: !2, file: !2, line: 33, type: !86, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !31)
!86 = !DISubroutineType(types: !87)
!87 = !{!36, !36}
!88 = !DILocalVariable(name: "x", arg: 1, scope: !85, file: !2, line: 33, type: !36)
!89 = !DILocation(line: 33, column: 23, scope: !85)
!90 = !DILocalVariable(name: "y", scope: !85, file: !2, line: 35, type: !36)
!91 = !DILocation(line: 35, column: 7, scope: !85)
!92 = !DILocation(line: 35, column: 11, scope: !85)
!93 = !DILocation(line: 35, column: 13, scope: !85)
!94 = !DILocation(line: 36, column: 22, scope: !85)
!95 = !DILocation(line: 36, column: 3, scope: !85)
!96 = !DILocation(line: 37, column: 10, scope: !85)
!97 = !DILocation(line: 37, column: 3, scope: !85)
!98 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 40, type: !99, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !12)
!99 = !DISubroutineType(types: !100)
!100 = !{!36}
!101 = !DILocation(line: 42, column: 7, scope: !98)
!102 = !DILocation(line: 42, column: 3, scope: !98)
!103 = !DILocation(line: 43, column: 3, scope: !98)
