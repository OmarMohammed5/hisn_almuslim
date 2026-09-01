import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/quran_modeel.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../widgets/quran_section_card.dart';

class Quran extends StatelessWidget {
  const Quran({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidget(title: "القرآن الكريم"),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeroHeader(context, isDark)),
          // SECTION TITLE
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 2.h, 20.w, 14.h),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  CustomText(
                    "اقرأ واستمع",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1C2B27),
                  ),
                ],
              ),
            ),
          ),

          // QURAN SECTIONS
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),

            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final section = sections[index];

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),

                  child: QuranSectionCard(
                    title: section.title,
                    icon: section.icon,
                    subtitle: _getSubtitle(index),
                    onTap: () {
                      Navigator.pushNamed(context, section.route);
                    },
                  ),
                );
              }, childCount: sections.length),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }


  String _getSubtitle(int index) {
    switch (index) {
      case 0:
        return 'قراءة المصحف الشريف';
      case 1:
        return 'استمع إلى تلاوات القرآن';
      default:
        return 'اكتشف المزيد';
    }
  }


  Widget _buildHeroHeader(BuildContext context, bool isDark) {
    final primary = AppColors.kPrimary;

    final background = isDark
        ? const Color(0xFF123F3A)
        : const Color(0xFF087F73);

    final background2 = isDark
        ? const Color(0xFF0C2D2A)
        : const Color(0xFF0A6D63);

    return Container(
      height: 178.h,

      margin: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 22.h),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),

        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,

          colors: [background, background2],
        ),

        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDark ? .12 : .16),
            blurRadius: 25.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),

        child: Stack(
          children: [

            // DECORATION
            Positioned(
              top: -65.h,
              right: -40.w,

              child: Container(
                width: 170.w,
                height: 170.w,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.white.withValues(alpha: .045),
                ),
              ),
            ),

            Positioned(
              bottom: -85.h,
              left: -55.w,

              child: Container(
                width: 180.w,
                height: 180.w,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(
                    color: Colors.white.withValues(alpha: .035),
                    width: 22.w,
                  ),
                ),
              ),
            ),

            // CONTENT
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 62.w,
                    height: 62.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: .09),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .22),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      FlutterIslamicIcons.solidQuran2,
                      size: 31.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  CustomText(
                    'القرآن الكريم',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
