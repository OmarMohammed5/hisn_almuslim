import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDuaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDark;
  final VoidCallback onFontTap;

  const CustomDuaAppBar({
    super.key,
    required this.title,
    required this.isDark,
    required this.onFontTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Cairo",
          fontSize: 14.sp,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.text_fields, color: Colors.teal.shade700),
          onPressed: onFontTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
