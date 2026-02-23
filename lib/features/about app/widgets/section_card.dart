import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/about%20app/widgets/section_item.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key});

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
            spacing: 8.w,
            children: [
              Icon(Icons.apps_rounded, color: Colors.teal.shade800),
              Text(
                'أقسام التطبيق',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          Gap(22.w),
          SectionItem(
            icon: FlutterIslamicIcons.quran2,
            title: 'القرآن الكريم',
            subtitle: 'تلاوة وقراءة القرآن الكريم كاملًا',
          ),
          SectionItem(
            icon: FlutterIslamicIcons.mosque,
            title: 'مواقيت الصلاة',
            subtitle: 'تنبيهات دقيقه بمواعيد الأذان',
          ),
          SectionItem(
            icon: FlutterIslamicIcons.calendar,
            title: 'التقويم الهجري',
            subtitle: 'تقويم هجري دقيق وواضح',
          ),
          SectionItem(
            icon: Icons.wb_sunny_outlined,
            title: 'أذكار الصباح',
            subtitle: 'أذكار الصباح كاملة مع عدّاد للتسبيح',
          ),
          SectionItem(
            icon: Icons.dark_mode_outlined,
            title: 'أذكار المساء',
            subtitle: 'أذكار المساء كاملة مع تنبيهات يومية',
          ),
          SectionItem(
            icon: FlutterIslamicIcons.tasbihHand,
            title: 'جميع الأذكار',
            subtitle: 'أذكار النوم، الاستيقاظ، الصلاة، الطعام وغيرها',
          ),
          SectionItem(
            icon: FlutterIslamicIcons.prayer,
            title: 'الأدعية',
            subtitle: 'أدعية مأثورة من القرآن والسنة',
          ),
          SectionItem(
            icon: FlutterIslamicIcons.mohammad,
            title: 'الأحاديث النبوية',
            subtitle: 'مجموعة مختارة من الأحاديث الصحيحة',
          ),
          SectionItem(
            icon: Icons.notifications_active_outlined,
            title: 'التنبيهات',
            subtitle: 'تنبيهات مخصصة لأذكار الصباح والمساء',
          ),
        ],
      ),
    );
  }
}
