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
  %6 = call i32 asm sideeffect "", "=r, ~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %0)
  %sitofp_to_double = sitofp i32 %6 to double
  %7 = fmul double %sitofp_to_double, 0x4000000000000
  %8 = call double @sample_bernstein_newtonraphson_1(double %7)
  %9 = fcmp olt double %8, 0x4044E32A06CF8F4A
  br i1 %9, label %always_hit, label %never_hit

always_hit:                                       ; preds = %1
  %10 = call i32 (ptr, ...) @printf(ptr @fmt_str)
  %11 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @llvm.dbg.declare(metadata ptr %2, metadata !27, metadata !DIExpression()), !dbg !28
  %12 = load i32, ptr %2, align 4, !dbg !29
  %13 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %12), !dbg !30
  call void @llvm.dbg.declare(metadata ptr %3, metadata !31, metadata !DIExpression()), !dbg !33
  store volatile i32 1, ptr %3, align 4, !dbg !33
  call void @llvm.dbg.declare(metadata ptr %4, metadata !34, metadata !DIExpression()), !dbg !35
  store volatile i32 2, ptr %4, align 4, !dbg !35
  call void @llvm.dbg.declare(metadata ptr %5, metadata !36, metadata !DIExpression()), !dbg !37
  %14 = load volatile i32, ptr %3, align 4, !dbg !38
  %15 = load volatile i32, ptr %4, align 4, !dbg !39
  %16 = srem i32 %14, %15, !dbg !40
  store volatile i32 %16, ptr %5, align 4, !dbg !37
  call void @llvm.dbg.declare(metadata ptr %11, metadata !41, metadata !DIExpression()), !dbg !42
  %17 = load volatile i32, ptr %5, align 4, !dbg !43
  %18 = load volatile i32, ptr %4, align 4, !dbg !44
  %19 = load volatile i32, ptr %3, align 4, !dbg !45
  %20 = mul nsw i32 %18, %19, !dbg !46
  %21 = add nsw i32 %17, %20, !dbg !47
  store volatile i32 %21, ptr %11, align 4, !dbg !42
  ret void, !dbg !48

never_hit:                                        ; preds = %1
  %22 = call i32 (ptr, ...) @printf(ptr @fmt_str.1)
  ret void
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
  %5 = add nsw i32 %4, 1, !dbg !57
  store i32 %5, ptr %3, align 4, !dbg !55
  %6 = call i32 asm sideeffect "", "=r, ~{memory},~{dirflag},~{fpsr},~{flags}"(i32 %0), !dbg !58
  %sitofp_to_double = sitofp i32 %6 to double, !dbg !58
  %7 = fmul double %sitofp_to_double, 0x4000000000000, !dbg !58
  %8 = call double @sample_bernstein_newtonraphson_2(double %7), !dbg !58
  %9 = fcmp olt double %8, 0x402EB0386189B557, !dbg !58
  br i1 %9, label %always_hit, label %never_hit, !dbg !58

always_hit:                                       ; preds = %1
  %10 = call i32 (ptr, ...) @printf(ptr @fmt_str.2), !dbg !58
  %11 = load i32, ptr %3, align 4, !dbg !58
  %12 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %11), !dbg !59
  %13 = load i32, ptr %3, align 4, !dbg !60
  ret i32 %13, !dbg !61

never_hit:                                        ; preds = %1
  %14 = call i32 (ptr, ...) @printf(ptr @fmt_str.3), !dbg !58
  ret i32 0, !dbg !58
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
  %0 = phi double [ 0x4044E9CD1DD2CAF9, %entry ], [ %51, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %52, %loop ]
  %2 = fsub double %0, 0x4044E77B03AD2200
  %3 = fmul double %2, 0x403B93E7668999BB
  %4 = fsub double 1.000000e+00, %3
  %5 = fmul double %4, %4
  %6 = fmul double %5, %4
  %7 = fmul double %6, %4
  %8 = fmul double 0.000000e+00, %7
  %9 = fadd double 0.000000e+00, %8
  %10 = fmul double %4, %4
  %11 = fmul double %10, %4
  %12 = fmul double 0x3FE4ED64EC6B2DA9, %3
  %13 = fmul double %12, %11
  %14 = fadd double %9, %13
  %15 = fmul double %3, %3
  %16 = fmul double %4, %4
  %17 = fmul double 0x40019DBA84EE8340, %15
  %18 = fmul double %17, %16
  %19 = fadd double %14, %18
  %20 = fmul double %3, %3
  %21 = fmul double %20, %3
  %22 = fmul double 0x3FFA7BFDD338F150, %21
  %23 = fmul double %22, %4
  %24 = fadd double %19, %23
  %25 = fmul double %3, %3
  %26 = fmul double %25, %3
  %27 = fmul double %26, %3
  %28 = fmul double 1.000000e+00, %27
  %29 = fmul double %28, 1.000000e+00
  %30 = fadd double %24, %29
  %31 = fmul double %4, %4
  %32 = fmul double %31, %4
  %33 = fmul double 0x3FE4ED64EC6B2DA9, %32
  %34 = fadd double 0.000000e+00, %33
  %35 = fmul double %4, %4
  %36 = fmul double 0x40038969588CA441, %3
  %37 = fmul double %36, %35
  %38 = fadd double %34, %37
  %39 = fmul double %3, %3
  %40 = fmul double 0x3FE1FA1ECBE18DE2, %39
  %41 = fmul double %40, %4
  %42 = fadd double %38, %41
  %43 = fmul double %3, %3
  %44 = fmul double %43, %3
  %45 = fmul double 0x4002C20116638758, %44
  %46 = fmul double %45, 1.000000e+00
  %47 = fadd double %42, %46
  %48 = fsub double %30, %u
  %49 = fmul double %47, 0x403B93E7668999BB
  %50 = fdiv double %48, %49
  %51 = fsub double %0, %50
  %52 = add i32 %1, 1
  %53 = icmp eq i32 %52, 16
  br i1 %53, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %51
}

