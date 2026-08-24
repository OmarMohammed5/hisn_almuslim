import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/helpers/lecture_progress_storage.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/player_main_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../domain/entities/lecture.dart';

class LecturePlayerScreen extends StatefulWidget {
  final Lecture lecture;
  final SharedPreferences preferences;
  final double? initialPositionSeconds;

  const LecturePlayerScreen({
    super.key,
    required this.lecture,
    required this.preferences,
    this.initialPositionSeconds,
  });

  @override
  State<LecturePlayerScreen> createState() =>
      _LecturePlayerScreenState();
}

class _LecturePlayerScreenState
    extends State<LecturePlayerScreen> {

  late final YoutubePlayerController _controller;

  Timer? _progressTimer;

  bool _isSavingProgress = false;

  String get _progressKey =>
      'lecture_progress_${widget.lecture.id}';

  // ============================================================
  // Save Last Lecture
  // ============================================================

  Future<void> _saveLastLecture() async {
    try {
      await LectureProgressStorage.saveLastLecture(
        preferences: widget.preferences,
        lecture: widget.lecture,
      );
    } catch (_) {}
  }

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    final start =
    (widget.initialPositionSeconds ?? 0) > 10
        ? widget.initialPositionSeconds
        : null;

    _controller =
        YoutubePlayerController.fromVideoId(
          videoId: widget.lecture.id,
          autoPlay: true,
          startSeconds: start,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            strictRelatedVideos: true,
          ),
        );

    // Save this lecture as the last listened lecture.
    _saveLastLecture();

    // Save progress periodically.
    _progressTimer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _saveProgress(),
    );
  }

  // ============================================================
  // Save Progress
  // ============================================================

  Future<void> _saveProgress() async {
    // Prevent multiple save operations
    // from running at the same time.
    if (_isSavingProgress) {
      return;
    }

    _isSavingProgress = true;

    try {
      final position =
      await _controller.currentTime;

      final duration =
      await _controller.duration;

      // YouTube controller may not have
      // loaded the duration yet.
      if (duration <= 0) {
        return;
      }

      final completed =
          position >= duration * 0.92;

      await widget.preferences.setString(
        _progressKey,
        '${position.toStringAsFixed(2)}|'
            '${duration.toStringAsFixed(2)}|'
            '$completed',
      );

      // Make sure SharedPreferences has
      // finished writing before continuing.
      await widget.preferences.reload();
    } catch (_) {
      // Ignore temporary YouTube/controller errors.
    } finally {
      _isSavingProgress = false;
    }
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _progressTimer?.cancel();

    _controller.close();

    super.dispose();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult:
          (didPop, result) async {
        if (didPop) {
          return;
        }

        // IMPORTANT:
        // Save the latest position before leaving.
        await _saveProgress();

        if (!mounted) {
          return;
        }

        Navigator.pop(context);
      },

      child: Scaffold(
        appBar: AppBarWidget(
          title: 'المحاضرة',
        ),

        body: ListView(
          physics:
          const BouncingScrollPhysics(),

          padding: EdgeInsets.only(
            bottom: 40.h,
          ),

          children: [

            // ======================================================
            // Video Player
            // ======================================================

            Padding(
              padding: EdgeInsets.fromLTRB(
                12.w,
                12.h,
                12.w,
                0,
              ),

              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(18.r),

                child: AspectRatio(
                  aspectRatio: 16 / 9,

                  child: YoutubePlayer(
                    controller: _controller,
                  ),
                ),
              ),
            ),

            Gap(18.h),

            // ======================================================
            // Main Content
            // ======================================================

            PlayerMainContent(
              lecture: widget.lecture,
            ),
          ],
        ),
      ),
    );
  }
}