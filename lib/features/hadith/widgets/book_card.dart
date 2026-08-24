import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
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
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // Teal palette
    final coverColor = isDark
        ? const Color(0xFF0E4A46)
        : const Color(0xFF078F80);

    final coverDark = isDark
        ? const Color(0xFF092F2D)
        : const Color(0xFF056B60);

    final accentColor = isDark
        ? Colors.teal.shade300
        : Colors.teal.shade100;

    final goldColor = isDark
        ? const Color(0xFFD8C27A)
        : const Color(0xFFF0D98A);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () {
          // Keep your existing onTap here
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? .35 : .16,
                ),
                blurRadius: 18.r,
                offset: Offset(4.w, 8.h),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),

            child: Stack(
              children: [

                // Main book cover
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        coverColor,
                        coverDark,
                      ],
                    ),

                    border: Border.all(
                      color: accentColor.withValues(
                        alpha: .25,
                      ),
                      width: 1,
                    ),
                  ),

                  child: Stack(
                    children: [

                      // Decorative circles
                      Positioned(
                        top: -35.w,
                        left: -35.w,
                        child: Container(
                          width: 95.w,
                          height: 95.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: .06,
                              ),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: -45.w,
                        right: -45.w,
                        child: Container(
                          width: 110.w,
                          height: 110.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: .05,
                              ),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      // Inner book frame
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(9.w),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(13.r),

                              border: Border.all(
                                color: goldColor.withValues(
                                  alpha: .35,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Top ornament
                      Positioned(
                        top: 22.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Icon(
                            FlutterIslamicIcons.mohammad,
                            color: goldColor,size: 22.sp,
                          ),
                        ),
                      ),

                      // Book title
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 35.h,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  fontFamily:
                                  "AlqalamQuranMajeed2",
                                  shadows: [
                                    Shadow(
                                      color:
                                      Colors.black.withValues(
                                        alpha: .30,
                                      ),
                                      offset:
                                      const Offset(0, 2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10.h),

                              Container(
                                width: 35.w,
                                height: 1.5.h,
                                decoration: BoxDecoration(
                                  color: goldColor,
                                  borderRadius:
                                  BorderRadius.circular(5.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom number
                      Positioned(
                        bottom: 16.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(
                                alpha: .10,
                              ),
                              borderRadius:
                              BorderRadius.circular(20.r),
                              border: Border.all(
                                color:
                                Colors.white.withValues(
                                  alpha: .08,
                                ),
                              ),
                            ),
                            child: Text(
                              number,
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: .75,
                                ),
                                fontSize: 8.5.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Book spine
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 7.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          coverDark,
                          coverColor,
                          coverDark,
                        ],
                      ),
                      border: Border(
                        left: BorderSide(
                          color: Colors.white.withValues(
                            alpha: .15,
                          ),
                          width: 1,
                        ),
                      ),
                    ),
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