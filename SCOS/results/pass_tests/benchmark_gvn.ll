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
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca [1000 x i32], align 4
  %9 = alloca i32, align 4
  %10 = alloca i64, align 8
  %11 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i64 0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  br label %12

12:                                               ; preds = %16, %0
  %13 = phi i64 [ %18, %16 ], [ 0, %0 ]
  %14 = phi i32 [ %19, %16 ], [ 0, %0 ]
  %15 = icmp slt i32 %14, 10000000
  br i1 %15, label %16, label %20

16:                                               ; preds = %12
  %17 = sext i32 %14 to i64
  %18 = add nsw i64 %13, %17
  store i64 %18, ptr %2, align 8
  %19 = add nsw i32 %14, 1
  store i32 %19, ptr %3, align 4
  br label %12, !llvm.loop !5

20:                                               ; preds = %12
  store i32 10, ptr %4, align 4
  store i32 20, ptr %5, align 4
  store i32 400, ptr %6, align 4
  store i32 70, ptr %7, align 4
  store i32 0, ptr %9, align 4
  br label %21

21:                                               ; preds = %24, %20
  %22 = phi i32 [ %28, %24 ], [ 0, %20 ]
  %23 = icmp slt i32 %22, 1000
  br i1 %23, label %24, label %29

24:                                               ; preds = %21
  %25 = mul nsw i32 %22, 2
  %26 = sext i32 %22 to i64
  %27 = getelementptr inbounds [1000 x i32], ptr %8, i64 0, i64 %26
  store i32 %25, ptr %27, align 4
  %28 = add nsw i32 %22, 1
  store i32 %28, ptr %9, align 4
  br label %21, !llvm.loop !7

29:                                               ; preds = %21
  store i64 0, ptr %10, align 8
  store i32 0, ptr %11, align 4
  br label %30

30:                                               ; preds = %34, %29
  %31 = phi i64 [ %39, %34 ], [ 0, %29 ]
  %32 = phi i32 [ %40, %34 ], [ 0, %29 ]
  %33 = icmp slt i32 %32, 1000
  br i1 %33, label %34, label %41

34:                                               ; preds = %30
  %35 = sext i32 %32 to i64
  %36 = getelementptr inbounds [1000 x i32], ptr %8, i64 0, i64 %35
  %37 = load i32, ptr %36, align 4
  %38 = sext i32 %37 to i64
  %39 = add nsw i64 %31, %38
  store i64 %39, ptr %10, align 8
  %40 = add nsw i32 %32, 1
  store i32 %40, ptr %11, align 4
  br label %30, !llvm.loop !8

41:                                               ; preds = %30
  %42 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %13)
  %43 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef 400)
  %44 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef 70)
  %45 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i64 noundef %31)
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
