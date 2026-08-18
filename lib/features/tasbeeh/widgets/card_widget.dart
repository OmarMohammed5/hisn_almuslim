import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  int _previousTotal = 0;

  @override
  void initState() {
    super.initState();
    context.read<CounterCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = [const Color(0xFF0F4E29), const Color(0xFF161C35)];

    final shadowColor = (isDark ? Colors.black : Colors.teal.shade900)
        .withValues(alpha: isDark ? 0.4 : 0.2);


    return BlocBuilder<CounterCubit, Map<int, int>>(
      builder: (context, state) {
        final total = context.read<CounterCubit>().total;
        final bool totalIncreased = total > _previousTotal;
        _previousTotal = total;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 20,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(18.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Badge
                        Align(
                          alignment: Alignment.topRight,
                          child: CustomText(
                            "قال تعالى",
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        Gap(12.h),
                        // الآية
                        Text(
                          "﴿ وَمَن أَعْرَضَ عَن ذِكْرِي فَإِنَّ لَهُ مَعِيشَةً ضَنكًا وَنَحْشُرُهُ يَوْمَ الْقِيَامَةِ أَعْمَى ﴾",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            height: 2.0,
                            fontFamily: "QuranFont",
                            color:  Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                        Gap(10.h),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CustomText(
                            "صدق الله العظيم",
                            fontSize: 9.5.sp,
                            color: Colors.white.withValues(alpha: 0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomText(
                          "الإجمالي",
                          fontSize: 10.5.sp,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : const Color(0xFF5D4037),
                          fontWeight: FontWeight.bold,
                        ),
                        Gap(6.h),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: Tween<double>(begin: 0.6, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.slowMiddle,
                                ),
                              ),
                              child: child,
                            );
                          },
                          child: Container(
                            key: ValueKey(total),
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [
                                  Colors.white.withValues(alpha: 0.12),
                                  Colors.white.withValues(alpha: 0.04),
                                ]
                                    : [
                                  Colors.white.withValues(alpha: 0.8),
                                  Colors.white.withValues(alpha: 0.4),
                                ],
                              ),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : Colors.white.withValues(alpha: 0.8),
                                width: 2.w,
                              ),
                            ),
                            child: Center(
                              child: CustomText(
                                "$total",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF4E342E),
                              ),
                            ),
                          ),
                        ),
                        Gap(8.h),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              context.read<CounterCubit>().resetAll();
                            },
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.white.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 4.w,
                                children: [
                                  Icon(
                                    Icons.restart_alt_rounded,
                                    color: isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF5D4037),
                                    size: 16.sp,
                                  ),
                                  CustomText(
                                    "إعادة",
                                    color: isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF5D4037),
                                    fontSize: 10.5.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
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
}