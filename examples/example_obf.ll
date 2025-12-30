; ModuleID = 'example_obf.bc'
source_filename = "example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"foo %lu\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [8 x i8] c"bar %i\0A\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [4 x i8] c"POP\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"example.c\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { ptr, ptr, ptr, i32, ptr }] [{ ptr, ptr, ptr, i32, ptr } { ptr @bar.old, ptr @.str.2, ptr @.str.3, i32 33, ptr null }, { ptr, ptr, ptr, i32, ptr } { ptr @foo, ptr @.str.2, ptr @.str.3, i32 22, ptr null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @rand_uint64.old() #0 {
zombie:
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i32 @rand() #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @wrapper() #0 !dbg !28 {
  %1 = call i64 @rand_uint64(i64 0), !dbg !30
  ret i64 %1, !dbg !31
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i64 noundef %0) #0 !dbg !32 {
  %2 = alloca i64, align 8
  store i64 %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !36, metadata !DIExpression()), !dbg !37
  %sitofp_to_double = sitofp i64 %0 to double, !dbg !38
  %3 = fmul double %sitofp_to_double, 0x4000000000000, !dbg !38
  %4 = call double @sample_bernstein_newtonraphson_foo2(double %3), !dbg !38
  %5 = fcmp olt double %4, 0xC0246C6CE8E7A1F4, !dbg !38
  br i1 %5, label %always_hit, label %never_hit, !dbg !38

always_hit:                                       ; preds = %1
  %6 = load i64, ptr %2, align 8, !dbg !38
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %6), !dbg !39
  ret void, !dbg !40

never_hit:                                        ; preds = %1
  ret void, !dbg !38
}

declare i32 @printf(ptr noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @bar.old(i32 noundef %0) #0 {
zombie:
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !41 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %2 = call i64 @wrapper(), !dbg !45
  call void @foo(i64 noundef %2), !dbg !46
  ret i32 0, !dbg !47
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @rand_uint64(i64 %pop_external_param) #0 {
  %1 = alloca i64, align 8
  %2 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %1, metadata !48, metadata !DIExpression()), !dbg !50
  store i64 0, ptr %1, align 8, !dbg !50
  call void @llvm.dbg.declare(metadata ptr %2, metadata !51, metadata !DIExpression()), !dbg !53
  store i32 0, ptr %2, align 4, !dbg !53
  br label %3, !dbg !54

3:                                                ; preds = %15, %0
  %4 = load i32, ptr %2, align 4, !dbg !55
  %5 = icmp slt i32 %4, 64, !dbg !57
  br i1 %5, label %6, label %18, !dbg !58

6:                                                ; preds = %6, %3
  %7 = load i64, ptr %1, align 8, !dbg !59
  %8 = mul i64 %7, 2147483648, !dbg !61
  %sitofp_to_double = sitofp i64 %pop_external_param to double, !dbg !62
  %9 = fmul double %sitofp_to_double, 0x4000000000000, !dbg !62
  %10 = call double @sample_bernstein_newtonraphson_rand_uint641(double %9), !dbg !62
  %11 = fcmp olt double %10, 0xC042AC0A9905CDF6, !dbg !62
  br i1 %11, label %always_hit, label %6, !dbg !62

always_hit:                                       ; preds = %6
  %12 = call i32 @rand() #5, !dbg !62
  %13 = sext i32 %12 to i64, !dbg !62
  %14 = add i64 %8, %13, !dbg !63
  store i64 %14, ptr %1, align 8, !dbg !64
  br label %15, !dbg !65

15:                                               ; preds = %always_hit
  %16 = load i32, ptr %2, align 4, !dbg !66
  %17 = add nsw i32 %16, 15, !dbg !66
  store i32 %17, ptr %2, align 4, !dbg !66
  br label %3, !dbg !67, !llvm.loop !68

18:                                               ; preds = %3
  %19 = load i64, ptr %1, align 8, !dbg !71
  ret i64 %19, !dbg !72
}

