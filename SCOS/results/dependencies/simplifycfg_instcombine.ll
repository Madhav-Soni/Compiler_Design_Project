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

9:                                                ; preds = %11, %0
  %storemerge = phi i32 [ 0, %0 ], [ %16, %11 ]
  store i32 %storemerge, ptr %2, align 4
  %10 = icmp slt i32 %storemerge, 10000000
  br i1 %10, label %11, label %17

11:                                               ; preds = %9
  %12 = load i32, ptr %2, align 4
  %13 = sext i32 %12 to i64
  %14 = load i64, ptr %1, align 8
  %15 = add nsw i64 %14, %13
  store i64 %15, ptr %1, align 8
  %16 = add nsw i32 %12, 1
  br label %9, !llvm.loop !5

17:                                               ; preds = %9
  store i32 400, ptr %3, align 4
  store i32 70, ptr %4, align 4
  br label %18

18:                                               ; preds = %20, %17
  %storemerge1 = phi i32 [ 0, %17 ], [ %25, %20 ]
  store i32 %storemerge1, ptr %6, align 4
  %19 = icmp slt i32 %storemerge1, 1000
  br i1 %19, label %20, label %26

20:                                               ; preds = %18
  %21 = load i32, ptr %6, align 4
  %22 = shl nsw i32 %21, 1
  %23 = sext i32 %21 to i64
  %24 = getelementptr inbounds [4 x i8], ptr %5, i64 %23
  store i32 %22, ptr %24, align 4
  %25 = add nsw i32 %21, 1
  br label %18, !llvm.loop !7

26:                                               ; preds = %18
  store i64 0, ptr %7, align 8
  br label %27

27:                                               ; preds = %29, %26
  %storemerge2 = phi i32 [ 0, %26 ], [ %38, %29 ]
  store i32 %storemerge2, ptr %8, align 4
  %28 = icmp slt i32 %storemerge2, 1000
  br i1 %28, label %29, label %39

29:                                               ; preds = %27
  %30 = load i32, ptr %8, align 4
  %31 = sext i32 %30 to i64
  %32 = getelementptr inbounds [4 x i8], ptr %5, i64 %31
  %33 = load i32, ptr %32, align 4
  %34 = sext i32 %33 to i64
  %35 = load i64, ptr %7, align 8
  %36 = add nsw i64 %35, %34
  store i64 %36, ptr %7, align 8
  %37 = load i32, ptr %8, align 4
  %38 = add nsw i32 %37, 1
  br label %27, !llvm.loop !8

39:                                               ; preds = %27
  %40 = load i64, ptr %1, align 8
  %41 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %40) #2
  %42 = load i32, ptr %3, align 4
  %43 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef %42) #2
  %44 = load i32, ptr %4, align 4
  %45 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i32 noundef %44) #2
  %46 = load i64, ptr %7, align 8
  %47 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.3, i64 noundef %46) #2
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
