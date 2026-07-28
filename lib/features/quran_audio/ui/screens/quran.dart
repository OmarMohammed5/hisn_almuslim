import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/home/widgets/custom_card_widget.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/quran_modeel.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../core/shared/app_bar_widget.dart';
import '../../../../core/theme/app_colors.dart';

class Quran extends StatelessWidget {
  const Quran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "القرآن الكريم"),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeroHeader(context)),

          // Categories
          SliverPadding(
            padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 12.h),
            sliver: SliverGrid.builder(
              itemCount: sections.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.h,
              ),
              itemBuilder: (context, index) {
                final section = sections[index];
                return CustomCardWidget(
                  title: section.title,
                  icon: section.icon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => section.screen),
                    );
                  },
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: Gap(100.h)),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 24.h),
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.teal.shade700, Colors.teal.shade900]
              : [AppColors.kPrimary, Colors.teal.shade600],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // decorative
          Positioned(
            bottom: -40,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          Positioned(
            top: -40,
            left: -40,
            child: IgnorePointer(
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    FlutterIslamicIcons.solidQuran2,
                    size: 36.sp,
                    color: Colors.white,
                  ),
                ),
                Gap(16.h),
                CustomText(
                  'المصحف الشريف',
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                Gap(6.h),
                CustomText(
                  'تلاوة، تفسير، واستماع لأصوات نخبة من القراء',
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
