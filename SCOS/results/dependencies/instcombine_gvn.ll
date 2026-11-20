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
  %1 = alloca i64, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca [1000 x i32], align 4
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  %8 = alloca i32, align 4
  store i64 0, ptr %1, align 8
  br label %9

9:                                                ; preds = %13, %0
  %10 = phi i64 [ 0, %0 ], [ %15, %13 ]
  %11 = phi i32 [ 0, %0 ], [ %16, %13 ]
  store i32 %11, ptr %2, align 4
  %12 = icmp slt i32 %11, 10000000
  br i1 %12, label %13, label %17

13:                                               ; preds = %9
  %14 = sext i32 %11 to i64
  %15 = add nsw i64 %10, %14
  store i64 %15, ptr %1, align 8
  %16 = add nsw i32 %11, 1
  br label %9, !llvm.loop !5

17:                                               ; preds = %9
  store i32 400, ptr %3, align 4
  store i32 70, ptr %4, align 4
  br label %18

18:                                               ; preds = %21, %17
  %19 = phi i32 [ 0, %17 ], [ %25, %21 ]
  store i32 %19, ptr %6, align 4
  %20 = icmp slt i32 %19, 1000
  br i1 %20, label %21, label %26

21:                                               ; preds = %18
  %22 = shl nsw i32 %19, 1
  %23 = sext i32 %19 to i64
  %24 = getelementptr inbounds [4 x i8], ptr %5, i64 %23
  store i32 %22, ptr %24, align 4
  %25 = add nsw i32 %19, 1
  br label %18, !llvm.loop !7

26:                                               ; preds = %18
  store i64 0, ptr %7, align 8
  br label %27

27:                                               ; preds = %31, %26
  %28 = phi i64 [ 0, %26 ], [ %36, %31 ]
  %29 = phi i32 [ 0, %26 ], [ %37, %31 ]
  store i32 %29, ptr %8, align 4
  %30 = icmp slt i32 %29, 1000
  br i1 %30, label %31, label %38

31:                                               ; preds = %27
  %32 = sext i32 %29 to i64
  %33 = getelementptr inbounds [4 x i8], ptr %5, i64 %32
  %34 = load i32, ptr %33, align 4
  %35 = sext i32 %34 to i64
  %36 = add nsw i64 %28, %35
  store i64 %36, ptr %7, align 8
  %37 = add nsw i32 %29, 1
  br label %27, !llvm.loop !8

38:                                               ; preds = %27
  %39 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %10) #2
  %40 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef 400) #2
  %41 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i32 noundef 70) #2
  %42 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.3, i64 noundef %28) #2
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
