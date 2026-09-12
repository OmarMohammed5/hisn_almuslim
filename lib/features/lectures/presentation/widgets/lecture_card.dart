import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/lecture.dart';

class LectureCard extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onTap;

  const LectureCard({super.key, required this.lecture, required this.onTap});

  String _duration() {
    if (lecture.duration == Duration.zero) return '';

    final h = lecture.duration.inHours;
    final m = lecture.duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final s = lecture.duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
        child: Ink(
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 9)),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 18),
            ),
            border: Border.all(color: scheme.primary.withValues(alpha: .09)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? .05
                      : .025,
                ),
                blurRadius: AppResponsive.radius(context, 12),
                offset: Offset(0, AppResponsive.heightValue(context, 4)),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 15),
                ),
                child: SizedBox(
                  width: AppResponsive.widthValue(context, 132),
                  height: AppResponsive.heightValue(context, 82),
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
                        size: AppResponsive.fontSize(context, 25),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.widthValue(context, 11)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      lecture.title,
                      maxLines: 3,
                      fontSize: AppResponsive.fontSize(context, 11.5),
                      fontWeight: FontWeight.w800,
                      height: AppResponsive.heightValue(context, 1.35),
                    ),
                    SizedBox(height: AppResponsive.heightValue(context, 12)),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline_rounded,
                          size: AppResponsive.fontSize(context, 14),
                          color: AppColors.kPrimary,
                        ),
                        SizedBox(width: AppResponsive.widthValue(context, 5)),
                        Expanded(
                          child: CustomText(
                            'YouTube • ${lecture.channelName}',
                            maxLines: 1,
                            fontSize: AppResponsive.fontSize(context, 9),
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface.withValues(alpha: .55),
                          ),
                        ),
                      ],
                    ),
                    if (_duration().isNotEmpty) ...[
                      SizedBox(height: AppResponsive.heightValue(context, 7)),
                      CustomText(
                        _duration(),
                        fontSize: AppResponsive.fontSize(context, 9),
                        color: scheme.onSurface.withValues(alpha: .45),
                      ),
                    ],
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
