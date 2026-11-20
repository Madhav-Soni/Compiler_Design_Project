; ModuleID = 'benchmarks/benchmark.c'
source_filename = "benchmarks/benchmark.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

@.str = private unnamed_addr constant [16 x i8] c"Loop sum: %lld\0A\00", align 1
@.str.1 = private unnamed_addr constant [26 x i8] c"Repeated calculation: %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [21 x i8] c"Constant result: %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"Array sum: %lld\0A\00", align 1

; Function Attrs: nofree nounwind ssp uwtable(sync)
define noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca [1000 x i32], align 4
  call void @llvm.lifetime.start.p0(ptr nonnull %1) #4
  br label %2

2:                                                ; preds = %2, %0
  %3 = phi i64 [ 0, %0 ], [ %16, %2 ]
  %4 = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %0 ], [ %17, %2 ]
  %5 = getelementptr inbounds nuw [4 x i8], ptr %1, i64 %3
  %6 = shl <4 x i32> %4, splat (i32 1)
  %7 = shl <4 x i32> %4, splat (i32 1)
  %8 = add <4 x i32> %7, splat (i32 8)
  %9 = shl <4 x i32> %4, splat (i32 1)
  %10 = add <4 x i32> %9, splat (i32 16)
  %11 = shl <4 x i32> %4, splat (i32 1)
  %12 = add <4 x i32> %11, splat (i32 24)
  %13 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %14 = getelementptr inbounds nuw i8, ptr %5, i64 32
  %15 = getelementptr inbounds nuw i8, ptr %5, i64 48
  store <4 x i32> %6, ptr %5, align 4, !tbaa !10
  store <4 x i32> %8, ptr %13, align 4, !tbaa !10
  store <4 x i32> %10, ptr %14, align 4, !tbaa !10
  store <4 x i32> %12, ptr %15, align 4, !tbaa !10
  %16 = add nuw i64 %3, 16
  %17 = add <4 x i32> %4, splat (i32 16)
  %18 = icmp eq i64 %16, 992
  br i1 %18, label %19, label %2, !llvm.loop !11

19:                                               ; preds = %2
  %20 = getelementptr inbounds nuw i8, ptr %1, i64 3968
  store <4 x i32> <i32 1984, i32 1986, i32 1988, i32 1990>, ptr %20, align 4, !tbaa !10
  %21 = getelementptr inbounds nuw i8, ptr %1, i64 3984
  store <4 x i32> <i32 1992, i32 1994, i32 1996, i32 1998>, ptr %21, align 4, !tbaa !10
  br label %22

22:                                               ; preds = %19, %22
  %23 = phi i64 [ %44, %22 ], [ 0, %19 ]
  %24 = phi <4 x i64> [ %40, %22 ], [ zeroinitializer, %19 ]
  %25 = phi <4 x i64> [ %41, %22 ], [ zeroinitializer, %19 ]
  %26 = phi <4 x i64> [ %42, %22 ], [ zeroinitializer, %19 ]
  %27 = phi <4 x i64> [ %43, %22 ], [ zeroinitializer, %19 ]
  %28 = getelementptr inbounds nuw [4 x i8], ptr %1, i64 %23
  %29 = getelementptr inbounds nuw i8, ptr %28, i64 16
  %30 = getelementptr inbounds nuw i8, ptr %28, i64 32
  %31 = getelementptr inbounds nuw i8, ptr %28, i64 48
  %32 = load <4 x i32>, ptr %28, align 4, !tbaa !10
  %33 = load <4 x i32>, ptr %29, align 4, !tbaa !10
  %34 = load <4 x i32>, ptr %30, align 4, !tbaa !10
  %35 = load <4 x i32>, ptr %31, align 4, !tbaa !10
  %36 = sext <4 x i32> %32 to <4 x i64>
  %37 = sext <4 x i32> %33 to <4 x i64>
  %38 = sext <4 x i32> %34 to <4 x i64>
  %39 = sext <4 x i32> %35 to <4 x i64>
  %40 = add <4 x i64> %24, %36
  %41 = add <4 x i64> %25, %37
  %42 = add <4 x i64> %26, %38
  %43 = add <4 x i64> %27, %39
  %44 = add nuw i64 %23, 16
  %45 = icmp eq i64 %44, 992
  br i1 %45, label %46, label %22, !llvm.loop !15

46:                                               ; preds = %22
  %47 = add <4 x i64> %41, %40
  %48 = add <4 x i64> %42, %47
  %49 = add <4 x i64> %43, %48
  %50 = tail call i64 @llvm.vector.reduce.add.v4i64(<4 x i64> %49)
  %51 = insertelement <4 x i64> <i64 poison, i64 0, i64 0, i64 0>, i64 %50, i64 0
  %52 = getelementptr inbounds nuw i8, ptr %1, i64 3968
  %53 = load <4 x i32>, ptr %52, align 4, !tbaa !10
  %54 = sext <4 x i32> %53 to <4 x i64>
  %55 = add <4 x i64> %51, %54
  %56 = getelementptr inbounds nuw i8, ptr %1, i64 3984
  %57 = load <4 x i32>, ptr %56, align 4, !tbaa !10
  %58 = sext <4 x i32> %57 to <4 x i64>
  %59 = add <4 x i64> %55, %58
  %60 = tail call i64 @llvm.vector.reduce.add.v4i64(<4 x i64> %59)
  %61 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef 49999995000000)
  %62 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, i32 noundef 400)
  %63 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i32 noundef 70)
  %64 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.3, i64 noundef %60)
  call void @llvm.lifetime.end.p0(ptr nonnull %1) #4
  ret i32 0
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v4i64(<4 x i64>) #3

attributes #0 = { nofree nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nofree nounwind "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" "tune-cpu"="apple-m5" }
attributes #3 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}
!llvm.errno.tbaa = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 2]}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 1}
!3 = !{i32 7, !"frame-pointer", i32 4}
!4 = !{!"Homebrew clang version 23.1.6"}
!5 = !{!6, !7, i64 0}
!6 = !{!"__libc_errno", !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!7, !7, i64 0}
!11 = distinct !{!11, !12, !13, !14}
!12 = !{!"llvm.loop.mustprogress"}
!13 = !{!"llvm.loop.isvectorized", i32 1}
!14 = !{!"llvm.loop.unroll.runtime.disable"}
!15 = distinct !{!15, !12, !13, !14}
