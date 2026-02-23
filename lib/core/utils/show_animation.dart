import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';
import 'package:lottie/lottie.dart';

class ShowAnimation {
  void showCompletionAnimation({required BuildContext context, isDark}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration Animation
              Lottie.asset(
                'assets/json/confetti.json',
                width: 200.w,
                height: 200.w,
              ),
              // Celebration Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDark ? Color(0xff1c2227) : Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  children: [
                    /// Success Icon
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade700.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 36.sp,
                        color: Colors.teal.shade700,
                      ),
                    ),

                    Gap(16.h),
                    CustomText(
                      'بارك الله فيك لقد أكملت ختمة القرآن الكريم !',
                      textAlign: TextAlign.center,
                      fontSize: 12.5.sp,
                      maxLines: 6,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      // color: Colors.teal.shade800,
                    ),
                    Gap(12.h),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                      ),
                      child: CustomText(
                        'حسناً',
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Gap(16.h),
            ],
          ),
        );
      },
    );
  }
}
