import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';


class PlayerControlsRow extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekBack;
  final VoidCallback onSeekForward;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool hasPrevious;
  final bool hasNext;

  const PlayerControlsRow({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.onPlayPause,
    required this.onSeekBack,
    required this.onSeekForward,
    this.onPrevious = _emptyCallback,
    this.onNext = _emptyCallback,
    this.hasPrevious = true,
    this.hasNext = true,
  });

  static void _emptyCallback() {}

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _secondaryButton(
          icon: Icons.skip_previous_rounded,
          onTap: hasPrevious ? onPrevious : null,
          enabled: hasPrevious,
          size: 23.sp,
        ),
        SizedBox(width: 6.w),
        _secondaryButton(
          icon: Icons.replay_10_rounded,
          onTap: onSeekBack,
          enabled: true,
          size: 25.sp,
        ),
        SizedBox(width: 18.w),
        _playButton(),
        SizedBox(width: 18.w),
        _secondaryButton(
          icon: Icons.forward_10_rounded,
          onTap: onSeekForward,
          enabled: true,
          size: 25.sp,
        ),
        SizedBox(width: 6.w),
        _secondaryButton(
          icon: Icons.skip_next_rounded,
          onTap: hasNext ? onNext : null,
          enabled: hasNext,
          size: 23.sp,
        ),
      ],
    );
  }

  Widget _secondaryButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool enabled,
    required double size,
  }) {
    return IconButton(
      onPressed: onTap,
      iconSize: size,
      splashRadius: 24.r,
      color: enabled
          ? Colors.white.withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.22),
      icon: Icon(icon),
    );
  }

  Widget _playButton() {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Ink(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.kPrimary,
              AppColors.kPrimary.withValues(alpha: 0.82),
            ],
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPlayPause,
          child: SizedBox(
            width: 64.w,
            height: 64.w,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isBuffering
                  ? const Padding(
                key: ValueKey('buffering'),
                padding: EdgeInsets.all(18),
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
                  : Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                key: ValueKey(isPlaying),
                color: Colors.white,
                size: 32.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}