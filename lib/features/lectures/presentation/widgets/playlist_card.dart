import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/lecture_playlist.dart';

class PlaylistCard extends StatelessWidget {
  final LecturePlaylist playlist;
  final VoidCallback onTap;

  const PlaylistCard({
    required this.playlist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: scheme.primary.withValues(alpha: .10),),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.all(9.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(14.r),
                child: SizedBox(
                  width: 105.w,
                  height: 72.h,
                  child: CachedNetworkImage(
                    imageUrl:
                    playlist.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CupertinoActivityIndicator(color: AppColors.kPrimary,),
                    errorWidget: (_, __, ___) => Icon(
                      Icons.playlist_play_rounded,
                      color: AppColors.kPrimary,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      maxLines: 5,
                      overflow:
                      TextOverflow.ellipsis,
                      textAlign:
                      TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    Gap(12.h),
                    CustomText(
                      '${playlist.itemCount} محاضرة',
                      fontSize: 10.sp,
                      color: scheme.onSurface.withValues(alpha: .55,),
                    ),
                  ],
                ),
              ),
              Gap(20.w),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15.sp,
                color: AppColors.kPrimary,
              ),
              Gap(10.w),
            ],
          ),
        ),
      ),
    );
  }
}

