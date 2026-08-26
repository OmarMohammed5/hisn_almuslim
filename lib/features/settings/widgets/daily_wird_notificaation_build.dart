import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_state.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';


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

        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey.shade900.withOpacity(0.3)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? Colors.grey.shade800.withOpacity(0.3)
                  : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              /// Main Toggle Row
              _buildMainToggle(
                context: context,
                state: state,
                cubit: cubit,
                isDark: isDark,
              ),

              /// Choose the timing
              if (state.enableDailyWird) ...[
                Divider(
                  color: isDark
                      ? Colors.grey.shade800.withOpacity(0.3)
                      : Colors.grey.shade200.withValues(alpha: 0.5),
                  height: 1.h,
                  indent: 16.w,
                  endIndent: 16.w,
                ),
                Gap(4.h),
                _buildTimePicker(
                  context: context,
                  state: state,
                  cubit: cubit,
                  isDark: isDark,
                ),
                Gap(4.h),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainToggle({
    required BuildContext context,
    required NotificationState state,
    required NotificationCubit cubit,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          cubit.toggleDailyWird(!state.enableDailyWird);
        },
        borderRadius: BorderRadius.circular(12.r),
        splashColor: state.enableDailyWird
            ? Colors.teal.withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: state.enableDailyWird
                      ? LinearGradient(
                    colors: [
                      Colors.teal.shade700.withOpacity(0.15),
                      Colors.teal.shade700.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: isDark
                      ? (state.enableDailyWird
                      ? Colors.teal.shade700.withOpacity(0.15)
                      : Colors.grey.shade800.withOpacity(0.2))
                      : (state.enableDailyWird
                      ? Colors.teal.shade50.withOpacity(0.8)
                      : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: state.enableDailyWird
                        ? Colors.teal.shade700.withOpacity(0.2)
                        : (isDark
                        ? Colors.grey.shade700.withOpacity(0.1)
                        : Colors.grey.shade200),
                    width: state.enableDailyWird ? 1.5 : 1,
                  ),
                ),
                child: Icon(
                  FlutterIslamicIcons.quran2,
                  size: 20.sp,
                  color: state.enableDailyWird
                      ? Colors.teal.shade700
                      : (isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600),
                ),
              ),

              Gap(14.w),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "ورد القرآن",
                      fontSize: 13.sp,
                      fontWeight: state.enableDailyWird
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: state.enableDailyWird
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              // Custom Switch
              _buildCustomSwitch(
                isActive: state.enableDailyWird,
                activeColor: Colors.teal.shade700,
                isDark: isDark,
                onChanged: () {
                  cubit.toggleDailyWird(!state.enableDailyWird);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required NotificationState state,
    required NotificationCubit cubit,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: state.dailyWirdTime,
          );

          if (picked != null) {
            cubit.changeDailyWirdTime(picked);
          }
        },
        borderRadius: BorderRadius.circular(12.r),
        splashColor: Colors.teal.withOpacity(0.05),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.teal.shade800.withOpacity(0.2)
                      : Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.teal.shade800.withOpacity(0.2)
                        : Colors.teal.shade100,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.access_time,
                  size: 20.sp,
                  color: isDark
                      ? Colors.teal.shade300
                      : Colors.teal.shade700,
                ),
              ),

              Gap(14.w),

              // Title
              Expanded(
                child: CustomText(
                  "وقت التنبيه",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),

              // Time Display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDark
                          ? Colors.teal.shade800.withOpacity(0.3)
                          : Colors.teal.shade50,
                      isDark
                          ? Colors.teal.shade900.withOpacity(0.1)
                          : Colors.teal.shade50.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.teal.shade800.withOpacity(0.2)
                        : Colors.teal.shade100,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_notifications_outlined,
                      size: 16.sp,
                      color: isDark
                          ? Colors.teal.shade300
                          : Colors.teal.shade700,
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      _formatTimeArabic(state.dailyWirdTime),
                      color: isDark
                          ? Colors.teal.shade200
                          : Colors.teal.shade700,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch({
    required bool isActive,
    required Color activeColor,
    required bool isDark,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48.w,
        height: 28.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: isActive
              ? activeColor
              : (isDark
              ? Colors.grey.shade700
              : Colors.grey.shade300),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: activeColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Track
            Container(
              width: 48.w,
              height: 28.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                gradient: isActive
                    ? LinearGradient(
                  colors: [
                    activeColor,
                    activeColor.withOpacity(0.7),
                  ],
                )
                    : null,
              ),
            ),

            // Thumb
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isActive
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isActive ? Icons.check_rounded : Icons.close_rounded,
                    size: 14.sp,
                    color: isActive ? activeColor : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}