import 'package:flutter/material.dart';

class BookmarkIndicator extends StatelessWidget {
  final Color color;

  const BookmarkIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 24,
      child: CustomPaint(
        size: const Size(32, 56),
        painter: _BookmarkPainter(color: color),
      ),
    );
  }
}

class _BookmarkPainter extends CustomPainter {
  final Color color;
  const _BookmarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height - 14)
      ..lineTo(0, size.height)
      ..close();

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path.shift(const Offset(2, 2)), shadowPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BookmarkPainter old) => old.color != color;
}
