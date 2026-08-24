import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<_ShimmerBox> createState() =>
      _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox> with SingleTickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration:
    const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<double>
  _opacity = Tween<double>(begin: .35, end: .9,).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.kPrimary
              .withValues(
            alpha:
            .08 * _opacity.value,
          ),
          borderRadius:
          widget.borderRadius,
        ),
      ),
    );
  }
}

class LectureCardSkeleton
    extends StatelessWidget {
  const LectureCardSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(8.w),
      child: Row(
        children: [
          _ShimmerBox(
            width: 126.w,
            height: 78.h,
            borderRadius:
            BorderRadius.circular(14.r),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(
                  width: double.infinity,
                  height: 13.h,
                  borderRadius:
                  BorderRadius.circular(
                    6.r,
                  ),
                ),
                SizedBox(height: 8.h),
                _ShimmerBox(
                  width: 120.w,
                  height: 11.h,
                  borderRadius:
                  BorderRadius.circular(
                    6.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LectureResultsSkeleton
    extends StatelessWidget {
  final int count;

  const LectureResultsSkeleton({
    super.key,
    this.count = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
            (_) => const LectureCardSkeleton(),
      ),
    );
  }
}

class LectureFeedbackView
    extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const LectureFeedbackView({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  const LectureFeedbackView.invalidQuery({
    super.key,
    required this.message,
  })  : icon = Icons.mosque_outlined,
        actionLabel = null,
        onAction = null;

  const LectureFeedbackView.empty({
    super.key,
  })  : icon = Icons.search_off_rounded,
        message =
        'لم نجد نتائج مناسبة، جرّب كلمات بحث مختلفة.',
        actionLabel = null,
        onAction = null;

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return Padding(
      padding:
      EdgeInsets.symmetric(
        vertical: 44.h,
        horizontal: 24.w,
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: scheme.primary
                  .withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: scheme.primary,
              size: 26.sp,
            ),
          ),
          SizedBox(height: 14.h),
          CustomText(
            message,
            textAlign:
            TextAlign.center,
            fontSize: 12.5.sp,
            height: 1.6,
            fontWeight:
            FontWeight.w600,
            color: scheme.onSurface
                .withValues(alpha: .68),
          ),
          if (actionLabel != null &&
              onAction != null) ...[
            SizedBox(height: 14.h),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label:
              Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
