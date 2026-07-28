import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class ZekrCounterCard extends StatelessWidget {
  const ZekrCounterCard({super.key, required this.title, required this.index});

  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final borderColor = isDark ? Colors.white24 : Colors.grey.withOpacity(0.3);

    return BlocBuilder<CounterCubit, Map<int, int>>(
      builder: (context, state) {
        final count = state[index] ?? 0;

        return GestureDetector(
          onTap: () {
            context.read<CounterCubit>().increment(index);
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Circular Counter
                Container(
                  width: 47.w,
                  height: 47.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.teal.withOpacity(0.15)
                        : Colors.teal.withOpacity(0.08),
                  ),
                  child: CustomText(
                    '$count',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.tealAccent : Colors.teal.shade800,
                  ),
                ),

                Gap(14.h),

                /// Zekr Title
                CustomText(
                  title,
                  fontSize: 9.7.sp,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
