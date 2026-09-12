import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';

class PlayerArtworkSquare extends StatelessWidget {
  final Widget child;
  final double size;

  const PlayerArtworkSquare({super.key, required this.child, this.size = 220});

  @override
  Widget build(BuildContext context) {
    final responsiveSize = AppResponsive.widthValue(context, size);
    final outerSize = responsiveSize + AppResponsive.widthValue(context, 30);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => Opacity(
        opacity: t,
        child: Transform.scale(
          scale: 0.90 + (0.10 * t),
          child: _artwork(context, outerSize),
        ),
      ),
    );
  }

  Widget _artwork(BuildContext context, double outerSize) {
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
              width: AppResponsive.widthValue(context, size),
              height: AppResponsive.widthValue(context, size),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF063F3A),
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
