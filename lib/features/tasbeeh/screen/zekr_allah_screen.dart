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
            CardWidget(),
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