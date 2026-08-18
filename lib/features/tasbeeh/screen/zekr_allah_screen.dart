// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';
// import 'package:hisn_almuslim/features/tasbeeh/widgets/card_widget.dart';
// import 'package:hisn_almuslim/features/tasbeeh/widgets/zekr_counter_build.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/shared/app_bar_widget.dart';
//
// class ZekrAllahScreen extends StatelessWidget {
//   const ZekrAllahScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterCubit(),
//       child: Scaffold(
//         appBar: AppBarWidget(title: "السبحة"),
//         body: Column(
//           children: [
//             /// Banner of Counter
//             CardWidget(),
//
//             /// Zekr Counter Build
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
//                 child: Column(children: [ZekrCounterBuild()]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';
import 'package:hisn_almuslim/features/tasbeeh/widgets/card_widget.dart';
import 'package:hisn_almuslim/features/tasbeeh/widgets/zekr_counter_build.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/shared/app_bar_widget.dart';

class ZekrAllahScreen extends StatelessWidget {
  const ZekrAllahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => CounterCubit(),
      child: Scaffold(
        appBar: AppBarWidget(
          title: "السبحة",
        ),
        body: Column(
          children: [
            // ✅ Banner with Verse + Total
            CardWidget(),
            // ✅ Zekr Grid
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: const ZekrCounterBuild(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}