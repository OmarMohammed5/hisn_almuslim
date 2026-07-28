import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/features/settings/widgets/about_app_widget.dart';
import 'package:hisn_almuslim/features/settings/widgets/azkar_notifications_build.dart';
import 'package:hisn_almuslim/features/settings/widgets/change_theme_mode.dart';
import 'package:hisn_almuslim/features/settings/widgets/daily_wird_notificaation_build.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/shared/app_bar_widget.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == ThemeMode.dark;
    final isLight = themeCubit.state == ThemeMode.light;
    return Scaffold(
      appBar: AppBarWidget(title: "اِلإِعْدَادَات"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  "تغيير المظهر",
                  color: AppColors.kIconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Gap(10.h),
            _sectionCard(
              isDark,
              ChangeThemeMode(isDark: isDark, isLight: isLight),
            ),

            Gap(25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  "الورد اليومي",
                  color: AppColors.kIconColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(10.h),
            _sectionCard(isDark, const WirdNotificationBuild()),

            Gap(25.h),

            //  AZKAR NOTIFICATIONS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  "منبهات الأذكار",
                  color: AppColors.kIconColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(10.h),
            _sectionCard(isDark, const AzkarNotificationsBuild()),

            Gap(25.h),

            // ABOUT APP
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  "عن التطبيق",
                  color: AppColors.kIconColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(10.h),
            _sectionCard(isDark, const AboutAppWidget()),

            Gap(120.h),
          ],
        ),
      ),
    );
  }

  // UI HELPERs

  Widget _sectionCard(bool isDark, Widget child) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2126) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Color(0xff023d22) : Colors.grey.shade300,
        ),
      ),
      child: child,
    );
  }
}
