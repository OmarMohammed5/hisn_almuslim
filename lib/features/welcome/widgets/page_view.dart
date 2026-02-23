import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';
import 'package:introduction_screen/introduction_screen.dart';

PageViewModel pageView({
  required String title,
  required String desc,
  required Widget icon,
  required List<String> featureBadges,
  required Color accentColor,
  bool isLast = false,
}) {
  return PageViewModel(
    titleWidget: _TitleWidget(title: title, accentColor: accentColor),
    bodyWidget: _BodyWidget(
      desc: desc,
      featureBadges: featureBadges,
      accentColor: accentColor,
      isLast: isLast,
    ),
    image: _ImageWidget(icon: icon, accentColor: accentColor),
  );
}

//  Title
class _TitleWidget extends StatelessWidget {
  final String title;
  final Color accentColor;

  const _TitleWidget({required this.title, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      child: Column(
        children: [
          // Decoration
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _decorativeLine(accentColor),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(Icons.dark_mode, color: accentColor, size: 14.sp),
              ),
              _decorativeLine(accentColor),
            ],
          ),
          SizedBox(height: 10.h),
          CustomText(
            title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            textAlign: TextAlign.center,
            height: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _decorativeLine(Color color) {
    return Container(
      width: 50.w,
      height: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.transparent, color]),
      ),
    );
  }
}

// Badges
class _BodyWidget extends StatelessWidget {
  final String desc;
  final List<String> featureBadges;
  final Color accentColor;
  final bool isLast;

  const _BodyWidget({
    required this.desc,
    required this.featureBadges,
    required this.accentColor,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),

              // Description Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24.r),
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: CustomText(
                  desc,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 11.sp,
                  height: 1.8,
                  // fontWeight: FontWeight.w400,
                ),
              ),

              // Feature Badges
              if (featureBadges.isNotEmpty) ...[
                SizedBox(height: 18.h),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: featureBadges.map((badge) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: CustomText(
                        badge,
                        fontSize: 10.sp,
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Glow
class _ImageWidget extends StatelessWidget {
  final Widget icon;
  final Color accentColor;

  const _ImageWidget({required this.icon, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.8 + (0.2 * value), child: child),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            Container(
              width: 130.w,
              height: 130.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.06),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
