; ModuleID = 'example_obf.bc'
source_filename = "example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"foo %i\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [28 x i8] c"insert_stochastic_predicate\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [10 x i8] c"example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [1 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.1, ptr @.str.2, i32 6, ptr null }], section "llvm.metadata"

; Function Attrs: nofree nounwind uwtable
define dso_local void @foo(i32 noundef %0) #0 !dbg !17 {
  %sitofp_to_double = sitofp i32 %0 to double, !dbg !23
  %2 = fmul double %sitofp_to_double, 0x4000000000000, !dbg !23
  %3 = call double @sample_bernstein_inverse(double %2), !dbg !23
  %4 = fcmp olt double %3, 0xC02546A0981749AC, !dbg !23
  br i1 %4, label %always_hit, label %never_hit, !dbg !23

always_hit:                                       ; preds = %1
  tail call void @llvm.dbg.value(metadata i32 %0, metadata !22, metadata !DIExpression()), !dbg !24
  %5 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %0), !dbg !23
  ret void, !dbg !25

never_hit:                                        ; preds = %1
  unreachable, !dbg !23
}

; Function Attrs: nofree nounwind
declare !dbg !26 noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #1

; Function Attrs: nofree nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 !dbg !33 {
  call void @llvm.dbg.value(metadata i32 123123, metadata !22, metadata !DIExpression()), !dbg !36
  %1 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef 123123), !dbg !38
  ret i32 0, !dbg !39
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

define double @sample_bernstein_inverse(double %u) {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %low = phi double [ 0xC02564617B40068C, %entry ], [ %next_low, %loop ]
  %high = phi double [ 0xC0254563394AEC7D, %entry ], [ %next_high, %loop ]
  %iter = phi i32 [ 0, %entry ], [ %24, %loop ]
  %0 = fadd double %low, %high
  %mid = fmul double %0, 5.000000e-01
  %1 = fsub double %mid, 0xC02564617B40068C
  %2 = fmul double 0x4030850EB9ECF021, %1
  %3 = fsub double 1.000000e+00, %2
  %4 = fmul double 1.000000e+00, %3
  %5 = fmul double %4, %3
  %6 = fmul double %5, %3
  %7 = fmul double 0.000000e+00, %6
  %8 = fadd double 0.000000e+00, %7
  %9 = fmul double 1.000000e+00, %2
  %10 = fdiv double %6, %3
  %11 = fmul double 0x3FDC9E589DC270C6, %9
  %12 = fmul double %11, %10
  %13 = fadd double %8, %12
  %14 = fmul double %9, %2
  %15 = fdiv double %10, %3
  %16 = fmul double 0x3FE539BFEFBB6A97, %14
  %17 = fmul double %16, %15
  %18 = fadd double %13, %17
  %19 = fmul double %14, %2
  %20 = fdiv double %15, %3
  %21 = fmul double 1.000000e+00, %19
  %22 = fmul double %21, %20
  %23 = fadd double %18, %22
  %is_too_low = fcmp olt double %23, %u
  %next_low = select i1 %is_too_low, double %mid, double %low
  %next_high = select i1 %is_too_low, double %high, double %mid
  %24 = add i32 %iter, 1
  %25 = icmp eq i32 %24, 64
  br i1 %25, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %next_low
}

attributes #0 = { nofree nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 8, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "9cc1d5fa49da888eebf447b0ac459a52")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 8)
!7 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, globals: !8, splitDebugInlining: false, nameTableKind: None)
!8 = !{!0}
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 8, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 2}
!15 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!16 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!17 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 6, type: !18, scopeLine: 7, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !7, retainedNodes: !21)
!18 = !DISubroutineType(types: !19)
!19 = !{null, !20}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{!22}
!22 = !DILocalVariable(name: "x", arg: 1, scope: !17, file: !2, line: 6, type: !20)
!23 = !DILocation(line: 8, column: 3, scope: !17)
!24 = !DILocation(line: 0, scope: !17)
!25 = !DILocation(line: 10, column: 1, scope: !17)
!26 = !DISubprogram(name: "printf", scope: !27, file: !27, line: 363, type: !28, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!27 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "1e435c46987a169d9f9186f63a512303")
!28 = !DISubroutineType(types: !29)
!29 = !{!20, !30, null}
!30 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !31)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!33 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 12, type: !34, scopeLine: 13, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !7)
!34 = !DISubroutineType(types: !35)
!35 = !{!20}
!36 = !DILocation(line: 0, scope: !17, inlinedAt: !37)
!37 = distinct !DILocation(line: 14, column: 3, scope: !33)
!38 = !DILocation(line: 8, column: 3, scope: !17, inlinedAt: !37)
!39 = !DILocation(line: 15, column: 3, scope: !33)
