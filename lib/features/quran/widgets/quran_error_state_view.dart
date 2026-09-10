import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/shared/custom_text.dart';

class QuranErrorStateView extends StatelessWidget {
  final String message;
  final dynamic colors;
  final VoidCallback onRetry;

  const QuranErrorStateView({
    super.key,
    required this.message,
    required this.colors,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: AppResponsive.fontSize(context, 46), color: colors.primary),
            SizedBox(height: AppResponsive.heightValue(context, 14)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 12),
                height: 1.7,
                color: colors.text.withValues(alpha: .7),
              ),
            ),
            SizedBox(height: AppResponsive.heightValue(context, 14)),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const CustomText('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}