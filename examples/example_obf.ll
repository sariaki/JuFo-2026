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
  %3 = call double @sample_poisson(double 0xR112A0000000000)
  %4 = fcmp ult double %3, 0xR14000000000000
  br i1 %4, label %always_hit, label %never_hit

always_hit:                                       ; preds = %2
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  store ptr %1, ptr %5, align 8
  store ptr %0, ptr %6, align 8
  call void @llvm.va_start.p0(ptr %8)
  %9 = load ptr, ptr %8, align 8
  %10 = load ptr, ptr %5, align 8
  %11 = load ptr, ptr %6, align 8
  %12 = call i32 @_vsprintf_l(ptr noundef %11, ptr noundef %10, ptr noundef null, ptr noundef %9)
  store i32 %12, ptr %7, align 4
  call void @llvm.va_end.p0(ptr %8)
  %13 = load i32, ptr %7, align 4
  ret i32 %13

never_hit:                                        ; preds = %2
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @vsprintf(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 comdat {
  %4 = call double @sample_poisson(double 0xR17C80000000000)
  %5 = fcmp ult double %4, 0xR14000000000000
  br i1 %5, label %always_hit, label %never_hit

always_hit:                                       ; preds = %3
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store ptr %2, ptr %6, align 8
  store ptr %1, ptr %7, align 8
  store ptr %0, ptr %8, align 8
  %9 = load ptr, ptr %6, align 8
  %10 = load ptr, ptr %7, align 8
  %11 = load ptr, ptr %8, align 8
  %12 = call i32 @_vsnprintf_l(ptr noundef %11, i64 noundef -1, ptr noundef %10, ptr noundef null, ptr noundef %9)
  ret i32 %12

never_hit:                                        ; preds = %3
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_snprintf(ptr noundef %0, i64 noundef %1, ptr noundef %2, ...) #0 comdat {
  %4 = call double @sample_poisson(double 0xR16300000000000)
  %5 = fcmp ult double %4, 0xR14000000000000
  br i1 %5, label %always_hit, label %never_hit

always_hit:                                       ; preds = %3
  %6 = alloca ptr, align 8
  %7 = alloca i64, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca ptr, align 8
  store ptr %2, ptr %6, align 8
  store i64 %1, ptr %7, align 8
  store ptr %0, ptr %8, align 8
  call void @llvm.va_start.p0(ptr %10)
  %11 = load ptr, ptr %10, align 8
  %12 = load ptr, ptr %6, align 8
  %13 = load i64, ptr %7, align 8
  %14 = load ptr, ptr %8, align 8
  %15 = call i32 @_vsnprintf(ptr noundef %14, i64 noundef %13, ptr noundef %12, ptr noundef %11)
  store i32 %15, ptr %9, align 4
  call void @llvm.va_end.p0(ptr %10)
  %16 = load i32, ptr %9, align 4
  ret i32 %16

never_hit:                                        ; preds = %3
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsnprintf(ptr noundef %0, i64 noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat {
  %5 = call double @sample_poisson(double 0xR1AF78000000000)
  %6 = fcmp ult double %5, 0xR14000000000000
  br i1 %6, label %always_hit, label %never_hit

always_hit:                                       ; preds = %4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i64, align 8
  %10 = alloca ptr, align 8
  store ptr %3, ptr %7, align 8
  store ptr %2, ptr %8, align 8
  store i64 %1, ptr %9, align 8
  store ptr %0, ptr %10, align 8
  %11 = load ptr, ptr %7, align 8
  %12 = load ptr, ptr %8, align 8
  %13 = load i64, ptr %9, align 8
  %14 = load ptr, ptr %10, align 8
  %15 = call i32 @_vsnprintf_l(ptr noundef %14, i64 noundef %13, ptr noundef %12, ptr noundef null, ptr noundef %11)
  ret i32 %15

never_hit:                                        ; preds = %4
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo() #0 {
  %1 = call double @sample_poisson(double 0xR10B40000000000)
  %2 = fcmp ult double %1, 0xR14000000000000
  br i1 %2, label %always_hit, label %never_hit

always_hit:                                       ; preds = %0
  %3 = call i32 (ptr, ...) @printf(ptr noundef @"??_C@_04PFIOAJMN@foo?6?$AA@")
  ret void

never_hit:                                        ; preds = %0
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @printf(ptr noundef %0, ...) #0 comdat {
  %2 = call double @sample_poisson(double 0xR1C6F8000000000)
  %3 = fcmp ult double %2, 0xR14000000000000
  br i1 %3, label %always_hit, label %never_hit

always_hit:                                       ; preds = %1
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  call void @llvm.va_start.p0(ptr %6)
  %7 = load ptr, ptr %6, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = call ptr @__acrt_iob_func(i32 noundef 1)
  %10 = call i32 @_vfprintf_l(ptr noundef %9, ptr noundef %8, ptr noundef null, ptr noundef %7)
  store i32 %10, ptr %5, align 4
  call void @llvm.va_end.p0(ptr %6)
  %11 = load i32, ptr %5, align 4
  ret i32 %11

never_hit:                                        ; preds = %1
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = call double @sample_poisson(double 0xR19C18000000000)
  %2 = fcmp ult double %1, 0xR14000000000000
  br i1 %2, label %always_hit, label %never_hit

always_hit:                                       ; preds = %0
  %3 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  call void @foo()
  ret i32 0

never_hit:                                        ; preds = %0
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start.p0(ptr) #1

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsprintf_l(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat {
  %5 = call double @sample_poisson(double 0xR152DC000000000)
  %6 = fcmp ult double %5, 0xR14000000000000
  br i1 %6, label %always_hit, label %never_hit

always_hit:                                       ; preds = %4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  store ptr %3, ptr %7, align 8
  store ptr %2, ptr %8, align 8
  store ptr %1, ptr %9, align 8
  store ptr %0, ptr %10, align 8
  %11 = load ptr, ptr %7, align 8
  %12 = load ptr, ptr %8, align 8
  %13 = load ptr, ptr %9, align 8
  %14 = load ptr, ptr %10, align 8
  %15 = call i32 @_vsnprintf_l(ptr noundef %14, i64 noundef -1, ptr noundef %13, ptr noundef %12, ptr noundef %11)
  ret i32 %15

never_hit:                                        ; preds = %4
  unreachable
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end.p0(ptr) #1

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vsnprintf_l(ptr noundef %0, i64 noundef %1, ptr noundef %2, ptr noundef %3, ptr noundef %4) #0 comdat {
  %6 = call double @sample_poisson(double 0xR1EFD8000000000)
  %7 = fcmp ult double %6, 0xR14000000000000
  br i1 %7, label %always_hit, label %never_hit

always_hit:                                       ; preds = %5
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i64, align 8
  %12 = alloca ptr, align 8
  %13 = alloca i32, align 4
  store ptr %4, ptr %8, align 8
  store ptr %3, ptr %9, align 8
  store ptr %2, ptr %10, align 8
  store i64 %1, ptr %11, align 8
  store ptr %0, ptr %12, align 8
  %14 = load ptr, ptr %8, align 8
  %15 = load ptr, ptr %9, align 8
  %16 = load ptr, ptr %10, align 8
  %17 = load i64, ptr %11, align 8
  %18 = load ptr, ptr %12, align 8
  %19 = call ptr @__local_stdio_printf_options()
  %20 = load i64, ptr %19, align 8
  %21 = or i64 %20, 1
  %22 = call i32 @__stdio_common_vsprintf(i64 noundef %21, ptr noundef %18, i64 noundef %17, ptr noundef %16, ptr noundef %15, ptr noundef %14)
  store i32 %22, ptr %13, align 4
  %23 = load i32, ptr %13, align 4
  %24 = icmp slt i32 %23, 0
  br i1 %24, label %25, label %26

25:                                               ; preds = %always_hit
  br label %28

26:                                               ; preds = %always_hit
  %27 = load i32, ptr %13, align 4
  br label %28

28:                                               ; preds = %26, %25
  %29 = phi i32 [ -1, %25 ], [ %27, %26 ]
  ret i32 %29

never_hit:                                        ; preds = %5
  unreachable
}

declare dso_local i32 @__stdio_common_vsprintf(i64 noundef, ptr noundef, i64 noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local ptr @__local_stdio_printf_options() #0 comdat {
  %1 = call double @sample_poisson(double 0xR16900000000000)
  %2 = fcmp ult double %1, 0xR14000000000000
  br i1 %2, label %always_hit, label %never_hit

always_hit:                                       ; preds = %0
  ret ptr @__local_stdio_printf_options._OptionsStorage

never_hit:                                        ; preds = %0
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_vfprintf_l(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3) #0 comdat {
  %5 = call double @sample_poisson(double 0xR13200000000000)
  %6 = fcmp ult double %5, 0xR14000000000000
  br i1 %6, label %always_hit, label %never_hit

always_hit:                                       ; preds = %4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  store ptr %3, ptr %7, align 8
  store ptr %2, ptr %8, align 8
  store ptr %1, ptr %9, align 8
  store ptr %0, ptr %10, align 8
  %11 = load ptr, ptr %7, align 8
  %12 = load ptr, ptr %8, align 8
  %13 = load ptr, ptr %9, align 8
  %14 = load ptr, ptr %10, align 8
  %15 = call ptr @__local_stdio_printf_options()
  %16 = load i64, ptr %15, align 8
  %17 = call i32 @__stdio_common_vfprintf(i64 noundef %16, ptr noundef %14, ptr noundef %13, ptr noundef %12, ptr noundef %11)
  ret i32 %17

never_hit:                                        ; preds = %4
  unreachable
}

declare dso_local ptr @__acrt_iob_func(i32 noundef) #2

declare dso_local i32 @__stdio_common_vfprintf(i64 noundef, ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

declare double @sample_poisson(double)

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
