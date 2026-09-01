import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hisn_almuslim/features/asma%20allah/data/model/asma_allah_model.dart';

class AsmaCard extends StatelessWidget {
  final AsmaAllahModel model;
  final VoidCallback? onTap;

  const AsmaCard({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accent = isDark ? const Color(0xFF63D8C2) : const Color(0xFF087F73);

    final cardColor = isDark ? const Color(0xFF142522) : Colors.white;

    final titleColor = isDark
        ? const Color(0xFFF0F5F2)
        : const Color(0xFF12332E);

    final bodyColor = isDark
        ? const Color(0xFFA7B5B0)
        : const Color(0xFF58736D);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 8.h),

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,

        child: Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: cardColor,

            borderRadius: BorderRadius.circular(30.r),

            border: Border.all(
              color: accent.withValues(alpha: .12),
              width: 1.w,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .18 : .055),
                blurRadius: 24.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),

            child: Stack(
              children: [
                // =================================================
                // BACKGROUND WATERMARK
                // =================================================
                Positioned(
                  top: -35.h,
                  right: -25.w,

                  child: Text(
                    'الله',
                    style: TextStyle(
                      fontFamily: 'QuranFont',
                      fontSize: 130.sp,
                      fontWeight: FontWeight.bold,
                      color: accent.withValues(alpha: isDark ? .025 : .035),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -45.h,
                  left: -25.w,

                  child: Container(
                    width: 120.w,
                    height: 120.w,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accent.withValues(alpha: .045),
                        width: 14.w,
                      ),
                    ),
                  ),
                ),

                // =================================================
                // CONTENT
                // =================================================
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // ===========================================
                      // SMALL LABEL
                      // ===========================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            width: 5.w,
                            height: 5.w,

                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                          ),

                          SizedBox(width: 7.w),

                          Text(
                            'مِنْ أَسْمَاءِ اللهِ الْحُسْنَى',
                            style: TextStyle(
                              fontFamily: 'Noon',
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),

                          SizedBox(width: 7.w),

                          Container(
                            width: 5.w,
                            height: 5.w,

                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 28.h),

                      // ===========================================
                      // NAME
                      // ===========================================
                      Text(
                        model.name,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontFamily: 'QuranFont',
                          fontSize: 43.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: titleColor,
                        ),
                      ),

                      SizedBox(height: 14.h),

                      // ===========================================
                      // DECORATIVE LINE
                      // ===========================================
                      Container(
                        width: 42.w,
                        height: 3.h,

                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // ===========================================
                      // DESCRIPTION
                      // ===========================================
                      Text(
                        model.text,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontFamily: 'QuranFont',
                          fontSize: 17.sp,
                          height: 2,
                          fontWeight: FontWeight.w400,
                          color: bodyColor,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // ===========================================
                      // TAP INDICATOR
                      // ===========================================
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 13.w,
                          vertical: 7.h,
                        ),

                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: .06),

                          borderRadius: BorderRadius.circular(20.r),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              Icons.touch_app_outlined,
                              size: 13.sp,
                              color: accent,
                            ),

                            SizedBox(width: 6.w),

                            Text(
                              'اضغط للمتابعة',
                              style: TextStyle(
                                fontFamily: 'Noon',
                                fontSize: 8.5.sp,
                                fontWeight: FontWeight.w600,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
