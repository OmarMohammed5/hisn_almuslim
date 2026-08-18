import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_state.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/theme/app_colors.dart';

class WirdNotificationBuild extends StatefulWidget {
  const WirdNotificationBuild({super.key});

  @override
  State<WirdNotificationBuild> createState() => _WirdNotificationBuildState();
}

class _WirdNotificationBuildState extends State<WirdNotificationBuild> {
  // Format time to Arabic AM/PM
  String _formatTimeArabic(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final cubit = context.read<NotificationCubit>();

        return Column(
          children: [
            ///
            Row(
              spacing: 14.w,
              children: [
                Gap(2.w),
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.teal.shade800.withValues(alpha: 0.3)
                        : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    FlutterIslamicIcons.quran2,
                    size: 22.sp,
                    color: AppColors.kIconColor,
                  ),
                ),

                CustomText("ورد القرآن", fontSize: 12.sp),
                const Spacer(),
                Switch(
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.kIconColor,
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                  value: state.enableDailyWird,
                  onChanged: (value) {
                    cubit.toggleDailyWird(value);
                  },
                ),
                Gap(9.w),
              ],
            ),

            /// Choose the timing
            if (state.enableDailyWird) ...[
              Divider(
                color: isDark ? const Color(0xff023d22) : Colors.grey.shade300,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: state.dailyWirdTime,
                  );

                  if (picked != null) {
                    cubit.changeDailyWirdTime(picked);
                  }
                },
                title: Row(
                  spacing: 14.w,
                  children: [
                    Gap(2.w),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.teal.shade800.withValues(alpha: 0.3)
                            : Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.access_time,
                        size: 22.sp,
                        color: AppColors.kIconColor,
                      ),
                    ),
                    CustomText("وقت التنبيه", fontSize: 12.5.sp),
                  ],
                ),
                trailing: Container(
                  padding: EdgeInsets.all(6.w),
                  margin: EdgeInsets.only(left: 17.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.teal.shade800.withValues(alpha: 0.3)
                        : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.w,
                    children: [
                      CustomText(
                        _formatTimeArabic(state.dailyWirdTime),
                        color: AppColors.kIconColor,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                      ),

                      Icon(
                        Icons.edit_notifications_outlined,
                        size: 17.sp,
                        color: AppColors.kIconColor.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
