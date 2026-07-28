import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<CounterCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final accentColor = isDark
        ? Colors.tealAccent.shade200
        : Colors.teal.shade700;
    final textColor = isDark ? Colors.white : Colors.black87;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.2)
        : Colors.grey.shade300.withValues(alpha: 0.5);

    return BlocBuilder<CounterCubit, Map<int, int>>(
      builder: (context, state) {
        final total = context.read<CounterCubit>().total;
        return Container(
          margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 2.h),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20.r),
            border: isDark
                ? Border.all(color: Colors.grey.shade800, width: 1.w)
                : Border.all(color: Colors.grey.shade200, width: 1.w),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: isDark ? 16 : 12,
                spreadRadius: isDark ? 0 : 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),

            child: Column(
              children: [
                // Top decorative bar
                Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.3),
                        accentColor,
                        accentColor.withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Row(
                    children: [
                      // Quranic verse section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: CustomText(
                                  "قال تعالى",
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ),
                            Gap(12.h),
                            Text(
                              "﴿ وَمَن أَعْرَضَ عَن ذِكْرِي فَإِنَّ لَهُ مَعِيشَةً ضَنكًا وَنَحْشُرُهُ يَوْمَ الْقِيَامَةِ أَعْمَى ﴾",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                height: 2.0,
                                fontFamily: "Noon",
                                color: textColor,
                              ),
                            ),
                            Gap(10.h),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CustomText(
                                "صدق الله العظيم",
                                fontSize: 9.5.sp,
                                color: textColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Gap(24.h),

                      // Counter section
                      Column(
                        children: [
                          // Counter circle
                          Container(
                            width: 75.w,
                            height: 75.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  accentColor.withValues(alpha: 0.15),
                                  accentColor.withValues(alpha: 0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.3),
                                width: 3.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: CustomText(
                                "$total",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ),

                          Gap(12.h),

                          // Reset button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                context.read<CounterCubit>().resetAll();
                              },
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: accentColor.withValues(alpha: 0.3),
                                    width: 1.w,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 6.w,
                                  children: [
                                    Icon(
                                      Icons.restart_alt_rounded,
                                      color: accentColor,
                                      size: 15.sp,
                                    ),
                                    CustomText(
                                      "إعادة",
                                      color: accentColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
