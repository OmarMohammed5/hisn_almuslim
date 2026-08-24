import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/data/models/zekr_model.dart';
import 'package:hisn_almuslim/features/tasbeeh/widgets/zekr_counter_card.dart';

class ZekrCounterBuild extends StatelessWidget {
  const ZekrCounterBuild({super.key});

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      itemCount: zekrList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final zekr = zekrList[index];
        return ZekrCounterCard(
          title: zekr.title,
          index: index,
        );
      },
    );
  }
}