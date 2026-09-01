import 'package:flutter/material.dart';
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
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 46.sp, color: colors.primary),
            SizedBox(height: 14.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.7,
                color: colors.text.withValues(alpha: .7),
              ),
            ),
            SizedBox(height: 14.h),
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