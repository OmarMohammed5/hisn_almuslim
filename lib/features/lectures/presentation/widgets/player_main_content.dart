import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/lecture.dart';
import '../../../../core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerMainContent extends StatelessWidget {
  final Lecture lecture;
  const PlayerMainContent({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return  Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Gap(12.h),

          // Lecture Title

          CustomText(
            lecture.title,
            fontSize: 20.sp,
            fontWeight:
            FontWeight.w900,
            height: 1.45,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
