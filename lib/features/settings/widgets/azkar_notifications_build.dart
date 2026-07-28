import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_state.dart';
import 'package:hisn_almuslim/features/settings/widgets/list_tile_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/shared/custom_snack_bar.dart';
import '../../../core/theme/app_colors.dart';

class AzkarNotificationsBuild extends StatelessWidget {
  const AzkarNotificationsBuild({super.key});

  // Method to show time picker
  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != initialTime) {
      onTimeSelected(picked);
    }
  }

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
    return Column(
      children: [
        /// Morning + Evening Notifications
        BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            return Column(
              // spacing: 15,
              children: [
                // =====================
                // Morning Azkar Toggle
                // =====================
                ListTileWidget(
                  icon: state.enableMorning
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  title: 'أذكار الصباح',
                  trailing: Switch(
                    value: state.enableMorning,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.kIconColor,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                    onChanged: (value) {
                      context.read<NotificationCubit>().toggleMorning(value);

                      final message = value
                          ? "تم تفعيل أذكار الصباح"
                          : "تم إيقاف أذكار الصباح";

                      final icon = value
                          ? Icons.notifications_active_outlined
                          : Icons.notifications_off_outlined;

                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar(
                          message,
                          icon,
                          context,
                          lightColor: value
                              ? Colors.teal.shade700
                              : Colors.red.shade700,
                          darkColor: value
                              ? Colors.teal.shade900
                              : Colors.red.shade900,
                        ),
                      );
                    },
                  ),
                ),
                if (state.enableMorning)
                  Divider(
                    color: isDark
                        ? const Color(0xff023d22)
                        : Colors.grey.shade300,
                  ),
                // =====================
                // Morning Time Picker
                // =====================
                if (state.enableMorning)
                  GestureDetector(
                    onTap: () {
                      _selectTime(context, state.morningTime, (selectedTime) {
                        context.read<NotificationCubit>().setMorningTime(
                          selectedTime,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            "تم تغيير وقت أذكار الصباح إلى ${_formatTimeArabic(selectedTime)}",
                            Icons.access_time,
                            context,
                            lightColor: Colors.blue.shade700,
                            darkColor: Colors.blue.shade900,
                          ),
                        );
                      });
                    },
                    child: ListTileWidget(
                      icon: Icons.access_time,
                      title: 'وقت أذكار الصباح',
                      trailing: Container(
                        padding: EdgeInsets.all(6.w),
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
                              _formatTimeArabic(state.morningTime),
                              color: AppColors.kIconColor,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w700,
                            ),

                            Icon(
                              Icons.edit_notifications_outlined,
                              size: 17.sp,
                              color: AppColors.kIconColor.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Divider(
                  color: isDark
                      ? const Color(0xff023d22)
                      : Colors.grey.shade300,
                ),
                // =====================
                // Evening Azkar Toggle
                // =====================
                ListTileWidget(
                  icon: state.enableEvening
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  title: "أذكار المساء",
                  trailing: Switch(
                    value: state.enableEvening,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.kIconColor,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                    onChanged: (value) {
                      context.read<NotificationCubit>().toggleEvening(value);

                      final message = value
                          ? "تم تفعيل أذكار المساء"
                          : "تم إيقاف أذكار المساء";

                      final icon = value
                          ? Icons.notifications_active_outlined
                          : Icons.notifications_off_outlined;

                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar(
                          message,
                          icon,
                          context,
                          lightColor: value
                              ? Colors.teal.shade700
                              : Colors.red.shade700,
                          darkColor: value
                              ? Colors.teal.shade900
                              : Colors.red.shade900,
                        ),
                      );
                    },
                  ),
                ),
                if (state.enableEvening)
                  Divider(
                    color: isDark
                        ? const Color(0xff023d22)
                        : Colors.grey.shade300,
                  ),
                // =====================
                // Evening Time Picker
                // =====================
                if (state.enableEvening)
                  GestureDetector(
                    onTap: () {
                      _selectTime(context, state.eveningTime, (selectedTime) {
                        context.read<NotificationCubit>().setEveningTime(
                          selectedTime,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            "تم تغيير وقت أذكار المساء إلى ${_formatTimeArabic(selectedTime)}",
                            Icons.access_time,
                            context,
                            lightColor: Colors.blue.shade700,
                            darkColor: Colors.blue.shade900,
                          ),
                        );
                      });
                    },
                    child: ListTileWidget(
                      icon: Icons.access_time,
                      title: 'وقت أذكار المساء',
                      trailing: Container(
                        padding: EdgeInsets.all(6.w),
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
                              _formatTimeArabic(state.eveningTime),
                              color: AppColors.kIconColor,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w700,
                            ),

                            Icon(
                              Icons.edit_notifications_outlined,
                              size: 17.sp,
                              color: AppColors.kIconColor.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
