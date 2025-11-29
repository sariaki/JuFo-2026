; ModuleID = 'example_obf.bc'
source_filename = "example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"foo %i\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [28 x i8] c"insert_stochastic_predicate\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [10 x i8] c"example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [1 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.1, ptr @.str.2, i32 6, ptr null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32 noundef %0) #0 !dbg !17 {
  %sitofp_to_double = sitofp i32 %0 to double
  %2 = fmul double %sitofp_to_double, 0x4000000000000
  %3 = call double @sample_bernstein(double %2)
  %4 = fcmp olt double %3, 0x3FEFAE147AE147AE
  br i1 %4, label %always_hit, label %never_hit

always_hit:                                       ; preds = %1
  %5 = alloca i32, align 4
  store i32 %0, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !22, metadata !DIExpression()), !dbg !23
  %6 = load i32, ptr %5, align 4, !dbg !24
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %6), !dbg !25
  ret void, !dbg !26

never_hit:                                        ; preds = %1
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !27 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @foo(i32 noundef 123123), !dbg !30
  ret i32 0, !dbg !31
}

define double @sample_bernstein(double %u) {
entry:
  %oneMinusU = fsub double 1.000000e+00, %u
  %powOneMinusU_mul = fmul double 1.000000e+00, %oneMinusU
  %powOneMinusU_mul1 = fmul double %powOneMinusU_mul, %oneMinusU
  %powOneMinusU_mul2 = fmul double %powOneMinusU_mul1, %oneMinusU
  %powOneMinusU_mul3 = fmul double %powOneMinusU_mul2, %oneMinusU
  %t_mul_powOneMinusU = fmul double 0.000000e+00, %powOneMinusU_mul3
  %accum = fadd double 0.000000e+00, %t_mul_powOneMinusU
  %powU_next = fmul double 1.000000e+00, %u
  %powOneMinusU_div = fdiv double %powOneMinusU_mul3, %oneMinusU
  %t_mul_c_powU = fmul double 0x3FE6E4BDB6FC02D6, %powU_next
  %t_mul_powOneMinusU4 = fmul double %t_mul_c_powU, %powOneMinusU_div
  %accum5 = fadd double %accum, %t_mul_powOneMinusU4
  %powU_next6 = fmul double %powU_next, %u
  %powOneMinusU_div7 = fdiv double %powOneMinusU_div, %oneMinusU
  %t_mul_c_powU8 = fmul double 0x3FFD0AC3394828D4, %powU_next6
  %t_mul_powOneMinusU9 = fmul double %t_mul_c_powU8, %powOneMinusU_div7
  %accum10 = fadd double %accum5, %t_mul_powOneMinusU9
  %powU_next11 = fmul double %powU_next6, %u
  %powOneMinusU_div12 = fdiv double %powOneMinusU_div7, %oneMinusU
  %t_mul_c_powU13 = fmul double 4.000000e+00, %powU_next11
  %t_mul_powOneMinusU14 = fmul double %t_mul_c_powU13, %powOneMinusU_div12
  %accum15 = fadd double %accum10, %t_mul_powOneMinusU14
  %powU_next16 = fmul double %powU_next11, %u
  %powOneMinusU_div17 = fdiv double %powOneMinusU_div12, %oneMinusU
  %t_mul_c_powU18 = fmul double 0x57B3F9AEA980, %powU_next16
  %t_mul_powOneMinusU19 = fmul double %t_mul_c_powU18, %powOneMinusU_div17
  %accum20 = fadd double %accum15, %t_mul_powOneMinusU19
  ret double %accum20
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
!7 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !8, splitDebugInlining: false, nameTableKind: None)
!8 = !{!0}
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 8, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 2}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!17 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 6, type: !18, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !21)
!18 = !DISubroutineType(types: !19)
!19 = !{null, !20}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{}
!22 = !DILocalVariable(name: "x", arg: 1, scope: !17, file: !2, line: 6, type: !20)
!23 = !DILocation(line: 6, column: 14, scope: !17)
!24 = !DILocation(line: 8, column: 22, scope: !17)
!25 = !DILocation(line: 8, column: 3, scope: !17)
!26 = !DILocation(line: 10, column: 1, scope: !17)
!27 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 12, type: !28, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !7)
!28 = !DISubroutineType(types: !29)
!29 = !{!20}
!30 = !DILocation(line: 14, column: 3, scope: !27)
!31 = !DILocation(line: 15, column: 3, scope: !27)
