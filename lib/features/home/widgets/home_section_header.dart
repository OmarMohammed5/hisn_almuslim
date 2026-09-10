import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import '../../../core/responsive/app_responsive.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final IconData icon;

  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final teal =
    isDark
        ? AppColors.kPrimaryLight
        : AppColors.kPrimary;

    return SizedBox(
      height: AppResponsive.heightValue(context, 38),
      child: Row(
        children: [

          // Section title
          Container(
            width: AppResponsive.widthValue(context, 4),
            height: AppResponsive.heightValue(context, 24),
            decoration: BoxDecoration(
              color: teal,
              borderRadius:
              BorderRadius.circular(AppResponsive.radius(context, 10)),
            ),
          ),

          SizedBox(width: AppResponsive.widthValue(context, 9)),

          Expanded(
            child: CustomText(
              title,
              fontSize: AppResponsive.fontSize(context, 13),
              fontWeight:
              FontWeight.w900,
              color:
              theme.colorScheme.onSurface,
              maxLines: 1,
            ),
          ),


          // Optional action
          if (actionLabel != null &&
              onAction != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAction,
                borderRadius:
                BorderRadius.circular(
                  AppResponsive.radius(context, 12),
                ),
                splashColor:
                teal.withValues(
                  alpha: .08,
                ),
                highlightColor:
                teal.withValues(
                  alpha: .04,
                ),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: AppResponsive.widthValue(context, 7),
                    vertical: AppResponsive.heightValue(context, 6),
                  ),
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      CustomText(
                        actionLabel!,
                        fontSize: AppResponsive.fontSize(context, 11),
                        fontWeight:
                        FontWeight.w700,
                        color: teal,
                      ),

                      SizedBox(width: AppResponsive.widthValue(context, 4)),

                      AnimatedRotation(
                        turns:
                        actionLabel ==
                            'عرض أقل'
                            ? -.5
                            : 0,
                        duration:
                        const Duration(
                          milliseconds: 280,
                        ),
                        curve:
                        Curves.easeOutCubic,
                        child: Icon(
                          actionIcon ??
                              Icons
                                  .arrow_back_ios_new_rounded,
                          size: AppResponsive.iconSize(context, 11),
                          color: teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Section icon
          if (actionLabel == null ||
              onAction == null)
            SizedBox(width: AppResponsive.widthValue(context, 8)),

          Container(
            width: AppResponsive.widthValue(context, 34),
            height: AppResponsive.widthValue(context, 34),
            decoration: BoxDecoration(
              color: teal.withValues(
                alpha: isDark ? .13 : .07,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppResponsive.fontSize(context, 17),
              color: teal,
            ),
          ),
        ],
      ),
    );
  }
}