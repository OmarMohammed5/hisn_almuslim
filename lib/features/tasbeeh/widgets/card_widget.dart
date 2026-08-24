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

    // Soft, elegant Islamic color palette
    final gradientColors = isDark
        ? [
      const Color(0xFF003333), // Very dark teal
      const Color(0xFF005050), // Dark teal
      // const Color(0xFF007070), // Medium-dark teal
    ]
        : [
      // Light mode (unchanged)
      const Color(0xFF1B4D3E),
      const Color(0xFF2D6A4F),
      const Color(0xFF40916C),
    ];


    final accentColor = isDark ? const Color(0xFF52B788) : const Color(0xFFD4EDDA);
    final textColor = isDark ? Colors.white : Colors.white;
    final cardShadow = isDark
        ? Colors.black.withValues(alpha: 0.5)
        : const Color(0xFF1B4D3E).withValues(alpha: 0.3);

    return BlocBuilder<CounterCubit, Map<int, int>>(
      builder: (context, state) {
        final total = context.read<CounterCubit>().total;
        final bool totalIncreased = total > _previousTotal;
        _previousTotal = total;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: cardShadow,
                  blurRadius: 30,
                  offset: Offset(0, 10.h),
                ),
              ],
              border: Border.all(
                color: accentColor.withValues(alpha: 0.15),
                width: 1.5.w,
              ),
            ),
            child: Stack(
              children: [
                // Decorative Islamic pattern overlay
                Positioned(
                  top: -20.h,
                  right: -20.w,
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                        radius: 1.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30.h,
                  left: -30.w,
                  child: Container(
                    width: 150.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                        radius: 1.0,
                      ),
                    ),
                  ),
                ),

                // Main content
                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16.w,
                    children: [
                      /// Ayah
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: 0.1),
                                ),
                              ),
                              child: CustomText(
                                "قال الله تعالى",
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: accentColor.withValues(alpha: 0.8),
                              ),
                            ),
                            Gap(14.h),

                            // Ayah Text
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: 0.06),
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                "﴿ وَمَن أَعْرَضَ عَن ذِكْرِي فَإِنَّ لَهُ مَعِيشَةً ضَنكًا وَنَحْشُرُهُ يَوْمَ الْقِيَامَةِ أَعْمَى ﴾",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 2.0,
                                  fontFamily: "QuranFont",
                                  color: textColor.withValues(alpha: 0.92),
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Gap(10.h),

                            // Source
                            CustomText(
                              "صدق الله العظيم",
                              fontSize: 10.sp,
                              color: textColor.withValues(alpha: 0.35),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      /// Total Counter
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: 0.2),
                                  width: 1.w,
                                ),
                              ),
                              child: CustomText(
                                "الإجمالي",
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: accentColor.withValues(alpha: 0.9),
                              ),
                            ),
                            Gap(10.h),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
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
                              child: Container(
                                key: ValueKey(total),
                                width: 64.w,
                                height: 64.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      accentColor.withValues(alpha: 0.2),
                                      accentColor.withValues(alpha: 0.05),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: accentColor.withValues(alpha: 0.3),
                                    width: 2.5.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withValues(alpha: 0.1),
                                      blurRadius: 15,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CustomText(
                                    "$total",
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                            Gap(12.h),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.mediumImpact();

                                  context.read<CounterCubit>().resetAll();
                                },
                                borderRadius: BorderRadius.circular(14.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        accentColor.withValues(alpha: 0.15),
                                        accentColor.withValues(alpha: 0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: accentColor.withValues(alpha: 0.15),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 4.w,
                                    children: [
                                      Icon(
                                        Icons.restart_alt_rounded,
                                        color: accentColor.withValues(alpha: 0.8),
                                        size: 16.sp,
                                      ),
                                      CustomText(
                                        "إعادة",
                                        color: accentColor.withValues(alpha: 0.8),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
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
              ],
            ),
          ),
        );
      },
    );
  }
}