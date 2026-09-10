import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/notification_cubit.dart';
import 'package:hisn_almuslim/features/settings/data/cubit/theme_cubit.dart';
import 'package:hisn_almuslim/features/settings/widgets/about_app_widget.dart';
import 'package:hisn_almuslim/features/settings/widgets/azkar_notifications_build.dart';
import 'package:hisn_almuslim/features/settings/widgets/change_theme_mode.dart';
import 'package:hisn_almuslim/features/settings/widgets/daily_wird_notificaation_build.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/settings/widgets/list_tile_widget.dart';
import '../../../core/shared/app_bar_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/app_responsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.state == ThemeMode.dark;
    final isLight = themeCubit.state == ThemeMode.light;


    final maxWidth = AppResponsive.isDesktop(context)
        ? 1100.0
        : AppResponsive.isTablet(context)
        ? 820.0
        : double.infinity;


    return Scaffold(
      appBar: AppBarWidget(title: "اِلإِعْدَادَات"),
      body: AppResponsive.constrain(
        context,
        maxWidth: maxWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.widthValue(context, 16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(AppResponsive.heightValue(context, 20)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(context, 16),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    "تغيير المظهر",
                    fontWeight: FontWeight.bold,
                    fontSize: AppResponsive.fontSize(context, 12),
                  ),
                ),
              ),
              Gap(AppResponsive.heightValue(context, 10)),
              ChangeThemeMode(isDark: isDark, isLight: isLight),

              Gap(AppResponsive.heightValue(context, 25)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(context, 16),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    "الورد اليومي",
                    fontSize: AppResponsive.fontSize(context, 12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(AppResponsive.heightValue(context, 10)),
              const WirdNotificationBuild(),

              Gap(AppResponsive.heightValue(context, 25)),

              //  AZKAR NOTIFICATIONS
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(context, 16),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    "منبهات الأذكار",
                    fontSize: AppResponsive.fontSize(context, 12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(AppResponsive.heightValue(context, 10)),
              const AzkarNotificationsBuild(),

              Gap(AppResponsive.heightValue(context, 90)),
            ],
          ),
        ),
      ),
    );
  }
}
