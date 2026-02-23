import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;

  const BookCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Color(0xFF1A5F5F), Color(0xFF0D3D3D), Color(0xFF062626)]
              : [Color(0xFF26A69A), Color(0xFF00897B), Color(0xFF00695C)],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: Offset(5, 5),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.teal.shade900 : Colors.teal.shade700,
            width: 8.w,
          ),
        ),
      ),
      child: Stack(
        children: [
          // الزخرفة
          Positioned(
            right: 8.w,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.5),
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.teal.shade50,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      fontFamily: "AlqalamQuranMajeed2",
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Gap(20.h),
                // Text(
                //   subtitle,
                //   style: TextStyle(
                //     color: Colors.white.withValues(alpha: 0.85),
                //     fontSize: 16.sp,
                //     height: 1.5,
                //     fontFamily: "Amiri Quran",
                //   ),
                //   textAlign: TextAlign.center,
                //   maxLines: 3,
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
