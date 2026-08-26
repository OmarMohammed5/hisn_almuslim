import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class LecturesScreenSkeleton extends StatelessWidget {
  const LecturesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey.shade300,
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade100,
      enabled: true,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 40.h),
        children: [
          // Continue Listening Skeleton
          _buildContinueListeningSkeleton(),
          SizedBox(height: 30.h),

          // Categories Title
          Align(
            alignment: Alignment.centerRight,
            child: _buildShimmerBox(width: 90.w, height: 21.h, radius: 6.r),
          ),
          SizedBox(height: 16.h),

          // Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: .88,
            ),
            itemBuilder: (_, __) => _buildCategorySkeleton(),
          ),
          SizedBox(height: 38.h),

          // Sheikh Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(width: 100.w, height: 21.h, radius: 6.r),
              _buildShimmerBox(width: 45.w, height: 10.h, radius: 5.r),
            ],
          ),
          SizedBox(height: 16.h),

          // Sheikh Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: .65,
            ),
            itemBuilder: (_, __) => _buildSheikhSkeleton(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildContinueListeningSkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmerBox(width: 22.w, height: 22.w, radius: 7.r),
              SizedBox(width: 8.w),
              _buildShimmerBox(width: 105.w, height: 14.h, radius: 5.r),
              const Spacer(),
              _buildShimmerBox(width: 42.w, height: 11.h, radius: 5.r),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildShimmerBox(width: 105.w, height: 72.h, radius: 14.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(width: double.infinity, height: 13.h, radius: 5.r),
                    SizedBox(height: 8.h),
                    _buildShimmerBox(width: 145.w, height: 11.h, radius: 5.r),
                    SizedBox(height: 8.h),
                    _buildShimmerBox(width: 95.w, height: 9.h, radius: 5.r),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _buildShimmerBox(width: double.infinity, height: 5.h, radius: 10.r),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildShimmerBox(width: 70.w, height: 10.h, radius: 5.r),
              const Spacer(),
              _buildShimmerBox(width: 85.w, height: 34.h, radius: 10.r),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySkeleton() {
    return Container(
      height: 118.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShimmerBox(width: 52.w, height: 52.w, radius: 100.r),
          SizedBox(height: 12.h),
          _buildShimmerBox(width: 70.w, height: 11.h, radius: 5.r),
        ],
      ),
    );
  }

  Widget _buildSheikhSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildShimmerBox(width: 58.w, height: 58.w, radius: 100.r),
          SizedBox(height: 9.h),
          _buildShimmerBox(width: 70.w, height: 10.h, radius: 5.r),
          SizedBox(height: 7.h),
          _buildShimmerBox(width: 45.w, height: 8.h, radius: 5.r),
          SizedBox(height: 9.h),
          _buildShimmerBox(width: 12.w, height: 12.w, radius: 100.r),
        ],
      ),
    );
  }
}