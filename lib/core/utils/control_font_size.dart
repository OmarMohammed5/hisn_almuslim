import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontSizeController {
  static void showFontSizeSlider({
    required BuildContext context,
    required ValueNotifier<double> fontSizeNotifire,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.h,
            children: [
              Text(
                'حجم الخط',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold,
                ),
              ),

              ValueListenableBuilder<double>(
                valueListenable: fontSizeNotifire,
                builder: (context, fontSize, _) {
                  return Slider(
                    min: 16,
                    max: 32,
                    divisions: 8,
                    value: fontSize,
                    label: fontSize.toInt().toString(),
                    activeColor: Colors.teal.shade700,
                    onChanged: (value) {
                      fontSizeNotifire.value = value;
                    },
                  );
                },
              ),

              Text(
                'اسحب لتكبير أو تصغير الخط',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontFamily: "Cairo",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
