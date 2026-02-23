import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Color(0xff1c2227) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info,
                color: isDark ? Colors.white : Colors.teal.shade800,
                size: 22.sp,
              ),
              Gap(8.w),
              Text(
                'عن التطبيق',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          Gap(12.w),
          CustomText(
            'تطبيق حصن المسلم هو رفيقك اليومي للمداومة على الذِّكر والدعاء، '
            'يهدف إلى تذكير المسلم بأذكار الصباح والمساء وجميع الأذكار الواردة في السنة النبوية.\n\n'
            'يوفر التطبيق محتوى شامل من القرآن الكريم، الأحاديث النبوية، '
            'والأدعية المأثورة، مع تنبيهات مخصصة لأذكار الصباح والمساء '
            'ليكون عونًا لك على ذكر الله في كل وقت.',
            fontSize: 11.sp,
            height: 1.5.h,
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade600,
            maxLines: 20,
          ),
        ],
      ),
    );
  }
}
