; ModuleID = 'example_obf.bc'
source_filename = "example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"foo %i\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [7 x i8] c"bar %i\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [4 x i8] c"POP\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @bar, ptr @.str.2, ptr @.str.3, i32 17, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.2, ptr @.str.3, i32 7, ptr null }], section "llvm.metadata"
@fmt_str = private unnamed_addr constant [16 x i8] c"TrueBB says hi\0A\00"
@fmt_str.1 = private unnamed_addr constant [17 x i8] c"FalseBB says hi\0A\00"
@fmt_str.2 = private unnamed_addr constant [16 x i8] c"TrueBB says hi\0A\00"
@fmt_str.3 = private unnamed_addr constant [17 x i8] c"FalseBB says hi\0A\00"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 noundef %0) #0 !dbg !22 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !27, metadata !DIExpression()), !dbg !28
  %7 = load i32, ptr %2, align 4, !dbg !29
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %7), !dbg !30
  call void @llvm.dbg.declare(metadata ptr %3, metadata !31, metadata !DIExpression()), !dbg !33
  store volatile i32 1, ptr %3, align 4, !dbg !33
  call void @llvm.dbg.declare(metadata ptr %4, metadata !34, metadata !DIExpression()), !dbg !35
  store volatile i32 2, ptr %4, align 4, !dbg !35
  call void @llvm.dbg.declare(metadata ptr %5, metadata !36, metadata !DIExpression()), !dbg !37
  %9 = load volatile i32, ptr %3, align 4, !dbg !38
  %10 = load volatile i32, ptr %4, align 4, !dbg !39
  %sitofp_to_double = sitofp i32 %0 to double, !dbg !40
  %11 = fmul double %sitofp_to_double, 0x4000000000000, !dbg !40
  %12 = call double @sample_bernstein_newtonraphson_1(double %11), !dbg !40
  %13 = fcmp ogt double %12, 0x4041668E5F3E3F58, !dbg !40
  br i1 %13, label %never_hit, label %always_hit, !dbg !40

always_hit:                                       ; preds = %1
  %14 = call i32 (ptr, ...) @printf(ptr @fmt_str), !dbg !40
  %15 = srem i32 %9, %10, !dbg !40
  store volatile i32 %15, ptr %5, align 4, !dbg !37
  call void @llvm.dbg.declare(metadata ptr %6, metadata !41, metadata !DIExpression()), !dbg !42
  %16 = load volatile i32, ptr %5, align 4, !dbg !43
  %17 = load volatile i32, ptr %4, align 4, !dbg !44
  %18 = load volatile i32, ptr %3, align 4, !dbg !45
  %19 = mul nsw i32 %17, %18, !dbg !46
  %20 = add nsw i32 %16, %19, !dbg !47
  store volatile i32 %20, ptr %6, align 4, !dbg !42
  ret void, !dbg !48

never_hit:                                        ; preds = %1
  %21 = call i32 (ptr, ...) @printf(ptr @fmt_str.1), !dbg !40
  unreachable, !dbg !40
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar(i32 noundef %0) #0 !dbg !49 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !52, metadata !DIExpression()), !dbg !53
  call void @llvm.dbg.declare(metadata ptr %3, metadata !54, metadata !DIExpression()), !dbg !55
  %4 = load i32, ptr %2, align 4, !dbg !56
  %sitofp_to_double = sitofp i32 %0 to double, !dbg !57
  %5 = fmul double %sitofp_to_double, 0x4000000000000, !dbg !57
  %6 = call double @sample_bernstein_newtonraphson_2(double %5), !dbg !57
  %7 = fcmp ogt double %6, 0x40141584714A316A, !dbg !57
  br i1 %7, label %never_hit, label %always_hit, !dbg !57

always_hit:                                       ; preds = %1
  %8 = call i32 (ptr, ...) @printf(ptr @fmt_str.2), !dbg !57
  %9 = add nsw i32 %4, 1, !dbg !57
  store i32 %9, ptr %3, align 4, !dbg !55
  %10 = load i32, ptr %3, align 4, !dbg !58
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %10), !dbg !59
  %12 = load i32, ptr %3, align 4, !dbg !60
  ret i32 %12, !dbg !61

never_hit:                                        ; preds = %1
  %13 = call i32 (ptr, ...) @printf(ptr @fmt_str.3), !dbg !57
  unreachable, !dbg !57
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !62 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @foo(i32 noundef 123123), !dbg !65
  ret i32 0, !dbg !66
}

; Function Attrs: alwaysinline
define double @sample_bernstein_newtonraphson_1(double %u) #3 {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %0 = phi double [ 0x4041644F372A5472, %entry ], [ %35, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %36, %loop ]
  %2 = fsub double %0, 0x404161D97127109A
  %3 = fmul double %2, 0x403A04051C884EC2
  %4 = fsub double 1.000000e+00, %3
  %5 = fmul double %4, %4
  %6 = fmul double %5, %4
  %7 = fmul double 0.000000e+00, %6
  %8 = fadd double 0.000000e+00, %7
  %9 = fmul double %4, %4
  %10 = fmul double 0x3FE1987A075C6112, %3
  %11 = fmul double %10, %9
  %12 = fadd double %8, %11
  %13 = fmul double %3, %3
  %14 = fmul double 0x3FE2FB30E199768E, %13
  %15 = fmul double %14, %4
  %16 = fadd double %12, %15
  %17 = fmul double %3, %3
  %18 = fmul double %17, %3
  %19 = fmul double 1.000000e+00, %18
  %20 = fmul double %19, 1.000000e+00
  %21 = fadd double %16, %20
  %22 = fmul double %4, %4
  %23 = fmul double 0x3FE1987A075C6112, %22
  %24 = fadd double 0.000000e+00, %23
  %25 = fmul double 0x3FB62B6DA3D157C0, %3
  %26 = fmul double %25, %4
  %27 = fadd double %24, %26
  %28 = fmul double %3, %3
  %29 = fmul double 0x40034133C799A25C, %28
  %30 = fmul double %29, 1.000000e+00
  %31 = fadd double %27, %30
  %32 = fsub double %21, %u
  %33 = fmul double %31, 0x403A04051C884EC2
  %34 = fdiv double %32, %33
  %35 = fsub double %0, %34
  %36 = add i32 %1, 1
  %37 = icmp eq i32 %36, 16
  br i1 %37, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %35
}

