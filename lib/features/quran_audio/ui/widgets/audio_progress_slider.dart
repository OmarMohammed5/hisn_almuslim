// import 'package:flutter/material.dart';
//
// class AudioProgressSlider extends StatelessWidget {
//   final Duration currentPosition;
//   final Duration totalDuration;
//   final Function(Duration) onSeek;
//
//   const AudioProgressSlider({
//     super.key,
//     required this.currentPosition,
//     required this.totalDuration,
//     required this.onSeek,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Slider(
//       value: currentPosition.inMilliseconds.toDouble(),
//       max: totalDuration.inMilliseconds.toDouble(),
//       min: 0,
//       onChanged: (value) {
//         onSeek(Duration(milliseconds: value.toInt()));
//       },
//       activeColor: Theme.of(context).colorScheme.primary,
//       inactiveColor: Theme.of(context).colorScheme.surfaceVariant,
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AudioProgressSlider extends StatelessWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final Function(Duration) onSeek;

  const AudioProgressSlider({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    // Guard against totalDuration still being zero right after init —
    // Slider.max must be > 0 or it throws.
    final maxMs = totalDuration.inMilliseconds > 0
        ? totalDuration.inMilliseconds.toDouble()
        : 1.0;

    final valueMs = currentPosition.inMilliseconds
        .toDouble()
        .clamp(0.0, maxMs);

    return Slider(
      value: valueMs,
      max: maxMs,
      min: 0,
      onChanged: (value) {
        onSeek(Duration(milliseconds: value.toInt()));
      },
      activeColor: AppColors.kIconColor,
      inactiveColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}