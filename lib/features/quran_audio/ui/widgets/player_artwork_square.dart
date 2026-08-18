// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// class PlayerArtworkSquare extends StatelessWidget {
//   final Widget child;
//   final double size;
//
//   const PlayerArtworkSquare({super.key, required this.child, this.size = 220});
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.92, end: 1.0),
//       duration: const Duration(milliseconds: 320),
//       curve: Curves.easeOutCubic,
//       builder: (context, scale, v) => Transform.scale(scale: scale, child: v),
//       child: RepaintBoundary(
//         child: Container(
//           width: size.w,
//           height: size.w,
//           decoration: BoxDecoration(
//            shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.30),
//                 blurRadius: 2,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(24.r),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerArtworkSquare extends StatelessWidget {
  final Widget child;
  final double size;

  const PlayerArtworkSquare({super.key, required this.child, this.size = 220});

  @override
  Widget build(BuildContext context) {
    final outerSize = size.w + 30.w;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => Opacity(
        opacity: t,
        child: Transform.scale(
          scale: 0.90 + (0.10 * t),
          child: _artwork(outerSize),
        ),
      ),
    );
  }

  Widget _artwork(double outerSize) {
    return RepaintBoundary(
      child: SizedBox(
        width: outerSize,
        height: outerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient gold-ish glow behind the artwork.
            Container(
              width: outerSize,
              height: outerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD8B463).withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Container(
              width: size.w,
              height: size.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(child: child),
            ),
          ],
        ),
      ),
    );
  }
}