import 'package:flutter/material.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class AppBarAboutApp extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAboutApp({
    super.key,
    required this.accentColor,
    required this.isDark,
  });

  final Color accentColor;
  final bool isDark;

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      elevation: 0,
      iconTheme: IconThemeData(color: accentColor, size: 27),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.teal.shade800, Colors.green.shade800]
                : [Colors.teal.shade400, Colors.green.shade500],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const CustomText(
          "عن التطبيق",
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
