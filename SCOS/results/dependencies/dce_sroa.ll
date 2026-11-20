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
  %.023 = phi i32 [ 0, %0 ], [ %8, %7 ]
  %.022 = phi i64 [ 0, %0 ], [ %6, %7 ]
  %3 = icmp slt i32 %.023, 10000000
  br i1 %3, label %4, label %9

4:                                                ; preds = %2
  %5 = sext i32 %.023 to i64
  %6 = add nsw i64 %.022, %5
  br label %7

7:                                                ; preds = %4
  %8 = add nsw i32 %.023, 1
  br label %2, !llvm.loop !5

9:                                                ; preds = %2
  %10 = mul nsw i32 10, 20
  %11 = mul nsw i32 10, 20
  %12 = add nsw i32 %10, %11
  br label %13

13:                                               ; preds = %19, %9
  %.021 = phi i32 [ 0, %9 ], [ %20, %19 ]
  %14 = icmp slt i32 %.021, 1000
  br i1 %14, label %15, label %21

15:                                               ; preds = %13
  %16 = mul nsw i32 %.021, 2
  %17 = sext i32 %.021 to i64
  %18 = getelementptr inbounds [1000 x i32], ptr %1, i64 0, i64 %17
  store i32 %16, ptr %18, align 4
  br label %19

19:                                               ; preds = %15
  %20 = add nsw i32 %.021, 1
  br label %13, !llvm.loop !7

21:                                               ; preds = %13
  br label %22

22:                                               ; preds = %30, %21
  %.020 = phi i64 [ 0, %21 ], [ %29, %30 ]
  %.0 = phi i32 [ 0, %21 ], [ %31, %30 ]
  %23 = icmp slt i32 %.0, 1000
  br i1 %23, label %24, label %32

24:                                               ; preds = %22
  %25 = sext i32 %.0 to i64
  %26 = getelementptr inbounds [1000 x i32], ptr %1, i64 0, i64 %25
  %27 = load i32, ptr %26, align 4
  %28 = sext i32 %27 to i64
  %29 = add nsw i64 %.020, %28
  br label %30

30:                                               ; preds = %24
  %31 = add nsw i32 %.0, 1
  br label %22, !llvm.loop !8

32:                                               ; preds = %22
  %33 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %.022)
  %34 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %12)
  %35 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef 70)
  %36 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i64 noundef %.020)
  ret i32 0
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }

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
