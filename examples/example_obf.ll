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
  %sitofp_to_double = sitofp i64 %0 to double
  %3 = fmul double %sitofp_to_double, 0x4000000000000
  %4 = call double @sample_bernstein_newtonraphson_1(double %3)
  %5 = fcmp olt double %4, 0x40455F1ABF7B05ED
  br i1 %5, label %always_hit, label %never_hit

always_hit:                                       ; preds = %1
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i64 %0, ptr %2, align 8
  call void @llvm.dbg.declare(metadata ptr %2, metadata !62, metadata !DIExpression()), !dbg !63
  %10 = load i64, ptr %2, align 8, !dbg !64
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %10), !dbg !65
  call void @llvm.dbg.declare(metadata ptr %6, metadata !66, metadata !DIExpression()), !dbg !68
  store volatile i32 1, ptr %6, align 4, !dbg !68
  call void @llvm.dbg.declare(metadata ptr %7, metadata !69, metadata !DIExpression()), !dbg !70
  store volatile i32 2, ptr %7, align 4, !dbg !70
  call void @llvm.dbg.declare(metadata ptr %8, metadata !71, metadata !DIExpression()), !dbg !72
  %12 = load volatile i32, ptr %6, align 4, !dbg !73
  %13 = load volatile i32, ptr %7, align 4, !dbg !74
  %14 = srem i32 %12, %13, !dbg !75
  store volatile i32 %14, ptr %8, align 4, !dbg !72
  call void @llvm.dbg.declare(metadata ptr %9, metadata !76, metadata !DIExpression()), !dbg !77
  %15 = load volatile i32, ptr %8, align 4, !dbg !78
  %16 = load volatile i32, ptr %7, align 4, !dbg !79
  %17 = load volatile i32, ptr %6, align 4, !dbg !80
  %18 = mul nsw i32 %16, %17, !dbg !81
  %19 = add nsw i32 %15, %18, !dbg !82
  store volatile i32 %19, ptr %9, align 4, !dbg !77
  ret void, !dbg !83

