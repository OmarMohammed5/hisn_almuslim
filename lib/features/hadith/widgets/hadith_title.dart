import 'package:flutter/material.dart';

class HadithTitle extends StatelessWidget {
  const HadithTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xff1c2227) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF677C8D).withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          height: 1.8,
          fontFamily: "Uthmani",
        ),
      ),
    );
  }
}
