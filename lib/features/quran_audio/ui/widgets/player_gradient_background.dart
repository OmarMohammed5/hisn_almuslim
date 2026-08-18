import 'package:flutter/material.dart';

class PlayerGradientBackground extends StatelessWidget {
  final int surahNumber;
  final Widget child;

  const PlayerGradientBackground({
    super.key,
    required this.surahNumber,
    required this.child,
  });


  static const List<List<Color>> _palettes = [
    [Color(0xFF17322F), Color(0xFF0A1B1A)],
    [Color(0xFF241F42), Color(0xFF120F22)],
    [Color(0xFF3A2A1C), Color(0xFF1A120B)],
    [Color(0xFF162B42), Color(0xFF08131F)],
    [Color(0xFF2E1E2C), Color(0xFF150B14)],
    [Color(0xFF1E351F), Color(0xFF0C160D)],
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _palettes[surahNumber % _palettes.length];

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: palette,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.55),
              radius: 1.1,
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              stops: const [0.6, 1.0],
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.22),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}