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

2:                                                ; preds = %4, %0
  %.02 = phi i32 [ 0, %0 ], [ %7, %4 ]
  %.01 = phi i64 [ 0, %0 ], [ %6, %4 ]
  %3 = icmp slt i32 %.02, 10000000
  br i1 %3, label %4, label %8

4:                                                ; preds = %2
  %5 = sext i32 %.02 to i64
  %6 = add nsw i64 %.01, %5
  %7 = add nsw i32 %.02, 1
  br label %2, !llvm.loop !5

8:                                                ; preds = %2
  br label %9

9:                                                ; preds = %11, %8
  %.04 = phi i32 [ 0, %8 ], [ %15, %11 ]
  %10 = icmp slt i32 %.04, 1000
  br i1 %10, label %11, label %16

11:                                               ; preds = %9
  %12 = mul nsw i32 %.04, 2
  %13 = sext i32 %.04 to i64
  %14 = getelementptr inbounds [1000 x i32], ptr %1, i64 0, i64 %13
  store i32 %12, ptr %14, align 4
  %15 = add nsw i32 %.04, 1
  br label %9, !llvm.loop !7

16:                                               ; preds = %9
  br label %17

17:                                               ; preds = %19, %16
  %.03 = phi i64 [ 0, %16 ], [ %24, %19 ]
  %.0 = phi i32 [ 0, %16 ], [ %25, %19 ]
  %18 = icmp slt i32 %.0, 1000
  br i1 %18, label %19, label %26

19:                                               ; preds = %17
  %20 = sext i32 %.0 to i64
  %21 = getelementptr inbounds [1000 x i32], ptr %1, i64 0, i64 %20
  %22 = load i32, ptr %21, align 4
  %23 = sext i32 %22 to i64
  %24 = add nsw i64 %.03, %23
  %25 = add nsw i32 %.0, 1
  br label %17, !llvm.loop !8

26:                                               ; preds = %17
  %27 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %.01)
  %28 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef 400)
  %29 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef 70)
  %30 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i64 noundef %.03)
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
