import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';


class PlayerControlCard extends StatelessWidget {
  final String arabicTitle;
  final String reciterName;
  final String? riwayaText;
  final Widget progressSlider;
  final Widget timeRow;
  final Widget controlsRow;
  final Widget speedChip;
  final Widget? completionMode;

  const PlayerControlCard({
    super.key,
    required this.arabicTitle,
    required this.reciterName,
    this.riwayaText,
    required this.progressSlider,
    required this.timeRow,
    required this.controlsRow,
    required this.speedChip,
    this.completionMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            " سورة ${arabicTitle}",
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: Colors.white,
              fontFamily: "Noon",
            ),
          ),
          SizedBox(height: AppResponsive.heightValue(context, 6)),
          Text(
            "القارئ الشيخ /  ${reciterName}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14),
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: "Noon",
            ),
          ),
          if (riwayaText != null && riwayaText!.trim().isNotEmpty) ...[
            SizedBox(height: AppResponsive.heightValue(context, 3)),
            Text(
              riwayaText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 10.5),
                color: Colors.white.withValues(alpha: 0.42),
                fontFamily: "Noon",
              ),
            ),
          ],
          SizedBox(height: AppResponsive.heightValue(context, 26)),
          progressSlider,
          timeRow,
          SizedBox(height: AppResponsive.heightValue(context, 22)),
          controlsRow,
          SizedBox(height: AppResponsive.heightValue(context, 22)),
          if (completionMode != null) ...[
            completionMode!,
            SizedBox(height: AppResponsive.heightValue(context, 14)),
          ],
          speedChip,
          SizedBox(height: AppResponsive.heightValue(context, 8)),
        ],
      ),
    );
  }
}