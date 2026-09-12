import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/lecture.dart';

class FeaturedLectureCard extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onTap;
  final double? width;

  const FeaturedLectureCard({
    super.key,
    required this.lecture,
    required this.onTap,
    this.width,
  });

  String _duration() {
    if (lecture.duration == Duration.zero) return '';
    final minutes = lecture.duration.inMinutes;
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    return hours > 0 ? '${hours}س ${remaining}د' : '$minutes د';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        child: Ink(
          width: width ?? AppResponsive.widthValue(context, 252),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 20),
            ),
            border: Border.all(
              color: AppColors.kPrimary.withValues(alpha: .10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? .04
                      : .025,
                ),
                blurRadius: AppResponsive.radius(context, 12),
                offset: Offset(0, AppResponsive.heightValue(context, 4)),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppResponsive.radius(context, 20)),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 8.7,
                  child: CachedNetworkImage(
                    imageUrl: lecture.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => ColoredBox(
                      color: AppColors.kPrimary.withValues(alpha: .06),
                      child: const Center(child: CupertinoActivityIndicator()),
                    ),
                    errorWidget: (_, __, ___) => ColoredBox(
                      color: AppColors.kPrimary.withValues(alpha: .07),
                      child: Icon(
                        Icons.ondemand_video_rounded,
                        color: AppColors.kPrimary,
                        size: AppResponsive.fontSize(context, 32),
                      ),
                    ),
                  ),
                ),
              ),


              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppResponsive.widthValue(context, 12),
                    AppResponsive.heightValue(context, 14),
                    AppResponsive.widthValue(context, 12),
                    AppResponsive.heightValue(context, 14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CustomText(
                          lecture.title,
                          maxLines: 4,
                          fontSize: AppResponsive.fontSize(context, 9.5),
                          fontWeight: FontWeight.w800,
                          fontFamily: "Noon",
                          height: 1.35,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.play_circle_outline_rounded,
                                size: AppResponsive.fontSize(context, 13),
                                color: AppColors.kPrimary,
                              ),
                              SizedBox(width: AppResponsive.widthValue(context, 5)),
                              Expanded(
                                child: CustomText(
                                  lecture.channelName,
                                  fontFamily: "Noon",
                                  maxLines: 1,
                                  fontSize: AppResponsive.fontSize(context, 9.5),
                                  color: scheme.onSurface.withValues(alpha: .55),
                                ),
                              ),
                              if (_duration().isNotEmpty)
                                CustomText(
                                  _duration(),
                                  fontSize: AppResponsive.fontSize(context, 9),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.kPrimary,
                                ),
                            ],
                          ),
                          SizedBox(height: AppResponsive.heightValue(context, 8)),
                          CustomText(
                            'YouTube',
                            fontSize: AppResponsive.fontSize(context, 9),
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface.withValues(alpha: .42),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}