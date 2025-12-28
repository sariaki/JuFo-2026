; ModuleID = 'example_obf.bc'
source_filename = "example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"foo %lu\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [8 x i8] c"bar %i\0A\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [4 x i8] c"POP\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @bar, ptr @.str.2, ptr @.str.3, i32 33, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.2, ptr @.str.3, i32 22, ptr null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @rand_uint64() #0 !dbg !28 {
  %1 = alloca i64, align 8
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !31, metadata !DIExpression()), !dbg !32
  store i64 0, ptr %1, align 8, !dbg !32
  call void @llvm.dbg.declare(metadata ptr %2, metadata !33, metadata !DIExpression()), !dbg !36
  store i32 0, ptr %2, align 4, !dbg !36
  br label %3, !dbg !37

3:                                                ; preds = %12, %0
  %4 = load i32, ptr %2, align 4, !dbg !38
  %5 = icmp slt i32 %4, 64, !dbg !40
  br i1 %5, label %6, label %15, !dbg !41

6:                                                ; preds = %3
  %7 = load i64, ptr %1, align 8, !dbg !42
  %8 = mul i64 %7, 2147483648, !dbg !44
  %9 = call i32 @rand() #5, !dbg !45
  %10 = sext i32 %9 to i64, !dbg !45
  %11 = add i64 %8, %10, !dbg !46
  store i64 %11, ptr %1, align 8, !dbg !47
  br label %12, !dbg !48

12:                                               ; preds = %6
  %13 = load i32, ptr %2, align 4, !dbg !49
  %14 = add nsw i32 %13, 15, !dbg !49
  store i32 %14, ptr %2, align 4, !dbg !49
  br label %3, !dbg !50, !llvm.loop !51

15:                                               ; preds = %3
  %16 = load i64, ptr %1, align 8, !dbg !54
  ret i64 %16, !dbg !55
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i32 @rand() #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @wrapper() #0 !dbg !56 {
  %1 = call i64 @rand_uint64(), !dbg !57
  ret i64 %1, !dbg !58
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i64 noundef %0) #0 !dbg !59 {
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i64 %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !62, metadata !DIExpression()), !dbg !63
  %7 = load i64, ptr %2, align 8, !dbg !64
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %7), !dbg !65
  call void @llvm.dbg.declare(metadata ptr %3, metadata !66, metadata !DIExpression()), !dbg !68
  store volatile i32 1, ptr %3, align 4, !dbg !68
  call void @llvm.dbg.declare(metadata ptr %4, metadata !69, metadata !DIExpression()), !dbg !70
  store volatile i32 2, ptr %4, align 4, !dbg !70
  call void @llvm.dbg.declare(metadata ptr %5, metadata !71, metadata !DIExpression()), !dbg !72
  %9 = load volatile i32, ptr %3, align 4, !dbg !73
  %sitofp_to_double = sitofp i64 %0 to double, !dbg !74
  %10 = fmul double %sitofp_to_double, 0x4000000000000, !dbg !74
  %11 = call double @sample_bernstein_newtonraphson_foo1(double %10), !dbg !74
  %12 = fcmp olt double %11, 0xC0450D2AAD7500B7, !dbg !74
  br i1 %12, label %always_hit, label %never_hit, !dbg !74

always_hit:                                       ; preds = %1
  %13 = load volatile i32, ptr %4, align 4, !dbg !74
  %14 = srem i32 %9, %13, !dbg !75
  store volatile i32 %14, ptr %5, align 4, !dbg !72
  call void @llvm.dbg.declare(metadata ptr %6, metadata !76, metadata !DIExpression()), !dbg !77
  %15 = load volatile i32, ptr %5, align 4, !dbg !78
  %16 = load volatile i32, ptr %4, align 4, !dbg !79
  %17 = load volatile i32, ptr %3, align 4, !dbg !80
  %18 = mul nsw i32 %16, %17, !dbg !81
  %19 = add nsw i32 %15, %18, !dbg !82
  store volatile i32 %19, ptr %6, align 4, !dbg !77
  ret void, !dbg !83

