import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            " سورة ${arabicTitle}",
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
              fontFamily: "Noon",
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "القارئ الشيخ /  ${reciterName}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: "Noon",
            ),
          ),
          if (riwayaText != null && riwayaText!.trim().isNotEmpty) ...[
            SizedBox(height: 3.h),
            Text(
              riwayaText!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5.sp,
                color: Colors.white.withValues(alpha: 0.42),
                fontFamily: "Noon",
              ),
            ),
          ],
          SizedBox(height: 26.h),
          progressSlider,
          timeRow,
          SizedBox(height: 22.h),
          controlsRow,
          SizedBox(height: 22.h),
          if (completionMode != null) ...[
            completionMode!,
            SizedBox(height: 14.h),
          ],
          speedChip,
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}