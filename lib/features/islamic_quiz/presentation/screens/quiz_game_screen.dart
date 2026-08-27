import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routing/app_routes.dart';
import '../../domain/entities/level_entity.dart';
import '../cubit/game_cubit.dart';
import '../cubit/game_state.dart';
import '../theme/quiz_tokens.dart';
import '../widgets/quiz_answer_card.dart';
import '../widgets/quiz_next_button.dart';
import '../widgets/quiz_progress_header.dart';
import '../widgets/quiz_question_card.dart';
import 'quiz_result_screen.dart';

class QuizGameArgs {
  final String topicSlug;
  final LevelEntity level;

  const QuizGameArgs({required this.topicSlug, required this.level});
}

class QuizGameScreen extends StatelessWidget {
  const QuizGameScreen({super.key, required this.args});

  final QuizGameArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuizGameCubit>()
        ..startGame(topicSlug: args.topicSlug, level: args.level),
      child: const _QuizGameView(),
    );
  }
}

class _QuizGameView extends StatelessWidget {
  const _QuizGameView();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<QuizGameCubit, QuizGameState>(
            listener: (context, state) {
              if (state.status == QuizGameStatus.completed) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.quizResult,
                  arguments: QuizResultArgs(
                    score: state.score,
                    stars: state.stars,
                    passed: state.passed,
                    correctAnswers: state.correctAnswers,
                    wrongAnswers: state.wrongAnswers,
                    totalQuestions: state.questions.length,
                  ),
                );
              }
            },
            builder: (context, state) {
              final question = state.currentQuestion;

              if (question == null) {
                return  Center(child: CupertinoActivityIndicator(color: AppColors.kPrimary,));
              }

              final isAnswered = state.status == QuizGameStatus.answered;

              return Padding(
                padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 18.h),
                child: Column(
                  children: [
                    QuizProgressHeader(
                      currentQuestion: state.currentIndex + 1,
                      totalQuestions: state.questions.length,
                      progress: state.progress,
                    ),
                    SizedBox(height: 26.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: AnimatedSwitcher(
                          duration: QuizDurations.normal,
                          transitionBuilder: (child, animation) => FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(.06, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                              child: child,
                            ),
                          ),
                          child: Column(
                            key: ValueKey(state.currentIndex),
                            children: [
                              QuizQuestionCard(question: question.question),
                              SizedBox(height: 24.h),
                              ...List.generate(question.answers.length, (index) {
                                final answer = question.answers[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: QuizAnswerCard(
                                    answer: answer,
                                    index: index,
                                    selectedIndex: state.selectedAnswerIndex,
                                    isAnswered: isAnswered,
                                    onTap: () {
                                      context.read<QuizGameCubit>().selectAnswer(index);
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    QuizNextButton(
                      visible: isAnswered,
                      label: state.currentIndex == state.questions.length - 1
                          ? 'إنهاء المستوى'
                          : 'السؤال التالي',
                      onPressed: () {
                        context.read<QuizGameCubit>().nextQuestion();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
