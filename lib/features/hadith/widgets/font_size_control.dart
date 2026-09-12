import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';

class FontSizeControl extends StatelessWidget {
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool isDark;

  const FontSizeControl({
    super.key,
    required this.onIncrease,
    required this.onDecrease,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: AppResponsive.heightValue(context, 4)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff22272b) : const Color(0xffe9eef0),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppResponsive.widthValue(context, 6),
        children: [
          IconButton(
            icon: Icon(
              Icons.text_increase,
              size: AppResponsive.iconSize(context, 22),
              color: Colors.teal.shade700,
            ),
            onPressed: onIncrease,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            'حجم الخط',
            style: TextStyle(fontSize: AppResponsive.fontSize(context, 11), fontFamily: "Cairo"),
          ),
          IconButton(
            icon: Icon(
              Icons.text_decrease,
              size: AppResponsive.iconSize(context, 22),
              color: Colors.teal.shade700,
            ),
            onPressed: onDecrease,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