never_hit:                                        ; preds = %1
  ret void, !dbg !74
}

declare i32 @printf(ptr noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar(i32 noundef %0) #0 !dbg !84 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !87, metadata !DIExpression()), !dbg !88
  call void @llvm.dbg.declare(metadata ptr %3, metadata !89, metadata !DIExpression()), !dbg !90
  %4 = load i32, ptr %2, align 4, !dbg !91
  %5 = add nsw i32 %4, 1, !dbg !92
  store i32 %5, ptr %3, align 4, !dbg !90
  %6 = load i32, ptr %3, align 4, !dbg !93
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %6), !dbg !94
  %8 = load i32, ptr %3, align 4, !dbg !95
  ret i32 %8, !dbg !96
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !97 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i64 @wrapper(), !dbg !100
  call void @foo(i64 noundef %2), !dbg !101
  ret i32 0, !dbg !102
}

; Function Attrs: alwaysinline
define private double @sample_bernstein_newtonraphson_foo1(double %u) #4 {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %0 = phi double [ 0xC045103DF6EBFCE2, %entry ], [ %195, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %196, %loop ]
  %2 = fsub double %0, 0xC0451355A41D403E
  %3 = fmul double %2, 0x4034B2008F156A15
  %4 = fsub double 1.000000e+00, %3
  %5 = fmul double %4, %4
  %6 = fmul double %5, %4
  %7 = fmul double %6, %4
  %8 = fmul double %7, %4
  %9 = fmul double %8, %4
  %10 = fmul double %9, %4
  %11 = fmul double %10, %4
  %12 = fmul double %11, %4
  %13 = fmul double 0.000000e+00, %12
  %14 = fadd double 0.000000e+00, %13
  %15 = fmul double %4, %4
  %16 = fmul double %15, %4
  %17 = fmul double %16, %4
  %18 = fmul double %17, %4
  %19 = fmul double %18, %4
  %20 = fmul double %19, %4
  %21 = fmul double %20, %4
  %22 = fmul double 0x3FDFD74301C21CCE, %3
  %23 = fmul double %22, %21
  %24 = fadd double %14, %23
  %25 = fmul double %3, %3
  %26 = fmul double %4, %4
  %27 = fmul double %26, %4
  %28 = fmul double %27, %4
  %29 = fmul double %28, %4
  %30 = fmul double %29, %4
  %31 = fmul double %30, %4
  %32 = fmul double 0x4017077E3F718FC4, %25
  %33 = fmul double %32, %31
  %34 = fadd double %24, %33
  %35 = fmul double %3, %3
  %36 = fmul double %35, %3
  %37 = fmul double %4, %4
  %38 = fmul double %37, %4
  %39 = fmul double %38, %4
  %40 = fmul double %39, %4
  %41 = fmul double %40, %4
  %42 = fmul double 0x40356B9E90E1E894, %36
  %43 = fmul double %42, %41
  %44 = fadd double %34, %43
  %45 = fmul double %3, %3
  %46 = fmul double %45, %3
  %47 = fmul double %46, %3
  %48 = fmul double %4, %4
  %49 = fmul double %48, %4
  %50 = fmul double %49, %4
  %51 = fmul double %50, %4
  %52 = fmul double 0x40435F7D16B8309E, %47
  %53 = fmul double %52, %51
  %54 = fadd double %44, %53
  %55 = fmul double %3, %3
  %56 = fmul double %55, %3
  %57 = fmul double %56, %3
  %58 = fmul double %57, %3
  %59 = fmul double %4, %4
  %60 = fmul double %59, %4
  %61 = fmul double %60, %4
  %62 = fmul double 0x4047A05408132907, %58
  %63 = fmul double %62, %61
  %64 = fadd double %54, %63
  %65 = fmul double %3, %3
  %66 = fmul double %65, %3
  %67 = fmul double %66, %3
  %68 = fmul double %67, %3
  %69 = fmul double %68, %3
  %70 = fmul double %4, %4
  %71 = fmul double %70, %4
  %72 = fmul double 0x40441E5C59470E89, %69
  %73 = fmul double %72, %71
  %74 = fadd double %64, %73
  %75 = fmul double %3, %3
  %76 = fmul double %75, %3
  %77 = fmul double %76, %3
  %78 = fmul double %77, %3
  %79 = fmul double %78, %3
  %80 = fmul double %79, %3
  %81 = fmul double %4, %4
  %82 = fmul double 0x403252D18A678A2E, %80
  %83 = fmul double %82, %81
  %84 = fadd double %74, %83
  %85 = fmul double %3, %3
  %86 = fmul double %85, %3
  %87 = fmul double %86, %3
  %88 = fmul double %87, %3
  %89 = fmul double %88, %3
  %90 = fmul double %89, %3
  %91 = fmul double %90, %3
  %92 = fmul double 0x4015720F40702BD6, %91
  %93 = fmul double %92, %4
  %94 = fadd double %84, %93
  %95 = fmul double %3, %3
  %96 = fmul double %95, %3
  %97 = fmul double %96, %3
  %98 = fmul double %97, %3
  %99 = fmul double %98, %3
  %100 = fmul double %99, %3
  %101 = fmul double %100, %3
  %102 = fmul double %101, %3
  %103 = fmul double 1.000000e+00, %102
  %104 = fmul double %103, 1.000000e+00
  %105 = fadd double %94, %104
  %106 = fmul double %4, %4
  %107 = fmul double %106, %4
  %108 = fmul double %107, %4
  %109 = fmul double %108, %4
  %110 = fmul double %109, %4
  %111 = fmul double %110, %4
  %112 = fmul double %111, %4
  %113 = fmul double 0x3FDFD74301C21CCE, %112
  %114 = fadd double 0.000000e+00, %113
  %115 = fmul double %4, %4
  %116 = fmul double %115, %4
  %117 = fmul double %116, %4
  %118 = fmul double %117, %4
  %119 = fmul double %118, %4
  %120 = fmul double %119, %4
  %121 = fmul double 0x401E235AFE021122, %3
  %122 = fmul double %121, %120
  %123 = fadd double %114, %122
  %124 = fmul double %3, %3
  %125 = fmul double %4, %4
  %126 = fmul double %125, %4
  %127 = fmul double %126, %4
  %128 = fmul double %127, %4
  %129 = fmul double %128, %4
  %130 = fmul double 0x4037F5BEC39EFE23, %124
  %131 = fmul double %130, %129
  %132 = fadd double %123, %131
  %133 = fmul double %3, %3
  %134 = fmul double %133, %3
  %135 = fmul double %4, %4
  %136 = fmul double %135, %4
  %137 = fmul double %136, %4
  %138 = fmul double %137, %4
  %139 = fmul double 0x403A76315076117A, %134
  %140 = fmul double %139, %138
  %141 = fadd double %132, %140
  %142 = fmul double %3, %3
  %143 = fmul double %142, %3
  %144 = fmul double %143, %3
  %145 = fmul double %4, %4
  %146 = fmul double %145, %4
  %147 = fmul double %146, %4
  %148 = fmul double 0x40454432B6C6DA0D, %144
  %149 = fmul double %148, %147
  %150 = fadd double %141, %149
  %151 = fmul double %3, %3
  %152 = fmul double %151, %3
  %153 = fmul double %152, %3
  %154 = fmul double %153, %3
  %155 = fmul double %4, %4
  %156 = fmul double %155, %4
  %157 = fmul double 0x404A34D9F75DB31C, %154
  %158 = fmul double %157, %156
  %159 = fadd double %150, %158
  %160 = fmul double %3, %3
  %161 = fmul double %160, %3
  %162 = fmul double %161, %3
  %163 = fmul double %162, %3
  %164 = fmul double %163, %3
  %165 = fmul double %4, %4
  %166 = fmul double 0x401E3642C4A9C019, %164
  %167 = fmul double %166, %165
  %168 = fadd double %159, %167
  %169 = fmul double %3, %3
  %170 = fmul double %169, %3
  %171 = fmul double %170, %3
  %172 = fmul double %171, %3
  %173 = fmul double %172, %3
  %174 = fmul double %173, %3
  %175 = fmul double 0x4018F9EDB0450D42, %174
  %176 = fmul double %175, %4
  %177 = fadd double %168, %176
  %178 = fmul double %3, %3
  %179 = fmul double %178, %3
  %180 = fmul double %179, %3
  %181 = fmul double %180, %3
  %182 = fmul double %181, %3
  %183 = fmul double %182, %3
  %184 = fmul double %183, %3
  %185 = fmul double 0x400D1BE17F1FA854, %184
  %186 = fmul double %185, 1.000000e+00
  %187 = fadd double %177, %186
  %188 = fsub double %105, %u
  %189 = fmul double %187, 0x4034B2008F156A15
  %190 = fdiv double %188, %189
  %191 = fsub double %0, %190
  %192 = fcmp ogt double %191, 0xC0450D2649BAB986
  %193 = select i1 %192, double 0xC0450D2649BAB986, double %191
  %194 = fcmp olt double %193, 0xC0451355A41D403E
  %195 = select i1 %194, double 0xC0451355A41D403E, double %193
  %196 = add i32 %1, 1
  %197 = icmp eq i32 %196, 12
  br i1 %197, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %191
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { alwaysinline }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!12}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25, !26}
!llvm.ident = !{!27}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 24, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "3ea44ddee13b2ab84b687f7fca1ff579")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 72, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 9)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 36, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 64, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 8)
!12 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !13, globals: !19, splitDebugInlining: false, nameTableKind: None)
!13 = !{!14}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !15, line: 27, baseType: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "256fcabbefa27ca8cf5e6d37525e6e16")
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !17, line: 45, baseType: !18)
!17 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "e1865d9fe29fe1b5ced550b7ba458f9e")
!18 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!19 = !{!0, !7}
!20 = !{i32 7, !"Dwarf Version", i32 5}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !{i32 8, !"PIC Level", i32 2}
!24 = !{i32 7, !"PIE Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 2}
!26 = !{i32 7, !"frame-pointer", i32 2}
!27 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!28 = distinct !DISubprogram(name: "rand_uint64", scope: !2, file: !2, line: 10, type: !29, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !30)
!29 = !DISubroutineType(types: !13)
!30 = !{}
!31 = !DILocalVariable(name: "r", scope: !28, file: !2, line: 11, type: !14)
!32 = !DILocation(line: 11, column: 12, scope: !28)
!33 = !DILocalVariable(name: "i", scope: !34, file: !2, line: 12, type: !35)
!34 = distinct !DILexicalBlock(scope: !28, file: !2, line: 12, column: 3)
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !DILocation(line: 12, column: 12, scope: !34)
!37 = !DILocation(line: 12, column: 8, scope: !34)
!38 = !DILocation(line: 12, column: 17, scope: !39)
!39 = distinct !DILexicalBlock(scope: !34, file: !2, line: 12, column: 3)
!40 = !DILocation(line: 12, column: 18, scope: !39)
!41 = !DILocation(line: 12, column: 3, scope: !34)
!42 = !DILocation(line: 13, column: 9, scope: !43)
!43 = distinct !DILexicalBlock(scope: !39, file: !2, line: 12, column: 39)
!44 = !DILocation(line: 13, column: 10, scope: !43)
!45 = !DILocation(line: 13, column: 38, scope: !43)
!46 = !DILocation(line: 13, column: 36, scope: !43)
!47 = !DILocation(line: 13, column: 7, scope: !43)
!48 = !DILocation(line: 14, column: 3, scope: !43)
!49 = !DILocation(line: 12, column: 25, scope: !39)
!50 = !DILocation(line: 12, column: 3, scope: !39)
!51 = distinct !{!51, !41, !52, !53}
!52 = !DILocation(line: 14, column: 3, scope: !34)
!53 = !{!"llvm.loop.mustprogress"}
!54 = !DILocation(line: 15, column: 10, scope: !28)
!55 = !DILocation(line: 15, column: 3, scope: !28)
!56 = distinct !DISubprogram(name: "wrapper", scope: !2, file: !2, line: 18, type: !29, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12)
!57 = !DILocation(line: 19, column: 10, scope: !56)
!58 = !DILocation(line: 19, column: 3, scope: !56)
!59 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 22, type: !60, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !30)
!60 = !DISubroutineType(types: !61)
!61 = !{null, !14}
!62 = !DILocalVariable(name: "x", arg: 1, scope: !59, file: !2, line: 22, type: !14)
!63 = !DILocation(line: 22, column: 29, scope: !59)
!64 = !DILocation(line: 24, column: 23, scope: !59)
!65 = !DILocation(line: 24, column: 3, scope: !59)
!66 = !DILocalVariable(name: "a", scope: !59, file: !2, line: 26, type: !67)
!67 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !35)
!68 = !DILocation(line: 26, column: 16, scope: !59)
!69 = !DILocalVariable(name: "b", scope: !59, file: !2, line: 27, type: !67)
!70 = !DILocation(line: 27, column: 16, scope: !59)
!71 = !DILocalVariable(name: "c", scope: !59, file: !2, line: 28, type: !67)
!72 = !DILocation(line: 28, column: 16, scope: !59)
!73 = !DILocation(line: 28, column: 20, scope: !59)
!74 = !DILocation(line: 28, column: 24, scope: !59)
!75 = !DILocation(line: 28, column: 22, scope: !59)
!76 = !DILocalVariable(name: "d", scope: !59, file: !2, line: 29, type: !67)
!77 = !DILocation(line: 29, column: 16, scope: !59)
!78 = !DILocation(line: 29, column: 20, scope: !59)
!79 = !DILocation(line: 29, column: 24, scope: !59)
!80 = !DILocation(line: 29, column: 28, scope: !59)
!81 = !DILocation(line: 29, column: 26, scope: !59)
!82 = !DILocation(line: 29, column: 22, scope: !59)
!83 = !DILocation(line: 31, column: 1, scope: !59)
!84 = distinct !DISubprogram(name: "bar", scope: !2, file: !2, line: 33, type: !85, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !30)
!85 = !DISubroutineType(types: !86)
!86 = !{!35, !35}
!87 = !DILocalVariable(name: "x", arg: 1, scope: !84, file: !2, line: 33, type: !35)
!88 = !DILocation(line: 33, column: 23, scope: !84)
!89 = !DILocalVariable(name: "y", scope: !84, file: !2, line: 35, type: !35)
!90 = !DILocation(line: 35, column: 7, scope: !84)
!91 = !DILocation(line: 35, column: 11, scope: !84)
!92 = !DILocation(line: 35, column: 13, scope: !84)
!93 = !DILocation(line: 36, column: 22, scope: !84)
!94 = !DILocation(line: 36, column: 3, scope: !84)
!95 = !DILocation(line: 37, column: 10, scope: !84)
!96 = !DILocation(line: 37, column: 3, scope: !84)
!97 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 40, type: !98, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !12)
!98 = !DISubroutineType(types: !99)
!99 = !{!35}
!100 = !DILocation(line: 42, column: 7, scope: !97)
!101 = !DILocation(line: 42, column: 3, scope: !97)
!102 = !DILocation(line: 43, column: 3, scope: !97)
