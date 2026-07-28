import 'dart:ui';
import 'package:flutter/material.dart';

class PlayerBackground extends StatelessWidget {
  final Widget child;

  const PlayerBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0B1E2D), // deep dark blue
                Color(0xFF10333A), // dark teal
                Color(0xFF123B33), // soft green-teal
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        // Soft glow accents, blurred for a calm, ambient feel
        Positioned(
          top: -80,
          left: -60,
          child: _glow(const Color(0xFF2ED9B8), 220),
        ),
        Positioned(
          bottom: -100,
          right: -60,
          child: _glow(const Color(0xFF1B6E63), 260),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: const SizedBox.expand(),
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
        color: color.withValues(alpha: 0.25),
      ),
    );
  }
}