import 'package:flutter/material.dart';

class PlayerBackground extends StatelessWidget {
  final Widget child;

  const PlayerBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF587264),
                Color(0xFF10333A),
                Color(0xFF123B33),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}