; ModuleID = './example.c'
source_filename = "./example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"foo %i\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [7 x i8] c"bar %i\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [4 x i8] c"POP\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [12 x i8] c"./example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @bar, ptr @.str.2, ptr @.str.3, i32 13, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.2, ptr @.str.3, i32 7, ptr null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 noundef %0) #0 !dbg !23 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !28, metadata !DIExpression()), !dbg !29
  %3 = load i32, ptr %2, align 4, !dbg !30
  %4 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %3), !dbg !31
  ret void, !dbg !32
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar(i32 noundef %0) #0 !dbg !33 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !36, metadata !DIExpression()), !dbg !37
  call void @llvm.dbg.declare(metadata ptr %3, metadata !38, metadata !DIExpression()), !dbg !39
  %4 = load i32, ptr %2, align 4, !dbg !40
  %5 = add nsw i32 %4, 1, !dbg !41
  store i32 %5, ptr %3, align 4, !dbg !39
  %6 = load i32, ptr %3, align 4, !dbg !42
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %6), !dbg !43
  %8 = load i32, ptr %3, align 4, !dbg !44
  ret i32 %8, !dbg !45
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !46 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @foo(i32 noundef 123123), !dbg !49
  ret i32 0, !dbg !50
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!12}
!llvm.module.flags = !{!15, !16, !17, !18, !19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 9, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "./example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "a6eb3bfa9d310204b0913a34d627c941")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 8)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 56, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 7)
!12 = distinct !DICompileUnit(language: DW_LANG_C11, file: !13, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !14, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "a6eb3bfa9d310204b0913a34d627c941")
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
!32 = !DILocation(line: 11, column: 1, scope: !23)
!33 = distinct !DISubprogram(name: "bar", scope: !2, file: !2, line: 13, type: !34, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !27)
!34 = !DISubroutineType(types: !35)
!35 = !{!26, !26}
!36 = !DILocalVariable(name: "x", arg: 1, scope: !33, file: !2, line: 13, type: !26)
!37 = !DILocation(line: 13, column: 23, scope: !33)
!38 = !DILocalVariable(name: "y", scope: !33, file: !2, line: 15, type: !26)
!39 = !DILocation(line: 15, column: 7, scope: !33)
!40 = !DILocation(line: 15, column: 11, scope: !33)
!41 = !DILocation(line: 15, column: 13, scope: !33)
!42 = !DILocation(line: 16, column: 20, scope: !33)
!43 = !DILocation(line: 16, column: 3, scope: !33)
!44 = !DILocation(line: 17, column: 10, scope: !33)
!45 = !DILocation(line: 17, column: 3, scope: !33)
!46 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 20, type: !47, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !12)
!47 = !DISubroutineType(types: !48)
!48 = !{!26}
!49 = !DILocation(line: 22, column: 3, scope: !46)
!50 = !DILocation(line: 23, column: 3, scope: !46)
