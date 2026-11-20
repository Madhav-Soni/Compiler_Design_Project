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

2:                                                ; preds = %6, %0
  %3 = phi i64 [ %8, %6 ], [ 0, %0 ]
  %4 = phi i32 [ %9, %6 ], [ 0, %0 ]
  %5 = icmp slt i32 %4, 10000000
  br i1 %5, label %6, label %10

6:                                                ; preds = %2
  %7 = sext i32 %4 to i64
  %8 = add nsw i64 %3, %7
  %9 = add nsw i32 %4, 1
  br label %2, !llvm.loop !5

10:                                               ; preds = %2
  br label %11

11:                                               ; preds = %14, %10
  %12 = phi i32 [ %18, %14 ], [ 0, %10 ]
  %13 = icmp slt i32 %12, 1000
  br i1 %13, label %14, label %19

14:                                               ; preds = %11
  %15 = mul nsw i32 %12, 2
  %16 = sext i32 %12 to i64
  %17 = getelementptr inbounds [1000 x i32], ptr %1, i64 0, i64 %16
  store i32 %15, ptr %17, align 4
  %18 = add nsw i32 %12, 1
  br label %11, !llvm.loop !7

19:                                               ; preds = %11
  br label %20

20:                                               ; preds = %24, %19
  %21 = phi i64 [ %29, %24 ], [ 0, %19 ]
  %22 = phi i32 [ %30, %24 ], [ 0, %19 ]
  %23 = icmp slt i32 %22, 1000
  br i1 %23, label %24, label %31

24:                                               ; preds = %20
  %25 = sext i32 %22 to i64
  %26 = getelementptr inbounds [1000 x i32], ptr %1, i64 0, i64 %25
  %27 = load i32, ptr %26, align 4
  %28 = sext i32 %27 to i64
  %29 = add nsw i64 %21, %28
  %30 = add nsw i32 %22, 1
  br label %20, !llvm.loop !8

31:                                               ; preds = %20
  %32 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %3)
  %33 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef 400)
  %34 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef 70)
  %35 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i64 noundef %21)
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
