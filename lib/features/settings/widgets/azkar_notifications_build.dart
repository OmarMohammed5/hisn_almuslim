import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_state.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/responsive/app_responsive.dart';

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
                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
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
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: AppResponsive.heightValue(context, 8), horizontal: AppResponsive.widthValue(context, 4)),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey.shade900.withOpacity(0.3)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
            border: Border.all(
              color: isDark
                  ? Colors.grey.shade800.withOpacity(0.3)
                  : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              /// Morning Azkar
              _buildAzkarToggle(
                context: context,
                isDark: isDark,
                isEnabled: state.enableMorning,
                title: 'أذكار الصباح',
                icon: state.enableMorning
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
                activeColor: Colors.amber.shade700,
                onToggle: (value) {
                  context.read<NotificationCubit>().toggleMorning(value);
                },
              ),

              if (state.enableMorning) ...[
                Divider(
                  color: isDark
                      ? Colors.grey.shade800.withOpacity(0.3)
                      : Colors.grey.shade200,
                  height: AppResponsive.heightValue(context, 1),
                  indent: AppResponsive.widthValue(context, 16),
                  endIndent: AppResponsive.widthValue(context, 16),
                ),
                Gap(AppResponsive.heightValue(context, 4)),
                _buildTimePickerTile(
                  context: context,
                  isDark: isDark,
                  time: state.morningTime,
                  title: 'وقت أذكار الصباح',
                  onTap: () {
                    _selectTime(context, state.morningTime, (selectedTime) {
                      context.read<NotificationCubit>().setMorningTime(
                        selectedTime,
                      );
                    });
                  },
                ),
                Gap(AppResponsive.heightValue(context, 4)),
              ],

              Divider(
                color: isDark
                    ? Colors.grey.shade800.withOpacity(0.3)
                    : Colors.grey.shade200,
                height: AppResponsive.heightValue(context, 1),
                indent: AppResponsive.widthValue(context, 16),
                endIndent: AppResponsive.widthValue(context, 16),
              ),

              /// Evening Azkar
              _buildAzkarToggle(
                context: context,
                isDark: isDark,
                isEnabled: state.enableEvening,
                title: 'أذكار المساء',
                icon: state.enableEvening
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
                activeColor: Colors.deepPurple.shade400,
                onToggle: (value) {
                  context.read<NotificationCubit>().toggleEvening(value);
                },
              ),

              if (state.enableEvening) ...[
                Divider(
                  color: isDark
                      ? Colors.grey.shade800.withOpacity(0.3)
                      : Colors.grey.shade200,
                  height: AppResponsive.heightValue(context, 1),
                  indent: AppResponsive.widthValue(context, 16),
                  endIndent: AppResponsive.widthValue(context, 16),
                ),
                Gap(AppResponsive.heightValue(context, 4)),
                _buildTimePickerTile(
                  context: context,
                  isDark: isDark,
                  time: state.eveningTime,
                  title: 'وقت أذكار المساء',
                  onTap: () {
                    _selectTime(context, state.eveningTime, (selectedTime) {
                      context.read<NotificationCubit>().setEveningTime(
                        selectedTime,
                      );
                    });
                  },
                ),
                Gap(AppResponsive.heightValue(context, 4)),
              ],

              Divider(
                color: isDark
                    ? Colors.grey.shade800.withOpacity(0.3)
                    : Colors.grey.shade200,
                height: AppResponsive.heightValue(context, 1),
                indent: AppResponsive.widthValue(context, 16),
                endIndent: AppResponsive.widthValue(context, 16),
              ),

              /// Recurring Salat upon the Prophet reminder
              _buildAzkarToggle(
                context: context,
                isDark: isDark,
                isEnabled: state.enableDhikrReminder,
                title: 'الصلاة على النبي ﷺ',
                icon: state.enableDhikrReminder
                    ? FlutterIslamicIcons.mohammad
                    : FlutterIslamicIcons.mohammad,
                activeColor: Colors.teal.shade600,
                onToggle: (value) {
                  context.read<NotificationCubit>().toggleDhikrReminder(value);
                },
              ),

              if (state.enableDhikrReminder) ...[
                Divider(
                  color: isDark
                      ? Colors.grey.shade800.withOpacity(0.3)
                      : Colors.grey.shade200,
                  height: AppResponsive.heightValue(context, 1),
                  indent: AppResponsive.widthValue(context, 16),
                  endIndent: AppResponsive.widthValue(context, 16),
                ),
                Gap(AppResponsive.heightValue(context, 4)),
                _buildDhikrReminderIntervalTile(
                  context: context,
                  isDark: isDark,
                  minutes: state.dhikrReminderMinutes,
                ),
                Gap(AppResponsive.heightValue(context, 4)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAzkarToggle({
    required BuildContext context,
    required bool isDark,
    required bool isEnabled,
    required String title,
    required IconData icon,
    required Color activeColor,
    required Function(bool) onToggle,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onToggle(!isEnabled);
        },
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        splashColor: isEnabled
            ? activeColor.withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10), vertical: AppResponsive.heightValue(context, 8)),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
                decoration: BoxDecoration(
                  gradient: isEnabled
                      ? LinearGradient(
                    colors: [
                      activeColor.withOpacity(0.15),
                      activeColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: isDark
                      ? (isEnabled
                      ? activeColor.withOpacity(0.15)
                      : Colors.grey.shade800.withOpacity(0.2))
                      : (isEnabled
                      ? activeColor.withOpacity(0.08)
                      : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
                  border: Border.all(
                    color: isEnabled
                        ? activeColor.withOpacity(0.2)
                        : (isDark
                        ? Colors.grey.shade700.withOpacity(0.1)
                        : Colors.grey.shade200),
                    width: isEnabled ? 1.5 : 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: AppResponsive.iconSize(context, 20),
                  color: isEnabled
                      ? activeColor
                      : (isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600),
                ),
              ),

              Gap(AppResponsive.widthValue(context, 14)),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontSize: AppResponsive.fontSize(context, 13),
                      fontWeight: isEnabled ? FontWeight.w700 : FontWeight.w600,
                      color: isEnabled
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              // Custom Switch
              _buildCustomSwitch(
                context: context,
                isActive: isEnabled,
                activeColor: activeColor,
                isDark: isDark,
                onChanged: () {
                  onToggle(!isEnabled);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDhikrReminderIntervalTile({
    required BuildContext context,
    required bool isDark,
    required int minutes,
  }) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10), vertical: AppResponsive.heightValue(context, 8)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.teal.shade800.withOpacity(0.2)
                    : Colors.teal.shade50,
                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
                border: Border.all(
                  color: isDark
                      ? Colors.teal.shade800.withOpacity(0.2)
                      : Colors.teal.shade100,
                ),
              ),
              child: Icon(
                Icons.schedule_rounded,
                size: AppResponsive.iconSize(context, 20),
                color: isDark
                    ? Colors.teal.shade300
                    : Colors.teal.shade700,
              ),
            ),
            Gap(AppResponsive.widthValue(context, 14)),
            Expanded(
              child: CustomText(
                'التذكير كل',
                fontSize: AppResponsive.fontSize(context, 13),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.teal.shade900.withOpacity(0.25)
                    : Colors.teal.shade50,
                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 10)),
                border: Border.all(
                  color: isDark
                      ? Colors.teal.shade800.withOpacity(0.3)
                      : Colors.teal.shade100,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: minutes,
                  isDense: true,
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: AppResponsive.iconSize(context, 20),
                    color: isDark
                        ? Colors.teal.shade300
                        : Colors.teal.shade700,
                  ),
                  dropdownColor: isDark
                      ? Colors.grey.shade900
                      : Colors.white,
                  items: NotificationCubit.dhikrReminderIntervals
                      .map(
                        (value) => DropdownMenuItem<int>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: CustomText(
                          '$value دقيقة',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.teal.shade200
                              : Colors.teal.shade700,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    context
                        .read<NotificationCubit>()
                        .setDhikrReminderMinutes(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerTile({
    required BuildContext context,
    required bool isDark,
    required TimeOfDay time,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        splashColor: Colors.teal.withOpacity(0.05),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10), vertical: AppResponsive.heightValue(context, 8)),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.teal.shade800.withOpacity(0.2)
                      : Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
                  border: Border.all(
                    color: isDark
                        ? Colors.teal.shade800.withOpacity(0.2)
                        : Colors.teal.shade100,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.access_time,
                  size: AppResponsive.iconSize(context, 20),
                  color: isDark
                      ? Colors.teal.shade300
                      : Colors.teal.shade700,
                ),
              ),

              Gap(AppResponsive.widthValue(context, 14)),

              // Title
              Expanded(
                child: CustomText(
                  title,
                  fontSize: AppResponsive.fontSize(context, 13),
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),

              // Time Display
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 14), vertical: AppResponsive.heightValue(context, 6)),
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
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 10)),
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
                      size: AppResponsive.iconSize(context, 16),
                      color: isDark
                          ? Colors.teal.shade300
                          : Colors.teal.shade700,
                    ),
                    SizedBox(width: AppResponsive.widthValue(context, 8)),
                    CustomText(
                      _formatTimeArabic(time),
                      color: isDark
                          ? Colors.teal.shade200
                          : Colors.teal.shade700,
                      fontSize: AppResponsive.fontSize(context, 13),
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
    required BuildContext context,
    required bool isActive,
    required Color activeColor,
    required bool isDark,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: AppResponsive.widthValue(context, 48),
        height: AppResponsive.heightValue(context, 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
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
              width: AppResponsive.widthValue(context, 48),
              height: AppResponsive.heightValue(context, 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
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
                padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 3)),
                child: Container(
                  width: AppResponsive.widthValue(context, 22),
                  height: AppResponsive.widthValue(context, 22),
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
                    size: AppResponsive.iconSize(context, 14),
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
