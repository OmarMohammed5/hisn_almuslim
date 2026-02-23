import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/about%20app/widgets/about_card.dart';
import 'package:hisn_almuslim/features/about%20app/widgets/section_card.dart';
import 'package:hisn_almuslim/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/shared/app_logo.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "عن التطبيق"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          spacing: 16.h,
          children: [
            Gap(10.h),
            AppLogo(),
            Gap(10.h),
            AboutCard(),
            SectionCard(),
            Gap(10.h),
          ],
        ),
      ),
    );
  }
}
