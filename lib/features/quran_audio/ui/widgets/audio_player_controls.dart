import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';

class AudioPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPlayPause;

  const AudioPlayerControls({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isBuffering
          ? Container(
              width: AppResponsive.widthValue(context, 55),
              height: AppResponsive.heightValue(context, 55),
              decoration: BoxDecoration(
                color: AppColors.kPrimary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: AppResponsive.widthValue(context, 24),
                  height: AppResponsive.heightValue(context, 24),
                  child: CupertinoActivityIndicator(color: Colors.white),
                ),
              ),
            )
          : Material(
              color: AppColors.kPrimary,
              shape: const CircleBorder(),
              elevation: 6,
              shadowColor: AppColors.kPrimary.withValues(alpha: 0.5),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onPlayPause,
                child: SizedBox(
                  width: AppResponsive.widthValue(context, 42),
                  height: AppResponsive.heightValue(context, 42),
                  child: Icon(
                    isPlaying ? Icons.pause_sharp : Icons.play_arrow_outlined,
                    color: Colors.white,
                    size: AppResponsive.iconSize(context, 28),
                  ),
                ),
              ),
            ),
    );
  }
}
