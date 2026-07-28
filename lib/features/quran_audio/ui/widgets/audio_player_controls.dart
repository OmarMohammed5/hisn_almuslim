// import 'package:flutter/material.dart';
//
// import '../../../../core/theme/app_colors.dart';
//
// class AudioPlayerControls extends StatelessWidget {
//   final bool isPlaying;
//   final bool isBuffering;
//   final VoidCallback onPlayPause;
//
//   const AudioPlayerControls({
//     super.key,
//     required this.isPlaying,
//     required this.isBuffering,
//     required this.onPlayPause,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: isBuffering
//           ? Container(
//               width: 68,
//               height: 68,
//               decoration: BoxDecoration(
//                 color: AppColors.kPrimary,
//                 shape: BoxShape.circle,
//               ),
//               child: const Center(
//                 child: SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             )
//           : Material(
//               color: AppColors.kPrimary,
//               shape: const CircleBorder(),
//               elevation: 6,
//               shadowColor: AppColors.kPrimary.withValues(alpha: 0.5),
//               child: InkWell(
//                 customBorder: const CircleBorder(),
//                 onTap: onPlayPause,
//                 child: SizedBox(
//                   width: 68,
//                   height: 68,
//                   child: Icon(
//                     isPlaying ? Icons.pause_sharp : Icons.play_arrow_outlined,
//                     color: Colors.white,
//                     size: 34,
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';

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
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.kPrimary,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
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
            width: 68,
            height: 68,
            child: Icon(
              isPlaying ? Icons.pause_sharp : Icons.play_arrow_outlined,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),
      ),
    );
  }
}