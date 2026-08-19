import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/cubit/hajj%20and%20omra/hajj_dua_cubit.dart';
import 'package:hisn_almuslim/features/jami%20dua/screen/hajj_and_omra_details.dart';
import 'package:hisn_almuslim/features/jami%20dua/widgets/category_card.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/shared/app_bar_widget.dart';

class HajjAndOmraScreen extends StatelessWidget {
  const HajjAndOmraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "أدعية الحج و العمرة"),
      body: BlocBuilder<HajjDuaCubit, HajjDuaState>(
        builder: (context, state) {
          if (state is HajjDuaLoading) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.teal.shade700),
            );
          }

          if (state is HajjDuaLoaded) {
            final chapter = state.items;
            return Padding(
              padding: EdgeInsets.all(12.w),
              child: ListView.builder(
                itemCount: chapter.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    title: chapter[index].chapterTitle,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.hajjAndOmraDuaDetails ,
                        arguments: {
                        'title' : chapter[index].chapterTitle,
                        'hajjItems': chapter[index].items,
                        },);
                    },
                  );
                },
              ),
            );
          } else if (state is HajjDuaError) {
            return Center(child: CustomText(state.message));
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
