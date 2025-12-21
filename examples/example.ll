; ModuleID = './example.c'
source_filename = "./example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"foo %i\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [7 x i8] c"bar %i\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [4 x i8] c"POP\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [12 x i8] c"./example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @bar, ptr @.str.2, ptr @.str.3, i32 17, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.2, ptr @.str.3, i32 7, ptr null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 noundef %0) #0 !dbg !23 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !28, metadata !DIExpression()), !dbg !29
  %7 = load i32, ptr %2, align 4, !dbg !30
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %7), !dbg !31
  call void @llvm.dbg.declare(metadata ptr %3, metadata !32, metadata !DIExpression()), !dbg !34
  store volatile i32 1, ptr %3, align 4, !dbg !34
  call void @llvm.dbg.declare(metadata ptr %4, metadata !35, metadata !DIExpression()), !dbg !36
  store volatile i32 2, ptr %4, align 4, !dbg !36
  call void @llvm.dbg.declare(metadata ptr %5, metadata !37, metadata !DIExpression()), !dbg !38
  %9 = load volatile i32, ptr %3, align 4, !dbg !39
  %10 = load volatile i32, ptr %4, align 4, !dbg !40
  %11 = srem i32 %9, %10, !dbg !41
  store volatile i32 %11, ptr %5, align 4, !dbg !38
  call void @llvm.dbg.declare(metadata ptr %6, metadata !42, metadata !DIExpression()), !dbg !43
  %12 = load volatile i32, ptr %5, align 4, !dbg !44
  %13 = load volatile i32, ptr %4, align 4, !dbg !45
  %14 = load volatile i32, ptr %3, align 4, !dbg !46
  %15 = mul nsw i32 %13, %14, !dbg !47
  %16 = add nsw i32 %12, %15, !dbg !48
  store volatile i32 %16, ptr %6, align 4, !dbg !43
  ret void, !dbg !49
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar(i32 noundef %0) #0 !dbg !50 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata ptr %3, metadata !55, metadata !DIExpression()), !dbg !56
  %4 = load i32, ptr %2, align 4, !dbg !57
  %5 = add nsw i32 %4, 1, !dbg !58
  store i32 %5, ptr %3, align 4, !dbg !56
  %6 = load i32, ptr %3, align 4, !dbg !59
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %6), !dbg !60
  %8 = load i32, ptr %3, align 4, !dbg !61
  ret i32 %8, !dbg !62
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !63 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @foo(i32 noundef 123123), !dbg !66
  ret i32 0, !dbg !67
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!12}
!llvm.module.flags = !{!15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 9, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "./example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "45a9bc3947b170af3aadf3a5ee22dde9")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 8)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 20, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 56, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 7)
!12 = distinct !DICompileUnit(language: DW_LANG_C11, file: !13, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !14, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "45a9bc3947b170af3aadf3a5ee22dde9")
!14 = !{!0, !7}
!15 = !{i32 7, !"Dwarf Version", i32 5}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = !{i32 8, !"PIC Level", i32 2}
!19 = !{i32 7, !"PIE Level", i32 2}
!20 = !{i32 7, !"uwtable", i32 2}
!21 = !{i32 7, !"frame-pointer", i32 2}
!22 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!23 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 7, type: !24, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !27)
!24 = !DISubroutineType(types: !25)
!25 = !{null, !26}
!26 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!27 = !{}
!28 = !DILocalVariable(name: "x", arg: 1, scope: !23, file: !2, line: 7, type: !26)
!29 = !DILocation(line: 7, column: 24, scope: !23)
!30 = !DILocation(line: 9, column: 22, scope: !23)
!31 = !DILocation(line: 9, column: 3, scope: !23)
!32 = !DILocalVariable(name: "a", scope: !23, file: !2, line: 10, type: !33)
!33 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !26)
!34 = !DILocation(line: 10, column: 16, scope: !23)
!35 = !DILocalVariable(name: "b", scope: !23, file: !2, line: 11, type: !33)
!36 = !DILocation(line: 11, column: 16, scope: !23)
!37 = !DILocalVariable(name: "c", scope: !23, file: !2, line: 12, type: !33)
!38 = !DILocation(line: 12, column: 16, scope: !23)
!39 = !DILocation(line: 12, column: 20, scope: !23)
!40 = !DILocation(line: 12, column: 24, scope: !23)
!41 = !DILocation(line: 12, column: 22, scope: !23)
!42 = !DILocalVariable(name: "d", scope: !23, file: !2, line: 13, type: !33)
!43 = !DILocation(line: 13, column: 16, scope: !23)
!44 = !DILocation(line: 13, column: 20, scope: !23)
!45 = !DILocation(line: 13, column: 24, scope: !23)
!46 = !DILocation(line: 13, column: 28, scope: !23)
!47 = !DILocation(line: 13, column: 26, scope: !23)
!48 = !DILocation(line: 13, column: 22, scope: !23)
!49 = !DILocation(line: 15, column: 1, scope: !23)
!50 = distinct !DISubprogram(name: "bar", scope: !2, file: !2, line: 17, type: !51, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !27)
!51 = !DISubroutineType(types: !52)
!52 = !{!26, !26}
!53 = !DILocalVariable(name: "x", arg: 1, scope: !50, file: !2, line: 17, type: !26)
!54 = !DILocation(line: 17, column: 23, scope: !50)
!55 = !DILocalVariable(name: "y", scope: !50, file: !2, line: 19, type: !26)
!56 = !DILocation(line: 19, column: 7, scope: !50)
!57 = !DILocation(line: 19, column: 11, scope: !50)
!58 = !DILocation(line: 19, column: 13, scope: !50)
!59 = !DILocation(line: 20, column: 20, scope: !50)
!60 = !DILocation(line: 20, column: 3, scope: !50)
!61 = !DILocation(line: 21, column: 10, scope: !50)
!62 = !DILocation(line: 21, column: 3, scope: !50)
!63 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 24, type: !64, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !12)
!64 = !DISubroutineType(types: !65)
!65 = !{!26}
!66 = !DILocation(line: 26, column: 3, scope: !63)
!67 = !DILocation(line: 27, column: 3, scope: !63)
