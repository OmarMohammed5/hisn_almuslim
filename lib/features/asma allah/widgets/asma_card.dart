import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hisn_almuslim/features/asma%20allah/data/model/asma_allah_model.dart';

import '../../../core/responsive/app_responsive.dart';
import '../../../core/theme/app_colors.dart';

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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 7),
        vertical: AppResponsive.heightValue(context, 8),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: borderColor,
              width: AppResponsive.widthValue(context, 1),
            ),
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .18 : .055),
                blurRadius: 12.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 30),
            ),

            child: Stack(
              children: [
                Positioned(
                  top: AppResponsive.widthValue(context, -35),
                  right: AppResponsive.widthValue(context, -25),

                  child: Text(
                    'الله',
                    style: TextStyle(
                      fontFamily: 'Noon',
                      fontSize: AppResponsive.fontSize(context, 130),
                      fontWeight: FontWeight.bold,
                      color: accent.withValues(alpha: isDark ? .025 : .035),
                    ),
                  ),
                ),

                Positioned(
                  bottom: AppResponsive.heightValue(context, -45),
                  left: AppResponsive.widthValue(context, -25),

                  child: Container(
                    width: AppResponsive.widthValue(context, 120),
                    height: AppResponsive.heightValue(context, 120),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accent.withValues(alpha: .045),
                        width: AppResponsive.widthValue(context, 14),
                      ),
                    ),
                  ),
                ),

                // CONTENT
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppResponsive.widthValue(context, 24),
                    AppResponsive.widthValue(context, 28),
                    AppResponsive.widthValue(context, 24),
                    AppResponsive.heightValue(context, 24),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // SMALL LABEL
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            width: AppResponsive.widthValue(context, 5),
                            height: AppResponsive.heightValue(context, 5),

                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                          ),

                          SizedBox(width: AppResponsive.widthValue(context, 7)),

                          Text(
                            'مِنْ أَسْمَاءِ اللهِ الْحُسْنَى',
                            style: TextStyle(
                              fontFamily: 'Noon',
                              fontSize: AppResponsive.fontSize(context, 8),
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),

                          SizedBox(width: AppResponsive.widthValue(context, 7)),

                          Container(
                            width: AppResponsive.widthValue(context, 5),
                            height: AppResponsive.heightValue(context, 5),

                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 28)),

                      // NAME
                      Text(
                        model.name,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontFamily: 'Noon',
                          fontSize: AppResponsive.fontSize(context, 43),
                          fontWeight: FontWeight.bold,
                          height: AppResponsive.heightValue(context, 1.3),
                          color: titleColor,
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 14)),

                      // DECORATIVE LINE
                      Container(
                        width: AppResponsive.widthValue(context, 42),
                        height: AppResponsive.heightValue(context, 3),

                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(
                            AppResponsive.radius(context, 10),
                          ),
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 30)),

                      // DESCRIPTION
                      Text(
                        model.text,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontFamily: 'Noon',
                          fontSize: AppResponsive.fontSize(context, 17),
                          height: AppResponsive.heightValue(context, 2),
                          fontWeight: FontWeight.w400,
                          color: bodyColor,
                        ),
                      ),

                      SizedBox(height: AppResponsive.heightValue(context, 30)),

                      // TAP INDICATOR
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppResponsive.widthValue(context, 13),
                          vertical: AppResponsive.heightValue(context, 7),
                        ),

                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: .06),

                          borderRadius: BorderRadius.circular(
                            AppResponsive.radius(context, 20),
                          ),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              Icons.touch_app_outlined,
                              size: AppResponsive.iconSize(context, 13),
                              color: accent,
                            ),

                            SizedBox(
                              width: AppResponsive.widthValue(context, 6),
                            ),

                            Text(
                              'اضغط للمتابعة',
                              style: TextStyle(
                                fontFamily: 'Noon',
                                fontSize: AppResponsive.fontSize(context, 9),
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
