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
  %3 = call double @sample_bernstein_inverse(double %2)
  %4 = fcmp olt double %3, 0xC02894B7A03C447F
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

define double @sample_bernstein_inverse(double %u) {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %low = phi double [ 0xC028B57326ACB238, %entry ], [ %next_low, %loop ]
  %high = phi double [ 0xC0289462FBF7E667, %entry ], [ %next_high, %loop ]
  %iter = phi i32 [ 0, %entry ], [ %156, %loop ]
  %0 = fadd double %low, %high
  %mid = fmul double %0, 5.000000e-01
  %1 = fsub double %mid, 0xC028B57326ACB238
  %2 = fmul double 0x402EF895B2542CC8, %1
  %3 = fsub double 1.000000e+00, %2
  %4 = fmul double 1.000000e+00, %3
  %5 = fmul double %4, %3
  %6 = fmul double %5, %3
  %7 = fmul double %6, %3
  %8 = fmul double %7, %3
  %9 = fmul double %8, %3
  %10 = fmul double %9, %3
  %11 = fmul double %10, %3
  %12 = fmul double %11, %3
  %13 = fmul double %12, %3
  %14 = fmul double %13, %3
  %15 = fmul double %14, %3
  %16 = fmul double %15, %3
  %17 = fmul double %16, %3
  %18 = fmul double %17, %3
  %19 = fmul double %18, %3
  %20 = fmul double %19, %3
  %21 = fmul double %20, %3
  %22 = fmul double %21, %3
  %23 = fmul double %22, %3
  %24 = fmul double %23, %3
  %25 = fmul double %24, %3
  %26 = fmul double %25, %3
  %27 = fmul double %26, %3
  %28 = fmul double %27, %3
  %29 = fmul double 0.000000e+00, %28
  %30 = fadd double 0.000000e+00, %29
  %31 = fmul double 1.000000e+00, %2
  %32 = fdiv double %28, %3
  %33 = fmul double 0x3FE9B047D75957CC, %31
  %34 = fmul double %33, %32
  %35 = fadd double %30, %34
  %36 = fmul double %31, %2
  %37 = fdiv double %32, %3
  %38 = fmul double 0x402BA045EB3E8A1B, %36
  %39 = fmul double %38, %37
  %40 = fadd double %35, %39
  %41 = fmul double %36, %2
  %42 = fdiv double %37, %3
  %43 = fmul double 0x405C3CDBF340EB40, %41
  %44 = fmul double %43, %42
  %45 = fadd double %40, %44
  %46 = fmul double %41, %2
  %47 = fdiv double %42, %3
  %48 = fmul double 0x408FD3A809CBBE1A, %46
  %49 = fmul double %48, %47
  %50 = fadd double %45, %49
  %51 = fmul double %46, %2
  %52 = fdiv double %47, %3
  %53 = fmul double 0x40B7E62C6DD20828, %51
  %54 = fmul double %53, %52
  %55 = fadd double %50, %54
  %56 = fmul double %51, %2
  %57 = fdiv double %52, %3
  %58 = fmul double 0x40D8896E022F4E0C, %56
  %59 = fmul double %58, %57
  %60 = fadd double %55, %59
  %61 = fmul double %56, %2
  %62 = fdiv double %57, %3
  %63 = fmul double 0x40F45E051E21208F, %61
  %64 = fmul double %63, %62
  %65 = fadd double %60, %64
  %66 = fmul double %61, %2
  %67 = fdiv double %62, %3
  %68 = fmul double 0x410A772599CD11A1, %66
  %69 = fmul double %68, %67
  %70 = fadd double %65, %69
  %71 = fmul double %66, %2
  %72 = fdiv double %67, %3
  %73 = fmul double 0x411AC06651FC7814, %71
  %74 = fmul double %73, %72
  %75 = fadd double %70, %74
  %76 = fmul double %71, %2
  %77 = fdiv double %72, %3
  %78 = fmul double 0x41286735D7AE1662, %76
  %79 = fmul double %78, %77
  %80 = fadd double %75, %79
  %81 = fmul double %76, %2
  %82 = fdiv double %77, %3
  %83 = fmul double 0x4130FCA832A22E67, %81
  %84 = fmul double %83, %82
  %85 = fadd double %80, %84
  %86 = fmul double %81, %2
  %87 = fdiv double %82, %3
  %88 = fmul double 0x413689E5E4659CCF, %86
  %89 = fmul double %88, %87
  %90 = fadd double %85, %89
  %91 = fmul double %86, %2
  %92 = fdiv double %87, %3
  %93 = fmul double 0x41379ADC03F9DD31, %91
  %94 = fmul double %93, %92
  %95 = fadd double %90, %94
  %96 = fmul double %91, %2
  %97 = fdiv double %92, %3
  %98 = fmul double 0x41368FF0C90C173F, %96
  %99 = fmul double %98, %97
  %100 = fadd double %95, %99
  %101 = fmul double %96, %2
  %102 = fdiv double %97, %3
  %103 = fmul double 0x413224B310A2D13B, %101
  %104 = fmul double %103, %102
  %105 = fadd double %100, %104
  %106 = fmul double %101, %2
  %107 = fdiv double %102, %3
  %108 = fmul double 0x41288565B23B4F7B, %106
  %109 = fmul double %108, %107
  %110 = fadd double %105, %109
  %111 = fmul double %106, %2
  %112 = fdiv double %107, %3
  %113 = fmul double 0x411C4F8723DA5398, %111
  %114 = fmul double %113, %112
  %115 = fadd double %110, %114
  %116 = fmul double %111, %2
  %117 = fdiv double %112, %3
  %118 = fmul double 0x410B691E8F49C55F, %116
  %119 = fmul double %118, %117
  %120 = fadd double %115, %119
  %121 = fmul double %116, %2
  %122 = fdiv double %117, %3
  %123 = fmul double 0x40F542682B8EC233, %121
  %124 = fmul double %123, %122
  %125 = fadd double %120, %124
  %126 = fmul double %121, %2
  %127 = fdiv double %122, %3
  %128 = fmul double 0x40DB37392EFEB82F, %126
  %129 = fmul double %128, %127
  %130 = fadd double %125, %129
  %131 = fmul double %126, %2
  %132 = fdiv double %127, %3
  %133 = fmul double 0x40BB049942741601, %131
  %134 = fmul double %133, %132
  %135 = fadd double %130, %134
  %136 = fmul double %131, %2
  %137 = fdiv double %132, %3
  %138 = fmul double 0x4093EE1F9E94EAEE, %136
  %139 = fmul double %138, %137
  %140 = fadd double %135, %139
  %141 = fmul double %136, %2
  %142 = fdiv double %137, %3
  %143 = fmul double 0x40656625A3D7D41B, %141
  %144 = fmul double %143, %142
  %145 = fadd double %140, %144
  %146 = fmul double %141, %2
  %147 = fdiv double %142, %3
  %148 = fmul double 0x402CAB3C19F4EF63, %146
  %149 = fmul double %148, %147
  %150 = fadd double %145, %149
  %151 = fmul double %146, %2
  %152 = fdiv double %147, %3
  %153 = fmul double 1.000000e+00, %151
  %154 = fmul double %153, %152
  %155 = fadd double %150, %154
  %is_too_low = fcmp olt double %155, %u
  %next_low = select i1 %is_too_low, double %mid, double %low
  %next_high = select i1 %is_too_low, double %high, double %mid
  %156 = add i32 %iter, 1
  %157 = icmp eq i32 %156, 64
  br i1 %157, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %next_low
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
