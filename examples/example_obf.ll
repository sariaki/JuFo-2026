; ModuleID = 'example.ll'
source_filename = "./example.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.36.32535"

$sprintf = comdat any

$vsprintf = comdat any

$_snprintf = comdat any

$_vsnprintf = comdat any

$printf = comdat any

$_vsprintf_l = comdat any

$_vsnprintf_l = comdat any

$__local_stdio_printf_options = comdat any

$_vfprintf_l = comdat any

$"??_C@_04PFIOAJMN@foo?6?$AA@" = comdat any

@"??_C@_04PFIOAJMN@foo?6?$AA@" = linkonce_odr dso_local unnamed_addr constant [5 x i8] c"foo\0A\00", comdat, align 1
@__local_stdio_printf_options._OptionsStorage = internal global i64 0, align 8

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @sprintf(ptr noundef %0, ptr noundef %1, ...) #0 comdat {
  %3 = call i64 @sample_poisson(double 0xR10000000000000)
  %4 = sitofp i64 %3 to double
  %5 = fcmp olt double %4, 0xR10000000000000
  br i1 %5, label %always_hit, label %never_hit

always_hit:                                       ; preds = %2
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 8
  store ptr %1, ptr %6, align 8
  store ptr %0, ptr %7, align 8
  call void @llvm.va_start.p0(ptr %9)
  %10 = load ptr, ptr %9, align 8
  %11 = load ptr, ptr %6, align 8
  %12 = load ptr, ptr %7, align 8
  %13 = call i32 @_vsprintf_l(ptr noundef %12, ptr noundef %11, ptr noundef null, ptr noundef %10)
  store i32 %13, ptr %8, align 4
  call void @llvm.va_end.p0(ptr %9)
  %14 = load i32, ptr %8, align 4
  ret i32 %14