never_hit:                                        ; preds = %1
  ret void
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
define double @sample_bernstein_newtonraphson_1(double %u) #4 {
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  %0 = phi double [ 0x40455D3FED6593E5, %entry ], [ %379, %loop ]
  %1 = phi i32 [ 0, %entry ], [ %380, %loop ]
  %2 = fsub double %0, 0x40455B590E0C01EA
  %3 = fmul double %2, 0x4040D3651E760C9B
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
  %16 = fmul double %15, %4
  %17 = fmul double 0.000000e+00, %16
  %18 = fadd double 0.000000e+00, %17
  %19 = fmul double %4, %4
  %20 = fmul double %19, %4
  %21 = fmul double %20, %4
  %22 = fmul double %21, %4
  %23 = fmul double %22, %4
  %24 = fmul double %23, %4
  %25 = fmul double %24, %4
  %26 = fmul double %25, %4
  %27 = fmul double %26, %4
  %28 = fmul double %27, %4
  %29 = fmul double %28, %4
  %30 = fmul double 0x3FE0173BE855297D, %3
  %31 = fmul double %30, %29
  %32 = fadd double %18, %31
  %33 = fmul double %3, %3
  %34 = fmul double %4, %4
  %35 = fmul double %34, %4
  %36 = fmul double %35, %4
  %37 = fmul double %36, %4
  %38 = fmul double %37, %4
  %39 = fmul double %38, %4
  %40 = fmul double %39, %4
  %41 = fmul double %40, %4
  %42 = fmul double %41, %4
  %43 = fmul double %42, %4
  %44 = fmul double 0x40129E0042C61167, %33
  %45 = fmul double %44, %43
  %46 = fadd double %32, %45
  %47 = fmul double %3, %3
  %48 = fmul double %47, %3
  %49 = fmul double %4, %4
  %50 = fmul double %49, %4
  %51 = fmul double %50, %4
  %52 = fmul double %51, %4
  %53 = fmul double %52, %4
  %54 = fmul double %53, %4
  %55 = fmul double %54, %4
  %56 = fmul double %55, %4
  %57 = fmul double %56, %4
  %58 = fmul double 0x403852125E61D409, %48
  %59 = fmul double %58, %57
  %60 = fadd double %46, %59
  %61 = fmul double %3, %3
  %62 = fmul double %61, %3
  %63 = fmul double %62, %3
  %64 = fmul double %4, %4
  %65 = fmul double %64, %4
  %66 = fmul double %65, %4
  %67 = fmul double %66, %4
  %68 = fmul double %67, %4
  %69 = fmul double %68, %4
  %70 = fmul double %69, %4
  %71 = fmul double %70, %4
  %72 = fmul double 0x40526CE31221F577, %63
  %73 = fmul double %72, %71
  %74 = fadd double %60, %73
  %75 = fmul double %3, %3
  %76 = fmul double %75, %3
  %77 = fmul double %76, %3
  %78 = fmul double %77, %3
  %79 = fmul double %4, %4
  %80 = fmul double %79, %4
  %81 = fmul double %80, %4
  %82 = fmul double %81, %4
  %83 = fmul double %82, %4
  %84 = fmul double %83, %4
  %85 = fmul double %84, %4
  %86 = fmul double 0x406456C20C8469C7, %78
  %87 = fmul double %86, %85
  %88 = fadd double %74, %87
  %89 = fmul double %3, %3
  %90 = fmul double %89, %3
  %91 = fmul double %90, %3
  %92 = fmul double %91, %3
  %93 = fmul double %92, %3
  %94 = fmul double %4, %4
  %95 = fmul double %94, %4
  %96 = fmul double %95, %4
  %97 = fmul double %96, %4
  %98 = fmul double %97, %4
  %99 = fmul double %98, %4
  %100 = fmul double 0x4074A69D04DF88A4, %93
  %101 = fmul double %100, %99
  %102 = fadd double %88, %101
  %103 = fmul double %3, %3
  %104 = fmul double %103, %3
  %105 = fmul double %104, %3
  %106 = fmul double %105, %3
  %107 = fmul double %106, %3
  %108 = fmul double %107, %3
  %109 = fmul double %4, %4
  %110 = fmul double %109, %4
  %111 = fmul double %110, %4
  %112 = fmul double %111, %4
  %113 = fmul double %112, %4
  %114 = fmul double 0x40752A8C2643159B, %108
  %115 = fmul double %114, %113
  %116 = fadd double %102, %115
  %117 = fmul double %3, %3
  %118 = fmul double %117, %3
  %119 = fmul double %118, %3
  %120 = fmul double %119, %3
  %121 = fmul double %120, %3
  %122 = fmul double %121, %3
  %123 = fmul double %122, %3
  %124 = fmul double %4, %4
  %125 = fmul double %124, %4
  %126 = fmul double %125, %4
  %127 = fmul double %126, %4
  %128 = fmul double 0x4070AC554D483BFB, %123
  %129 = fmul double %128, %127
  %130 = fadd double %116, %129
  %131 = fmul double %3, %3
  %132 = fmul double %131, %3
  %133 = fmul double %132, %3
  %134 = fmul double %133, %3
  %135 = fmul double %134, %3
  %136 = fmul double %135, %3
  %137 = fmul double %136, %3
  %138 = fmul double %137, %3
  %139 = fmul double %4, %4
  %140 = fmul double %139, %4
  %141 = fmul double %140, %4
  %142 = fmul double 0x4062AC0B7E6FE599, %138
  %143 = fmul double %142, %141
  %144 = fadd double %130, %143
  %145 = fmul double %3, %3
  %146 = fmul double %145, %3
  %147 = fmul double %146, %3
  %148 = fmul double %147, %3
  %149 = fmul double %148, %3
  %150 = fmul double %149, %3
  %151 = fmul double %150, %3
  %152 = fmul double %151, %3
  %153 = fmul double %152, %3
  %154 = fmul double %4, %4
  %155 = fmul double %154, %4
  %156 = fmul double 0x4050661B37A32550, %153
  %157 = fmul double %156, %155
  %158 = fadd double %144, %157
  %159 = fmul double %3, %3
  %160 = fmul double %159, %3
  %161 = fmul double %160, %3
  %162 = fmul double %161, %3
  %163 = fmul double %162, %3
  %164 = fmul double %163, %3
  %165 = fmul double %164, %3
  %166 = fmul double %165, %3
  %167 = fmul double %166, %3
  %168 = fmul double %167, %3
  %169 = fmul double %4, %4
  %170 = fmul double 0x4036C28F611432CD, %168
  %171 = fmul double %170, %169
  %172 = fadd double %158, %171
  %173 = fmul double %3, %3
  %174 = fmul double %173, %3
  %175 = fmul double %174, %3
  %176 = fmul double %175, %3
  %177 = fmul double %176, %3
  %178 = fmul double %177, %3
  %179 = fmul double %178, %3
  %180 = fmul double %179, %3
  %181 = fmul double %180, %3
  %182 = fmul double %181, %3
  %183 = fmul double %182, %3
  %184 = fmul double 0x4011624886B3CCF6, %183
  %185 = fmul double %184, %4
  %186 = fadd double %172, %185
  %187 = fmul double %3, %3
  %188 = fmul double %187, %3
  %189 = fmul double %188, %3
  %190 = fmul double %189, %3
  %191 = fmul double %190, %3
  %192 = fmul double %191, %3
  %193 = fmul double %192, %3
  %194 = fmul double %193, %3
  %195 = fmul double %194, %3
  %196 = fmul double %195, %3
  %197 = fmul double %196, %3
  %198 = fmul double %197, %3
  %199 = fmul double 1.000000e+00, %198
  %200 = fmul double %199, 1.000000e+00
  %201 = fadd double %186, %200
  %202 = fmul double %4, %4
  %203 = fmul double %202, %4
  %204 = fmul double %203, %4
  %205 = fmul double %204, %4
  %206 = fmul double %205, %4
  %207 = fmul double %206, %4
  %208 = fmul double %207, %4
  %209 = fmul double %208, %4
  %210 = fmul double %209, %4
  %211 = fmul double %210, %4
  %212 = fmul double %211, %4
  %213 = fmul double 0x3FE0173BE855297D, %212
  %214 = fadd double 0.000000e+00, %213
  %215 = fmul double %4, %4
  %216 = fmul double %215, %4
  %217 = fmul double %216, %4
  %218 = fmul double %217, %4
  %219 = fmul double %218, %4
  %220 = fmul double %219, %4
  %221 = fmul double %220, %4
  %222 = fmul double %221, %4
  %223 = fmul double %222, %4
  %224 = fmul double %223, %4
  %225 = fmul double 0x400A324D5218C924, %3
  %226 = fmul double %225, %224
  %227 = fadd double %214, %226
  %228 = fmul double %3, %3
  %229 = fmul double %4, %4
  %230 = fmul double %229, %4
  %231 = fmul double %230, %4
  %232 = fmul double %231, %4
  %233 = fmul double %232, %4
  %234 = fmul double %233, %4
  %235 = fmul double %234, %4
  %236 = fmul double %235, %4
  %237 = fmul double %236, %4
  %238 = fmul double 0x4035C3B66384CC40, %228
  %239 = fmul double %238, %237
  %240 = fadd double %227, %239
  %241 = fmul double %3, %3
  %242 = fmul double %241, %3
  %243 = fmul double %4, %4
  %244 = fmul double %243, %4
  %245 = fmul double %244, %4
  %246 = fmul double %245, %4
  %247 = fmul double %246, %4
  %248 = fmul double %247, %4
  %249 = fmul double %248, %4
  %250 = fmul double %249, %4
  %251 = fmul double 0x4049CCBCB926878C, %242
  %252 = fmul double %251, %250
  %253 = fadd double %240, %252
  %254 = fmul double %3, %3
  %255 = fmul double %254, %3
  %256 = fmul double %255, %3
  %257 = fmul double %4, %4
  %258 = fmul double %257, %4
  %259 = fmul double %258, %4
  %260 = fmul double %259, %4
  %261 = fmul double %260, %4
  %262 = fmul double %261, %4
  %263 = fmul double %262, %4
  %264 = fmul double 0x4062C7CC6CFD4049, %256
  %265 = fmul double %264, %263
  %266 = fadd double %253, %265
  %267 = fmul double %3, %3
  %268 = fmul double %267, %3
  %269 = fmul double %268, %3
  %270 = fmul double %269, %3
  %271 = fmul double %4, %4
  %272 = fmul double %271, %4
  %273 = fmul double %272, %4
  %274 = fmul double %273, %4
  %275 = fmul double %274, %4
  %276 = fmul double %275, %4
  %277 = fmul double 0x40854652F595C65F, %270
  %278 = fmul double %277, %276
  %279 = fadd double %266, %278
  %280 = fmul double %3, %3
  %281 = fmul double %280, %3
  %282 = fmul double %281, %3
  %283 = fmul double %282, %3
  %284 = fmul double %283, %3
  %285 = fmul double %4, %4
  %286 = fmul double %285, %4
  %287 = fmul double %286, %4
  %288 = fmul double %287, %4
  %289 = fmul double %288, %4
  %290 = fmul double 0x404CDC4F4DC6D5E3, %284
  %291 = fmul double %290, %289
  %292 = fadd double %279, %291
  %293 = fmul double %3, %3
  %294 = fmul double %293, %3
  %295 = fmul double %294, %3
  %296 = fmul double %295, %3
  %297 = fmul double %296, %3
  %298 = fmul double %297, %3
  %299 = fmul double %4, %4
  %300 = fmul double %299, %4
  %301 = fmul double %300, %4
  %302 = fmul double %301, %4
  %303 = fmul double 0x40598D8612BD78E6, %298
  %304 = fmul double %303, %302
  %305 = fadd double %292, %304
  %306 = fmul double %3, %3
  %307 = fmul double %306, %3
  %308 = fmul double %307, %3
  %309 = fmul double %308, %3
  %310 = fmul double %309, %3
  %311 = fmul double %310, %3
  %312 = fmul double %311, %3
  %313 = fmul double %4, %4
  %314 = fmul double %313, %4
  %315 = fmul double %314, %4
  %316 = fmul double 0x40251126D1CBA93A, %312
  %317 = fmul double %316, %315
  %318 = fadd double %305, %317
  %319 = fmul double %3, %3
  %320 = fmul double %319, %3
  %321 = fmul double %320, %3
  %322 = fmul double %321, %3
  %323 = fmul double %322, %3
  %324 = fmul double %323, %3
  %325 = fmul double %324, %3
  %326 = fmul double %325, %3
  %327 = fmul double %4, %4
  %328 = fmul double %327, %4
  %329 = fmul double 0x404D396871C090B3, %326
  %330 = fmul double %329, %328
  %331 = fadd double %318, %330
  %332 = fmul double %3, %3
  %333 = fmul double %332, %3
  %334 = fmul double %333, %3
  %335 = fmul double %334, %3
  %336 = fmul double %335, %3
  %337 = fmul double %336, %3
  %338 = fmul double %337, %3
  %339 = fmul double %338, %3
  %340 = fmul double %339, %3
  %341 = fmul double %4, %4
  %342 = fmul double 0x404AC971481C3784, %340
  %343 = fmul double %342, %341
  %344 = fadd double %331, %343
  %345 = fmul double %3, %3
  %346 = fmul double %345, %3
  %347 = fmul double %346, %3
  %348 = fmul double %347, %3
  %349 = fmul double %348, %3
  %350 = fmul double %349, %3
  %351 = fmul double %350, %3
  %352 = fmul double %351, %3
  %353 = fmul double %352, %3
  %354 = fmul double %353, %3
  %355 = fmul double 0x401A86EB47CC0526, %354
  %356 = fmul double %355, %4
  %357 = fadd double %344, %356
  %358 = fmul double %3, %3
  %359 = fmul double %358, %3
  %360 = fmul double %359, %3
  %361 = fmul double %360, %3
  %362 = fmul double %361, %3
  %363 = fmul double %362, %3
  %364 = fmul double %363, %3
  %365 = fmul double %364, %3
  %366 = fmul double %365, %3
  %367 = fmul double %366, %3
  %368 = fmul double %367, %3
  %369 = fmul double 0x40214EDBBCA61985, %368
  %370 = fmul double %369, 1.000000e+00
  %371 = fadd double %357, %370
  %372 = fsub double %201, %u
  %373 = fmul double %371, 0x4040D3651E760C9B
  %374 = fdiv double %372, %373
  %375 = fsub double %0, %374
  %376 = fcmp ogt double %375, 0x40455F26CCBF25DF
  %377 = select i1 %376, double 0x40455F26CCBF25DF, double %375
  %378 = fcmp olt double %377, 0x40455B590E0C01EA
  %379 = select i1 %378, double 0x40455B590E0C01EA, double %377
  %380 = add i32 %1, 1
  %381 = icmp eq i32 %380, 16
  br i1 %381, label %exit, label %loop

exit:                                             ; preds = %loop
  ret double %375
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