; Function Attrs: alwaysinline
define private double @sample_bernstein_newtonraphson_rand_uint641(double %u) #4 {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %0 = phi double [ 0xC042AF13F43D1004, %entry ], [ %127, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %128, %loop ]
  %2 = fsub double %0, 0xC042B221B699B9E8
  %3 = fmul double %2, 0x4034F53647135CB5
  %4 = fsub double 1.000000e+00, %3
  %5 = fmul double %4, %4
  %6 = fmul double %5, %4
  %7 = fmul double %6, %4
  %8 = fmul double %7, %4
  %9 = fmul double %8, %4
  %10 = fmul double %9, %4
  %11 = fmul double 0.000000e+00, %10
  %12 = fadd double 0.000000e+00, %11
  %13 = fmul double %4, %4
  %14 = fmul double %13, %4
  %15 = fmul double %14, %4
  %16 = fmul double %15, %4
  %17 = fmul double %16, %4
  %18 = fmul double 0x3FE04E9911DDBA81, %3
  %19 = fmul double %18, %17
  %20 = fadd double %12, %19
  %21 = fmul double %3, %3
  %22 = fmul double %4, %4
  %23 = fmul double %22, %4
  %24 = fmul double %23, %4
  %25 = fmul double %24, %4
  %26 = fmul double 0x4005C529508C929D, %21
  %27 = fmul double %26, %25
  %28 = fadd double %20, %27
  %29 = fmul double %3, %3
  %30 = fmul double %29, %3
  %31 = fmul double %4, %4
  %32 = fmul double %31, %4
  %33 = fmul double %32, %4
  %34 = fmul double 0x401C333C33422761, %30
  %35 = fmul double %34, %33
  %36 = fadd double %28, %35
  %37 = fmul double %3, %3
  %38 = fmul double %37, %3
  %39 = fmul double %38, %3
  %40 = fmul double %4, %4
  %41 = fmul double %40, %4
  %42 = fmul double 0x4027C2E84C4C1A20, %39
  %43 = fmul double %42, %41
  %44 = fadd double %36, %43
  %45 = fmul double %3, %3
  %46 = fmul double %45, %3
  %47 = fmul double %46, %3
  %48 = fmul double %47, %3
  %49 = fmul double %4, %4
  %50 = fmul double 0x40218E551111400F, %48
  %51 = fmul double %50, %49
  %52 = fadd double %44, %51
  %53 = fmul double %3, %3
  %54 = fmul double %53, %3
  %55 = fmul double %54, %3
  %56 = fmul double %55, %3
  %57 = fmul double %56, %3
  %58 = fmul double 0x400B62507CF91054, %57
  %59 = fmul double %58, %4
  %60 = fadd double %52, %59
  %61 = fmul double %3, %3
  %62 = fmul double %61, %3
  %63 = fmul double %62, %3
  %64 = fmul double %63, %3
  %65 = fmul double %64, %3
  %66 = fmul double %65, %3
  %67 = fmul double 1.000000e+00, %66
  %68 = fmul double %67, 1.000000e+00
  %69 = fadd double %60, %68
  %70 = fmul double %4, %4
  %71 = fmul double %70, %4
  %72 = fmul double %71, %4
  %73 = fmul double %72, %4
  %74 = fmul double %73, %4
  %75 = fmul double 0x3FE04E9911DDBA81, %74
  %76 = fadd double 0.000000e+00, %75
  %77 = fmul double %4, %4
  %78 = fmul double %77, %4
  %79 = fmul double %78, %4
  %80 = fmul double %79, %4
  %81 = fmul double 0x4003146D064C8D7A, %3
  %82 = fmul double %81, %80
  %83 = fadd double %76, %82
  %84 = fmul double %3, %3
  %85 = fmul double %4, %4
  %86 = fmul double %85, %4
  %87 = fmul double %86, %4
  %88 = fmul double 0x401E2CCD5067079A, %84
  %89 = fmul double %88, %87
  %90 = fadd double %83, %89
  %91 = fmul double %3, %3
  %92 = fmul double %91, %3
  %93 = fmul double %4, %4
  %94 = fmul double %93, %4
  %95 = fmul double 0x4033529465560CDF, %92
  %96 = fmul double %95, %94
  %97 = fadd double %90, %96
  %98 = fmul double %3, %3
  %99 = fmul double %98, %3
  %100 = fmul double %99, %3
  %101 = fmul double %4, %4
  %102 = fmul double 0x40207EF07071F1EE, %100
  %103 = fmul double %102, %101
  %104 = fadd double %97, %103
  %105 = fmul double %3, %3
  %106 = fmul double %105, %3
  %107 = fmul double %106, %3
  %108 = fmul double %107, %3
  %109 = fmul double 0x4007DB3A654C617A, %108
  %110 = fmul double %109, %4
  %111 = fadd double %104, %110
  %112 = fmul double %3, %3
  %113 = fmul double %112, %3
  %114 = fmul double %113, %3
  %115 = fmul double %114, %3
  %116 = fmul double %115, %3
  %117 = fmul double 0x400C9DAF8306EFAC, %116
  %118 = fmul double %117, 1.000000e+00
  %119 = fadd double %111, %118
  %120 = fsub double %69, %u
  %121 = fmul double %119, 0x4034F53647135CB5
  %122 = fdiv double %120, %121
  %123 = fsub double %0, %122
  %124 = fcmp ogt double %123, 0xC042AC0631E06620
  %125 = select i1 %124, double 0xC042AC0631E06620, double %123
  %126 = fcmp olt double %125, 0xC042B221B699B9E8
  %127 = select i1 %126, double 0xC042B221B699B9E8, double %125
  %128 = add i32 %1, 1
  %129 = icmp eq i32 %128, 12
  br i1 %129, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %123
}

