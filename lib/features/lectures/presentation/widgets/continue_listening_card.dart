import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import '../../../../core/helpers/lecture_progress_storage.dart';
import '../../domain/entities/lecture.dart';

class ContinueListeningCard extends StatelessWidget {
  final Lecture lecture;
  final LectureProgressData progress;
  final VoidCallback onContinue;

  const ContinueListeningCard({
    super.key,
    required this.lecture,
    required this.progress,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Container(
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(context, 10),
                  vertical: AppResponsive.heightValue(context, 6),
                ),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 20),
                  ),
                ),
                child: CustomText(
                  'متابعة الاستماع',
                  fontSize: AppResponsive.fontSize(context, 9.5),
                  fontWeight: FontWeight.w800,
                  color: AppColors.kPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: AppResponsive.heightValue(context, 12)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 16),
                ),
                child: CachedNetworkImage(
                  imageUrl: lecture.thumbnailUrl,
                  width: AppResponsive.widthValue(context, 120),
                  height: AppResponsive.heightValue(context, 80),
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) {
                    return Container(
                      width: AppResponsive.widthValue(context, 115),
                      height: AppResponsive.heightValue(context, 78),
                      color: AppColors.kPrimary.withValues(alpha: .08),
                      child: Icon(
                        Icons.play_circle_outline,
                        color: AppColors.kPrimary,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(width: AppResponsive.widthValue(context, 12)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      lecture.title,
                      maxLines: 8,
                      fontSize: AppResponsive.fontSize(context, 11),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),

                    SizedBox(height: AppResponsive.heightValue(context, 6)),

                    CustomText(
                      lecture.channelName,
                      maxLines: 8,
                      fontSize: AppResponsive.fontSize(context, 10.5),
                      color: scheme.onSurface.withValues(alpha: .55),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppResponsive.heightValue(context, 12)),

          // Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 10),
            ),
            child: LinearProgressIndicator(
              value: progress.percentage,
              minHeight: AppResponsive.heightValue(context, 5),
              backgroundColor: AppColors.kPrimary.withValues(alpha: .08),
              valueColor: AlwaysStoppedAnimation(AppColors.kPrimary),
            ),
          ),

          SizedBox(height: AppResponsive.heightValue(context, 10)),

          Row(
            children: [
              CustomText(
                '${progress.percentageInt} % مكتمل',
                fontSize: AppResponsive.fontSize(context, 11),
                fontWeight: FontWeight.w600,
                color: scheme.onSurface.withValues(alpha: .50),
              ),

              const Spacer(),

              Material(
                color: AppColors.kPrimary,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 14),
                ),
                child: InkWell(
                  onTap: onContinue,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 14),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.widthValue(context, 15),
                      vertical: AppResponsive.heightValue(context, 9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          size: AppResponsive.fontSize(context, 15),
                          color: Colors.white,
                        ),
                        SizedBox(width: AppResponsive.widthValue(context, 5)),
                        CustomText(
                          'متابعة',
                          fontSize: AppResponsive.fontSize(context, 11),
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
