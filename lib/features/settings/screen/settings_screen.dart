import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/features/adhan/data/cubit/adhan_settings_cubit.dart';
import 'package:hisn_almuslim/features/adhan/widgets/adhan_settings_widget.dart';
import 'package:hisn_almuslim/features/settings/widgets/about_app_widget.dart';
import 'package:hisn_almuslim/features/settings/widgets/azkar_notifications_build.dart';
import 'package:hisn_almuslim/features/settings/widgets/build_adhan_card.dart';
import 'package:hisn_almuslim/features/settings/widgets/change_theme_mode.dart';
import 'package:hisn_almuslim/features/settings/widgets/daily_wird_notificaation_build.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/settings/widgets/list_tile_widget.dart';
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
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Gap(10.h),
            ChangeThemeMode(isDark: isDark, isLight: isLight),

            Gap(25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  "الورد اليومي",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(10.h),
            const WirdNotificationBuild(),

            Gap(25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  "الأذان",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(10.h),

           BuildAdhanCard(isDark: isDark),

            // BlocProvider(
            // create: (_) => AdhanSettingsCubit(),
            // child:
            // const AdhanSettingsWidget(),
            // ),
            Gap(25.h),

            //  AZKAR NOTIFICATIONS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  "منبهات الأذكار",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(10.h),
            const AzkarNotificationsBuild(),

            Gap(130.h),
          ],
        ),
      ),
    );
  }

}
