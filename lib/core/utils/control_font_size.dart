import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class FontSizeController {
  static void showFontSizeSlider({
    required BuildContext context,
    required ValueNotifier<double> fontSizeNotifire,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        maxWidth: double.infinity,
      ),
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppResponsive.radius(context, 36))),
      ),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppResponsive.heightValue(context, 16),
              children: [
                CustomText(
                  'حجم الخط',
                    fontSize: AppResponsive.fontSize(context, 13),
                    fontWeight: FontWeight.bold,
                ),

                ValueListenableBuilder<double>(
                  valueListenable: fontSizeNotifire,
                  builder: (context, fontSize, _) {
                    final safeFontSize = fontSize.clamp(16.0, 32.0);
                    return Slider(
                      min: 16,
                      max: 32,
                      divisions: 8,
                      value: safeFontSize,
                      label: safeFontSize.toInt().toString(),
                      activeColor: Colors.teal.shade700,
                      onChanged: (value) {
                        fontSizeNotifire.value = value;
                      },
                    );
                  },
                ),

                CustomText(
                  'اسحب لتكبير أو تصغير الخط',
                  fontSize: AppResponsive.fontSize(context, 11),
                    color: isDark ? Colors.black26 : Colors.black54,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
