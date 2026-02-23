import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IslamicWelcomeHeader extends StatelessWidget {
  const IslamicWelcomeHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    String icon;

    if (hour >= 5 && hour < 12) {
      greeting = 'صَبَاحُ الْخَيْرِ';
      icon = '☀️';
    } else if (hour >= 12 && hour < 15) {
      greeting = 'ظُهْرُكَ مُبَارَك';
      icon = '🌤️';
    } else if (hour >= 15 && hour < 18) {
      greeting = 'عَصْرُكَ سَعِيد';
      icon = '🌅';
    } else if (hour >= 18 && hour < 21) {
      greeting = 'مَسَاءُ الْخَيْرِ';
      icon = '🌆';
    } else {
      greeting = 'طَابَتْ لَيْلَتُك';
      icon = '🌙';
    }

    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.teal.shade600,
                  Colors.teal.shade700,
                  Colors.teal.shade900,
                ]
              : [
                  Colors.teal.shade700,
                  Colors.teal.shade800,
                  Colors.teal.shade900,
                ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Text(icon, style: TextStyle(fontSize: 28)),
          ),
          Gap(16),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.5,
                    fontFamily: "Cairo",
                  ),
                ),
                Gap(4),
                Text(
                  'اللَّهُمَّ بَارِكْ لَنَا فِي يَوْمِنَا',
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: .9),
                  ),
                ),
              ],
            ),
          ),
          // Decoration Islamic
          Icon(
            Icons.mosque,
            color: Colors.white.withValues(alpha: 0.3),
            size: 40,
          ),
        ],
      ),
    );
  }
}
