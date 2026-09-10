import 'package:flutter/cupertino.dart';
import '../../../core/responsive/app_responsive.dart';
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
      left: AppResponsive.widthValue(context, 12),
      right: AppResponsive.widthValue(context, 12),
      bottom: AppResponsive.heightValue(context, 12),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 10), vertical: AppResponsive.heightValue(context, 8)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),
            border: Border.all(color: colors.primary.withValues(alpha: .10)),
          ),
          child: Row(
            children: [
              _buildPlayButton(context),
              SizedBox(width: AppResponsive.widthValue(context, 10)),
              Expanded(child: _buildStatusText(context)),
              Icon(Icons.graphic_eq_rounded, color: colors.primary, size: AppResponsive.fontSize(context, 20)),
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
      width: AppResponsive.widthValue(context, 40),
      height: AppResponsive.widthValue(context, 40),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .10),
        shape: BoxShape.circle,
      ),
      child: isLoading
          ? Padding(
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 11)),
        child: CupertinoActivityIndicator(
          color: colors.primary,
        ),
      )
          : IconButton(
        padding: EdgeInsets.zero,
        onPressed: audioManager.togglePlay,
        icon: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: colors.primary,
          size: AppResponsive.fontSize(context, 21),
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
            fontSize: AppResponsive.fontSize(context, 11),
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: AppResponsive.heightValue(context, 2)),
        Text(
          playingAyah == null
              ? 'الشيخ محمود خليل الحصري'
              : 'آية $playingAyah • الشيخ محمود خليل الحصري',
          style: TextStyle(
            color: colors.text.withValues(alpha: .52),
            fontSize: AppResponsive.fontSize(context, 8.5),
          ),
        ),
      ],
    );
  }
}