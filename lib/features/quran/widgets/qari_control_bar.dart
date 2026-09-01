import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../service/audio_player_manager.dart';

class QariControlBar extends StatelessWidget {
  final AudioPlayerManager audioManager;
  final dynamic colors;
  final bool darkMode;

  const QariControlBar({
    super.key,
    required this.audioManager,
    required this.colors,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 12.w,
      right: 12.w,
      bottom: 12.h,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22.r),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: colors.primary.withValues(alpha: .10)),
          ),
          child: Row(
            children: [
              _buildPlayButton(context),
              SizedBox(width: 10.w),
              Expanded(child: _buildStatusText(context)),
              Icon(Icons.graphic_eq_rounded, color: colors.primary, size: 20.sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    final isLoading = audioManager.isLoading;
    final isPlaying = audioManager.isPlaying;

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .10),
        shape: BoxShape.circle,
      ),
      child: isLoading
          ? Padding(
        padding: EdgeInsets.all(11.w),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.primary,
        ),
      )
          : IconButton(
        padding: EdgeInsets.zero,
        onPressed: audioManager.togglePlay,
        icon: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: colors.primary,
          size: 21.sp,
        ),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context) {
    final isPlaying = audioManager.isPlaying;
    final playingAyah = audioManager.playingAyah;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isPlaying ? 'جاري التلاوة' : 'اضغط على آية للبدء',
          style: TextStyle(
            color: colors.text,
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          playingAyah == null
              ? 'الشيخ محمود خليل الحصري'
              : 'آية $playingAyah • الشيخ محمود خليل الحصري',
          style: TextStyle(
            color: colors.text.withValues(alpha: .52),
            fontSize: 8.5.sp,
          ),
        ),
      ],
    );
  }
}