; Function Attrs: alwaysinline
define private double @sample_bernstein_newtonraphson_foo2(double %u) #4 {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %0 = phi double [ 0xC02476656789A4DA, %entry ], [ %159, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %160, %loop ]
  %2 = fsub double %0, 0xC024807102DF1F50
  %3 = fmul double %2, 0x40397C055131351E
  %4 = fsub double 1.000000e+00, %3
  %5 = fmul double %4, %4
  %6 = fmul double %5, %4
  %7 = fmul double %6, %4
  %8 = fmul double %7, %4
  %9 = fmul double %8, %4
  %10 = fmul double %9, %4
  %11 = fmul double %10, %4
  %12 = fmul double 0.000000e+00, %11
  %13 = fadd double 0.000000e+00, %12
  %14 = fmul double %4, %4
  %15 = fmul double %14, %4
  %16 = fmul double %15, %4
  %17 = fmul double %16, %4
  %18 = fmul double %17, %4
  %19 = fmul double %18, %4
  %20 = fmul double 0x3FEEEFD22063A88E, %3
  %21 = fmul double %20, %19
  %22 = fadd double %13, %21
  %23 = fmul double %3, %3
  %24 = fmul double %4, %4
  %25 = fmul double %24, %4
  %26 = fmul double %25, %4
  %27 = fmul double %26, %4
  %28 = fmul double %27, %4
  %29 = fmul double 0x4019B8BD49711AEC, %23
  %30 = fmul double %29, %28
  %31 = fadd double %22, %30
  %32 = fmul double %3, %3
  %33 = fmul double %32, %3
  %34 = fmul double %4, %4
  %35 = fmul double %34, %4
  %36 = fmul double %35, %4
  %37 = fmul double %36, %4
  %38 = fmul double 0x403271A55A90C0F6, %33
  %39 = fmul double %38, %37
  %40 = fadd double %31, %39
  %41 = fmul double %3, %3
  %42 = fmul double %41, %3
  %43 = fmul double %42, %3
  %44 = fmul double %4, %4
  %45 = fmul double %44, %4
  %46 = fmul double %45, %4
  %47 = fmul double 0x403B30FED9C1C060, %43
  %48 = fmul double %47, %46
  %49 = fadd double %40, %48
  %50 = fmul double %3, %3
  %51 = fmul double %50, %3
  %52 = fmul double %51, %3
  %53 = fmul double %52, %3
  %54 = fmul double %4, %4
  %55 = fmul double %54, %4
  %56 = fmul double 0x403A611EDC2E43EB, %53
  %57 = fmul double %56, %55
  %58 = fadd double %49, %57
  %59 = fmul double %3, %3
  %60 = fmul double %59, %3
  %61 = fmul double %60, %3
  %62 = fmul double %61, %3
  %63 = fmul double %62, %3
  %64 = fmul double %4, %4
  %65 = fmul double 0x402F025824993641, %63
  %66 = fmul double %65, %64
  %67 = fadd double %58, %66
  %68 = fmul double %3, %3
  %69 = fmul double %68, %3
  %70 = fmul double %69, %3
  %71 = fmul double %70, %3
  %72 = fmul double %71, %3
  %73 = fmul double %72, %3
  %74 = fmul double 0x401523BAF5624336, %73
  %75 = fmul double %74, %4
  %76 = fadd double %67, %75
  %77 = fmul double %3, %3
  %78 = fmul double %77, %3
  %79 = fmul double %78, %3
  %80 = fmul double %79, %3
  %81 = fmul double %80, %3
  %82 = fmul double %81, %3
  %83 = fmul double %82, %3
  %84 = fmul double 1.000000e+00, %83
  %85 = fmul double %84, 1.000000e+00
  %86 = fadd double %76, %85
  %87 = fmul double %4, %4
  %88 = fmul double %87, %4
  %89 = fmul double %88, %4
  %90 = fmul double %89, %4
  %91 = fmul double %90, %4
  %92 = fmul double %91, %4
  %93 = fmul double 0x3FEEEFD22063A88E, %92
  %94 = fadd double 0.000000e+00, %93
  %95 = fmul double %4, %4
  %96 = fmul double %95, %4
  %97 = fmul double %96, %4
  %98 = fmul double %97, %4
  %99 = fmul double %98, %4
  %100 = fmul double 0x40185FA2B68B025D, %3
  %101 = fmul double %100, %99
  %102 = fadd double %94, %101
  %103 = fmul double %3, %3
  %104 = fmul double %4, %4
  %105 = fmul double %104, %4
  %106 = fmul double %105, %4
  %107 = fmul double %106, %4
  %108 = fmul double 0x4030BFD421889A7F, %103
  %109 = fmul double %108, %107
  %110 = fadd double %102, %109
  %111 = fmul double %3, %3
  %112 = fmul double %111, %3
  %113 = fmul double %4, %4
  %114 = fmul double %113, %4
  %115 = fmul double %114, %4
  %116 = fmul double 0x40308BC0A2333CB3, %112
  %117 = fmul double %116, %115
  %118 = fadd double %110, %117
  %119 = fmul double %3, %3
  %120 = fmul double %119, %3
  %121 = fmul double %120, %3
  %122 = fmul double %4, %4
  %123 = fmul double %122, %4
  %124 = fmul double 0x4037219EE5E05216, %121
  %125 = fmul double %124, %123
  %126 = fadd double %118, %125
  %127 = fmul double %3, %3
  %128 = fmul double %127, %3
  %129 = fmul double %128, %3
  %130 = fmul double %129, %3
  %131 = fmul double %4, %4
  %132 = fmul double 0x402BC757B281AE02, %130
  %133 = fmul double %132, %131
  %134 = fadd double %126, %133
  %135 = fmul double %3, %3
  %136 = fmul double %135, %3
  %137 = fmul double %136, %3
  %138 = fmul double %137, %3
  %139 = fmul double %138, %3
  %140 = fmul double 0x4017F0BC234AFD77, %139
  %141 = fmul double %140, %4
  %142 = fadd double %134, %141
  %143 = fmul double %3, %3
  %144 = fmul double %143, %3
  %145 = fmul double %144, %3
  %146 = fmul double %145, %3
  %147 = fmul double %146, %3
  %148 = fmul double %147, %3
  %149 = fmul double 0x4005B88A153B7994, %148
  %150 = fmul double %149, 1.000000e+00
  %151 = fadd double %142, %150
  %152 = fsub double %86, %u
  %153 = fmul double %151, 0x40397C055131351E
  %154 = fdiv double %152, %153
  %155 = fsub double %0, %154
  %156 = fcmp ogt double %155, 0xC0246C59CC342A63
  %157 = select i1 %156, double 0xC0246C59CC342A63, double %155
  %158 = fcmp olt double %157, 0xC024807102DF1F50
  %159 = select i1 %158, double 0xC024807102DF1F50, double %157
  %160 = add i32 %1, 1
  %161 = icmp eq i32 %160, 12
  br i1 %161, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %155
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar(i32 noundef %0, i64 %pop_external_param) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !73, metadata !DIExpression()), !dbg !77
  call void @llvm.dbg.declare(metadata ptr %3, metadata !78, metadata !DIExpression()), !dbg !79
  %4 = load i32, ptr %2, align 4, !dbg !80
  %5 = add nsw i32 %4, 1, !dbg !81
  %sitofp_to_double = sitofp i64 %pop_external_param to double, !dbg !79
  %6 = fmul double %sitofp_to_double, 0x4000000000000, !dbg !79
  %7 = call double @sample_bernstein_newtonraphson_bar3(double %6), !dbg !79
  %8 = fcmp ogt double %7, 0x40475AA127A953CD, !dbg !79
  br i1 %8, label %never_hit, label %always_hit, !dbg !79