never_hit:                                        ; preds = %2
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @vsprintf(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 comdat {
  %4 = call i64 @sample_poisson(double 0xR10000000000000)
  %5 = sitofp i64 %4 to double
  %6 = fcmp olt double %5, 0xR10000000000000
  br i1 %6, label %always_hit, label %never_hit

always_hit:                                       ; preds = %3
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  store ptr %2, ptr %7, align 8
  store ptr %1, ptr %8, align 8
  store ptr %0, ptr %9, align 8
  %10 = load ptr, ptr %7, align 8
  %11 = load ptr, ptr %8, align 8
  %12 = load ptr, ptr %9, align 8
  %13 = call i32 @_vsnprintf_l(ptr noundef %12, i64 noundef -1, ptr noundef %11, ptr noundef null, ptr noundef %10)
  ret i32 %13

never_hit:                                        ; preds = %3
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_snprintf(ptr noundef %0, i64 noundef %1, ptr noundef %2, ...) #0 comdat {
  %4 = call i64 @sample_poisson(double 0xR10000000000000)
  %5 = sitofp i64 %4 to double
  %6 = fcmp olt double %5, 0xR10000000000000
  br i1 %6, label %always_hit, label %never_hit

always_hit:                                       ; preds = %3
  %7 = alloca ptr, align 8
  %8 = alloca i64, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i32, align 4
  %11 = alloca ptr, align 8
  store ptr %2, ptr %7, align 8
  store i64 %1, ptr %8, align 8
  store ptr %0, ptr %9, align 8
  call void @llvm.va_start.p0(ptr %11)
  %12 = load ptr, ptr %11, align 8
  %13 = load ptr, ptr %7, align 8
  %14 = load i64, ptr %8, align 8
  %15 = load ptr, ptr %9, align 8
  %16 = call i32 @_vsnprintf(ptr noundef %15, i64 noundef %14, ptr noundef %13, ptr noundef %12)
  store i32 %16, ptr %10, align 4
  call void @llvm.va_end.p0(ptr %11)
  %17 = load i32, ptr %10, align 4
  ret i32 %17

never_hit:                                        ; preds = %3
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsnprintf(ptr noundef %0, i64 noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat {
  %5 = call i64 @sample_poisson(double 0xR10000000000000)
  %6 = sitofp i64 %5 to double
  %7 = fcmp olt double %6, 0xR10000000000000
  br i1 %7, label %always_hit, label %never_hit

always_hit:                                       ; preds = %4
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i64, align 8
  %11 = alloca ptr, align 8
  store ptr %3, ptr %8, align 8
  store ptr %2, ptr %9, align 8
  store i64 %1, ptr %10, align 8
  store ptr %0, ptr %11, align 8
  %12 = load ptr, ptr %8, align 8
  %13 = load ptr, ptr %9, align 8
  %14 = load i64, ptr %10, align 8
  %15 = load ptr, ptr %11, align 8
  %16 = call i32 @_vsnprintf_l(ptr noundef %15, i64 noundef %14, ptr noundef %13, ptr noundef null, ptr noundef %12)
  ret i32 %16

never_hit:                                        ; preds = %4
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 {
  %1 = call i64 @sample_poisson(double 0xR10000000000000)
  %2 = sitofp i64 %1 to double
  %3 = fcmp olt double %2, 0xR10000000000000
  br i1 %3, label %always_hit, label %never_hit

always_hit:                                       ; preds = %0
  %4 = call i32 (ptr, ...) @printf(ptr noundef @"??_C@_04PFIOAJMN@foo?6?$AA@")
  ret void

never_hit:                                        ; preds = %0
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @printf(ptr noundef %0, ...) #0 comdat {
  %2 = call i64 @sample_poisson(double 0xR10000000000000)
  %3 = sitofp i64 %2 to double
  %4 = fcmp olt double %3, 0xR10000000000000
  br i1 %4, label %always_hit, label %never_hit

always_hit:                                       ; preds = %1
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  store ptr %0, ptr %5, align 8
  call void @llvm.va_start.p0(ptr %7)
  %8 = load ptr, ptr %7, align 8
  %9 = load ptr, ptr %5, align 8
  %10 = call ptr @__acrt_iob_func(i32 noundef 1)
  %11 = call i32 @_vfprintf_l(ptr noundef %10, ptr noundef %9, ptr noundef null, ptr noundef %8)
  store i32 %11, ptr %6, align 4
  call void @llvm.va_end.p0(ptr %7)
  %12 = load i32, ptr %6, align 4
  ret i32 %12

never_hit:                                        ; preds = %1
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = call i64 @sample_poisson(double 0xR10000000000000)
  %2 = sitofp i64 %1 to double
  %3 = fcmp olt double %2, 0xR10000000000000
  br i1 %3, label %always_hit, label %never_hit

always_hit:                                       ; preds = %0
  %4 = alloca i32, align 4
  store i32 0, ptr %4, align 4
  call void @foo()
  ret i32 0

never_hit:                                        ; preds = %0
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #1

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsprintf_l(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat {
  %5 = call i64 @sample_poisson(double 0xR10000000000000)
  %6 = sitofp i64 %5 to double
  %7 = fcmp olt double %6, 0xR10000000000000
  br i1 %7, label %always_hit, label %never_hit

always_hit:                                       ; preds = %4
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  store ptr %3, ptr %8, align 8
  store ptr %2, ptr %9, align 8
  store ptr %1, ptr %10, align 8
  store ptr %0, ptr %11, align 8
  %12 = load ptr, ptr %8, align 8
  %13 = load ptr, ptr %9, align 8
  %14 = load ptr, ptr %10, align 8
  %15 = load ptr, ptr %11, align 8
  %16 = call i32 @_vsnprintf_l(ptr noundef %15, i64 noundef -1, ptr noundef %14, ptr noundef %13, ptr noundef %12)
  ret i32 %16

never_hit:                                        ; preds = %4
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end.p0(ptr) #1

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsnprintf_l(ptr noundef %0, i64 noundef %1, ptr noundef %2, ptr noundef %3, ptr noundef %4) #0 comdat {
  %6 = call i64 @sample_poisson(double 0xR10000000000000)
  %7 = sitofp i64 %6 to double
  %8 = fcmp olt double %7, 0xR10000000000000
  br i1 %8, label %always_hit, label %never_hit

always_hit:                                       ; preds = %5
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  %12 = alloca i64, align 8
  %13 = alloca ptr, align 8
  %14 = alloca i32, align 4
  store ptr %4, ptr %9, align 8
  store ptr %3, ptr %10, align 8
  store ptr %2, ptr %11, align 8
  store i64 %1, ptr %12, align 8
  store ptr %0, ptr %13, align 8
  %15 = load ptr, ptr %9, align 8
  %16 = load ptr, ptr %10, align 8
  %17 = load ptr, ptr %11, align 8
  %18 = load i64, ptr %12, align 8
  %19 = load ptr, ptr %13, align 8
  %20 = call ptr @__local_stdio_printf_options()
  %21 = load i64, ptr %20, align 8
  %22 = or i64 %21, 1
  %23 = call i32 @__stdio_common_vsprintf(i64 noundef %22, ptr noundef %19, i64 noundef %18, ptr noundef %17, ptr noundef %16, ptr noundef %15)
  store i32 %23, ptr %14, align 4
  %24 = load i32, ptr %14, align 4
  %25 = icmp slt i32 %24, 0
  br i1 %25, label %26, label %27

26:                                               ; preds = %always_hit
  br label %29

27:                                               ; preds = %always_hit
  %28 = load i32, ptr %14, align 4
  br label %29

29:                                               ; preds = %27, %26
  %30 = phi i32 [ -1, %26 ], [ %28, %27 ]
  ret i32 %30

never_hit:                                        ; preds = %5
  unreachable
}

declare dso_local i32 @__stdio_common_vsprintf(i64 noundef, ptr noundef, i64 noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local ptr @__local_stdio_printf_options() #0 comdat {
  %1 = call i64 @sample_poisson(double 0xR10000000000000)
  %2 = sitofp i64 %1 to double
  %3 = fcmp olt double %2, 0xR10000000000000
  br i1 %3, label %always_hit, label %never_hit

always_hit:                                       ; preds = %0
  ret ptr @__local_stdio_printf_options._OptionsStorage

never_hit:                                        ; preds = %0
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vfprintf_l(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat {
  %5 = call i64 @sample_poisson(double 0xR10000000000000)
  %6 = sitofp i64 %5 to double
  %7 = fcmp olt double %6, 0xR10000000000000
  br i1 %7, label %always_hit, label %never_hit

always_hit:                                       ; preds = %4
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  store ptr %3, ptr %8, align 8
  store ptr %2, ptr %9, align 8
  store ptr %1, ptr %10, align 8
  store ptr %0, ptr %11, align 8
  %12 = load ptr, ptr %8, align 8
  %13 = load ptr, ptr %9, align 8
  %14 = load ptr, ptr %10, align 8
  %15 = load ptr, ptr %11, align 8
  %16 = call ptr @__local_stdio_printf_options()
  %17 = load i64, ptr %16, align 8
  %18 = call i32 @__stdio_common_vfprintf(i64 noundef %17, ptr noundef %15, ptr noundef %14, ptr noundef %13, ptr noundef %12)
  ret i32 %18

never_hit:                                        ; preds = %4
  unreachable
}

declare dso_local ptr @__acrt_iob_func(i32 noundef) #2

declare dso_local i32 @__stdio_common_vfprintf(i64 noundef, ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

define i64 @sample_poisson(double %u) {
entry:
  %0 = call i64 @sample_poisson(double 0xR10000000000000)
  %1 = sitofp i64 %0 to double
  %2 = fcmp olt double %1, 0xR10000000000000
  br i1 %2, label %always_hit, label %never_hit

always_hit:                                       ; preds = %entry
  %p0 = call double @exp(double 0xR1F7CEDA0000000)
  br label %loop

loop:                                             ; preds = %loop, %always_hit
  %k = phi i64 [ 0, %always_hit ], [ %3, %loop ]
  %p = phi double [ %p0, %always_hit ], [ %6, %loop ]
  %s = phi double [ %p0, %always_hit ], [ %7, %loop ]
  %3 = add i64 %k, 1
  %4 = sitofp i64 %3 to double
  %5 = fdiv double 0xR1F7CEDA0000000, %4
  %6 = fmul double %p, %5
  %7 = fadd double %s, %6
  %8 = fcmp ogt double %u, %s
  br i1 %8, label %loop, label %exit

exit:                                             ; preds = %loop
  ret i64 %3

never_hit:                                        ; preds = %entry
  unreachable
}

declare double @exp(double)

attributes #0 = { noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind willreturn }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{i32 1, !"MaxTLSAlign", i32 65536}
!4 = !{!"clang version 20.1.4"}
