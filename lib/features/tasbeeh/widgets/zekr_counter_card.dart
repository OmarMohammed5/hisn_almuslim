import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';
import '../../../core/theme/app_colors.dart';
import 'tasbeeh_tap_animation.dart';

class ZekrCounterCard extends StatelessWidget {
  const ZekrCounterCard({
    super.key,
    required this.title,
    required this.index,
  });

  final String title;
  final int index;

  static const _accent = Color(0xFF17866B);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final muted = isDark ? Colors.white.withValues(alpha: .55) : const Color(0xFF718078);

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;


    return BlocBuilder<CounterCubit, Map<int, int>>(
      buildWhen: (previous, current) =>
          previous[index] != current[index],
      builder: (context, state) {
        final count = state[index] ?? 0;
        final isActive = count > 0;

        return Semantics(
          button: true,
          label: '$title، العدد $count',
          hint: 'اضغط للتسبيح',
          child: TasbeehTapAnimation(
            accentColor: isDark ? const Color(0xFF63C9A9) : _accent,
            onTap: () {
              HapticFeedback.selectionClick();
              context.read<CounterCubit>().increment(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 11.h),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? .12 : .045,
                    ),
                    blurRadius: isActive ? 18.r : 10.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          title,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          color: isDark
                              ? Colors.white.withValues(alpha: .82)
                              : const Color(0xFF25332E),
                        ),
                      ),
                      Gap(8.w),
                      _CountBadge(
                        count: count,
                        active: isActive,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        size: 13.sp,
                        color: isActive
                            ? (isDark
                                ? const Color(0xFF63C9A9)
                                : _accent)
                            : muted,
                      ),
                      Gap(4.w),
                      Expanded(
                        child: CustomText(
                          isActive ? 'استمر في الذكر' : 'اضغط للتسبيح',
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? (isDark
                                  ? const Color(0xFF63C9A9)
                                  : _accent)
                              : muted,
                          maxLines: 1,
                        ),
                      ),
                      if (isActive)
                        _ProgressLine(
                          count: count,
                          isDark: isDark,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.count,
    required this.active,
    required this.isDark,
  });

  final int count;
  final bool active;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? const Color(0xFF63C9A9) : ZekrCounterCard._accent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? accent.withValues(alpha: .10)
            : (isDark
                ? Colors.white.withValues(alpha: .035)
                : const Color(0xFFF4F7F5)),
        border: Border.all(
          color: active
              ? accent.withValues(alpha: .32)
              : (isDark
                  ? Colors.white.withValues(alpha: .07)
                  : const Color(0xFFE6EBE8)),
          width: active ? 1.6.w : 1.w,
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 160),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Text(
            '$count',
            key: ValueKey(count),
            style: TextStyle(
              fontSize: count > 999 ? 11.sp : 17.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Cairo',
              color: active
                  ? accent
                  : (isDark
                      ? Colors.white.withValues(alpha: .48)
                      : const Color(0xFF98A39E)),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.count,
    required this.isDark,
  });

  final int count;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? const Color(0xFF63C9A9) : ZekrCounterCard._accent;
    final progress = (count / 33).clamp(0.0, 1.0);

    return SizedBox(
      width: 36.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: LinearProgressIndicator(
          minHeight: 3.h,
          value: progress,
          backgroundColor: accent.withValues(alpha: .08),
          valueColor: AlwaysStoppedAnimation<Color>(
            accent.withValues(alpha: .65),
          ),
        ),
      ),
    );
  }
}
