import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/custom_text.dart';

class DashboardErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DashboardErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(Icons.wifi_off_rounded, size: 42.sp),

            SizedBox(height: 12.h),

            CustomText(message, textAlign: TextAlign.center),

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
