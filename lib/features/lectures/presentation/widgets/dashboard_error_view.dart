import 'package:flutter/material.dart';
import '../../../../core/responsive/app_responsive.dart';
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
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 24)),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: AppResponsive.fontSize(context, 42),
            ),

            SizedBox(height: AppResponsive.heightValue(context, 12)),

            CustomText(message, textAlign: TextAlign.center),

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
