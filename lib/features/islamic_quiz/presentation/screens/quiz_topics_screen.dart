import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/shared/re_build_scroll_To_Top.dart';
import '../../domain/entities/main_category_entity.dart';
import '../../domain/repositories/quiz_progress_repository.dart';
import '../theme/quiz_tokens.dart';
import '../widgets/quiz_staggered_entry.dart';
import '../widgets/quiz_topic_card.dart';

class QuizTopicsScreen extends StatefulWidget {
  const QuizTopicsScreen({super.key, required this.category});

  final MainCategoryEntity category;

  @override
  State<QuizTopicsScreen> createState() => _QuizTopicsScreenState();
}

class _QuizTopicsScreenState extends State<QuizTopicsScreen> {
  final Map<String, int> _completedByTopicSlug = {};
  bool _isLoadingProgress = true;


  /// Scroll
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);


  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      _showScrollToTop.value = _scrollController.offset > 300;
    });

    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final repository = sl<QuizProgressRepository>();
    final result = <String, int>{};

    for (final topic in widget.category.topics) {
      var completed = 0;
      for (final level in topic.levels) {
        final data = await repository.getLevelProgress(
          topicSlug: topic.slug,
          levelNumber: level.levelNumber,
        );
        if (data?['passed'] == true) completed++;
      }
      result[topic.slug] = completed;
    }

    if (!mounted) return;
    setState(() {
      _completedByTopicSlug
        ..clear()
        ..addAll(result);
      _isLoadingProgress = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: widget.category.arabicName),
      body: Column(
        children: [
          // Padding(
          //   padding:  EdgeInsets.symmetric(horizontal:  12.w , vertical: 16.h),
          //   child: Align(
          //     alignment: Alignment.topRight,
          //       child: CustomText('اختر الموضوع', fontSize: 18.sp)),
          // ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 30.h),
                itemCount: widget.category.topics.length,
                itemBuilder: (context , index){
              final topic = widget.category.topics[index];
              return QuizStaggeredEntry(
                index: index,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: QuizTopicCard(
                    topic: topic,
                    completedLevels: _isLoadingProgress ? 0 : (_completedByTopicSlug[topic.slug] ?? 0),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.quizLevels,
                        arguments: topic,
                      );
                      _loadProgress();
                    },
                  ),
                ),
              );
            }),
          ),

        ],
      ),
      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }
}
