import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';

class QuranSectionCard extends StatefulWidget {
  const QuranSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<QuranSectionCard> createState() => _QuranSectionCardState();
}

class _QuranSectionCardState extends State<QuranSectionCard> {
  bool _pressed = false;

  void _handleTap() {
    setState(() {
      _pressed = true;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      setState(() {
        _pressed = false;
      });
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primary = AppColors.kPrimary;

    final background = isDark ? const Color(0xFF151D1B) : Colors.white;

    final titleColor = isDark
        ? const Color(0xFFE8EFEC)
        : const Color(0xFF172C27);

    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: .42)
        : const Color(0xFF75847F);

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _pressed ? .975 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 75.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: primary.withValues(alpha: isDark ? .12 : .08),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: primary.withValues(alpha: .045),
                  blurRadius: 14.r,
                  offset: Offset(0, 6.h),
                ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isDark ? .10 : .07),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: primary.withValues(alpha: .10)),
                ),
                child: Icon(
                  widget.icon,
                  size: 23.sp,
                  color: isDark ? Colors.tealAccent.shade200 : primary,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      widget.title,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                      maxLines: 1,
                    ),
                    SizedBox(height: 9.h),
                    CustomText(
                      widget.subtitle,
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isDark ? .08 : .05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.sp,
                  color: primary.withValues(alpha: .75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
