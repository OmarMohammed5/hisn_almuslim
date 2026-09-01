import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class FontSizeController {
  static void showFontSizeSlider({
    required BuildContext context,
    required ValueNotifier<double> fontSizeNotifire,
  }) {
    showModalBottomSheet(
      context: context,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.h,
            children: [
              CustomText(
                'حجم الخط',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
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

              CustomText(
                'اسحب لتكبير أو تصغير الخط',
                  fontSize: 12.sp,
                  color: isDark ? Colors.black26 : Colors.black54,
              ),
            ],
          ),
        );
      },
    );
  }
}
