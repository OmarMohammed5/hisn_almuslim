import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/features/hisn%20al-muslim/data/models/zekr_model.dart';
import 'package:hisn_almuslim/features/tasbeeh/widgets/zekr_counter_card.dart';

class ZekrCounterBuild extends StatelessWidget {
  const ZekrCounterBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsive.isMobile(context);
    return GridView.builder(
      padding: EdgeInsets.only(top:AppResponsive.heightValue(context, 2)),
      itemCount: zekrList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppResponsive.widthValue(context, 12),
        mainAxisSpacing: AppResponsive.heightValue(context, 12),
        childAspectRatio: isMobile ? 1.20 : 1.7,
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
