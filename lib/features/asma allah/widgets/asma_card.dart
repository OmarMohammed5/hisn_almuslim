import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/model/asma_allah_model.dart';

class AsmaCard extends StatelessWidget {
  final AsmaAllahModel model;
  final VoidCallback? onTap;

  const AsmaCard({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF1A3A3A), const Color(0xFF112828)]
                  : [Colors.white, const Color(0xFFF0FAFA)],
            ),
            border: Border.all(
              color: isDark
                  ? Colors.teal.withOpacity(0.2)
                  : Colors.teal.withOpacity(0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 2),
                color: Colors.teal.withOpacity(isDark ? 0.15 : 0.1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    model.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0D3333),
                      fontFamily: "QuranFont",
                      height: 1.3,
                    ),
                  ),
                  Gap(8.h),
                  Container(
                    height: 3.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade600, Colors.teal.shade700],
                      ),
                    ),
                  ),
                ],
              ),
              Gap(28.h),
              Text(
                model.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: "QuranFont",
                  height: 1.7.h,
                  color: isDark
                      ? Colors.white60
                      : Colors.teal.shade900.withOpacity(0.7),
                ),
              ),
              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }
}