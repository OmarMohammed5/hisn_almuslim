import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/sheikh_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routing/app_routes.dart';
import '../../domain/entities/lecture_playlist.dart';
import '../../domain/entities/sheikh.dart';
import '../../domain/repositories/lectures_repository.dart';
import '../widgets/playlist_card.dart';

class SheikhDetailsScreen extends StatefulWidget {
  final Sheikh sheikh;
  final SharedPreferences preferences;
  final LecturesRepository repository;

  const SheikhDetailsScreen({
    super.key,
    required this.sheikh,
    required this.preferences,
    required this.repository,
  });

  @override
  State<SheikhDetailsScreen> createState() =>
      _SheikhDetailsScreenState();
}

class _SheikhDetailsScreenState
    extends State<SheikhDetailsScreen> {
  late Future<List<LecturePlaylist>> _future;

  @override
  void initState() {
    super.initState();

    _future = widget.repository.getSheikhPlaylists(
      widget.sheikh.channelId,
    );
  }

  // Open Playlist
  void _openPlaylist(
      LecturePlaylist playlist,
      ) {
    Navigator.pushNamed(
      context,
      AppRoutes.playListView,
      arguments: {
        'preferences': widget.preferences,
        'playlist': playlist,
        'repository': widget.repository,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidget(
        title: widget.sheikh.name,
      ),

      body: FutureBuilder<List<LecturePlaylist>>(
        future: _future,

        builder: (context, snapshot) {

          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return _buildLoadingState();
          }

          // Error
          if (snapshot.hasError) {
            return _buildErrorState(
              context,
              scheme,
            );
          }

          final playlists = snapshot.data ?? const [];

          // Content
          return RefreshIndicator(
            color: AppColors.kPrimary,
            onRefresh: () async {
              setState(() {
                _future =
                    widget.repository
                        .getSheikhPlaylists(
                      widget.sheikh.channelId,
                    );
              });

              await _future;
            },

            child: ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                16.w,
                14.h,
                16.w,
                50.h,
              ),

              children: [

                // Sheikh Hero
                SheikhHeader(scheme: scheme, isDark: isDark, sheikh: widget.sheikh,),
                Gap(28.h),

                // Playlists Header
                _buildPlaylistsHeader(
                  scheme,
                  playlists.length,
                ),

                Gap(12.h),

                // Playlists
                if (playlists.isEmpty)
                  _buildEmptyState(
                    scheme,
                  )
                else
                  ...playlists.map(
                        (playlist) => Padding(
                      padding:
                      EdgeInsets.only(
                        bottom: 12.h,
                      ),
                      child: PlaylistCard(
                        playlist: playlist,
                        onTap: () =>
                            _openPlaylist(
                              playlist,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }


  // Playlists Header
  Widget _buildPlaylistsHeader(
      ColorScheme scheme,
      int count,
      ) {
    return Row(
      textDirection:
      TextDirection.rtl,

      children: [

        // Icon
        Container(
          width: 40.w,
          height: 40.w,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: scheme.primary
                .withValues(
              alpha: .08,
            ),
          ),

          child: Icon(
            Icons
                .video_library_rounded,
            color:
            AppColors.kPrimary,
            size: 20.sp,
          ),
        ),

        SizedBox(width: 10.w),

        // Title
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              CustomText(
                'السلاسل والقوائم',

                fontSize: 15.sp,

                fontWeight:
                FontWeight.w900,
              ),

              SizedBox(height: 3.h),

              CustomText(
                count == 0
                    ? 'لا توجد قوائم متاحة'
                    : '$count سلسلة متاحة',

                fontSize: 9.5.sp,

                color: scheme.onSurface
                    .withValues(
                  alpha: .50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Empty State
  Widget _buildEmptyState(
      ColorScheme scheme,
      ) {
    return Container(
      margin:
      EdgeInsets.only(top: 12.h),

      padding:
      EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 34.h,
      ),

      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(20.r),

        color: scheme.primary
            .withValues(
          alpha: .035,
        ),

        border: Border.all(
          color: scheme.primary
              .withValues(
            alpha: .07,
          ),
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 58.w,
            height: 58.w,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: scheme.primary
                  .withValues(
                alpha: .08,
              ),
            ),

            child: Icon(
              Icons
                  .playlist_play_rounded,
              color:
              AppColors.kPrimary,
              size: 29.sp,
            ),
          ),

          Gap(12.h),

          CustomText(
            'لا توجد قوائم متاحة حاليًا',

            textAlign:
            TextAlign.center,

            fontSize: 13.sp,

            fontWeight:
            FontWeight.w800,
          ),

          Gap(5.h),

          CustomText(
            'لم يتم العثور على سلاسل أو قوائم محاضرات لهذا الشيخ.',

            textAlign:
            TextAlign.center,

            fontSize: 10.sp,

            color: scheme.onSurface
                .withValues(
              alpha: .50,
            ),

            height: 1.5,
          ),
        ],
      ),
    );
  }

  // Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          CupertinoActivityIndicator(
            color:
            AppColors.kPrimary,
            radius: 13.r,
          ),

          Gap(12.h),

          CustomText(
            'جاري تحميل السلاسل...',
            fontSize: 11.sp,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(
              alpha: .50,
            ),
          ),
        ],
      ),
    );
  }

  // Error State
  Widget _buildErrorState(
      BuildContext context,
      ColorScheme scheme,
      ) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),

      padding:
      EdgeInsets.symmetric(
        horizontal: 24.w,
      ),

      children: [
        SizedBox(height: 120.h),

        Container(
          width: 70.w,
          height: 70.w,

          margin:
          EdgeInsets.symmetric(
            horizontal: 100.w,
          ),

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: scheme.primary
                .withValues(
              alpha: .08,
            ),
          ),

          child: Icon(
            Icons
                .cloud_off_rounded,
            color:
            AppColors.kPrimary,
            size: 32.sp,
          ),
        ),

        Gap(18.h),

        CustomText(
          'تعذر تحميل قوائم المحاضرات',

          textAlign:
          TextAlign.center,

          fontSize: 14.sp,

          fontWeight:
          FontWeight.w800,
        ),

        Gap(7.h),

        CustomText(
          'حدثت مشكلة أثناء جلب محتوى الشيخ. حاول مرة أخرى.',

          textAlign:
          TextAlign.center,

          fontSize: 10.5.sp,

          color: scheme.onSurface
              .withValues(
            alpha: .50,
          ),

          height: 1.5,
        ),

        Gap(20.h),

        Center(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _future = widget.repository
                    .getSheikhPlaylists(
                  widget.sheikh.channelId,
                );
              });
            },

            icon: Icon(
              Icons.refresh_rounded,
              size: 17.sp,
            ),

            label: CustomText(
              'إعادة المحاولة',
              fontSize: 11.sp,
              fontWeight:
              FontWeight.w700,
            ),

            style:
            OutlinedButton.styleFrom(
              foregroundColor:
              AppColors.kPrimary,

              side: BorderSide(
                color:
                AppColors.kPrimary
                    .withValues(
                  alpha: .30,
                ),
              ),

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  20.r,
                ),
              ),

              padding:
              EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 10.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}