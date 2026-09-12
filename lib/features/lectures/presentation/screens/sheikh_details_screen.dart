import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_content_container.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
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
  State<SheikhDetailsScreen> createState() => _SheikhDetailsScreenState();
}

class _SheikhDetailsScreenState extends State<SheikhDetailsScreen> {
  late Future<List<LecturePlaylist>> _future;

  @override
  void initState() {
    super.initState();

    _future = widget.repository.getSheikhPlaylists(widget.sheikh.channelId);
  }

  // Open Playlist
  void _openPlaylist(LecturePlaylist playlist) {
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidget(title: widget.sheikh.name),

      body: LectureContentContainer(
        child: FutureBuilder<List<LecturePlaylist>>(
          future: _future,

          builder: (context, snapshot) {
            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            // Error
            if (snapshot.hasError) {
              return _buildErrorState(context, scheme);
            }

            final playlists = snapshot.data ?? const [];

            // Content
            return RefreshIndicator(
              color: AppColors.kPrimary,
              onRefresh: () async {
                setState(() {
                  _future = widget.repository.getSheikhPlaylists(
                    widget.sheikh.channelId,
                  );
                });

                await _future;
              },

              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: EdgeInsets.fromLTRB(
                  AppResponsive.widthValue(context, 16),
                  AppResponsive.heightValue(context, 14),
                  AppResponsive.widthValue(context, 16),
                  AppResponsive.heightValue(context, 50),
                ),

                children: [
                  // Sheikh Hero
                  SheikhHeader(
                    scheme: scheme,
                    isDark: isDark,
                    sheikh: widget.sheikh,
                  ),
                  Gap(AppResponsive.heightValue(context, 28)),

                  // Playlists Header
                  _buildPlaylistsHeader(scheme, playlists.length),

                  Gap(AppResponsive.heightValue(context, 12)),

                  // Playlists
                  if (playlists.isEmpty)
                    _buildEmptyState(scheme)
                  else
                    ...playlists.map(
                      (playlist) => Padding(
                        padding: EdgeInsets.only(
                          bottom: AppResponsive.heightValue(context, 8),
                        ),
                        child: PlaylistCard(
                          playlist: playlist,
                          onTap: () => _openPlaylist(playlist),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Playlists Header
  Widget _buildPlaylistsHeader(ColorScheme scheme, int count) {
    return Row(
      children: [
        // Icon
        Container(
          width: AppResponsive.widthValue(context, 40),
          height: AppResponsive.widthValue(context, 40),

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: scheme.primary.withValues(alpha: .08),
          ),

          child: Icon(
            Icons.video_library_rounded,
            color: AppColors.kPrimary,
            size: AppResponsive.fontSize(context, 20),
          ),
        ),

        SizedBox(width: AppResponsive.widthValue(context, 10)),

        // Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              CustomText(
                'السلاسل والقوائم',
                fontSize: AppResponsive.fontSize(context, 13),
                fontWeight: FontWeight.w900,
              ),

              SizedBox(height: AppResponsive.heightValue(context, 5)),

              CustomText(
                count == 0 ? 'لا توجد قوائم متاحة' : '$count سلسلة متاحة',
                fontSize: AppResponsive.fontSize(context, 9),
                color: scheme.onSurface.withValues(alpha: .50),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Empty State
  Widget _buildEmptyState(ColorScheme scheme) {
    return Container(
      margin: EdgeInsets.only(top: AppResponsive.heightValue(context, 12)),

      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 20),
        vertical: AppResponsive.heightValue(context, 34),
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),

        color: scheme.primary.withValues(alpha: .035),

        border: Border.all(color: scheme.primary.withValues(alpha: .07)),
      ),

      child: Column(
        children: [
          Container(
            width: AppResponsive.widthValue(context, 58),
            height: AppResponsive.widthValue(context, 58),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: scheme.primary.withValues(alpha: .08),
            ),

            child: Icon(
              Icons.playlist_play_rounded,
              color: AppColors.kPrimary,
              size: AppResponsive.fontSize(context, 29),
            ),
          ),

          Gap(AppResponsive.heightValue(context, 12)),

          CustomText(
            'لا توجد قوائم متاحة حاليًا',

            textAlign: TextAlign.center,

            fontSize: AppResponsive.fontSize(context, 13),

            fontWeight: FontWeight.w800,
          ),

          Gap(AppResponsive.heightValue(context, 5)),

          CustomText(
            'لم يتم العثور على سلاسل أو قوائم محاضرات لهذا الشيخ.',

            textAlign: TextAlign.center,

            fontSize: AppResponsive.fontSize(context, 10),

            color: scheme.onSurface.withValues(alpha: .50),

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
        mainAxisSize: MainAxisSize.min,

        children: [
          CupertinoActivityIndicator(
            color: AppColors.kPrimary,
            radius: AppResponsive.radius(context, 13),
          ),

          Gap(AppResponsive.heightValue(context, 12)),

          CustomText(
            'جاري تحميل السلاسل...',
            fontSize: AppResponsive.fontSize(context, 11),
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .50),
          ),
        ],
      ),
    );
  }

  // Error State
  Widget _buildErrorState(BuildContext context, ColorScheme scheme) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 24),
      ),

      children: [
        SizedBox(height: AppResponsive.heightValue(context, 120)),

        Container(
          width: AppResponsive.widthValue(context, 70),
          height: AppResponsive.widthValue(context, 70),

          margin: EdgeInsets.symmetric(
            horizontal: AppResponsive.widthValue(context, 100),
          ),

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: scheme.primary.withValues(alpha: .08),
          ),

          child: Icon(
            Icons.cloud_off_rounded,
            color: AppColors.kPrimary,
            size: AppResponsive.fontSize(context, 32),
          ),
        ),

        Gap(AppResponsive.heightValue(context, 18)),

        CustomText(
          'تعذر تحميل قوائم المحاضرات',

          textAlign: TextAlign.center,

          fontSize: AppResponsive.fontSize(context, 14),

          fontWeight: FontWeight.w800,
        ),

        Gap(AppResponsive.heightValue(context, 7)),

        CustomText(
          'حدثت مشكلة أثناء جلب محتوى الشيخ. حاول مرة أخرى.',

          textAlign: TextAlign.center,

          fontSize: AppResponsive.fontSize(context, 10.5),

          color: scheme.onSurface.withValues(alpha: .50),

          height: 1.5,
        ),

        Gap(AppResponsive.heightValue(context, 20)),

        Center(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _future = widget.repository.getSheikhPlaylists(
                  widget.sheikh.channelId,
                );
              });
            },

            icon: Icon(
              Icons.refresh_rounded,
              size: AppResponsive.fontSize(context, 17),
            ),

            label: CustomText(
              'إعادة المحاولة',
              fontSize: AppResponsive.fontSize(context, 11),
              fontWeight: FontWeight.w700,
            ),

            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.kPrimary,

              side: BorderSide(
                color: AppColors.kPrimary.withValues(alpha: .30),
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 20),
                ),
              ),

              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.widthValue(context, 18),
                vertical: AppResponsive.heightValue(context, 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
