; ModuleID = '/Users/madhav/Desktop/CD_PROJECT/SCOS/results/benchmark_pass_input.ll'
source_filename = "benchmarks/benchmark.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@.str = private unnamed_addr constant [16 x i8] c"Loop sum: %lld\0A\00", align 1
@.str.1 = private unnamed_addr constant [26 x i8] c"Repeated calculation: %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [21 x i8] c"Constant result: %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"Array sum: %lld\0A\00", align 1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca [1000 x i32], align 4
  br label %2

2:                                                ; preds = %7, %0
  %.0 = phi i64 [ 0, %0 ], [ %6, %7 ]
  %storemerge = phi i32 [ 0, %0 ], [ %8, %7 ]
  %3 = icmp slt i32 %storemerge, 10000000
  br i1 %3, label %4, label %9

4:                                                ; preds = %2
  %5 = sext i32 %storemerge to i64
  %6 = add nsw i64 %.0, %5
  br label %7

7:                                                ; preds = %4
  %8 = add nsw i32 %storemerge, 1
  br label %2, !llvm.loop !5

9:                                                ; preds = %2
  br label %10

10:                                               ; preds = %16, %9
  %storemerge1 = phi i32 [ 0, %9 ], [ %17, %16 ]
  %11 = icmp slt i32 %storemerge1, 1000
  br i1 %11, label %12, label %18

12:                                               ; preds = %10
  %13 = shl nsw i32 %storemerge1, 1
  %14 = sext i32 %storemerge1 to i64
  %15 = getelementptr inbounds [4 x i8], ptr %1, i64 %14
  store i32 %13, ptr %15, align 4
  br label %16

16:                                               ; preds = %12
  %17 = add nsw i32 %storemerge1, 1
  br label %10, !llvm.loop !7

18:                                               ; preds = %10
  br label %19

19:                                               ; preds = %27, %18
  %.03 = phi i64 [ 0, %18 ], [ %26, %27 ]
  %storemerge2 = phi i32 [ 0, %18 ], [ %28, %27 ]
  %20 = icmp slt i32 %storemerge2, 1000
  br i1 %20, label %21, label %29

21:                                               ; preds = %19
  %22 = sext i32 %storemerge2 to i64
  %23 = getelementptr inbounds [4 x i8], ptr %1, i64 %22
  %24 = load i32, ptr %23, align 4
  %25 = sext i32 %24 to i64
  %26 = add nsw i64 %.03, %25
  br label %27

27:                                               ; preds = %21
  %28 = add nsw i32 %storemerge2, 1
  br label %19, !llvm.loop !8

29:                                               ; preds = %19
  %30 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %.0) #2
  %31 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef 400) #2
  %32 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i32 noundef 70) #2
  %33 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.3, i64 noundef %.03) #2
  ret i32 0
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 2]}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 1}
!3 = !{i32 7, !"frame-pointer", i32 4}
!4 = !{!"Homebrew clang version 23.1.6"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
