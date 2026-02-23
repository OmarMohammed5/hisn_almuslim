import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, required this.isDark});
  final String title;
  final bool isDark;
  @override
  Size get preferredSize => Size.fromHeight(75);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        size: 27,
        color: isDark ? Colors.white : Colors.teal.shade700,
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Color(0xff1c2227), Colors.teal.shade700]
                : [
                    Colors.teal.shade700,
                    Colors.teal.shade800,
                    Colors.teal.shade900,
                  ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.green.shade100,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          maxLines: 12,
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            height: 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: "Uthmani",
          ),
        ),
      ),
    );
  }
}
