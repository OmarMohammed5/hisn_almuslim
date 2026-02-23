import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/hadith/books/bukhary/data/models/hadith.dart';

class HadithDetailsCard extends StatelessWidget {
  final HadithSahih hadith;
  final VoidCallback? onTap;

  const HadithDetailsCard({super.key, required this.hadith, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1c2227) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 🔢 Hadith Number
            Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF272a2e)
                      : const Color(0xffE9EEF0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -0.785398,
                    child: Text(
                      hadith.hadithNumber.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Cairo",
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Gap(16.w),

            /// 📜 Hadith Title / Content
            Expanded(
              child: Text(
                hadith.hadithTitle.isNotEmpty
                    ? hadith.hadithTitle
                    : hadith.hadithContent,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Cairo",
                ),
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
