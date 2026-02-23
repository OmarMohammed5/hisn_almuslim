import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ChapterCard extends StatelessWidget {
  final int chapterId;
  final String chapterTitle;
  final int? count;
  final VoidCallback onTap;

  const ChapterCard({
    super.key,
    required this.chapterId,
    required this.onTap,
    required this.chapterTitle,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: const EdgeInsets.only(bottom: 12),
        // padding: const EdgeInsets.all(16),
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1c2227) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
            /// 🔢 Chapter Number
            CircleAvatar(
              radius: 22.r,
              backgroundColor: isDark
                  ? const Color(0xFF272a2e)
                  : const Color(0xffE9EEF0),
              child: Text(
                chapterId.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: "Cairo",
                  fontSize: 13.sp,
                ),
              ),
            ),

            Gap(16.w),

            /// 📘 Title + Count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapterTitle,
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Uthmani",
                    ),
                  ),
                  Gap(6.h),
                  if (count != null)
                    Text(
                      ' عدد الأحاديث : $count',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDark ? Colors.white38 : Colors.black54,
                        fontFamily: "Cairo",
                      ),
                    ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF272a2e)
                    : const Color(0xffE9EEF0),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios, size: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
