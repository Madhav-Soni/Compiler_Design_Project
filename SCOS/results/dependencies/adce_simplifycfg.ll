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

12:                                               ; preds = %15, %0
  %13 = load i32, ptr %3, align 4
  %14 = icmp slt i32 %13, 10000000
  br i1 %14, label %15, label %22

15:                                               ; preds = %12
  %16 = load i32, ptr %3, align 4
  %17 = sext i32 %16 to i64
  %18 = load i64, ptr %2, align 8
  %19 = add nsw i64 %18, %17
  store i64 %19, ptr %2, align 8
  %20 = load i32, ptr %3, align 4
  %21 = add nsw i32 %20, 1
  store i32 %21, ptr %3, align 4
  br label %12, !llvm.loop !5

22:                                               ; preds = %12
  store i32 10, ptr %4, align 4
  store i32 20, ptr %5, align 4
  %23 = load i32, ptr %4, align 4
  %24 = load i32, ptr %5, align 4
  %25 = mul nsw i32 %23, %24
  %26 = load i32, ptr %4, align 4
  %27 = load i32, ptr %5, align 4
  %28 = mul nsw i32 %26, %27
  %29 = add nsw i32 %25, %28
  store i32 %29, ptr %6, align 4
  store i32 70, ptr %7, align 4
  store i32 0, ptr %9, align 4
  br label %30

30:                                               ; preds = %33, %22
  %31 = load i32, ptr %9, align 4
  %32 = icmp slt i32 %31, 1000
  br i1 %32, label %33, label %41

33:                                               ; preds = %30
  %34 = load i32, ptr %9, align 4
  %35 = mul nsw i32 %34, 2
  %36 = load i32, ptr %9, align 4
  %37 = sext i32 %36 to i64
  %38 = getelementptr inbounds [1000 x i32], ptr %8, i64 0, i64 %37
  store i32 %35, ptr %38, align 4
  %39 = load i32, ptr %9, align 4
  %40 = add nsw i32 %39, 1
  store i32 %40, ptr %9, align 4
  br label %30, !llvm.loop !7

41:                                               ; preds = %30
  store i64 0, ptr %10, align 8
  store i32 0, ptr %11, align 4
  br label %42

42:                                               ; preds = %45, %41
  %43 = load i32, ptr %11, align 4
  %44 = icmp slt i32 %43, 1000
  br i1 %44, label %45, label %55

45:                                               ; preds = %42
  %46 = load i32, ptr %11, align 4
  %47 = sext i32 %46 to i64
  %48 = getelementptr inbounds [1000 x i32], ptr %8, i64 0, i64 %47
  %49 = load i32, ptr %48, align 4
  %50 = sext i32 %49 to i64
  %51 = load i64, ptr %10, align 8
  %52 = add nsw i64 %51, %50
  store i64 %52, ptr %10, align 8
  %53 = load i32, ptr %11, align 4
  %54 = add nsw i32 %53, 1
  store i32 %54, ptr %11, align 4
  br label %42, !llvm.loop !8

55:                                               ; preds = %42
  %56 = load i64, ptr %2, align 8
  %57 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %56)
  %58 = load i32, ptr %6, align 4
  %59 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %58)
  %60 = load i32, ptr %7, align 4
  %61 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %60)
  %62 = load i64, ptr %10, align 8
  %63 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i64 noundef %62)
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
