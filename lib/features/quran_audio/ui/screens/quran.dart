import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/home/widgets/category_card.dart';
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
                childAspectRatio: 2.h,
              ),
              itemBuilder: (context, index) {
                final section = sections[index];
                return CategoryCardWidget(
                  title: section.title,
                  icon: section.icon,
                  onTap: () {
                    Navigator.pushNamed(context, section.route);
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primary = AppColors.kPrimary;

    final backgroundColors = isDark
        ? const [Color(0xFF155A52), Color(0xFF0C3934)]
        : const [Color(0xFF0F9F8E), Color(0xFF08796D)];

    final titleColor = Colors.white.withValues(alpha: .96);

    return Container(
      width: double.infinity,
      height: 178.h,
      margin: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 24.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: backgroundColors,
        ),
        border: Border.all(
          color: primary.withValues(alpha: isDark ? .35 : .20),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDark ? .16 : .18),
            blurRadius: 24.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -55.h,
              right: -35.w,
              child: IgnorePointer(
                child: Container(
                  width: 135.w,
                  height: 135.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: isDark ? .035 : .055),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -70.h,
              left: -45.w,
              child: IgnorePointer(
                child: Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: isDark ? .025 : .045),
                  ),
                ),
              ),
            ),



            // Main content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 62.w,
                      height: 62.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(
                          alpha: isDark ? .10 : .14,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .24),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .08),
                            blurRadius: 12.r,
                            offset: Offset(0, 5.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        FlutterIslamicIcons.solidQuran2,
                        size: 30.sp,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 13.h),

                    // Title
                    CustomText(
                      'القرآن الكريم',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
