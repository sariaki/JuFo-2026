; ModuleID = 'example_obf.bc'
source_filename = "example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"foo %i\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [7 x i8] c"bar %i\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [4 x i8] c"POP\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @bar, ptr @.str.2, ptr @.str.3, i32 13, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.2, ptr @.str.3, i32 7, ptr null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 noundef %0) #0 !dbg !22 {
  %sitofp_to_double = sitofp i32 %0 to double
  %2 = fmul double %sitofp_to_double, 0x4000000000000
  %3 = call double @sample_bernstein_inverse(double %2)
  %4 = fcmp olt double %3, 0xC030C6A1B699D702
  br i1 %4, label %always_hit, label %never_hit

always_hit:                                       ; preds = %1
  %5 = alloca i32, align 4
  store i32 %0, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !27, metadata !DIExpression()), !dbg !28
  %6 = load i32, ptr %5, align 4, !dbg !29
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %6), !dbg !30
  ret void, !dbg !31

never_hit:                                        ; preds = %1
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar(i32 noundef %0) #0 !dbg !32 {
  %sitofp_to_double = sitofp i32 %0 to double
  %2 = fmul double %sitofp_to_double, 0x4000000000000
  %3 = call double @sample_bernstein_inverse(double %2)
  %4 = fcmp olt double %3, 0xC030C6A1B699D702
  br i1 %4, label %always_hit, label %never_hit

always_hit:                                       ; preds = %1
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !35, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata ptr %6, metadata !37, metadata !DIExpression()), !dbg !38
  %7 = load i32, ptr %5, align 4, !dbg !39
  %8 = add nsw i32 %7, 1, !dbg !40
  store i32 %8, ptr %6, align 4, !dbg !38
  %9 = load i32, ptr %6, align 4, !dbg !41
  %10 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %9), !dbg !42
  %11 = load i32, ptr %6, align 4, !dbg !43
  ret i32 %11, !dbg !44

never_hit:                                        ; preds = %1
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !45 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @foo(i32 noundef 123123), !dbg !48
  ret i32 0, !dbg !49
}

define double @sample_bernstein_inverse(double %u) {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %low = phi double [ 0xC030D686EB9A16E6, %entry ], [ %next_low, %loop ]
  %high = phi double [ 0xC030C56F6DCB5E85, %entry ], [ %next_high, %loop ]
  %iter = phi i32 [ 0, %entry ], [ %24, %loop ]
  %0 = fadd double %low, %high
  %mid = fmul double %0, 5.000000e-01
  %1 = fsub double %mid, 0xC030D686EB9A16E6
  %2 = fmul double 0x402DF4B91966F2FD, %1
  %3 = fsub double 1.000000e+00, %2
  %4 = fmul double 1.000000e+00, %3
  %5 = fmul double %4, %3
  %6 = fmul double %5, %3
  %7 = fmul double 0.000000e+00, %6
  %8 = fadd double 0.000000e+00, %7
  %9 = fmul double 1.000000e+00, %2
  %10 = fdiv double %6, %3
  %11 = fmul double 0x3FEE3C9C4EA10B14, %9
  %12 = fmul double %11, %10
  %13 = fadd double %8, %12
  %14 = fmul double %9, %2
  %15 = fdiv double %10, %3
  %16 = fmul double 0x3FFAD6EA037AC87D, %14
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

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!12}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20}
!llvm.ident = !{!21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 9, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "a6eb3bfa9d310204b0913a34d627c941")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 8)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 16, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 56, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 7)
!12 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !13, splitDebugInlining: false, nameTableKind: None)
!13 = !{!0, !7}
!14 = !{i32 7, !"Dwarf Version", i32 5}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{i32 8, !"PIC Level", i32 2}
!18 = !{i32 7, !"PIE Level", i32 2}
!19 = !{i32 7, !"uwtable", i32 2}
!20 = !{i32 7, !"frame-pointer", i32 2}
!21 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!22 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 7, type: !23, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !26)
!23 = !DISubroutineType(types: !24)
!24 = !{null, !25}
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !{}
!27 = !DILocalVariable(name: "x", arg: 1, scope: !22, file: !2, line: 7, type: !25)
!28 = !DILocation(line: 7, column: 24, scope: !22)
!29 = !DILocation(line: 9, column: 22, scope: !22)
!30 = !DILocation(line: 9, column: 3, scope: !22)
!31 = !DILocation(line: 11, column: 1, scope: !22)
!32 = distinct !DISubprogram(name: "bar", scope: !2, file: !2, line: 13, type: !33, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !26)
!33 = !DISubroutineType(types: !34)
!34 = !{!25, !25}
!35 = !DILocalVariable(name: "x", arg: 1, scope: !32, file: !2, line: 13, type: !25)
!36 = !DILocation(line: 13, column: 23, scope: !32)
!37 = !DILocalVariable(name: "y", scope: !32, file: !2, line: 15, type: !25)
!38 = !DILocation(line: 15, column: 7, scope: !32)
!39 = !DILocation(line: 15, column: 11, scope: !32)
!40 = !DILocation(line: 15, column: 13, scope: !32)
!41 = !DILocation(line: 16, column: 20, scope: !32)
!42 = !DILocation(line: 16, column: 3, scope: !32)
!43 = !DILocation(line: 17, column: 10, scope: !32)
!44 = !DILocation(line: 17, column: 3, scope: !32)
!45 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 20, type: !46, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !12)
!46 = !DISubroutineType(types: !47)
!47 = !{!25}
!48 = !DILocation(line: 22, column: 3, scope: !45)
!49 = !DILocation(line: 23, column: 3, scope: !45)
