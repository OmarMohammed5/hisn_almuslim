import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/quiz_progress_repository.dart';
import '../theme/quiz_tokens.dart';
import '../widgets/quiz_level_node.dart';
import 'quiz_game_screen.dart';

class QuizLevelsScreen extends StatefulWidget {
  const QuizLevelsScreen({super.key, required this.topic});

  final TopicEntity topic;

  @override
  State<QuizLevelsScreen> createState() => _QuizLevelsScreenState();
}

class _QuizLevelsScreenState extends State<QuizLevelsScreen> {
  Map<int, Map<String, dynamic>> progress = {};
  bool isLoading = true;


  Set<int> _newlyUnlocked = {};

  @override
  void initState() {
    super.initState();
    _loadProgress(isInitialLoad: true);
  }

  bool _isUnlockedFrom(Map<int, Map<String, dynamic>> data, int levelNumber) {
    if (levelNumber == 1) return true;
    return data[levelNumber - 1]?['passed'] == true;
  }

  Future<void> _loadProgress({bool isInitialLoad = false}) async {
    final repository = sl<QuizProgressRepository>();
    final loadedProgress = <int, Map<String, dynamic>>{};

    for (final level in widget.topic.levels) {
      final data = await repository.getLevelProgress(
        topicSlug: widget.topic.slug,
        levelNumber: level.levelNumber,
      );
      if (data != null) {
        loadedProgress[level.levelNumber] = data;
      }
    }

    if (!mounted) return;

    final previouslyUnlocked = {
      for (final level in widget.topic.levels)
        if (!isLoading && _isUnlockedFrom(progress, level.levelNumber)) level.levelNumber,
    };
    final nowUnlocked = {
      for (final level in widget.topic.levels)
        if (_isUnlockedFrom(loadedProgress, level.levelNumber)) level.levelNumber,
    };

    setState(() {
      progress = loadedProgress;
      isLoading = false;
      _newlyUnlocked = isInitialLoad ? {} : nowUnlocked.difference(previouslyUnlocked);
    });
  }

  bool _isUnlocked(int levelNumber) => _isUnlockedFrom(progress, levelNumber);

  bool _isPassed(int levelNumber) => progress[levelNumber]?['passed'] == true;

  int _getStars(int levelNumber) => (progress[levelNumber]?['stars'] as num?)?.toInt() ?? 0;

  int _getBestScore(int levelNumber) => (progress[levelNumber]?['bestScore'] as num?)?.toInt() ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: widget.topic.name),
      body: isLoading
          ?  Center(child: CupertinoActivityIndicator(color: AppColors.kPrimary,))
          : ListView(
              padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 40.h),
              children: [
                CustomText(
                  'اختر المستوى',
                  textAlign: TextAlign.center,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  'أتقن كل مستوى لفتح المستوى التالي',
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
                SizedBox(height: 32.h),
                ...List.generate(widget.topic.levels.length, (index) {
                  final level = widget.topic.levels[index];
                  final unlocked = _isUnlocked(level.levelNumber);

                  return QuizLevelNode(
                    level: level,
                    unlocked: unlocked,
                    passed: _isPassed(level.levelNumber),
                    stars: _getStars(level.levelNumber),
                    bestScore: _getBestScore(level.levelNumber),
                    isLast: index == widget.topic.levels.length - 1,
                    justUnlocked: _newlyUnlocked.contains(level.levelNumber),
                    onTap: unlocked
                        ? () async {
                            await Navigator.pushNamed(
                              context,
                              AppRoutes.quizGame,
                              arguments: QuizGameArgs(
                                topicSlug: widget.topic.slug,
                                level: level,
                              ),
                            );
                            await _loadProgress();
                          }
                        : null,
                  );
                }),
              ],
            ),
    );
  }
}
