import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/responsive/app_responsive.dart';

class BookCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final String number;

  const BookCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.number,
    required this.onTap,
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
      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? .35 : .16,
                ),
                blurRadius: 2.r,
                offset: Offset(4.w, 2.h),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),

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
                      width: AppResponsive.widthValue(context, 1),
                    ),
                  ),

                  child: Stack(
                    children: [

                      // Decorative circles
                      Positioned(
                        top: AppResponsive.heightValue(context, -35),
                        left: AppResponsive.widthValue(context, -35),
                        child: Container(
                          width: AppResponsive.widthValue(context, 95),
                          height: AppResponsive.heightValue(context, 95),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(
                                alpha: .06,
                              ),
                              width: AppResponsive.widthValue(context, 1),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: AppResponsive.heightValue(context, -45),
                        right: AppResponsive.widthValue(context, -45),
                        child: Container(
                          width: AppResponsive.widthValue(context, 110),
                          height: AppResponsive.heightValue(context, 110),
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
                              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 13)),


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
                        top: AppResponsive.heightValue(context, 22),
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Icon(
                            FlutterIslamicIcons.mohammad,
                            color: goldColor,size:AppResponsive.iconSize(context, 22),
                          ),
                        ),
                      ),

                      // Book title
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:AppResponsive.widthValue(context, 22),
                            vertical: AppResponsive.heightValue(context, 35),
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
                                  fontSize: AppResponsive.fontSize(context, 16),
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

                              SizedBox(height:AppResponsive.heightValue(context, 10)),

                              Container(
                                width: AppResponsive.widthValue(context, 35),
                                height:AppResponsive.heightValue(context, 1.5),
                                decoration: BoxDecoration(
                                  color: goldColor,
                                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 5)),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom number
                      Positioned(
                        bottom: AppResponsive.heightValue(context, 16),
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppResponsive.widthValue(context, 9),
                              vertical: AppResponsive.heightValue(context, 4),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(
                                alpha: .10,
                              ),
                              borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),

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
                                fontSize: AppResponsive.fontSize(context, 8.5),
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
                    width: AppResponsive.widthValue(context, 7),
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