always_hit:                                       ; preds = %1
  store i32 %5, ptr %3, align 4, !dbg !79
  %9 = load i32, ptr %3, align 4, !dbg !82
  %10 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %9), !dbg !83
  %11 = load i32, ptr %3, align 4, !dbg !84
  ret i32 %11, !dbg !85

never_hit:                                        ; preds = %1
  ret i32 0, !dbg !79
}

; Function Attrs: alwaysinline
define private double @sample_bernstein_newtonraphson_bar3(double %u) #4 {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %0 = phi double [ 0x404758AD0EFF4631, %entry ], [ %235, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %236, %loop ]
  %2 = fsub double %0, 0x404756B773A3254A
  %3 = fmul double %2, 0x404054DE243AB865
  %4 = fsub double 1.000000e+00, %3
  %5 = fmul double %4, %4
  %6 = fmul double %5, %4
  %7 = fmul double %6, %4
  %8 = fmul double %7, %4
  %9 = fmul double %8, %4
  %10 = fmul double %9, %4
  %11 = fmul double %10, %4
  %12 = fmul double %11, %4
  %13 = fmul double %12, %4
  %14 = fmul double 0.000000e+00, %13
  %15 = fadd double 0.000000e+00, %14
  %16 = fmul double %4, %4
  %17 = fmul double %16, %4
  %18 = fmul double %17, %4
  %19 = fmul double %18, %4
  %20 = fmul double %19, %4
  %21 = fmul double %20, %4
  %22 = fmul double %21, %4
  %23 = fmul double %22, %4
  %24 = fmul double 0x3FE1987AC4694FC1, %3
  %25 = fmul double %24, %23
  %26 = fadd double %15, %25
  %27 = fmul double %3, %3
  %28 = fmul double %4, %4
  %29 = fmul double %28, %4
  %30 = fmul double %29, %4
  %31 = fmul double %30, %4
  %32 = fmul double %31, %4
  %33 = fmul double %32, %4
  %34 = fmul double %33, %4
  %35 = fmul double 0x4012D7FCBC2ADC40, %27
  %36 = fmul double %35, %34
  %37 = fadd double %26, %36
  %38 = fmul double %3, %3
  %39 = fmul double %38, %3
  %40 = fmul double %4, %4
  %41 = fmul double %40, %4
  %42 = fmul double %41, %4
  %43 = fmul double %42, %4
  %44 = fmul double %43, %4
  %45 = fmul double %44, %4
  %46 = fmul double 0x402C5784BC7C92A4, %39
  %47 = fmul double %46, %45
  %48 = fadd double %37, %47
  %49 = fmul double %3, %3
  %50 = fmul double %49, %3
  %51 = fmul double %50, %3
  %52 = fmul double %4, %4
  %53 = fmul double %52, %4
  %54 = fmul double %53, %4
  %55 = fmul double %54, %4
  %56 = fmul double %55, %4
  %57 = fmul double 0x4042A66691183374, %51
  %58 = fmul double %57, %56
  %59 = fadd double %48, %58
  %60 = fmul double %3, %3
  %61 = fmul double %60, %3
  %62 = fmul double %61, %3
  %63 = fmul double %62, %3
  %64 = fmul double %4, %4
  %65 = fmul double %64, %4
  %66 = fmul double %65, %4
  %67 = fmul double %66, %4
  %68 = fmul double 0x40491D353FE396D6, %63
  %69 = fmul double %68, %67
  %70 = fadd double %59, %69
  %71 = fmul double %3, %3
  %72 = fmul double %71, %3
  %73 = fmul double %72, %3
  %74 = fmul double %73, %3
  %75 = fmul double %74, %3
  %76 = fmul double %4, %4
  %77 = fmul double %76, %4
  %78 = fmul double %77, %4
  %79 = fmul double 0x40457E0C4ABF158B, %75
  %80 = fmul double %79, %78
  %81 = fadd double %70, %80
  %82 = fmul double %3, %3
  %83 = fmul double %82, %3
  %84 = fmul double %83, %3
  %85 = fmul double %84, %3
  %86 = fmul double %85, %3
  %87 = fmul double %86, %3
  %88 = fmul double %4, %4
  %89 = fmul double %88, %4
  %90 = fmul double 0x403D749AEF955C70, %87
  %91 = fmul double %90, %89
  %92 = fadd double %81, %91
  %93 = fmul double %3, %3
  %94 = fmul double %93, %3
  %95 = fmul double %94, %3
  %96 = fmul double %95, %3
  %97 = fmul double %96, %3
  %98 = fmul double %97, %3
  %99 = fmul double %98, %3
  %100 = fmul double %4, %4
  %101 = fmul double 0x402C50732CAB5679, %99
  %102 = fmul double %101, %100
  %103 = fadd double %92, %102
  %104 = fmul double %3, %3
  %105 = fmul double %104, %3
  %106 = fmul double %105, %3
  %107 = fmul double %106, %3
  %108 = fmul double %107, %3
  %109 = fmul double %108, %3
  %110 = fmul double %109, %3
  %111 = fmul double %110, %3
  %112 = fmul double 0x400A843AC23ABB5E, %111
  %113 = fmul double %112, %4
  %114 = fadd double %103, %113
  %115 = fmul double %3, %3
  %116 = fmul double %115, %3
  %117 = fmul double %116, %3
  %118 = fmul double %117, %3
  %119 = fmul double %118, %3
  %120 = fmul double %119, %3
  %121 = fmul double %120, %3
  %122 = fmul double %121, %3
  %123 = fmul double %122, %3
  %124 = fmul double 1.000000e+00, %123
  %125 = fmul double %124, 1.000000e+00
  %126 = fadd double %114, %125
  %127 = fmul double %4, %4
  %128 = fmul double %127, %4
  %129 = fmul double %128, %4
  %130 = fmul double %129, %4
  %131 = fmul double %130, %4
  %132 = fmul double %131, %4
  %133 = fmul double %132, %4
  %134 = fmul double %133, %4
  %135 = fmul double 0x3FE1987AC4694FC1, %134
  %136 = fadd double 0.000000e+00, %135
  %137 = fmul double %4, %4
  %138 = fmul double %137, %4
  %139 = fmul double %138, %4
  %140 = fmul double %139, %4
  %141 = fmul double %140, %4
  %142 = fmul double %141, %4
  %143 = fmul double %142, %4
  %144 = fmul double 0x4011E46F5B5F3EC7, %3
  %145 = fmul double %144, %143
  %146 = fadd double %136, %145
  %147 = fmul double %3, %3
  %148 = fmul double %4, %4
  %149 = fmul double %148, %4
  %150 = fmul double %149, %4
  %151 = fmul double %150, %4
  %152 = fmul double %151, %4
  %153 = fmul double %152, %4
  %154 = fmul double 0x40134D3689948DD9, %147
  %155 = fmul double %154, %153
  %156 = fadd double %146, %155
  %157 = fmul double %3, %3
  %158 = fmul double %157, %3
  %159 = fmul double %4, %4
  %160 = fmul double %159, %4
  %161 = fmul double %160, %4
  %162 = fmul double %161, %4
  %163 = fmul double %162, %4
  %164 = fmul double 0x40490071FA86CD32, %158
  %165 = fmul double %164, %163
  %166 = fadd double %156, %165
  %167 = fmul double %3, %3
  %168 = fmul double %167, %3
  %169 = fmul double %168, %3
  %170 = fmul double %4, %4
  %171 = fmul double %170, %4
  %172 = fmul double %171, %4
  %173 = fmul double %172, %4
  %174 = fmul double 0x403B5745B1C17AEC, %169
  %175 = fmul double %174, %173
  %176 = fadd double %166, %175
  %177 = fmul double %3, %3
  %178 = fmul double %177, %3
  %179 = fmul double %178, %3
  %180 = fmul double %179, %3
  %181 = fmul double %4, %4
  %182 = fmul double %181, %4
  %183 = fmul double %182, %4
  %184 = fmul double 0x401B11FC0844789D, %180
  %185 = fmul double %184, %183
  %186 = fadd double %176, %185
  %187 = fmul double %3, %3
  %188 = fmul double %187, %3
  %189 = fmul double %188, %3
  %190 = fmul double %189, %3
  %191 = fmul double %190, %3
  %192 = fmul double %4, %4
  %193 = fmul double %192, %4
  %194 = fmul double 0x40411FED1B8E6D5A, %191
  %195 = fmul double %194, %193
  %196 = fadd double %186, %195
  %197 = fmul double %3, %3
  %198 = fmul double %197, %3
  %199 = fmul double %198, %3
  %200 = fmul double %199, %3
  %201 = fmul double %200, %3
  %202 = fmul double %201, %3
  %203 = fmul double %4, %4
  %204 = fmul double 0x4038E3FBE3ED4495, %202
  %205 = fmul double %204, %203
  %206 = fadd double %196, %205
  %207 = fmul double %3, %3
  %208 = fmul double %207, %3
  %209 = fmul double %208, %3
  %210 = fmul double %209, %3
  %211 = fmul double %210, %3
  %212 = fmul double %211, %3
  %213 = fmul double %212, %3
  %214 = fmul double 0x3FF844EEDD6BC508, %213
  %215 = fmul double %214, %4
  %216 = fadd double %206, %215
  %217 = fmul double %3, %3
  %218 = fmul double %217, %3
  %219 = fmul double %218, %3
  %220 = fmul double %219, %3
  %221 = fmul double %220, %3
  %222 = fmul double %221, %3
  %223 = fmul double %222, %3
  %224 = fmul double %223, %3
  %225 = fmul double 0x401ABDE29EE2A250, %224
  %226 = fmul double %225, 1.000000e+00
  %227 = fadd double %216, %226
  %228 = fsub double %126, %u
  %229 = fmul double %227, 0x404054DE243AB865
  %230 = fdiv double %228, %229
  %231 = fsub double %0, %230
  %232 = fcmp ogt double %231, 0x40475AA2AA5B6717
  %233 = select i1 %232, double 0x40475AA2AA5B6717, double %231
  %234 = fcmp olt double %233, 0x404756B773A3254A
  %235 = select i1 %234, double 0x404756B773A3254A, double %233
  %236 = add i32 %1, 1
  %237 = icmp eq i32 %236, 12
  br i1 %237, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %231
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
!2 = !DIFile(filename: "example.c", directory: "/home/paul/Documents/JuFo-2026/examples", checksumkind: CSK_MD5, checksum: "8dcaafc4a2d20b9010b46343247899bc")
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
!28 = distinct !DISubprogram(name: "wrapper", scope: !2, file: !2, line: 18, type: !29, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12)
!29 = !DISubroutineType(types: !13)
!30 = !DILocation(line: 19, column: 10, scope: !28)
!31 = !DILocation(line: 19, column: 3, scope: !28)
!32 = distinct !DISubprogram(name: "foo", scope: !2, file: !2, line: 22, type: !33, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !35)
!33 = !DISubroutineType(types: !34)
!34 = !{null, !14}
!35 = !{}
!36 = !DILocalVariable(name: "x", arg: 1, scope: !32, file: !2, line: 22, type: !14)
!37 = !DILocation(line: 22, column: 29, scope: !32)
!38 = !DILocation(line: 24, column: 23, scope: !32)
!39 = !DILocation(line: 24, column: 3, scope: !32)
!40 = !DILocation(line: 31, column: 1, scope: !32)
!41 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 40, type: !42, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !12)
!42 = !DISubroutineType(types: !43)
!43 = !{!44}
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !DILocation(line: 42, column: 7, scope: !41)
!46 = !DILocation(line: 42, column: 3, scope: !41)
!47 = !DILocation(line: 43, column: 3, scope: !41)
!48 = !DILocalVariable(name: "r", scope: !49, file: !2, line: 11, type: !14)
!49 = distinct !DISubprogram(name: "rand_uint64", scope: !2, file: !2, line: 10, type: !29, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !35)
!50 = !DILocation(line: 11, column: 12, scope: !49)
!51 = !DILocalVariable(name: "i", scope: !52, file: !2, line: 12, type: !44)
!52 = distinct !DILexicalBlock(scope: !49, file: !2, line: 12, column: 3)
!53 = !DILocation(line: 12, column: 12, scope: !52)
!54 = !DILocation(line: 12, column: 8, scope: !52)
!55 = !DILocation(line: 12, column: 17, scope: !56)
!56 = distinct !DILexicalBlock(scope: !52, file: !2, line: 12, column: 3)
!57 = !DILocation(line: 12, column: 18, scope: !56)
!58 = !DILocation(line: 12, column: 3, scope: !52)
!59 = !DILocation(line: 13, column: 9, scope: !60)
!60 = distinct !DILexicalBlock(scope: !56, file: !2, line: 12, column: 39)
!61 = !DILocation(line: 13, column: 10, scope: !60)
!62 = !DILocation(line: 13, column: 38, scope: !60)
!63 = !DILocation(line: 13, column: 36, scope: !60)
!64 = !DILocation(line: 13, column: 7, scope: !60)
!65 = !DILocation(line: 14, column: 3, scope: !60)
!66 = !DILocation(line: 12, column: 25, scope: !56)
!67 = !DILocation(line: 12, column: 3, scope: !56)
!68 = distinct !{!68, !58, !69, !70}
!69 = !DILocation(line: 14, column: 3, scope: !52)
!70 = !{!"llvm.loop.mustprogress"}
!71 = !DILocation(line: 15, column: 10, scope: !49)
!72 = !DILocation(line: 15, column: 3, scope: !49)
!73 = !DILocalVariable(name: "x", arg: 1, scope: !74, file: !2, line: 33, type: !44)
!74 = distinct !DISubprogram(name: "bar", scope: !2, file: !2, line: 33, type: !75, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !35)
!75 = !DISubroutineType(types: !76)
!76 = !{!44, !44}
!77 = !DILocation(line: 33, column: 23, scope: !74)
!78 = !DILocalVariable(name: "y", scope: !74, file: !2, line: 35, type: !44)
!79 = !DILocation(line: 35, column: 7, scope: !74)
!80 = !DILocation(line: 35, column: 11, scope: !74)
!81 = !DILocation(line: 35, column: 13, scope: !74)
!82 = !DILocation(line: 36, column: 22, scope: !74)
!83 = !DILocation(line: 36, column: 3, scope: !74)
!84 = !DILocation(line: 37, column: 10, scope: !74)
!85 = !DILocation(line: 37, column: 3, scope: !74)
