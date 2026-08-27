import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/custom_text.dart';
import '../../domain/entities/main_category_entity.dart';
import '../cubit/quiz_cubit.dart';
import '../theme/quiz_tokens.dart';
import '../widgets/quiz_category_card.dart';
import '../widgets/quiz_staggered_entry.dart';

class QuizCategoriesScreen extends StatelessWidget {
  const QuizCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
          title: "أسئلة دينيه",
      ),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          switch (state) {
            case QuizInitial():
              return const SizedBox();

            case QuizLoading():
              return  Center(child: CupertinoActivityIndicator(color: AppColors.kPrimary,));

            case QuizError(:final message):
              return _QuizErrorView(
                message: message,
                onRetry: () {
                  context.read<QuizCubit>().loadQuizDatabase();
                },
              );

            case QuizLoaded(:final database):
              return _CategoriesContent(categories: database.categories);
          }
        },
      ),
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  const _CategoriesContent({required this.categories});

  final List<MainCategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 30.h),
      children: [
        // HeroHeader(),
        SizedBox(height: 28.h),
        ...List.generate(categories.length, (index) {
          final category = categories[index];
          return QuizStaggeredEntry(
            index: index,
            child: Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: QuizCategoryCard(
                category: category,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.quizTopics,
                    arguments: category,
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}


class _QuizErrorView extends StatelessWidget {
  const _QuizErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 55.sp, color: QuizColors.error),
            SizedBox(height: 16.h),
            CustomText(
              message,
              textAlign: TextAlign.center,
              fontSize: 16.sp, color: QuizColors.textPrimary(context),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: onRetry,
              child: const CustomText('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
