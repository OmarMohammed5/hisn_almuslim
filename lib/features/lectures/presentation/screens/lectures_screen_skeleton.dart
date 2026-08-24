import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

class LecturesScreenSkeleton extends StatefulWidget {
  const LecturesScreenSkeleton({
    super.key,
  });

  @override
  State<LecturesScreenSkeleton> createState() =>
      _LecturesScreenSkeletonState();
}

class _LecturesScreenSkeletonState extends State<LecturesScreenSkeleton> with SingleTickerProviderStateMixin {

  late final AnimationController _controller =
  AnimationController(
    vsync: this,
    duration:
    const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<double> _opacity =
  Tween<double>(
    begin: .25,
    end: .75,
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _box({
    required double width,
    required double height,
    BorderRadius? radius,
  }) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.kPrimary.withValues(
              alpha: .10 * _opacity.value,
            ),
            borderRadius:
            radius ??
                BorderRadius.circular(8.r),
          ),
        );
      },
    );
  }

  Widget _categorySkeleton() {
    return Container(
      height: 118.h,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.kPrimary.withValues(alpha: .10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          _box(
            width: 52.w,
            height: 52.w,
            radius:
            BorderRadius.circular(100.r),
          ),

          SizedBox(height: 12.h),

          _box(
            width: 70.w,
            height: 11.h,
            radius:
            BorderRadius.circular(5.r),
          ),
        ],
      ),
    );
  }

  Widget _sheikhSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 8.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.kPrimary.withValues(
            alpha: .10,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _box(
            width: 58.w,
            height: 58.w,
            radius: BorderRadius.circular(100.r),
          ),

          SizedBox(height: 9.h),

          _box(
            width: 70.w,
            height: 10.h,
            radius: BorderRadius.circular(5.r),
          ),

          SizedBox(height: 7.h),

          _box(
            width: 45.w,
            height: 8.h,
            radius: BorderRadius.circular(5.r),
          ),

          SizedBox(height: 9.h),

          _box(
            width: 12.w,
            height: 12.w,
            radius: BorderRadius.circular(100.r),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle({
    required double width,
  }) {
    return Align(
      alignment:
      Alignment.centerRight,
      child: _box(
        width: width.w,
        height: 21.h,
        radius:
        BorderRadius.circular(6.r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics:
      const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 40.h,),
      children: [

        ContinueListeningCardSkeleton(),

        SizedBox(height: 30.h),

        // Categories title
        _sectionTitle(
          width: 90,
        ),

        SizedBox(height: 16.h),

        // Categories Grid
        GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: .88,
          ),
          itemBuilder: (_, __) {
            return _categorySkeleton();
          },
        ),

        SizedBox(height: 38.h),

        // Sheikh / Channels title
        Row(
          children: [


            SizedBox(width: 9.w),

            _sectionTitle(
              width: 100,
            ),

            const Spacer(),

            _box(
              width: 45.w,
              height: 10.h,
              radius:
              BorderRadius.circular(5.r),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Sheikh Grid
        GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: .65,
          ),
          itemBuilder: (_, __) {
            return _sheikhSkeleton();
          },
        ),
      ],
    );
  }
}


class ContinueListeningCardSkeleton extends StatefulWidget {
  const ContinueListeningCardSkeleton({super.key,});

  @override
  State<ContinueListeningCardSkeleton>
  createState() =>
      _ContinueListeningCardSkeletonState();
}

class _ContinueListeningCardSkeletonState extends State<ContinueListeningCardSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
  AnimationController(
    vsync: this,
    duration:
    const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<double> _opacity =
  Tween<double>(
    begin: .25,
    end: .75,
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _box({
    required double width,
    required double height,
    BorderRadius? radius,
  }) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color:
            AppColors.kPrimary.withValues(
              alpha:
              .10 * _opacity.value,
            ),
            borderRadius:
            radius ??
                BorderRadius.circular(
                  8.r,
                ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(20.r),
        border: Border.all(
          color:
          AppColors.kPrimary.withValues(
            alpha: .10,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _box(
                width: 22.w,
                height: 22.w,
                radius:
                BorderRadius.circular(
                  7.r,
                ),
              ),

              SizedBox(width: 8.w),

              _box(
                width: 105.w,
                height: 14.h,
                radius:
                BorderRadius.circular(
                  5.r,
                ),
              ),

              const Spacer(),

              _box(
                width: 42.w,
                height: 11.h,
                radius:
                BorderRadius.circular(
                  5.r,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Lecture Content
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              // Thumbnail
              _box(
                width: 105.w,
                height: 72.h,
                radius:
                BorderRadius.circular(
                  14.r,
                ),
              ),

              SizedBox(width: 12.w),

              // Information
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _box(
                      width: double.infinity,
                      height: 13.h,
                      radius:
                      BorderRadius.circular(
                        5.r,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    _box(
                      width: 145.w,
                      height: 11.h,
                      radius:
                      BorderRadius.circular(
                        5.r,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    _box(
                      width: 95.w,
                      height: 9.h,
                      radius:
                      BorderRadius.circular(
                        5.r,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Progress
          _box(
            width: double.infinity,
            height: 5.h,
            radius:
            BorderRadius.circular(
              10.r,
            ),
          ),

          SizedBox(height: 12.h),

          // Bottom Row
          Row(
            children: [
              _box(
                width: 70.w,
                height: 10.h,
                radius:
                BorderRadius.circular(
                  5.r,
                ),
              ),

              const Spacer(),

              _box(
                width: 85.w,
                height: 34.h,
                radius:
                BorderRadius.circular(
                  10.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

