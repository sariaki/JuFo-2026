; ModuleID = './example.cpp'
source_filename = "./example.cpp"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.36.32535"

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef i32 @"?foo@@YAHXZ"() #0 !dbg !9 {
  %1 = alloca i32, align 4
    #dbg_declare(ptr %1, !15, !DIExpression(), !17)
  store volatile i32 0, ptr %1, align 4, !dbg !17
  %2 = load atomic volatile i32, ptr %1 acquire, align 4, !dbg !18
  ret i32 %2, !dbg !18
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef i32 @"?bar@@YAHXZ"() #0 !dbg !19 {
  %1 = alloca i32, align 4
    #dbg_declare(ptr %1, !20, !DIExpression(), !21)
  store volatile i32 1, ptr %1, align 4, !dbg !21
  %2 = load atomic volatile i32, ptr %1 acquire, align 4, !dbg !22
  ret i32 %2, !dbg !22
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local noundef i32 @main() #1 !dbg !23 {
  %1 = alloca i32, align 4
    #dbg_declare(ptr %1, !24, !DIExpression(), !25)
  %2 = call noundef i32 @"?foo@@YAHXZ"(), !dbg !25
  store volatile i32 %2, ptr %1, align 4, !dbg !25
  %3 = call noundef i32 @"?bar@@YAHXZ"(), !dbg !26
  store atomic volatile i32 %3, ptr %1 release, align 4, !dbg !26
  ret i32 0, !dbg !27
}

attributes #0 = { mustprogress noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "clang version 20.1.4", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "example.cpp", directory: "C:\\Users\\sariaki\\Documents\\code\\py\\JuFo-2026\\examples", checksumkind: CSK_MD5, checksum: "926a58c4573f2bedde6340fb8bd0381b")
!2 = !{i32 2, !"CodeView", i32 1}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 2}
!5 = !{i32 8, !"PIC Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 1, !"MaxTLSAlign", i32 65536}
!8 = !{!"clang version 20.1.4"}
!9 = distinct !DISubprogram(name: "foo", linkageName: "?foo@@YAHXZ", scope: !10, file: !10, line: 1, type: !11, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!10 = !DIFile(filename: "./example.cpp", directory: "C:\\Users\\sariaki\\Documents\\code\\py\\JuFo-2026\\examples", checksumkind: CSK_MD5, checksum: "926a58c4573f2bedde6340fb8bd0381b")
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !{}
!15 = !DILocalVariable(name: "x", scope: !9, file: !10, line: 3, type: !16)
!16 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !13)
!17 = !DILocation(line: 3, scope: !9)
!18 = !DILocation(line: 4, scope: !9)
!19 = distinct !DISubprogram(name: "bar", linkageName: "?bar@@YAHXZ", scope: !10, file: !10, line: 7, type: !11, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!20 = !DILocalVariable(name: "x", scope: !19, file: !10, line: 9, type: !16)
!21 = !DILocation(line: 9, scope: !19)
!22 = !DILocation(line: 10, scope: !19)
!23 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 13, type: !11, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!24 = !DILocalVariable(name: "x", scope: !23, file: !10, line: 15, type: !16)
!25 = !DILocation(line: 15, scope: !23)
!26 = !DILocation(line: 16, scope: !23)
!27 = !DILocation(line: 18, scope: !23)
