import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/features/adhan/widgets/adhan_settings_widget.dart';


class AdhanSettingsScreen extends StatelessWidget {
  const AdhanSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "اعدادات الأذان"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w , vertical: 12.h),
        child: Column(
          children: [
            const AdhanSettingsWidget(),
            Gap(30.h),
          ],
        ),
      ),
    );
  }
}