; Function Attrs: alwaysinline
define double @sample_bernstein_newtonraphson_2(double %u) #3 {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %0 = phi double [ 0x4013FE09DD9519CF, %entry ], [ %35, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %36, %loop ]
  %2 = fsub double %0, 0x4013F1F55C02BD70
  %3 = fmul double %2, 0x4045311EA515589B
  %4 = fsub double 1.000000e+00, %3
  %5 = fmul double %4, %4
  %6 = fmul double %5, %4
  %7 = fmul double 0.000000e+00, %6
  %8 = fadd double 0.000000e+00, %7
  %9 = fmul double %4, %4
  %10 = fmul double 0x3FA62B6DA3D157BE, %3
  %11 = fmul double %10, %9
  %12 = fadd double %8, %11
  %13 = fmul double %3, %3
  %14 = fmul double 0x3FC22EDFF23A15CC, %13
  %15 = fmul double %14, %4
  %16 = fadd double %12, %15
  %17 = fmul double %3, %3
  %18 = fmul double %17, %3
  %19 = fmul double 1.000000e+00, %18
  %20 = fmul double %19, 1.000000e+00
  %21 = fadd double %16, %20
  %22 = fmul double %4, %4
  %23 = fmul double 0x3FA62B6DA3D157BE, %22
  %24 = fadd double 0.000000e+00, %23
  %25 = fmul double 0x3FC94809128B7FBA, %3
  %26 = fmul double %25, %4
  %27 = fadd double %24, %26
  %28 = fmul double %3, %3
  %29 = fmul double 0x4006DD1200DC5EA3, %28
  %30 = fmul double %29, 1.000000e+00
  %31 = fadd double %27, %30
  %32 = fsub double %21, %u
  %33 = fmul double %31, 0x4045311EA515589B
  %34 = fdiv double %32, %33
  %35 = fsub double %0, %34
  %36 = add i32 %1, 1
  %37 = icmp eq i32 %36, 16
  br i1 %37, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %35
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { alwaysinline }

!llvm.dbg.cu = !{!12}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20}
!llvm.ident = !{!21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 9, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "45a9bc3947b170af3aadf3a5ee22dde9")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 8)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 20, type: !9, isLocal: true, isDefinition: true)
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
!31 = !DILocalVariable(name: "a", scope: !22, file: !2, line: 10, type: !32)
!32 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !25)
!33 = !DILocation(line: 10, column: 16, scope: !22)
!34 = !DILocalVariable(name: "b", scope: !22, file: !2, line: 11, type: !32)
!35 = !DILocation(line: 11, column: 16, scope: !22)
!36 = !DILocalVariable(name: "c", scope: !22, file: !2, line: 12, type: !32)
!37 = !DILocation(line: 12, column: 16, scope: !22)
!38 = !DILocation(line: 12, column: 20, scope: !22)
!39 = !DILocation(line: 12, column: 24, scope: !22)
!40 = !DILocation(line: 12, column: 22, scope: !22)
!41 = !DILocalVariable(name: "d", scope: !22, file: !2, line: 13, type: !32)
!42 = !DILocation(line: 13, column: 16, scope: !22)
!43 = !DILocation(line: 13, column: 20, scope: !22)
!44 = !DILocation(line: 13, column: 24, scope: !22)
!45 = !DILocation(line: 13, column: 28, scope: !22)
!46 = !DILocation(line: 13, column: 26, scope: !22)
!47 = !DILocation(line: 13, column: 22, scope: !22)
!48 = !DILocation(line: 15, column: 1, scope: !22)
!49 = distinct !DISubprogram(name: "bar", scope: !2, file: !2, line: 17, type: !50, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !26)
!50 = !DISubroutineType(types: !51)
!51 = !{!25, !25}
!52 = !DILocalVariable(name: "x", arg: 1, scope: !49, file: !2, line: 17, type: !25)
!53 = !DILocation(line: 17, column: 23, scope: !49)
!54 = !DILocalVariable(name: "y", scope: !49, file: !2, line: 19, type: !25)
!55 = !DILocation(line: 19, column: 7, scope: !49)
!56 = !DILocation(line: 19, column: 11, scope: !49)
!57 = !DILocation(line: 19, column: 13, scope: !49)
!58 = !DILocation(line: 20, column: 20, scope: !49)
!59 = !DILocation(line: 20, column: 3, scope: !49)
!60 = !DILocation(line: 21, column: 10, scope: !49)
!61 = !DILocation(line: 21, column: 3, scope: !49)
!62 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 24, type: !63, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !12)
!63 = !DISubroutineType(types: !64)
!64 = !{!25}
!65 = !DILocation(line: 26, column: 3, scope: !62)
!66 = !DILocation(line: 27, column: 3, scope: !62)
