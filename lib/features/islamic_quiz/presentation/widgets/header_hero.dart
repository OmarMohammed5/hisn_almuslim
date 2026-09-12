import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../theme/quiz_tokens.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppResponsive.widthValue(context, 22),
        AppResponsive.heightValue(context, 24),
        AppResponsive.widthValue(context, 22),
        AppResponsive.heightValue(context, 24),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            QuizColors.primarySoft(context),
            QuizColors.primarySoft(context).withValues(alpha: .55),
          ],
        ),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, QuizRadius.xl),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: AppResponsive.widthValue(context, 62),
                height: AppResponsive.widthValue(context, 62),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 20),
                  ),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: AppResponsive.fontSize(context, 30),
                  color: QuizColors.primary(context),
                ),
              ),

              SizedBox(width: AppResponsive.widthValue(context, 16)),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppResponsive.heightValue(context, 7),
                  children: [
                    CustomText(
                      'اختبر معرفتك الدينيه',
                      fontSize: AppResponsive.fontSize(context, 13),
                    ),
                    CustomText(
                      "وَقُل رَّبِّ زِدْنِي عِلْمًا",
                      maxLines: 3,
                      fontSize: AppResponsive.fontSize(context, 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
