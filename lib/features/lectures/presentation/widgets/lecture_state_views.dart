import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
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
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: .35,
    end: .9,
  ).animate(_controller);

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
          color: AppColors.kPrimary.withValues(alpha: .08 * _opacity.value),
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }
}

class LectureCardSkeleton extends StatelessWidget {
  const LectureCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppResponsive.heightValue(context, 12)),
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
      child: Row(
        children: [
          _ShimmerBox(
            width: AppResponsive.widthValue(context, 126),
            height: AppResponsive.heightValue(context, 78),
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 14),
            ),
          ),
          SizedBox(width: AppResponsive.widthValue(context, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(
                  width: double.infinity,
                  height: AppResponsive.heightValue(context, 13),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 6),
                  ),
                ),
                SizedBox(height: AppResponsive.heightValue(context, 8)),
                _ShimmerBox(
                  width: AppResponsive.widthValue(context, 120),
                  height: AppResponsive.heightValue(context, 11),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 6),
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

class LectureResultsSkeleton extends StatelessWidget {
  final int count;

  const LectureResultsSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (_) => const LectureCardSkeleton()),
    );
  }
}

class LectureFeedbackView extends StatelessWidget {
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

  const LectureFeedbackView.invalidQuery({super.key, required this.message})
    : icon = Icons.search_off,
      actionLabel = null,
      onAction = null;

  const LectureFeedbackView.empty({super.key})
    : icon = Icons.search_off_rounded,
      message = 'لم نجد نتائج مناسبة، جرّب كلمات بحث مختلفة.',
      actionLabel = null,
      onAction = null;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppResponsive.heightValue(context, 44),
        horizontal: AppResponsive.widthValue(context, 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppResponsive.widthValue(context, 56),
            height: AppResponsive.widthValue(context, 56),
            decoration: BoxDecoration(
              color: AppColors.kPrimary.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.kPrimary,
              size: AppResponsive.fontSize(context, 26),
            ),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 14)),
          CustomText(
            message,
            maxLines: 4,
            textAlign: TextAlign.center,
            fontSize: AppResponsive.fontSize(context, 12.5),
            height: 1.6,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface.withValues(alpha: .68),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: AppResponsive.heightValue(context, 14)),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
