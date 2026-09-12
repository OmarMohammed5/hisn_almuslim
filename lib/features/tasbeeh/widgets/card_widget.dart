import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';

import '../../../core/responsive/app_responsive.dart';
import '../../../core/theme/app_colors.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  static const _deepGreen = Color(0xFF075847);
  static const _green = Color(0xFF0D8066);
  static const _mint = Color(0xFFBFEBDD);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return BlocBuilder<CounterCubit, Map<int, int>>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final total = context.read<CounterCubit>().total;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 8),
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 16),
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: AppResponsive.widthValue(context, 176),
              maxHeight: AppResponsive.widthValue(context, 205),
            ),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, 28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .20 : .08),
                  blurRadius: 12.r,
                  offset: Offset(0, 12.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, 28),
              ),
              child: Stack(
                children: [
                  // Very subtle identity accent — no heavy glow/gradient.
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: AppResponsive.widthValue(context, 92),
                      height: AppResponsive.heightValue(context, 5),
                      decoration: const BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppResponsive.widthValue(context, 18),
                      AppResponsive.heightValue(context, 18),
                      AppResponsive.widthValue(context, 18),
                      AppResponsive.heightValue(context, 17),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: AppResponsive.widthValue(
                                      context,
                                      42,
                                    ),
                                    height: AppResponsive.heightValue(
                                      context,
                                      42,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? _green.withValues(alpha: .18)
                                          : _green.withValues(alpha: .09),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _green.withValues(alpha: .18),
                                      ),
                                    ),
                                    child: Icon(
                                      FlutterIslamicIcons.tasbihHand,
                                      size: AppResponsive.iconSize(context, 19),
                                      color: isDark ? _mint : _green,
                                    ),
                                  ),
                                  Gap(AppResponsive.widthValue(context, 10)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        'عداد التسبيح',
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF18332D),
                                        fontSize: AppResponsive.fontSize(
                                          context,
                                          14,
                                        ),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            _ResetButton(
                              onTap: () => _reset(context),
                              isDark: isDark,
                            ),
                          ],
                        ),
                        Gap(AppResponsive.heightValue(context, 17)),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _TotalCounter(
                                  total: total,
                                  isDark: isDark,
                                ),
                              ),
                              Gap(AppResponsive.widthValue(context, 16)),
                              SizedBox(
                                width: AppResponsive.widthValue(context, 118),
                                child: _ProgressRing(
                                  total: total,
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _reset(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<CounterCubit>().resetAll();
  }
}

class _TotalCounter extends StatelessWidget {
  const _TotalCounter({required this.total, required this.isDark});

  final int total;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : const Color(0xFF17342E);
    final muted = isDark
        ? Colors.white.withValues(alpha: .52)
        : const Color(0xFF17342E).withValues(alpha: .50);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'إجمالي التسبيحات',
          color: muted,
          fontSize: AppResponsive.fontSize(context, 10),
          fontWeight: FontWeight.w600,
        ),
        Gap(AppResponsive.widthValue(context, 4)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Text(
            '$total',
            key: ValueKey(total),
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: total > 99999
                  ? AppResponsive.fontSize(context, 29)
                  : AppResponsive.fontSize(context, 34),
              height: AppResponsive.heightValue(context, 1),
              fontWeight: FontWeight.w900,
              color: primary,
              fontFamily: 'Cairo',
              letterSpacing: -.5,
            ),
          ),
        ),
        Gap(AppResponsive.widthValue(context, 8)),
        Row(
          children: [
            Container(
              width: AppResponsive.widthValue(context, 28),
              height: AppResponsive.heightValue(context, 3),
              decoration: BoxDecoration(
                color: CardWidget._green,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 10),
                ),
              ),
            ),
            Gap(AppResponsive.widthValue(context, 6)),
            Flexible(
              child: CustomText(
                total == 0 ? 'ابدأ أول تسبيحة' : 'ما شاء الله، استمر',
                color: muted,
                fontSize: AppResponsive.fontSize(context, 9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.total, required this.isDark});

  final int total;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final progress = (total % 33) / 33.0;
    final current = total % 33 == 0 && total > 0 ? 33 : total % 33;

    return SizedBox(
      width: AppResponsive.widthValue(context, 108),
      height: AppResponsive.heightValue(context, 108),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return CustomPaint(
            painter: _ProgressPainter(progress: value, isDark: isDark),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$current / 33',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppResponsive.fontSize(context, 10.5),
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? Colors.white.withValues(alpha: .82)
                          : const Color(0xFF17342E).withValues(alpha: .78),
                    ),
                  ),
                  Text(
                    'هذه الدورة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppResponsive.fontSize(context, 8),
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.white.withValues(alpha: .42)
                          : const Color(0xFF17342E).withValues(alpha: .42),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 5;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = (isDark ? Colors.white : CardWidget._deepGreen).withValues(
        alpha: .08,
      );

    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = isDark ? CardWidget._mint : CardWidget._green;

    canvas.drawCircle(center, radius, track);

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi * 2 * progress,
        false,
        active,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onTap, required this.isDark});

  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final foreground = isDark ? Colors.white : const Color(0xFF17342E);

    return Semantics(
      button: true,
      label: 'إعادة ضبط الإجمالي',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 14),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.widthValue(context, 11),
              vertical: AppResponsive.heightValue(context, 8),
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: .06)
                  : const Color(0xFFF3F7F5),
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, 14),
              ),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: .08)
                    : CardWidget._deepGreen.withValues(alpha: .08),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.restart_alt_rounded,
                  size: AppResponsive.iconSize(context, 15),
                  color: foreground.withValues(alpha: .68),
                ),
                Gap(AppResponsive.widthValue(context, 4)),
                CustomText(
                  'إعادة',
                  color: foreground.withValues(alpha: .68),
                  fontSize: AppResponsive.fontSize(context, 9.5),
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
