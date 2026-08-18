import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'tasbeeh_tap_animation.dart';

class ZekrCounterCard extends StatelessWidget {
  const ZekrCounterCard({
    super.key,
    required this.title,
    required this.index,
  });

  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? Colors.tealAccent.shade200 : Colors.teal.shade600;

    final cardGradient = isDark
        ? [Colors.grey.shade900, const Color(0xFF0F171A)]
        : [Colors.white, const Color(0xFFF8FAFC)];

    return BlocBuilder<CounterCubit, Map<int, int>>(
      builder: (context, state) {
        final count = state[index] ?? 0;
        final isActive = count > 0;

        return TasbeehTapAnimation(
          accentColor: accentColor,
          onTap: () {
            HapticFeedback.lightImpact();
            context.read<CounterCubit>().increment(index);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: cardGradient,
              ),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.grey.shade300,
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.15)
                      : Colors.grey.shade200.withValues(alpha: 0.3),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCounterCircle(count, accentColor, isDark, isActive),
                Gap(12.h),
                Container(
                  height: 30.h,
                  alignment: Alignment.center,
                  child: CustomText(
                    title,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.grey.shade700,
                  ),
                ),
                if (isActive)
                  Container(
                    margin: EdgeInsets.only(top: 6.h),
                    height: 2.5.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: count > 10 ? 1.0 : count / 10,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.5),
                              accentColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCounterCircle(int count, Color accentColor, bool isDark, bool isActive) {
    final size = count > 99 ? 50.w : 52.w;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? [
            accentColor.withValues(alpha: 0.25),
            accentColor.withValues(alpha: 0.08),
          ]
              : isDark
              ? [
            Colors.white.withValues(alpha: 0.04),
            Colors.white.withValues(alpha: 0.01),
          ]
              : [
            Colors.grey.shade100,
            Colors.grey.shade50,
          ],
        ),
        border: Border.all(
          color: isActive
              ? accentColor.withValues(alpha: 0.5)
              : isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey.shade200,
          width: isActive ? 2.5.w : 1.5.w,
        ),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ]
            : null,
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                ),
              ),
              child: child,
            );
          },
          child: Text(
            '$count',
            key: ValueKey(count),
            style: TextStyle(
              fontSize: count > 99 ? 14.sp : 18.sp,
              fontWeight: FontWeight.bold,
              color: isActive ? accentColor : Colors.grey.shade400,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }
}