; Function Attrs: alwaysinline
define double @sample_bernstein_newtonraphson_2(double %u) #3 {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %0 = phi double [ 0x402F013CB52B090F, %entry ], [ %323, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %324, %loop ]
  %2 = fsub double %0, 0x402ECBB6C59DDD60
  %3 = fmul double %2, 0x401321C3E3C5A901
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
  %14 = fmul double %13, %4
  %15 = fmul double %14, %4
  %16 = fmul double 0.000000e+00, %15
  %17 = fadd double 0.000000e+00, %16
  %18 = fmul double %4, %4
  %19 = fmul double %18, %4
  %20 = fmul double %19, %4
  %21 = fmul double %20, %4
  %22 = fmul double %21, %4
  %23 = fmul double %22, %4
  %24 = fmul double %23, %4
  %25 = fmul double %24, %4
  %26 = fmul double %25, %4
  %27 = fmul double %26, %4
  %28 = fmul double 0x3FE5D9F715BA0C8C, %3
  %29 = fmul double %28, %27
  %30 = fadd double %17, %29
  %31 = fmul double %3, %3
  %32 = fmul double %4, %4
  %33 = fmul double %32, %4
  %34 = fmul double %33, %4
  %35 = fmul double %34, %4
  %36 = fmul double %35, %4
  %37 = fmul double %36, %4
  %38 = fmul double %37, %4
  %39 = fmul double %38, %4
  %40 = fmul double %39, %4
  %41 = fmul double 0x4021D2A4249E03A3, %31
  %42 = fmul double %41, %40
  %43 = fadd double %30, %42
  %44 = fmul double %3, %3
  %45 = fmul double %44, %3
  %46 = fmul double %4, %4
  %47 = fmul double %46, %4
  %48 = fmul double %47, %4
  %49 = fmul double %48, %4
  %50 = fmul double %49, %4
  %51 = fmul double %50, %4
  %52 = fmul double %51, %4
  %53 = fmul double %52, %4
  %54 = fmul double 0x404251655515266C, %45
  %55 = fmul double %54, %53
  %56 = fadd double %43, %55
  %57 = fmul double %3, %3
  %58 = fmul double %57, %3
  %59 = fmul double %58, %3
  %60 = fmul double %4, %4
  %61 = fmul double %60, %4
  %62 = fmul double %61, %4
  %63 = fmul double %62, %4
  %64 = fmul double %63, %4
  %65 = fmul double %64, %4
  %66 = fmul double %65, %4
  %67 = fmul double 0x405D3E39B9B60C49, %59
  %68 = fmul double %67, %66
  %69 = fadd double %56, %68
  %70 = fmul double %3, %3
  %71 = fmul double %70, %3
  %72 = fmul double %71, %3
  %73 = fmul double %72, %3
  %74 = fmul double %4, %4
  %75 = fmul double %74, %4
  %76 = fmul double %75, %4
  %77 = fmul double %76, %4
  %78 = fmul double %77, %4
  %79 = fmul double %78, %4
  %80 = fmul double 0x406DA32F9DEF1D7D, %73
  %81 = fmul double %80, %79
  %82 = fadd double %69, %81
  %83 = fmul double %3, %3
  %84 = fmul double %83, %3
  %85 = fmul double %84, %3
  %86 = fmul double %85, %3
  %87 = fmul double %86, %3
  %88 = fmul double %4, %4
  %89 = fmul double %88, %4
  %90 = fmul double %89, %4
  %91 = fmul double %90, %4
  %92 = fmul double %91, %4
  %93 = fmul double 0x40732AAFD8E4A0B7, %87
  %94 = fmul double %93, %92
  %95 = fadd double %82, %94
  %96 = fmul double %3, %3
  %97 = fmul double %96, %3
  %98 = fmul double %97, %3
  %99 = fmul double %98, %3
  %100 = fmul double %99, %3
  %101 = fmul double %100, %3
  %102 = fmul double %4, %4
  %103 = fmul double %102, %4
  %104 = fmul double %103, %4
  %105 = fmul double %104, %4
  %106 = fmul double 0x4072D6925704B5B9, %101
  %107 = fmul double %106, %105
  %108 = fadd double %95, %107
  %109 = fmul double %3, %3
  %110 = fmul double %109, %3
  %111 = fmul double %110, %3
  %112 = fmul double %111, %3
  %113 = fmul double %112, %3
  %114 = fmul double %113, %3
  %115 = fmul double %114, %3
  %116 = fmul double %4, %4
  %117 = fmul double %116, %4
  %118 = fmul double %117, %4
  %119 = fmul double 0x406C6E9B7993867B, %115
  %120 = fmul double %119, %118
  %121 = fadd double %108, %120
  %122 = fmul double %3, %3
  %123 = fmul double %122, %3
  %124 = fmul double %123, %3
  %125 = fmul double %124, %3
  %126 = fmul double %125, %3
  %127 = fmul double %126, %3
  %128 = fmul double %127, %3
  %129 = fmul double %128, %3
  %130 = fmul double %4, %4
  %131 = fmul double %130, %4
  %132 = fmul double 0x40599AAEED930D74, %129
  %133 = fmul double %132, %131
  %134 = fadd double %121, %133
  %135 = fmul double %3, %3
  %136 = fmul double %135, %3
  %137 = fmul double %136, %3
  %138 = fmul double %137, %3
  %139 = fmul double %138, %3
  %140 = fmul double %139, %3
  %141 = fmul double %140, %3
  %142 = fmul double %141, %3
  %143 = fmul double %142, %3
  %144 = fmul double %4, %4
  %145 = fmul double 0x4041F26BA07C51D9, %143
  %146 = fmul double %145, %144
  %147 = fadd double %134, %146
  %148 = fmul double %3, %3
  %149 = fmul double %148, %3
  %150 = fmul double %149, %3
  %151 = fmul double %150, %3
  %152 = fmul double %151, %3
  %153 = fmul double %152, %3
  %154 = fmul double %153, %3
  %155 = fmul double %154, %3
  %156 = fmul double %155, %3
  %157 = fmul double %156, %3
  %158 = fmul double 0x401B334D1A8C508E, %157
  %159 = fmul double %158, %4
  %160 = fadd double %147, %159
  %161 = fmul double %3, %3
  %162 = fmul double %161, %3
  %163 = fmul double %162, %3
  %164 = fmul double %163, %3
  %165 = fmul double %164, %3
  %166 = fmul double %165, %3
  %167 = fmul double %166, %3
  %168 = fmul double %167, %3
  %169 = fmul double %168, %3
  %170 = fmul double %169, %3
  %171 = fmul double %170, %3
  %172 = fmul double 1.000000e+00, %171
  %173 = fmul double %172, 1.000000e+00
  %174 = fadd double %160, %173
  %175 = fmul double %4, %4
  %176 = fmul double %175, %4
  %177 = fmul double %176, %4
  %178 = fmul double %177, %4
  %179 = fmul double %178, %4
  %180 = fmul double %179, %4
  %181 = fmul double %180, %4
  %182 = fmul double %181, %4
  %183 = fmul double %182, %4
  %184 = fmul double %183, %4
  %185 = fmul double 0x3FE5D9F715BA0C8C, %184
  %186 = fadd double 0.000000e+00, %185
  %187 = fmul double %4, %4
  %188 = fmul double %187, %4
  %189 = fmul double %188, %4
  %190 = fmul double %189, %4
  %191 = fmul double %190, %4
  %192 = fmul double %191, %4
  %193 = fmul double %192, %4
  %194 = fmul double %193, %4
  %195 = fmul double %194, %4
  %196 = fmul double 0x40249F6E6A4C1EA7, %3
  %197 = fmul double %196, %195
  %198 = fadd double %186, %197
  %199 = fmul double %3, %3
  %200 = fmul double %4, %4
  %201 = fmul double %200, %4
  %202 = fmul double %201, %4
  %203 = fmul double %202, %4
  %204 = fmul double %203, %4
  %205 = fmul double %204, %4
  %206 = fmul double %205, %4
  %207 = fmul double %206, %4
  %208 = fmul double 0x4034CB2B4768D45A, %199
  %209 = fmul double %208, %207
  %210 = fadd double %198, %209
  %211 = fmul double %3, %3
  %212 = fmul double %211, %3
  %213 = fmul double %4, %4
  %214 = fmul double %213, %4
  %215 = fmul double %214, %4
  %216 = fmul double %215, %4
  %217 = fmul double %216, %4
  %218 = fmul double %217, %4
  %219 = fmul double %218, %4
  %220 = fmul double 0x4061454F73FC821F, %212
  %221 = fmul double %220, %219
  %222 = fadd double %210, %221
  %223 = fmul double %3, %3
  %224 = fmul double %223, %3
  %225 = fmul double %224, %3
  %226 = fmul double %4, %4
  %227 = fmul double %226, %4
  %228 = fmul double %227, %4
  %229 = fmul double %228, %4
  %230 = fmul double %229, %4
  %231 = fmul double %230, %4
  %232 = fmul double 0x406F37072ED3624C, %225
  %233 = fmul double %232, %231
  %234 = fadd double %222, %233
  %235 = fmul double %3, %3
  %236 = fmul double %235, %3
  %237 = fmul double %236, %3
  %238 = fmul double %237, %3
  %239 = fmul double %4, %4
  %240 = fmul double %239, %4
  %241 = fmul double %240, %4
  %242 = fmul double %241, %4
  %243 = fmul double %242, %4
  %244 = fmul double 0x406689F0D92DBA2E, %238
  %245 = fmul double %244, %243
  %246 = fadd double %234, %245
  %247 = fmul double %3, %3
  %248 = fmul double %247, %3
  %249 = fmul double %248, %3
  %250 = fmul double %249, %3
  %251 = fmul double %250, %3
  %252 = fmul double %4, %4
  %253 = fmul double %252, %4
  %254 = fmul double %253, %4
  %255 = fmul double %254, %4
  %256 = fmul double 0x4070DDE14BC533C2, %251
  %257 = fmul double %256, %255
  %258 = fadd double %246, %257
  %259 = fmul double %3, %3
  %260 = fmul double %259, %3
  %261 = fmul double %260, %3
  %262 = fmul double %261, %3
  %263 = fmul double %262, %3
  %264 = fmul double %263, %3
  %265 = fmul double %4, %4
  %266 = fmul double %265, %4
  %267 = fmul double %266, %4
  %268 = fmul double 0x4073899233368D4E, %264
  %269 = fmul double %268, %267
  %270 = fadd double %258, %269
  %271 = fmul double %3, %3
  %272 = fmul double %271, %3
  %273 = fmul double %272, %3
  %274 = fmul double %273, %3
  %275 = fmul double %274, %3
  %276 = fmul double %275, %3
  %277 = fmul double %276, %3
  %278 = fmul double %4, %4
  %279 = fmul double %278, %4
  %280 = fmul double 0x4027DA546C7A29CE, %277
  %281 = fmul double %280, %279
  %282 = fadd double %270, %281
  %283 = fmul double %3, %3
  %284 = fmul double %283, %3
  %285 = fmul double %284, %3
  %286 = fmul double %285, %3
  %287 = fmul double %286, %3
  %288 = fmul double %287, %3
  %289 = fmul double %288, %3
  %290 = fmul double %289, %3
  %291 = fmul double %4, %4
  %292 = fmul double 0x4049D81AB368E1C7, %290
  %293 = fmul double %292, %291
  %294 = fadd double %282, %293
  %295 = fmul double %3, %3
  %296 = fmul double %295, %3
  %297 = fmul double %296, %3
  %298 = fmul double %297, %3
  %299 = fmul double %298, %3
  %300 = fmul double %299, %3
  %301 = fmul double %300, %3
  %302 = fmul double %301, %3
  %303 = fmul double %302, %3
  %304 = fmul double 0x40081B2C3884B10E, %303
  %305 = fmul double %304, %4
  %306 = fadd double %294, %305
  %307 = fmul double %3, %3
  %308 = fmul double %307, %3
  %309 = fmul double %308, %3
  %310 = fmul double %309, %3
  %311 = fmul double %310, %3
  %312 = fmul double %311, %3
  %313 = fmul double %312, %3
  %314 = fmul double %313, %3
  %315 = fmul double %314, %3
  %316 = fmul double %315, %3
  %317 = fmul double 0x4014CCB2E573AF72, %316
  %318 = fmul double %317, 1.000000e+00
  %319 = fadd double %306, %318
  %320 = fsub double %174, %u
  %321 = fmul double %319, 0x401321C3E3C5A901
  %322 = fdiv double %320, %321
  %323 = fsub double %0, %322
  %324 = add i32 %1, 1
  %325 = icmp eq i32 %324, 16
  br i1 %325, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %323
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
