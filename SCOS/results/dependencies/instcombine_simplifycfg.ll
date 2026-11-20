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
  %storemerge = phi i32 [ 0, %0 ], [ %17, %11 ]
  store i32 %storemerge, ptr %2, align 4
  %10 = icmp slt i32 %storemerge, 10000000
  br i1 %10, label %11, label %18

11:                                               ; preds = %9
  %12 = load i32, ptr %2, align 4
  %13 = sext i32 %12 to i64
  %14 = load i64, ptr %1, align 8
  %15 = add nsw i64 %14, %13
  store i64 %15, ptr %1, align 8
  %16 = load i32, ptr %2, align 4
  %17 = add nsw i32 %16, 1
  br label %9, !llvm.loop !5

18:                                               ; preds = %9
  store i32 400, ptr %3, align 4
  store i32 70, ptr %4, align 4
  br label %19

19:                                               ; preds = %21, %18
  %storemerge1 = phi i32 [ 0, %18 ], [ %27, %21 ]
  store i32 %storemerge1, ptr %6, align 4
  %20 = icmp slt i32 %storemerge1, 1000
  br i1 %20, label %21, label %28

21:                                               ; preds = %19
  %22 = load i32, ptr %6, align 4
  %23 = shl nsw i32 %22, 1
  %24 = sext i32 %22 to i64
  %25 = getelementptr inbounds [4 x i8], ptr %5, i64 %24
  store i32 %23, ptr %25, align 4
  %26 = load i32, ptr %6, align 4
  %27 = add nsw i32 %26, 1
  br label %19, !llvm.loop !7

28:                                               ; preds = %19
  store i64 0, ptr %7, align 8
  br label %29

29:                                               ; preds = %31, %28
  %storemerge2 = phi i32 [ 0, %28 ], [ %40, %31 ]
  store i32 %storemerge2, ptr %8, align 4
  %30 = icmp slt i32 %storemerge2, 1000
  br i1 %30, label %31, label %41

31:                                               ; preds = %29
  %32 = load i32, ptr %8, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [4 x i8], ptr %5, i64 %33
  %35 = load i32, ptr %34, align 4
  %36 = sext i32 %35 to i64
  %37 = load i64, ptr %7, align 8
  %38 = add nsw i64 %37, %36
  store i64 %38, ptr %7, align 8
  %39 = load i32, ptr %8, align 4
  %40 = add nsw i32 %39, 1
  br label %29, !llvm.loop !8

41:                                               ; preds = %29
  %42 = load i64, ptr %1, align 8
  %43 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %42) #2
  %44 = load i32, ptr %3, align 4
  %45 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef %44) #2
  %46 = load i32, ptr %4, align 4
  %47 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i32 noundef %46) #2
  %48 = load i64, ptr %7, align 8
  %49 = call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.3, i64 noundef %48) #2
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
