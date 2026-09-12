import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/lecture_playlist.dart';

class PlaylistCard extends StatelessWidget {
  final LecturePlaylist playlist;
  final VoidCallback onTap;

  const PlaylistCard({required this.playlist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: AppResponsive.heightValue(context, 8)),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
        border: Border.all(color: scheme.primary.withValues(alpha: .10)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
        child: Padding(
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 9)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 14),
                ),
                child: SizedBox(
                  width: AppResponsive.widthValue(context, 105),
                  height: AppResponsive.heightValue(context, 72),
                  child: CachedNetworkImage(
                    imageUrl: playlist.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        CupertinoActivityIndicator(color: AppColors.kPrimary),
                    errorWidget: (_, __, ___) => Icon(
                      Icons.playlist_play_rounded,
                      color: AppColors.kPrimary,
                      size: AppResponsive.fontSize(context, 32),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.widthValue(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      playlist.title,
                      maxLines: 10,
                      textAlign: TextAlign.right,
                        fontSize: AppResponsive.fontSize(context, 11),
                        fontWeight: FontWeight.w600,
                    ),
                    Gap(AppResponsive.heightValue(context, 12)),
                    CustomText(
                      '${playlist.itemCount} محاضرة',
                      fontSize: AppResponsive.fontSize(context, 9),
                      color: scheme.onSurface.withValues(alpha: .55),
                    ),
                  ],
                ),
              ),
              Gap(AppResponsive.widthValue(context, 20)),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: AppResponsive.fontSize(context, 15),
                color: AppColors.kPrimary,
              ),
              Gap(AppResponsive.widthValue(context, 10)),
            ],
          ),
        ),
      ),
    );
  }
}
