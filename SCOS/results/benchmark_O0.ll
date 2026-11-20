; ModuleID = 'benchmarks/benchmark.c'
source_filename = "benchmarks/benchmark.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@.str = private unnamed_addr constant [16 x i8] c"Loop sum: %lld\0A\00", align 1
@.str.1 = private unnamed_addr constant [26 x i8] c"Repeated calculation: %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [21 x i8] c"Constant result: %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"Array sum: %lld\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
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

12:                                               ; preds = %20, %0
  %13 = load i32, ptr %3, align 4
  %14 = icmp slt i32 %13, 10000000
  br i1 %14, label %15, label %23

15:                                               ; preds = %12
  %16 = load i32, ptr %3, align 4
  %17 = sext i32 %16 to i64
  %18 = load i64, ptr %2, align 8
  %19 = add nsw i64 %18, %17
  store i64 %19, ptr %2, align 8
  br label %20

20:                                               ; preds = %15
  %21 = load i32, ptr %3, align 4
  %22 = add nsw i32 %21, 1
  store i32 %22, ptr %3, align 4
  br label %12, !llvm.loop !5

23:                                               ; preds = %12
  store i32 10, ptr %4, align 4
  store i32 20, ptr %5, align 4
  %24 = load i32, ptr %4, align 4
  %25 = load i32, ptr %5, align 4
  %26 = mul nsw i32 %24, %25
  %27 = load i32, ptr %4, align 4
  %28 = load i32, ptr %5, align 4
  %29 = mul nsw i32 %27, %28
  %30 = add nsw i32 %26, %29
  store i32 %30, ptr %6, align 4
  store i32 70, ptr %7, align 4
  store i32 0, ptr %9, align 4
  br label %31

31:                                               ; preds = %40, %23
  %32 = load i32, ptr %9, align 4
  %33 = icmp slt i32 %32, 1000
  br i1 %33, label %34, label %43

34:                                               ; preds = %31
  %35 = load i32, ptr %9, align 4
  %36 = mul nsw i32 %35, 2
  %37 = load i32, ptr %9, align 4
  %38 = sext i32 %37 to i64
  %39 = getelementptr inbounds [1000 x i32], ptr %8, i64 0, i64 %38
  store i32 %36, ptr %39, align 4
  br label %40

40:                                               ; preds = %34
  %41 = load i32, ptr %9, align 4
  %42 = add nsw i32 %41, 1
  store i32 %42, ptr %9, align 4
  br label %31, !llvm.loop !7

43:                                               ; preds = %31
  store i64 0, ptr %10, align 8
  store i32 0, ptr %11, align 4
  br label %44

44:                                               ; preds = %55, %43
  %45 = load i32, ptr %11, align 4
  %46 = icmp slt i32 %45, 1000
  br i1 %46, label %47, label %58

47:                                               ; preds = %44
  %48 = load i32, ptr %11, align 4
  %49 = sext i32 %48 to i64
  %50 = getelementptr inbounds [1000 x i32], ptr %8, i64 0, i64 %49
  %51 = load i32, ptr %50, align 4
  %52 = sext i32 %51 to i64
  %53 = load i64, ptr %10, align 8
  %54 = add nsw i64 %53, %52
  store i64 %54, ptr %10, align 8
  br label %55

55:                                               ; preds = %47
  %56 = load i32, ptr %11, align 4
  %57 = add nsw i32 %56, 1
  store i32 %57, ptr %11, align 4
  br label %44, !llvm.loop !8

58:                                               ; preds = %44
  %59 = load i64, ptr %2, align 8
  %60 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %59)
  %61 = load i32, ptr %6, align 4
  %62 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %61)
  %63 = load i32, ptr %7, align 4
  %64 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %63)
  %65 = load i64, ptr %10, align 8
  %66 = call i32 (ptr, ...) @printf(ptr noundef @.str.3, i64 noundef %65)
  ret i32 0
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
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
