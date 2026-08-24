import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/lecture.dart';
import '../../domain/entities/lecture_playlist.dart';
import '../../domain/repositories/lectures_repository.dart';
import '../widgets/lecture_card.dart';
import 'lecture_player_screen.dart';

class PlaylistDetailsScreen
    extends StatefulWidget {
  final LecturePlaylist playlist;
  final SharedPreferences preferences;
  final LecturesRepository repository;

  const PlaylistDetailsScreen({
    super.key,
    required this.playlist,
    required this.preferences,
    required this.repository,
  });

  @override
  State<PlaylistDetailsScreen> createState() =>
      _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState
    extends State<PlaylistDetailsScreen> {
  final List<Lecture> _lectures = [];

  String? _nextPageToken;

  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _error = null;
      _nextPageToken = null;
      _hasMore = true;
      _lectures.clear();
    });

    try {
      final page = await widget.repository
          .getPlaylistLectures(
        widget.playlist.id,
      );

      if (!mounted) return;

      setState(() {
        _lectures.addAll(page.lectures);
        _nextPageToken =
            page.nextPageToken;
        _hasMore = page.hasMore;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error =
        'تعذر تحميل محاضرات القائمة';
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore ||
        !_hasMore ||
        _nextPageToken == null) {
      return;
    }

    setState(() {
      _loadingMore = true;
    });

    try {
      final page =
      await widget.repository
          .getPlaylistLectures(
        widget.playlist.id,
        pageToken: _nextPageToken,
      );

      if (!mounted) return;

      final existing =
      _lectures.map((e) => e.id).toSet();

      setState(() {
        _lectures.addAll(
          page.lectures.where(
                (lecture) =>
            !existing.contains(
              lecture.id,
            ),
          ),
        );

        _nextPageToken =
            page.nextPageToken;

        _hasMore = page.hasMore;

        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingMore = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تحميل المزيد',
          ),
        ),
      );
    }
  }

  void _openLecture(
      Lecture lecture,
      ) {
    final raw = widget.preferences
        .getString(
      'lecture_progress_${lecture.id}',
    );

    double? position;

    if (raw != null) {
      final parts = raw.split('|');

      if (parts.length >= 3 &&
          parts[2] != 'true') {
        position = double.tryParse(
          parts[0],
        );
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LecturePlayerScreen(
              lecture: lecture,
              preferences:
              widget.preferences,
              initialPositionSeconds:
              position,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: widget.playlist.title),
      body: NotificationListener<ScrollNotification>(onNotification: (notification) {
          final metrics = notification.metrics;

          if (metrics.pixels >= metrics.maxScrollExtent - 450) {
            _loadMore();
          }

          return false;
        },
        child: RefreshIndicator(
          color: AppColors.kPrimary,
          onRefresh: _loadInitial,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return  Center(
        child: CupertinoActivityIndicator(color: AppColors.kPrimary,),
      );
    }

    if (_error != null) {
      return ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 180.h),
          Center(
            child: Text(_error!),
          ),
        ],
      );
    }

    if (_lectures.isEmpty) {
      return ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 180.h),
          const Center(
            child: CustomText(
              'لا توجد محاضرات في هذه القائمة',
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      physics:
      const AlwaysScrollableScrollPhysics(),

      padding: EdgeInsets.fromLTRB(
        16.w,
        16.h,
        16.w,
        40.h,
      ),

      itemCount:
      _lectures.length +
          (_loadingMore || !_hasMore ? 1 : 0),

      itemBuilder: (context, index) {
        if (index < _lectures.length) {
          final lecture = _lectures[index];

          return LectureCard(
            lecture: lecture,
            onTap: () => _openLecture(lecture),
          );
        }

        if (_loadingMore) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.h,
            ),
            child: Center(
              child: CupertinoActivityIndicator(
                color: AppColors.kPrimary,
              ),
            ),
          );
        }

        if (!_hasMore) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 18.h,
            ),
            child: Text(
              'وصلت إلى نهاية القائمة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(
                  alpha: .45,
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );

  }
}
