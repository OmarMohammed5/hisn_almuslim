import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';
import 'package:hisn_almuslim/features/tasbeeh/widgets/card_widget.dart';
import 'package:hisn_almuslim/features/tasbeeh/widgets/zekr_counter_build.dart';
import '../../../core/shared/app_bar_widget.dart';

class ZekrAllahScreen extends StatelessWidget {
  const ZekrAllahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: Scaffold(
        appBar: AppBarWidget(title: "السبحة"),
        body: Column(
          children: [
            const CardWidget(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                child: const ZekrCounterBuild(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
