import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/lecture.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerMainContent extends StatelessWidget {
  final Lecture lecture;

  const PlayerMainContent({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(AppResponsive.heightValue(context, 12)),

          // Lecture Title
          CustomText(
            lecture.title,
            fontSize: AppResponsive.fontSize(context, 15),
            fontWeight: FontWeight.w600,
            height: AppResponsive.heightValue(context, 1.45),
            maxLines: 30,
          ),
        ],
      ),
    );
  }
}
