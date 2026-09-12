import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisn_almuslim/features/tasbeeh/data/cubit/counter_cubit.dart';
import 'package:hisn_almuslim/features/tasbeeh/widgets/card_widget.dart';
import 'package:hisn_almuslim/features/tasbeeh/widgets/zekr_counter_build.dart';
import '../../../core/responsive/app_responsive.dart';
import '../../../core/shared/app_bar_widget.dart';

class ZekrAllahScreen extends StatelessWidget {
  const ZekrAllahScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final maxWidth = AppResponsive.isDesktop(context)
        ? 1100.0
        : AppResponsive.isTablet(context)
        ? 820.0
        : double.infinity;

    return BlocProvider(
      create: (_) => CounterCubit(),
      child: Scaffold(
        appBar: AppBarWidget(title: "السبحة"),
        body: AppResponsive.constrain(
          context,
          maxWidth: maxWidth,
          child: Column(
            children: [
              const CardWidget(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                      AppResponsive.widthValue(context, 16),
                      AppResponsive.heightValue(context, 4),
                      AppResponsive.widthValue(context, 16),
                      AppResponsive.heightValue(context, 24)
                  ),
                  child: const ZekrCounterBuild(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
