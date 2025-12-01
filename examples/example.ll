; ModuleID = './example.c'
source_filename = "./example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"foo %i\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [28 x i8] c"insert_stochastic_predicate\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [12 x i8] c"./example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [1 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.1, ptr @.str.2, i32 6, ptr null }], section "llvm.metadata"

; Function Attrs: nofree nounwind uwtable
define dso_local void @foo(i32 noundef %0) #0 !dbg !18 {
  tail call void @llvm.dbg.value(metadata i32 %0, metadata !23, metadata !DIExpression()), !dbg !24
  %2 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %0), !dbg !25
  ret void, !dbg !26
}

; Function Attrs: nofree nounwind
declare !dbg !27 noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: nofree nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 !dbg !34 {
  call void @llvm.dbg.value(metadata i32 123123, metadata !23, metadata !DIExpression()), !dbg !37
  %1 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef 123123), !dbg !39
  ret i32 0, !dbg !40
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nofree nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!10, !11, !12, !13, !14, !15, !16}
!llvm.ident = !{!17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 8, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "./example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "9cc1d5fa49da888eebf447b0ac459a52")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 8)
!7 = distinct !DICompileUnit(language: DW_LANG_C11, file: !8, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "9cc1d5fa49da888eebf447b0ac459a52")
!9 = !{!0}
!10 = !{i32 7, !"Dwarf Version", i32 5}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{i32 8, !"PIC Level", i32 2}
!14 = !{i32 7, !"PIE Level", i32 2}
!15 = !{i32 7, !"uwtable", i32 2}
!16 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!17 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!18 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 6, type: !19, scopeLine: 7, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !7, retainedNodes: !22)
!19 = !DISubroutineType(types: !20)
!20 = !{null, !21}
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !{!23}
!23 = !DILocalVariable(name: "x", arg: 1, scope: !18, file: !2, line: 6, type: !21)
!24 = !DILocation(line: 0, scope: !18)
!25 = !DILocation(line: 8, column: 3, scope: !18)
!26 = !DILocation(line: 10, column: 1, scope: !18)
!27 = !DISubprogram(name: "printf", scope: !28, file: !28, line: 363, type: !29, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!28 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "1e435c46987a169d9f9186f63a512303")
!29 = !DISubroutineType(types: !30)
!30 = !{!21, !31, null}
!31 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !32)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!34 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 12, type: !35, scopeLine: 13, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !7)
!35 = !DISubroutineType(types: !36)
!36 = !{!21}
!37 = !DILocation(line: 0, scope: !18, inlinedAt: !38)
!38 = distinct !DILocation(line: 14, column: 3, scope: !34)
!39 = !DILocation(line: 8, column: 3, scope: !18, inlinedAt: !38)
!40 = !DILocation(line: 15, column: 3, scope: !34)
