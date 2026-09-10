import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';
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

    final maxWidth = AppResponsive.isDesktop(context)
        ? 1100.0
        : AppResponsive.isTablet(context)
        ? 820.0
        : double.infinity;

    return Scaffold(
      appBar: AppBarWidget(title: "القرآن الكريم"),
      body: Center(
        child: AppResponsive.constrain(
          context,
          maxWidth: maxWidth,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeroHeader(context, isDark)),
              // SECTION TITLE
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppResponsive.widthValue(context, 20),
                    AppResponsive.heightValue(context, 14),
                    AppResponsive.widthValue(context, 20),
                    AppResponsive.heightValue(context, 20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width:  AppResponsive.widthValue(context, 4),
                        height:  AppResponsive.heightValue(context, 18),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary,
                          borderRadius: BorderRadius.circular( AppResponsive.radius(context, 10)),
                        ),
                      ),

                      SizedBox(width:  AppResponsive.widthValue(context, 8)),

                      CustomText(
                        "اقرأ واستمع",
                        fontSize:  AppResponsive.fontSize(context, 12),
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF1C2B27),
                      ),
                    ],
                  ),
                ),
              ),

              // QURAN SECTIONS
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal:  AppResponsive.widthValue(context, 18)),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final section = sections[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom:  AppResponsive.heightValue(context, 14)),
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

              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppResponsive.heightValue(context, 100),
                ),
              ),
            ],
          ),
        ),
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
      height: AppResponsive.heightValue(context, 178),

      margin: EdgeInsets.fromLTRB(
        AppResponsive.widthValue(context, 18),
        AppResponsive.heightValue(context, 16),
        AppResponsive.widthValue(context, 18),
        AppResponsive.heightValue(context, 22),
      ),

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
        borderRadius: BorderRadius.circular( AppResponsive.radius(context, 28)),
        child: Stack(
          children: [
            // DECORATION
            Positioned(
              top:  AppResponsive.heightValue(context, -65),
              right:  AppResponsive.widthValue(context, -40),
              child: Container(
                width:  AppResponsive.widthValue(context, 170),
                height:  AppResponsive.heightValue(context, 170),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .045),
                ),
              ),
            ),
            Positioned(
              bottom:  AppResponsive.heightValue(context, -85),
              left:  AppResponsive.widthValue(context, -55),
              child: Container(
                width:  AppResponsive.widthValue(context, 180),
                height: AppResponsive.heightValue(context, 180),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .035),
                    width: AppResponsive.widthValue(context, 22),
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
                    width: AppResponsive.widthValue(context, 62),
                    height: AppResponsive.heightValue(context, 62),
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
                      size:  AppResponsive.iconSize(context, 31),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height:  AppResponsive.heightValue(context, 14)),
                  CustomText(
                    'القرآن الكريم',
                    fontSize:  AppResponsive.fontSize(context, 16),
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
